#
# Be sure to run `pod lib lint TraceLog.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "TraceLog"
  s.version          = "4.0.1"
  s.summary          = "Dead Simple: logging the way it's meant to be!"
  s.description      = <<-DESC
                             TraceLog is a configurable debug logging system.  It is unique in that it's configured
                             after compilation in the runtime environment. It reads environment variables from the
                             process context to set log levels. This allows each developer to configure log output
                             per session based on the debugging needs of that session.

                             When compiled in a RELEASE build, TraceLog is compiled out and has no overhead in
                             the application.

                             Log output can be configured globally using the LOG_ALL environment variable,
                             by TAG name using the LOG_TAG_<TAGNAME> environment variable pattern,
                             and/or by a TAG prefix by using the LOG_PREFIX_<TAGPREFIX> environment
                             variable pattern.

                             Please see README.md for more details and examples.
                       DESC
  s.license          = 'Apache License, Version 2.0'
  s.homepage         = "https://github.com/tonystone/tracelog"
  s.author           = { "Tony Stone" => "https://github.com/tonystone" }
  s.source           = { :git => "https://github.com/tonystone/tracelog.git", :tag => s.version.to_s }

  s.swift_version = '4.1'

  s.ios.deployment_target     = '9.0'
  s.osx.deployment_target     = '10.10'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target    = '9.0'

  s.requires_arc = true
  s.default_subspecs = 'Swift'

  s.subspec 'Swift' do |swift|
    swift.source_files = 'Sources/TraceLog/**/*.swift'
  end

  s.subspec 'ObjC' do |objc|
    objc.dependency 'TraceLog/Swift'

    objc.public_header_files = 'Sources/TraceLogObjC/include/TraceLog.h'
    objc.source_files        = 'Sources/TraceLogObjC/**/*.{h,m}'
  end

end
