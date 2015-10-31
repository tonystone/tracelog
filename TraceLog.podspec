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
  s.version          = "0.4.0"
  s.summary          = "TraceLog a fully configurable logging service."
  s.description      = <<-DESC
                             TraceLog is a runtime configurable debug logging system.  It allows flexible
                             configuration via environment variables at run time which allows each developer
                             to configure log output per session based on the debugging needs of that session.

                             When compiled in a RELEASE build, TraceLog is compiled out and has no overhead at
                             all in the application.

                             Log output can be configured globally using the LOG_ALL environment variable,
                             by CLASS name using the LOG_CLASS_<CLASSNAME> environment variable pattern,
                             and/or by a CLASS group by using the CLASS_PREFIX_<CLASSPREFIX> environment
                             variable pattern.

                             Please see the main header file TraceLog.h for more details and examples.
                       DESC
  s.license          = 'Apache License, Version 2.0'
  s.homepage         = "https://github.com/TheClimateCorporation/tracelog"
  s.author           = { "Tony Stone" => "https://github.com/tonystone" }
  s.source           = { :git => "https://github.com/TheClimateCorporation/tracelog.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.public_header_files = 'Pod/TraceLog.h', 'Pod/Internal/TLogger.h'
  s.source_files = 'Pod/TraceLog.h', 'Pod/Internal/*'

end
