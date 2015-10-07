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
        projects = Redminerb.client.get_json('/projects.json', params)['projects']
        if (name = params.delete(:name))
          projects = projects.select {|project| project['name'] =~ /#{name}/i}
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
    end
  end
end
