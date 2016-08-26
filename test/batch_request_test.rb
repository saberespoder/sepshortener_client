require 'test_helper'

describe SepshortenerClient::BatchRequest do
  describe '#call' do
    describe 'for any exeptions' do
      it 'returns array of origin links' do
        SEPSHORTENER_HOST = 'empty.com'
        result = SepshortenerClient::BatchRequest.new.call(%w[site.com/1 site.com/2 site.com/3])
        result.must_equal [
          { origin_url: "site.com/1" },
          { origin_url: "site.com/2" },
          { origin_url: "site.com/3" }
        ]
      end
    end
  end
end
