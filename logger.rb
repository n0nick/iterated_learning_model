require 'logger' # Ruby's Logger

MyLogger = Logger.new(STDOUT)

MyLogger.formatter = proc do |severity, datetime, progname, msg|
  "[#{severity}] #{msg}\n"
end

MyLogger.level = Logger::INFO
