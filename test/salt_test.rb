require 'test_helper'

describe SepshortenerClient::Salt do

  describe '::generate' do
    it 'returns salt string from text' do
      salt = SepshortenerClient::Salt.generate('text')
      salt.must_be_kind_of String
      salt.length.must_equal 32
    end
  end
end
