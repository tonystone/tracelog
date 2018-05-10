#!/usr/bin/env ruby
#
#   xctest_tool.rb
#
#   Copyright 2017 Tony Stone
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
#   Created by Tony Stone on 10/2/17.
#
require 'getoptlong'
require 'fileutils'
require 'pathname'
require "rubygems"
require "json"

include FileUtils

def usage()
  string = <<USAGE
Usage:
   %{file_name} [--package-path path] [--header-template path] [--extension-files true|false]

Options:
  --package-path      Path to directory containing Package.swift
  --header-template   Path to the file to use as the header template for each generated file (defaults to .build-tools.header in the package-path directory)
  --extension-files   Should test class extensions files be generated (FileName+XCTest.swift) or should the extensions be embed in LinuxMain.swift (defaults to false)

USAGE

  puts string % {file_name:  File.basename(__FILE__)}
end

#
# Main routine
#
#
package_path="./"
header_template=nil
extension_files=false

options = GetoptLong.new(
    [ '--package-path', GetoptLong::REQUIRED_ARGUMENT ],
    [ '--extension-files', GetoptLong::REQUIRED_ARGUMENT ],
    [ '--help', GetoptLong::NO_ARGUMENT ]
)
options.quiet = true

begin
    options.each do |option, value|
        if    option == '--package-path' then package_path=value.dup
        elsif option == '--extension-files' then extension_files=(value.to_s == "true")
        elsif option == '--help' then usage(); abort
        end
    end
rescue GetoptLong::InvalidOption
    usage
    abort
end

package_path = File.expand_path(package_path)
default_tests_directory = defaultTestsDirectory(package_path)

unless File.file?(File.join(package_path, "Package.swift"))
  abort("Package.swift file not found at '#{package_path}', aborting.")
end

unless header_template then
  header_template = File.join(package_path, ".build-tools.header")
end
header_template = File.expand_path(header_template)

#
# Parse the output of swift package dump-package which outputs the Package file in JSON format.
#
package = JSON.parse(`swift package --package-path #{package_path} dump-package`)

# Extract the test targets
test_targets = package["targets"].select { |t| t["isTest"] }

file_classes = Array.new
module_names = Array.new

#
# Process each test target in turn
#
test_targets.each do |target|
    module_name = target["name"]

    target_path = target["path"] || File.join(default_tests_directory, module_name)
    target_sub_directory = File.join(package_path, target_path)

    module_names << module_name
    file_classes = file_classes + processTestFiles(header_template, target_sub_directory, extension_files)
end

#
# If its the root level and there are classes, create the LinuxMain file
#
if file_classes.count > 0
  target_path = File.join(package_path, default_tests_directory)

  createLinuxMain(header_template, target_path, module_names, file_classes, extension_files)
end

