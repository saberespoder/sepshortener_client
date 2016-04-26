require 'sepshortener_client/version'
require 'digest'

module SepshortenerClient
  INBOUNDSMS_TOKEN  = "INBOUNDSMS".freeze
  SEPRESEARCH_TOKEN = "SEPRESEARCH".freeze
  SEPCONTENT_TOKEN  = "SEPCONTENT".freeze

  CONTENT_TYPE = 'application/json'.freeze

  def short_url(url)
    return unless url
    response = HTTParty.post(
      sanitize_link("#{SEPSHORTENER_HOST}/short_link.json"),
      body: { url: url }.to_json,
      headers: {
        'salt' => Digest::MD5.hexdigest("#{Time.now.month}#{url}#{ ENV['salt']}" ),
        'Content-Type' => CONTENT_TYPE,
        'Accept' => CONTENT_TYPE 
      }
    )

    sanitize_link("#{SEPSHORTENER_REPLY}/#{response['short_url']}") if response.code == 200
  rescue => e
    Honeybadger.notify(e)
  end

  def sanitize_link(link)
    link.gsub!(/(http(s)?:\/\/)+/, '')
    "https://#{link}"
  end

  def real_link(link)
    return unless link

    link.gsub(/\A(#{INBOUNDSMS_TOKEN}|#{SEPRESEARCH_TOKEN}|#{SEPCONTENT_TOKEN})/) do |str|
      Kernel.const_get("#{str}_HOST")
    end
  end
end
