require 'shorten_url_client/version'
require 'rails'

module ShortenUrlClient
  def short_url(url)
  end

  def sanitize_link(link)
    "#{::Rails.application.config.force_ssl ? 'https' : 'http'}://#{link}".gsub(/(http(s)?:\/\/)+/, '\1')
  end

  def real_link(link)
  end
end
