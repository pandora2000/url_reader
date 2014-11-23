require 'spec_helper'

class DummUrlReader
  include UrlReader
end

describe UrlReader do
  let(:content) { File.read(File.expand_path('../test.html', __FILE__)) }
  let(:url) { 'http://www.example.com/test.html' }
  let(:read) { -> { DummUrlReader.new.read_url(url) } }

  describe '#read_url' do
    it 'should read url' do
      stub_request(:any, url).to_return(body: content)
      expect(read.call).to eq content
    end
  end
end
