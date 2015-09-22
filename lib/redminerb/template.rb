# Copyright (c) The Cocktail Experience S.L. (2015)
require 'ostruct'

module Redminerb
  # Class to read Redminerb's ERB templates
  class Template
    class << self
      # Returns the content of the given ERB file in the templates directory.
      #
      # Example:
      #   Redminerb::Template.read(:issue) # Returns the content of templates/issue.erb
      #

      def read(name)
        File.read(filepath(name))
      end

      private

      def filepath(name)
        File.join(File.dirname(__FILE__)[0..-15], 'templates', "#{name}.erb")
      end
    end
  end
end
