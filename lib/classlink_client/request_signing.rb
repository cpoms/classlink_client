require "net/https"
require "base64"
require_relative "response"

module ClassLink
  module RequestSigning
    def request(url)
      if proxy_api
        get(url, "Bearer #{access_token}")
      else
        get(url, auth_header(url))
      end
    end

    private
      def auth_header(url)
        # Generate timestamp and nonce
        timestamp = Time.now.to_i.to_s
        nonce = ('A'..'Z').to_a.sample(8).join

        oauth = {
          "oauth_consumer_key" => client_id,
          "oauth_signature_method" => "HMAC-SHA256",
          "oauth_timestamp" => timestamp,
          "oauth_nonce" => nonce,
        }

        # Combine oauth params and url params
        params = url.query ? CGI.parse(url.query).transform_values(&:first) : {}
        params.merge!(oauth)

        # Generate the auth signature
        base_info = build_base_string(url.to_s.split("?")[0], "GET", params)
        composite_key = CGI.escape(client_secret) + "&"
        auth_signature = generate_auth_signature(base_info, composite_key)
        oauth["oauth_signature"] = auth_signature

        # Generate auth header
        build_auth_header(oauth)
      end

      def build_base_string(base_url, http_method, params)
        param_string = params.to_query.gsub("+", "%20")

        http_method + "&" + CGI.escape(base_url) + "&" + CGI.escape(param_string)
      end

      def generate_auth_signature(base_info, composite_key)
        Base64.encode64(OpenSSL::HMAC::digest(
          OpenSSL::Digest.new("sha256"),
          composite_key,
          base_info
        ))
      end

      def build_auth_header(oauth)
        values = oauth.map{ |k, v| "#{k}=\"#{CGI.escape(v)}\"" }
        values << values.pop[0..-5] + "\""
        result = "OAuth #{values.join(",")}"
      end

      def get(url, header)
        req = Net::HTTP::Get.new(url.request_uri)
        req["Authorization"] = header

        http = Net::HTTP.new(url.hostname, url.port)
        http.use_ssl = true
        res = http.request(req)

        Response.new(res)
      end
  end
end
