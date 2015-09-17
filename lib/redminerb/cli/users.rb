# Copyright (c) The Cocktail Experience S.L. (2015)
module Redminerb
  # 'users' Thor subcommand definition
  class Users < Thor
    default_command :list

    desc 'list', 'Shows the current users in our Redmine'
    def list
      Redminerb.init!
      Redminerb.client.users.each do |user|
        puts [user.id, user.login, user.mail].join("\t").green
      end
    end

    desc 'create', 'Creates a user.'
    option :login, required: true
    option :password, required: true
    option :firstname, required: true
    option :lastname, required: true
    option :mail, required: true
    def create
      Redminerb.init!
      puts Redminerb.client.create_user(options).green
    end
  end
end
