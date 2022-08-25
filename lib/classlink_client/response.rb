require "json"

module ClassLink
  class Response
    extend Forwardable

    def_delegators :@net_http_response, :code, :message, :uri, :body

    def initialize(net_http_response)
      @net_http_response = net_http_response

      raise RequestError unless code.start_with?("2")
    end

    def parsed
      @parsed ||= JSON.parse(body).then do |res|
        # API responses are keyed (somewhat randomly)
        res.is_a?(Hash) ? res.values[0] : res
      end
    rescue JSON::ParserError
      warn "Error parsing response as JSON, returning raw body instead."

      body
    end

    def method_missing(method_name, *args, &block)
      if parsed.respond_to?(method_name)
        parsed.public_send(method_name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      parsed.respond_to?(method_name) || super
    end
  end
end
