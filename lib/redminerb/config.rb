# Copyright 2015 The Cocktail Experience, S.L.
require 'yaml'

module Redminerb
  # Read user's config from ~/.redminerb.yml
  class Config
    def initialize
      ENV['REDMINERB_URL'] ? _from_env : _from_yml
    end

    def url
      Redminerb.init_required!
      @url
    end

    def api_key
      Redminerb.init_required!
      @api_key
    end

    private

    def _from_yml
      YAML.load_file(File.join(ENV['HOME'], '.redminerb.yml')).tap do |yaml|
        @url = yaml['url']
        @api_key = yaml['api_key']
      end
    end

    def _from_env
      @url = ENV['REDMINERB_URL']
      @api_key = ENV['REDMINERB_API_KEY']
    end
  end
end
