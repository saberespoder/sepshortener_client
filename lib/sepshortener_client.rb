require 'sepshortener_client/version'
require 'sepshortener_client/sanitize_link'
require 'sepshortener_client/salt'
require 'net/http'
require 'json'
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
      'salt' => Salt.generate(link),
      'Content-Type' => CONTENT_TYPE,
      'Accept' => CONTENT_TYPE
    }

    http = Net::HTTP.new(uri.host, uri.port)
    response = http.get(uri.path, headers)
    data = JSON.parse(response.body)

    sanitize_link("#{ENV["SEPSHORTENER_REPLY"]}/#{data['short_url']}") if response.code.to_i == 200
  rescue
    link
  end

  def butch_shorting(links)
    return [] if links.empty?

    request_params = links.map do |link|
      {
        method: "post",
        url: "/short_link.json",
        params: { url: link },
        headers: {
          'salt' => Digest::MD5.hexdigest("#{Time.now.month}#{link}#{ENV['salt']}"),
          'Content-Type' => CONTENT_TYPE,
          'Accept' => CONTENT_TYPE
        }
      }
    end

    params = {
      ops: request_params,
      sequential: true
    }

    uri = URI(sanitize_link("#{SEPSHORTENER_HOST}/batch"))
    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    req.body = params.to_json
    response = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end

    data = JSON.parse(response.body)

    data['results'].map do |result|
      data_hash = { origin_url: result['body']['origin_url'] }
      data_hash[:short_url] = sanitize_link("#{ENV["SEPSHORTENER_REPLY"]}/#{result['body']['short_url']}") if result['body']['short_url']
      data_hash[:error] = result['body']['error'] if result['body']['error']

      data_hash
    end
  rescue
    links
  end

  def sanitize_link(link)
    SanitizeLink.call(link)
  end

  def real_link(link)
    return unless link

    link.gsub(/\A(#{INBOUNDSMS_TOKEN}|#{SEPRESEARCH_TOKEN}|#{SEPCONTENT_TOKEN})/) do |str|
      Kernel.const_get("#{str}_HOST")
    end
  end
end
