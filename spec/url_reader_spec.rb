require 'spec_helper'

describe UrlReader do
  let(:filename) { File.expand_path('../../tmp/spec.log', __FILE__) }
  let(:logger) { LoGspot.new(filename) }
  let(:read) { -> { File.read(filename) } }

  describe '#read_url' do
    it 'should read url' do
    end
  end
end
