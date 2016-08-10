require 'test_helper'

describe SepshortenerClient::SanitizeLink do
  describe '::call' do
    describe 'when link do not includes http prefix' do
      it 'returns link with one http prefix' do
        SepshortenerClient::SanitizeLink.call('test_link/123').must_equal('http://test_link/123')
      end
    end

    describe 'when link includes only one http prefix' do
      it 'returns link with one http prefix' do
        SepshortenerClient::SanitizeLink.call('http://test_link/123').must_equal('http://test_link/123')
      end
    end

    describe 'when link is freeze and includes only one http prefix' do
      it 'returns link with one http prefix' do
        SepshortenerClient::SanitizeLink.call('http://test_link/123'.freeze).must_equal('http://test_link/123')
      end
    end

    describe 'when link includes only one http prefix' do
      it 'returns link with one http prefix' do
        SepshortenerClient::SanitizeLink.call('http://test_link/123').must_equal('http://test_link/123')
      end
    end

    describe 'when link includes more than one http prefix' do
      it 'returns link with one http prefix' do
        SepshortenerClient::SanitizeLink.call('http://http://http://test_link/123').must_equal('http://test_link/123')
      end
    end
  end
end
