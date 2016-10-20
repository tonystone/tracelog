#
#   Vagrantfile
#
#   Copyright 2016 Tony Stone
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
#   Created by Tony Stone on 10/2/16.
#
require 'getoptlong'

#
# This script can be passed script arguments from the vagrant
# command line.  At this point script arguments must come
# before vagrant commands and arguments.
#
# Examples:
#
# > vagrant --swift-version="2016-04-25-a" up --provider=virtualbox
#
# > vagrant --release --swift-version="2.2.1" up --provider=virtualbox
#
sourceName=""
sourceDirectory=""

swiftRelease=true
swiftVersion="3.0"

options = GetoptLong.new(
    [ '--swift-version', GetoptLong::OPTIONAL_ARGUMENT ],
    [ '--release'      , GetoptLong::NO_ARGUMENT ]
)
options.quiet = true

begin
    options.each do |option, value|
        case option
            when '--swift-version'
            swiftVersion=value
            when '--release'
            swiftRelease=true
        end
    end
    rescue GetoptLong::InvalidOption
end

if swiftRelease
    sourceDirectory = "builds/swift-#{swiftVersion}-release/ubuntu1510/swift-#{swiftVersion}-RELEASE"
    sourceName      = "swift-#{swiftVersion}-RELEASE-ubuntu15.10"
else
    sourceDirectory = "builds/development/ubuntu1510/swift-DEVELOPMENT-SNAPSHOT-#{swiftVersion}"
    sourceName      = "swift-DEVELOPMENT-SNAPSHOT-#{swiftVersion}-ubuntu15.10"
end

Vagrant.configure("2") do |config|
  
  config.vm.box = "bento/ubuntu-15.10"

  config.vm.provider "virtualbox"

  config.vm.provider "parallels" do |v|
     v.name = "Ubuntu Linux 15.10 - TraceLog Development"
     v.memory = 512
  end

  config.vm.provision "fix-no-tty", type: "shell" do |s|
     s.privileged = false
     s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end
 
  #
  # Shell script to install the swift development environment
  #
  config.vm.provision "shell", inline: <<-SHELL
    #!/bin/sh

    #
    # Update apt-get first
    #
    sudo apt-get update
    
    #
    # Install the needed development and admin packages
    #
    sudo apt-get --assume-yes install clang libicu-dev libcurl3 libpython2.7-dev
    #
    # Import the gpg keys
    #
    wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import -
    
    gpg --keyserver hkp://pool.sks-keyservers.net --refresh-keys Swift
    
    #
    # Note: We're using wget here because of a display issue with curl and vagrant.  The display is corrupt using curl.
    #
    wget --progress=bar:force https://swift.org/"#{sourceDirectory}"/"#{sourceName}".tar.gz
    wget --progress=bar:force https://swift.org/"#{sourceDirectory}"/"#{sourceName}".tar.gz.sig

#
    # Validate the file
    #
    gpg --verify "#{sourceName}".tar.gz.sig
   
    if [ $? -eq 0 ]
    then
        #
        # Expand the swift code into our current directory
        # and update the permissions
        #
        tar zxf "#{sourceName}".tar.gz
    
        sudo chown -R vagrant:vagrant swift-*
   
        # Update the path so we can get to swift
        #
        echo "export PATH=/home/vagrant/#{sourceName}/usr/bin:\"${PATH}\"" >> .profile
        echo ""
        echo "Swift #{sourceName} has been successfully installed on Linux"
        echo "To use it, call 'vagrant ssh' and once logged in, cd to the /vagrant directory"
        echo ""
    else
        echo "Error: Swift #{sourceName} failed signature validation."
    fi
  SHELL
end
