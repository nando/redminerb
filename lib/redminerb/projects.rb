# Copyright (c) The Cocktail Experience S.L. (2015)
require 'recursive-open-struct'

module Redminerb
  # Projects resource wrapper
  class Projects
    class << self
      # Get Redmine's projects as OpenStruct objects.
      #
      # Example:
      #   Redminerb.init!
      #   Redminerb::Projects.list.each do |project|
      #      puts "#{project.id}: #{project.name}"
      #   end
      #
      def list(params)
        projects = if params.delete(:all)
                     Redminerb.client.get_collection(:projects, params)
                   elsif (name = params.delete(:name))
                     filter_projects_by_name name, params
                   else
                     Redminerb.client.get_json('/projects.json', params)['projects']
                   end
        projects.map do |project|
          OpenStruct.new project
        end
      end

      # Get an project's info as an OpenStruct object.
      #
      # Example:
      #   Redminerb.init!
      #   project = Redminerb::Projects.read(34)
      #   puts "#{project.id}: #{project.name}"
      #
      def read(id)
        RecursiveOpenStruct.new Redminerb.client.get_json("/projects/#{id}.json")['project']
      end

      private

      def filter_projects_by_name(name, params)
        Redminerb.client.get_collection(:projects, params).select do |project|
          project['name'] =~ /#{name}/i
        end
      end
    end
  end
end
