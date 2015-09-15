# Copyright (c) The Cocktail Experience S.L. (2015)
require 'faraday'
require 'json'
require 'ostruct'

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

    def get_json(path)
      Redminerb.init_required!
      JSON.parse(@connection.get(path).body)
    end

    def users
      get_json('/users.json')['users'].map do |user|
        OpenStruct.new user
      end
    end
  end
end
