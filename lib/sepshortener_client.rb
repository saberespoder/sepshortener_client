require 'sepshortener_client/version'
require 'net/https'
require 'digest'
require 'uri'

module SepshortenerClient
  INBOUNDSMS_TOKEN  = "INBOUNDSMS".freeze
  SEPRESEARCH_TOKEN = "SEPRESEARCH".freeze
  SEPCONTENT_TOKEN  = "SEPCONTENT".freeze

  CONTENT_TYPE = 'application/json'.freeze

  def short_url(link)
    return unless link

    params = URI.encode_www_form("url" => link)
    uri = URI.parse(sanitize_link("#{SEPSHORTENER_HOST}/short_link.json?#{params}"))
    headers = {
      'salt' => Digest::MD5.hexdigest("#{Time.now.month}#{link}#{ENV['salt']}" ),
      'Content-Type' => CONTENT_TYPE,
      'Accept' => CONTENT_TYPE 
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    response = http.get(uri.path, headers)
    data = JSON.parse(response.body)

    sanitize_link("#{ENV["SEPSHORTENER_REPLY"]}/#{data['short_url']}") if response.code.to_i == 200
  end

  def sanitize_link(link)
    link.sub!(/(http(s)?:\/\/)+/, '')
    "https://#{link}"
  end

  def real_link(link)
    return unless link

    link.gsub(/\A(#{INBOUNDSMS_TOKEN}|#{SEPRESEARCH_TOKEN}|#{SEPCONTENT_TOKEN})/) do |str|
      Kernel.const_get("#{str}_HOST")
    end
  end
end
