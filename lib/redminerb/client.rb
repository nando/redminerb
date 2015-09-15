# Copyright (c) The Cocktail Experience S.L. (2015)
require 'faraday'

module Redminerb
  # HTTP client to communicate w/ the Redmine server.
  class Client
    attr_reader :connection

    def initialize(cfg)
      @connection = Faraday.new(url: cfg.url) do |f|
        f.adapter Faraday.default_adapter
      end
      @connection.basic_auth(cfg.api_key, cfg.api_key)
    end
  end
end
