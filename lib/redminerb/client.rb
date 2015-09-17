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

    # Get the users of our Redmine as OpenStruct objects.
    #
    # Example:
    #   Redminerb.init!
    #   Redminerb.client.users.each do |user|
    #      puts user.firstname
    #   end
    #
    # See lib/reminerb/cli/user.rb code to see other example/s.

    def users
      get_json('/users.json')['users'].map do |user|
        OpenStruct.new user
      end
    end

    private

    # Requests the path that receives as param and parses the body of the
    # response received as JSON.
    def get_json(path)
      Redminerb.init_required!
      res = @connection.get(path)
      JSON.parse(res.body)
    rescue JSON::ParserError => e
      raise e, "HTTP status code #{res.status}"
    end
  end
end
