# Copyright (c) The Cocktail Experience S.L. (2015)
require 'thor'
require 'colorize'
require_relative '../redminerb'
require_relative 'cli/users'
require_relative 'cli/issues'
require_relative 'cli/projects'

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

    # The subcommad's classes are defined in lib/redminerb/cli
    desc 'users [list|<id>]', "Manage Redmine's users"
    subcommand 'users', Cli::Users
    desc 'issues [list|<id>]', "Manage Redmine's issues"
    subcommand 'issues', Cli::Issues
    desc 'projects [list|<id>]', "Manage Redmine's projects"
    subcommand 'projects', Cli::Projects
  end
end
