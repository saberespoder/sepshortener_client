require 'json'

module SepshortenerClient
  class BatchRequest
    def call(links)
      return [] if links.empty?

      make_request("#{SEPSHORTENER_HOST}/batch", {
        ops: links.map { |link| link_request(link) },
        sequential: true
      }).map do |result|
        data_hash = { origin_url: result['body']['origin_url'] }
        data_hash[:short_url] = SanitizeLink.call("#{ENV["SEPSHORTENER_REPLY"]}/#{result['body']['short_url']}") if result['body']['short_url']
        data_hash[:error] = result['body']['error'] if result['body']['error']

        data_hash
      end
    rescue
      links
    end

  private

    def link_request(link)
      {
        method: "post",
        url: "/short_link.json",
        params: { url: link },
        headers: {
          'salt' => Salt.generate(link),
          'Content-Type' => CONTENT_TYPE,
          'Accept' => CONTENT_TYPE
        }
      }
    end

    # to class
    def make_request(url, params)
      uri = URI(SanitizeLink.call(url))
      req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
      req.body = params.to_json
      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end

      results(response)
    end

    def results(response)
      JSON.parse(response.body)['results']
    end
  end
end
