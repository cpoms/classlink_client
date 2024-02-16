module ClassLink
  class RequestBuilder
    include Interface
    extend Forwardable

    TEST_ARRAY = [].freeze
    TEST_HASH = {}.freeze

    def_delegators :@client,
      :base_url,
      :access_token,
      :client_id,
      :client_secret,
      :proxy_api

    def initialize(client)
      @client = client

      @path_parts = []
      @query = {}
      @last_request_call = nil
    end

    def chain(request, options)
      @last_request_call = request
      @query.merge!(options[:query]) if options[:query]
      @path_parts += [request, *options[:segments]].map{ |s| "#{s}/" }

      self
    end

    def result
      @result ||= execute
    end

    def execute
      request(build_url)
    end

    def build_url
      URI.join(base_url, *@path_parts).tap do |url|
        url.path = url.path[..-2]
        url.query = @query.to_query
      end
    end

    def method_missing(method_name, *args, &block)
      # prevent accidental method_missing recursion in development
      # which can make things hard to debug.
      super if @in_method_missing
      @in_method_missing = true

      if result.respond_to?(method_name)
        result.public_send(method_name, *args, &block)
      else
        super
      end
    ensure
      @in_method_missing = false
    end

    def respond_to_missing?(method_name, include_private = false)
      if RESOURCES.include?(@last_request_call)
        TEST_ARRAY.respond_to?(method_name)
      elsif RESOURCES.map(&:singularize).include?(@last_request_call)
        TEST_HASH.respond_to?(method_name)
      else
        super
      end
    end
  end
end
