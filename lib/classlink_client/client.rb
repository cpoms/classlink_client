require "uri"
require_relative "request_signing"
require_relative "interface"
require_relative "request_builder"

module ClassLink
  class Client
    include Interface

    DIRECT_OPTIONS = %i(client_id client_secret endpoint)
    PROXY_OPTIONS = %i(access_token app_id)

    (DIRECT_OPTIONS + PROXY_OPTIONS).each do |opt|
      attr_reader opt
    end

    attr_reader :base_url, :proxy_api

    def initialize(options)
      handle_options!(options)

      # if an endpoint hasn't been supplied, then we're using the proxy
      @proxy_api = !endpoint
      @base_url = endpoint || "https://oneroster-proxy.classlink.io/#{app_id}"
      @base_url << "/ims/oneroster/v1p1/"
    end

    private
      def handle_options!(options)
        sorted_options = options.keys.sort

        if sorted_options != DIRECT_OPTIONS && sorted_options != PROXY_OPTIONS
          raise ArgumentError, <<~MSG.squish
            must pass options for direct access (#{DIRECT_OPTIONS}),
            or options for proxy access (#{PROXY_OPTIONS})
          MSG
        end

        options.each do |opt, value|
          instance_variable_set("@#{opt}", value)
        end
      end
  end
end
