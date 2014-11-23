Gem::Specification.new do |s|
  s.name = 'url_reader'
  s.version = '0.1.0'
  s.authors = ['Tetsuri Moriya']
  s.email = ['tetsuri.moriya@gmail.com']
  s.summary = 'Url reader'
  s.description = 'Web retrieval module with cache'
  s.homepage = 'https://github.com/pandora2000/url_reader'
  s.license = 'MIT'
  s.files = `git ls-files`.split("\n")
  s.add_development_dependency 'rspec', '>= 0'
  s.add_development_dependency 'webmock', '>= 0'
  s.add_runtime_dependency 'activesupport', '>= 4'
  s.add_runtime_dependency 'rest-client', '>= 0'
end
