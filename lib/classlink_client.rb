# frozen_string_literal: true

require "active_support/core_ext/string"
require_relative "classlink_client/version"
require_relative "classlink_client/client"

module ClassLink
  class RequestError < StandardError; end
end
