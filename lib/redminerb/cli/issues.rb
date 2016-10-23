# Copyright (c) The Cocktail Experience S.L. (2015)
require_relative '../issues'

module Redminerb
  module Cli
    # Thor's 'issues' subcommand definition
    class Issues < Thor
      default_command :list
  
      # rubocop:disable Metrics/AbcSize
      # (disabled to let the "closed" option be managed here)
      desc 'list', 'Shows open issues in our Redmine'
      option :offset,           aliases: :o
      option :limit,            aliases: :l
      option :closed,           aliases: :c, type: :boolean
      option :assigned_to_id,   aliases: :a
      option :project_id,       aliases: :p
      option :fixed_version_id, aliases: :v
      def list(issue_id = nil)
        if issue_id
          show(issue_id)
        else
          Redminerb.init!
          options[:status_id] = :closed if options.delete(:closed)
          Redminerb::Issues.list(options).each do |issue|
            puts "[#{issue.project.name}##{issue.id}] ".blue + issue.subject.green
          end
        end
      end
      # rubocop:enable Metrics/AbcSize

      desc 'show <number>', 'Shows an issue (SHORTCUT: "redminerb issues <number>")'
      option :template, aliases: :t
      def show(issue_id)
        Redminerb.init!
        puts Redminerb::Template.render(:issue, Redminerb::Issues.read(issue_id), options)
      end
    end
  end
end
