# Copyright (c) The Cocktail Experience S.L. (2015)
require 'thor'
require 'colorize'
require_relative '../redminerb'

module Redminerb
  # Thor's command class
  class CLI < Thor
    desc 'config', 'Shows this session current configuration'
    long_desc <<-LONGDESC
      In this version is the content of the ~/.redminerb.yml file.
    LONGDESC
    def config
      Redminerb.init!
      puts 'URL:     '.blue + Redminerb.config.url.green
      puts 'API-KEY: '.blue + Redminerb.config.api_key.green
    end
  end
end
