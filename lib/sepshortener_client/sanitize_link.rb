require 'digest'

module SepshortenerClient
  class SanitizeLink
    def self.call(link)
      link = link.sub(/(http(s)?:\/\/)+/, '')
      "http://#{link}"
    end
  end
end
