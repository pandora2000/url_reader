class UrlReader::BaseError < StandardError
  def self.msg(error, additional_msg = nil)
    msg = "#{error.class.name}: #{error.message}"
    if additional_msg
      msg += ", #{additional_msg}"
    end
    msg
  end

  def initialize(inner_or_msg = nil, additional_msg = nil)
    if inner_or_msg.is_a?(String)
      super(inner_or_msg)
    else
      super(self.class.msg(inner_or_msg, additional_msg))
      set_backtrace(inner_or_msg.backtrace)
    end
  end
end
