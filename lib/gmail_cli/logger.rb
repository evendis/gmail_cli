class GmailCli::Logger

  class << self
    def log(msg)
      $stdout.puts "#{Time.now}| #{msg}"
    end
    def trace(name,value) ; value ; end

    def set_log_mode(verbose)
      if verbose
        class_eval <<-LOGGER_ACTION, __FILE__, __LINE__
          def self.trace(name,value)
            $stderr.puts "\#{Time.now}| \#{name}: \#{value.inspect}"
            value
          end
        LOGGER_ACTION
      else
        class_eval <<-LOGGER_ACTION, __FILE__, __LINE__
          def self.trace(name,value) ; value ; end
        LOGGER_ACTION
      end
    end

  end

end

module GmailCli::LoggerSupport

  def trace(name,value)
    GmailCli::Logger.trace name,value
  end
  def log(msg)
    GmailCli::Logger.log msg
  end

end