BEGIN {

    #
    # Return the tests directory name the user is using or default to Tests
    #
    def defaultTestsDirectory(package_path)

      if File.directory?(package_path + "Test")
        return "Test"
      else
        return "Tests"
      end
    end

    #
    # Process the test files in the given target_sub_directory.
    #
    def processTestFiles(header_template, target_sub_directory, extension_files)

        file_classes = Array.new

        Dir[target_sub_directory + '/*Test{s,}.swift'].each do |target_path|

            if File.file? target_path

                classes = parseSourceFile(target_path)

                # If there are classes in the test source file, create an extension file for it.
                if classes.count > 0
                    if extension_files
                        createExtensionFile(header_template, target_path, classes)
                    end
                    file_classes << classes
                end
            end
        end

        # Now process the sub directories
        Dir[target_sub_directory + '/*'].each do |sub_directory|

            if File.directory?(sub_directory)
                sub_classes = processTestFiles(header_template, sub_directory, extension_files)

                # Aggregate the files and classes
                file_classes = file_classes + sub_classes
            end
        end

        return file_classes
    end

    #
    # Process the source file returning a list of classes in the source
    #
    # Classes structure:
    #
    #   className -> Array of func names
    #
    def parseSourceFile(file_name)

        puts "Parsing file:  " + file_name + "\n"

        classes = Array.new

        current_class = nil

        in_if_linux = false
        in_else    = false
        ignore    = false

        #
        # Read the file line by line and parse to find the class names and func names
        #
        File.readlines(file_name).each do |line|

            if in_if_linux
                if /\#else/.match(line)
                    in_else = true
                    ignore = true
                else
                    if /\#end/.match(line)
                        in_else = false
                        in_if_linux = false
                        ignore = false
                    end
                end
            else
                if /\#if[ \t]+os\(Linux\)/.match(line)
                    in_if_linux = true
                    ignore = false
                end
            end

            if !ignore

                # Match class or func
                match = line[/class[ \t]+[a-zA-Z0-9_]*(?=[ \t]*:[ \t]*XCTestCase)|func[ \t]+test[a-zA-Z0-9_]*(?=[ \t]*\(\))/, 0]
                if match

                    if match[/^class/, 0] == "class"
                        class_name = match.sub(/^class[ \t]+/, '')

                        # Create a new class / func structure and add it to the classes array.
                        current_class = [class_name, Array.new]

                        classes << current_class

                    else # Must be a func
                        func_name  = match.sub(/^func[ \t]+/, '')

                        # Add each func name the class / func structure created above.
                        current_class[1] << func_name
                    end
                end
            end
        end
        return classes
    end

    #
    # Creates the LinuxMain.swift file.
    #
    def createLinuxMain(header_template, target_path, module_names, file_classes, extension_files)

        file_name = target_path + "/LinuxMain.swift"
        print "Creating file: " + file_name + "\n"

        # Get the header first since we may open the file to read in the existing header.
        header_text = header(header_template,file_name)

        File.open(file_name, 'w') { |file|

            file.write header_text
            file.write "\n#if os(Linux) || os(FreeBSD)\n"
            file.write imports(module_names)
            file.write linuxMain(file_classes)

            unless extension_files
                for classes in file_classes
                    file.write extension(classes)
                end
            end
            file.write "\n#endif\n"
        }
    end

    # Creates an extension file for the given target_path
    #
    def createExtensionFile(header_template, target_path, classes)

        extension_file = target_path.sub! ".swift", "+XCTest.swift"
        print "Creating file: " + extension_file + "\n"

        # Get the header first since we may open the file to read in the existing header.
        header_text = header(header_template, extension_file)

        File.open(extension_file, 'w') { |file|

            file.write header_text
            file.write "\n#if os(Linux) || os(FreeBSD)\n"
            file.write "\nimport XCTest\n"

            file.write extension(classes)

            file.write "\n#endif\n"
        }
    end


    #
    # Returns the header to use for a file.
    #
    def header(header_template, target_path)
        header = ""
        marker = "\/\/\/ build-tools: auto-generated"

        # If the file already exists, read the existing header and return that.
        if (File.file? target_path) && (File.foreach(target_path).grep(/#{marker}/).size > 0)

            File.open(target_path, 'r').each_line do |line|
                    header += line
                    break if(line =~ /#{marker}/)
            end
        else
            if File.file? header_template
                header += File.open(header_template, 'r').read
            end
            header += "\n#{marker}\n"

            date = Time.now

            # substitute any variables
            header = header % {target_file: File.basename(target_path),
                               target_path: target_path,
                               script_file: File.basename(__FILE__),
                               script_path: __FILE__,
                               month: date.strftime("%m"),
                               day:   date.strftime("%d"),
                               year:  date.strftime("%Y"),
                               date:  date.strftime("%m/%d/%Y")}
        end

        return header
    end

    def imports(module_names)
        imports = "\nimport XCTest\n\n"

        module_names.each do |module_name|
            imports += "@testable import " + module_name + "\n"
        end
        imports += "\n"
    end

    def linuxMain(file_classes)

        linux_main = "XCTMain([\n"

        first = true

        for classes in file_classes
            for classArray in classes
                if !first
                    linux_main += ",\n"
                end
                linux_main += "   testCase(" + classArray[0] + ".allTests)"
                first = false
            end
        end
        linux_main += "\n])\n"
    end

    def extension(classes)
        extension = ""
        for class_array in classes
            extension += "\nextension " + class_array[0] + " {\n\n"
            extension += "   static var allTests: [(String, (" + class_array[0] + ") -> () throws -> Void)] {\n"
            extension += "      return [\n"

            first = true

            for func_name in class_array[1]
                if !first
                    extension += ",\n"
                end
                extension += "                (\"" + func_name + "\", " + func_name + ")"

                first = false
            end

            extension += "\n           ]\n"
            extension += "   }\n"
            extension += "}\n"
        end
        extension
    end
}
