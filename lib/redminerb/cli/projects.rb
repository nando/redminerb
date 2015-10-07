# Copyright (c) The Cocktail Experience S.L. (2015)
require_relative '../projects'

module Redminerb
  module Cli
    # Thor's 'projects' subcommand definition
    class Projects < Thor
      default_command :list
  
      desc 'list', 'Shows open projects in our Redmine'
      option :name,   aliases: [:q, '--query'], banner: '<FILTER>'
      option :offset, aliases: :o
      option :limit, aliases: :l
      def list(project_id = nil)
        if project_id
          show(project_id)
        else
          Redminerb.init!
          Redminerb::Projects.list(options).each do |p|
            puts "#{p.id}\t#{p.name.split.map(&:capitalize).join(' ')}".green
          end
        end
      end

      desc 'show <number>', 'Shows an project (SHORTCUT: "redminerb projects <number>")'
      option :template, aliases: :t
      def show(project_id)
        Redminerb.init!
        puts Redminerb::Template.render(:project, Redminerb::Projects.read(project_id), options)
      end
    end
  end
end
