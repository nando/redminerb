# Copyright 2015 The Cocktail Experience, S.L.
require 'singleton'
require 'yaml'

module Redminerb
  # Read user's config from ~/.redminerb
  class Config
    attr_reader :url
    attr_reader :api_key

    def initialize
      YAML.load_file(File.join(ENV['HOME'], '.redminerb.yml')).tap do |yaml|
        @url = yaml['url']
        @api_key = yaml['api_key']
      end
    end
  end
end