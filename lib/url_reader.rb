require_relative 'initialize'

require 'kconv'

module UrlReader
  extend ActiveSupport::Concern

  include UrlFixer

  REQUEST_TIMEOUT = 10
  REQUEST_OPEN_TIMEOUT = 10

  def read_url(url, options = {})
    if defined?(Rails) && Rails.env.development?
      if ENV['READ_URL_CACHE_NOT_USE'] != 'true'
        ckey = cache_key(url, options)
        res = cache.read_entry(ckey)
        res || read_url_core_with_cache_write(url, options, ckey)
      else
        read_url_core_with_cache_write(url, options)
      end
    else
      read_url_core(url, options)
    end
  end

  private

  def cache
    @cache ||= begin
                 %x(mkdir -p #{Rails.root}/tmp/cache/url_reader)
                 FileCache.new(File.join(Rails.root, 'tmp/cache/url_reader'))
               end
  end

  def cache_key(url, options)
    "#{url}?#{options.to_s}"
  end

  def read_url_core_with_cache_write(url, options, ckey = nil)
    ckey ||= cache_key(url, options)
    res = read_url_core(url, options)
    return nil if res.nil?
    cache.write_entry(ckey, res)
    res
  end

  def read_url_core(url, options)
    valid_url = fixed_url(url)
    headers = {}
    headers[:user_agent] = options[:user_agent] if options[:user_agent]
    hash = {
      url: valid_url,
      timeout: options[:request_timeout] || REQUEST_TIMEOUT,
      open_timeout: options[:request_open_timeout] || REQUEST_OPEN_TIMEOUT,
      headers: headers
    }
    response =
      begin
        if options[:method] == :post
          RestClient::Request.execute(hash.merge(method: :post, payload: options[:params]))
        else
          RestClient::Request.execute(hash.merge(method: :get))
        end
      rescue RestClient::ResourceNotFound,
             RestClient::InternalServerError,
             RestClient::RequestTimeout,
             RestClient::ServerBrokeConnection,
             Errno::ECONNREFUSED,
             Errno::ECONNRESET => e
        ne = ReadError.new(e, "Read #{hash[:url]} failed")
        if options[:ignore_not_found]
          options[:ignore_read_errors] ||= []
          options[:ignore_read_errors] << 'PageNotFound'
        end
        if ignore_errors = options[:ignore_read_errors]
          return nil if ignore_errors.map { |x| x.is_a?(Integer) ? x : ReadError.const_get(x) }.include?(ne.type)
        end
        raise ne
      end
    return nil unless response
    return resolve_encoding(response) if response.headers[:content_type] !~ /^image\//
    response.to_str
  end

  def resolve_encoding(response)
    response_str = response.to_str
    encoding = response_encoding(response.headers, response_str)
    begin
      return response_str.encode(Encoding::UTF_8, encoding)
    rescue Encoding::UndefinedConversionError => e
      return response_str.encode(Encoding::UTF_8, Encoding::CP932) if encoding == Encoding::Shift_JIS
      return response_str.encode(Encoding::UTF_8, Encoding::CP51932) if encoding == Encoding::EUC_JP
      raise CannotResolveEncodingError, e
    end
  end

  def response_encoding(response_headers, response_str)
    response_str_utf8 = response_str.toutf8
    [response_headers[:content_type].try(:match, /charset=(?<charset>[^;]+)($|;)/),
     response_str_utf8.match(/<meta .*?content="[^"]*?charset=(?<charset>[^;"]+)/),
     response_str_utf8.match(/<meta .*?charset="(?<charset>[^"]+)"/)]
      .map { |x| x.try(:[], 'charset') }.compact
      .map { |x| Encoding.find(x) rescue nil }.compact
      .push(Encoding::UTF_8)
      .first
  end
end
