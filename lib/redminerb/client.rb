# Copyright (c) The Cocktail Experience S.L. (2015)
require 'faraday'
require 'json'

module Redminerb
  # HTTP client to communicate w/ the Redmine server.
  class Client
    class UnprocessableEntity < StandardError; end

    attr_reader :requests

    def initialize(cfg)
      @connection = Faraday.new(url: cfg.url) do |f|
        f.adapter Faraday.default_adapter
      end
      @connection.basic_auth(cfg.api_key, cfg.api_key)
      @requests = 0
    end

    # Uses pagination (limit&offset) params to retreive all the resources of
    # the collection "name" using "params" in each request. Returns an array
    # with all the resources.
    def get_collection(name, params = {})
      offset = 0
      params[:limit] ||= 100
      [].tap do |resources|
        loop do
          params[:offset] = offset
          response = get_json("/#{name}.json", params)
          resources << response[name.to_s]
          offset += params[:limit].to_i
          break unless offset < response['total_count']
        end
      end.flatten
    end

    # Makes a GET request of the given 'path' param and returns the body of the
    # response parsed as JSON.
    def get_json(path, params = {})
      Redminerb.init_required!
      res = _get(path, params)
      if res.success?
        JSON.parse(res.body)
      else
        fail StandardError, "ERROR (status code #{res.status})"
      end
    rescue JSON::ParserError => e
      raise e, "HTTP status code #{res.status}"
    end

    # Makes a POST request to 'path' with 'params' in JSON format. 
    def post_json(path, params)
      Redminerb.init_required!
      @connection.post do |req|
        req.url path
        req.headers['Content-Type'] = 'application/json'
        req.body = params.to_json
      end
    end

    # It raises an exception giving the validation messages for 422 responses.
    def self.raise_error!(res)
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

    private

    def _get(path, params)
      @requests += 1
      @connection.get do |req|
        req.url path
        req.headers['Content-Type'] = 'application/json'
        req.body = params.to_json if params.any?
      end
    end
  end
end
