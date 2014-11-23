class UrlReader::FileCache
  def initialize(cache_dir_path)
    @cache_dir_path = cache_dir_path
    @cache = {}
  end

  def read_entry(key)
    unless @cache.has_key?(key)
      ekey = encoded_key(key)
      hash = hash(ekey)
      file_path = File.join(@cache_dir_path, hash)
      value = nil
      if File.exist?(file_path)
        value = (decoded_value(File.open(file_path).read.strip.split("\n")
                                 .select { |x| x.start_with?("#{ekey}\t") }[0].split("\t", 2)[1]) rescue nil)
      end
      @cache[key] = value
    end
    @cache[key]
  end

  def write_entry(key, value)
    @cache[key] = value
    ekey = encoded_key(key)
    hash = hash(ekey)
    file_path = File.join(@cache_dir_path, hash)
    File.open(file_path, 'a') { |f| f.puts("#{ekey}\t#{encoded_value(value)}") }
    true
  end

  private

  def encoded_key(key)
    URI.encode_www_form_component(key)
  end

  def encoded_value(value)
    CGI.escape(value)
  end

  def decoded_value(value)
    CGI.unescape(value)
  end

  def hash(key)
    Digest::SHA256.hexdigest(key)
  end
end
