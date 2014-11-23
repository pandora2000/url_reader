class UrlReader::ReadError < UrlReader::BaseError
  PageNotFound = 0
  RequestTimeout = 1
  UnidentifiedError = 2

  attr_reader :type

  def initialize(*args)
    super(*args)
    inner = args[0]
    @type =
      if inner.is_a?(RestClient::ResourceNotFound)
        PageNotFound
      elsif inner.is_a?(RestClient::RequestTimeout)
        RequestTimeout
      else
        UnidentifiedError
      end
  end
end
