# Copyright (c) The Cocktail Experience S.L. (2015)
module Redminerb
  # 'users' Thor subcommand definition
  class Users < Thor
    default_command :list

    desc 'list', 'Shows the current users in our Redmine'
    option :fields, banner: 'id:login:email'
    def list
      Redminerb.init!
      fields = options[:fields] || 'id:login:mail'
      Redminerb.client.users.each do |user|
        puts fields.split(':').map {|f| user.send(f)}.join("\t").green
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

    desc 'me', 'Shows the info of the owner of the API key'
    def me
      Redminerb.init!
      Redminerb.client.me.each do |field, value|
        puts "#{field}: ".blue + value.to_s.green
      end
    end
  end
end
