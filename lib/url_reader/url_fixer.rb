module UrlReader::UrlFixer
  extend ActiveSupport::Concern

  def fixed_url(url)
    url.gsub(/[^[:ascii:]]| /) { |c| URI.encode(c) }.gsub('[', '%5B').gsub(']', '%5D')
  end
end
