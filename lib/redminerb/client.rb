# Copyright (c) The Cocktail Experience S.L. (2015)
require 'faraday'
require 'json'
require 'ostruct'

module Redminerb
  # HTTP client to communicate w/ the Redmine server.
  class Client
    class UnprocessableEntity < StandardError; end

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

    # Creates a brand new user with the given params. In lib/reminerb/cli/user.rb
    # you can see which ones are required (or running 'redminerb users create'
    # from the command line).
    #
    # Example (missing required params):
    #   Redminerb.init!
    #   Redminerb.client.create_user login: 'wadus'

    def create_user(params)
      response = post_json('/users.json', user: params)

      if response.success?
        'Created'
      else
        raise_error! response
      end
    end

    private

    # Makes a GET request of the given 'path' param and returns the body of the
    # response parsed as JSON.
    def get_json(path)
      Redminerb.init_required!
      res = @connection.get(path)
      JSON.parse(res.body)
    rescue JSON::ParserError => e
      raise e, "HTTP status code #{res.status}"
    end

    # Makes a POST request to 'path' with 'params' in JSON format. 
    def post_json(path, params)
      @connection.post do |req|
        req.url path
        req.headers['Content-Type'] = 'application/json'
        req.body = params.to_json
      end
    end

    # It raises an exception giving the validation messages for 422 responses
    def raise_error!(res)
      if res.status == 422
        begin
          errors = JSON.parse(res.body)['errors']
        rescue JSON::ParserError
          errors = [res.body]
        end
        fail UnprocessableEntity, errors.join("\n")
      else
        fail StandardError, "ERROR (status code #{res.status})"
      end
    end
  end
end
