# Copyright (c) The Cocktail Experience S.L. (2015)
require 'recursive-open-struct'

module Redminerb
  # Issues resource wrapper
  class Issues
    class << self
      # Get Redmine's issues as OpenStruct objects.
      #
      # Example:
      #   Redminerb.init!
      #   Redminerb::Issues.list.each do |issue|
      #      puts "#{issue.id}: #{issue.subject}"
      #   end
      #
      def list(params)
        Redminerb.client.get_json('/issues.json', params)['issues'].map do |issue|
          RecursiveOpenStruct.new issue
        end
      end

      # Get an issue's info as an OpenStruct object.
      #
      # Example:
      #   Redminerb.init!
      #   issue = Redminerb::Issues.read(34)
      #   puts "#{issue.id}: #{issue.subject}"
      #
      def read(id)
        RecursiveOpenStruct.new Redminerb.client.get_json("/issues/#{id}.json")['issue']
      end
    end
  end
end
