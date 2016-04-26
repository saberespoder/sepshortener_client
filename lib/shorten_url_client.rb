require 'shorten_url_client/version'
require 'rails'

module ShortenUrlClient
  def short_url(url)
  end

  def sanitize_link(link)
    link.gsub!(/(http(s)?:\/\/)+/, '')
    "#{::Rails.application.config.force_ssl ? 'https' : 'http'}://#{link}"
  end

  def real_link(link)
  end
end
