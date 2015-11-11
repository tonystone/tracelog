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
  s.version          = "0.4.1"
  s.summary          = "TraceLog a fully configurable logging service."
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

  s.ios.deployment_target     = '5.0'
  s.osx.deployment_target     = '10.7'
  s.watchos.deployment_target = '2.0'

  s.requires_arc = true
  s.default_subspecs = 'ObjC'

  s.public_header_files = 'Pod/TraceLog.h', 'Pod/Internal/TLogger.h'
  s.preserve_paths = 'Pod/*.swift', 'Pod/Internal/*.swift'

  s.subspec 'ObjC' do |ss|
    ss.source_files = 'Pod/*.h'
    ss.dependency 'TraceLog/Core'
  end

  s.subspec 'Core' do |ss|
      ss.source_files = 'Pod/Internal/*.{h,m}'
  end

  s.subspec 'Swift' do |ss|
    ss.ios.deployment_target = '8.0'
    ss.osx.deployment_target = '10.10'
    ss.watchos.deployment_target = '2.0'

    ss.source_files = 'Pod/*.swift', 'Pod/Internal/*.swift'
    ss.dependency 'TraceLog/Core'
  end

end
