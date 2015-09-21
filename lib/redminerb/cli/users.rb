# Copyright (c) The Cocktail Experience S.L. (2015)
module Redminerb
  module Cli
    # 'users' Thor subcommand definition
    class Users < Thor
      default_command :list
  
      desc 'list', 'Shows the current users in our Redmine'
      option :fields, aliases: :f, banner: 'id:login:email'
      option :name,   aliases: [:q, '--query'], banner: '<FILTER>'
      def list
        Redminerb.init!
        fields = options.delete(:fields) || 'id:login:mail'
        Redminerb::Users.list(options).each do |user|
          puts fields.split(':').map {|f| user.send(f)}.join("\t").green
        end
      end
  
      desc 'create', 'Creates a user.'
      option :login,     aliases: :l,  required: true
      option :password,  aliases: :p,  required: true
      option :firstname, aliases: :fn, required: true
      option :lastname,  aliases: :ln, required: true
      option :mail,      aliases: :m,  required: true
      def create
        Redminerb.init!
        puts Redminerb::Users.create(options).green
      end
  
      desc 'me', 'Shows the info of the owner of the API key'
      def me
        Redminerb.init!
        Redminerb::Users.me.each do |field, value|
          puts "#{field}: ".blue + value.to_s.green
        end
      end
    end
  end
end
