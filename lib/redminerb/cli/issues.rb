# Copyright (c) The Cocktail Experience S.L. (2015)
require 'erb'
require_relative '../issues'

module Redminerb
  module Cli
    # Thor's 'issues' subcommand definition
    class Issues < Thor
      default_command :show
  
      desc 'list', 'Shows open issues in our Redmine'
      option :offset, aliases: :o
      option :limit, aliases: :l
      def list
        Redminerb.init!
        Redminerb::Issues.list(options).each do |issue|
          puts "[#{issue.id}] ".blue + issue.subject.green
        end
      end

      desc 'show <number>', 'Shows the data of the issue which id match with #<number>'
      def show(issue_id)
        Redminerb.init!
        issue = Redminerb::Issues.read(issue_id)
        template = Redminerb::Template.read(:issue)
        puts ERB.new(template).result(binding)
      end
    end
  end
end
