# Copyright (c) The Cocktail Experience S.L. (2015)
require 'ostruct'

module Redminerb
  # Users resource wrapper
  class Users
    class << self
      # Get the users of our Redmine as OpenStruct objects.
      #
      # Example:
      #   Redminerb.init!
      #   Redminerb::Users.list.each do |user|
      #      puts user.firstname
      #   end
      #
      # See lib/reminerb/cli/user.rb code to see other example/s.
  
      def list(params)
        Redminerb.client.get_json('/users.json', params)['users'].map do |user|
          OpenStruct.new user
        end
      end
  
      # Creates a brand new user with the given params. In lib/reminerb/cli/user.rb
      # you can see which ones are required (or running 'redminerb users create'
      # from the command line).
      #
      # Example (that will miss required params :_(:
      #   Redminerb.init!
      #   Redminerb::Users.create login: 'wadus'
  
      def create(params)
        response = Redminerb.client.post_json('/users.json', user: params)
  
        if response.success?
          'Created'
        else
          Redminerb::Client.raise_error! response
        end
      end
  
      # Returns a hash with the info of the user's account behind the API key that
      # is used by the script to access the Redmine's REST API.
      #
      # Example:
      #   Redminerb.init!
      #   me = Redminerb::Users.me
      #   puts me['login'] + ': ' + me['mail']
  
      def me
        Redminerb.client.get_json('/users/current.json')['user']
      end

      def read(id)
        OpenStruct.new Redminerb.client.get_json("/users/#{id}.json")['user']
      end
    end
  end
end
