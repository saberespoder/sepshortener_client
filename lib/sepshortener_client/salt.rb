require 'digest'

module SepshortenerClient
  class Salt
    def self.generate(text)
      Digest::MD5.hexdigest("#{Time.now.month}#{text}#{ENV['salt']}")
    end
  end
end
