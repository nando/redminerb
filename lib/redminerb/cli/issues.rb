# Copyright (c) The Cocktail Experience S.L. (2015)
module Redminerb
  module Cli
    # Thor's 'issues' subcommand definition
    class Issues < Thor
      default_command :list
  
      desc 'list', 'Shows open issues in our Redmine'
      option :offset, aliases: :o
      option :limit, aliases: :l
      def list
        Redminerb.init!
        Redminerb::Issues.list(options).each do |issue|
          puts "[#{issue.id}] ".blue + issue.subject.green
        end
      end
    end
  end
end
