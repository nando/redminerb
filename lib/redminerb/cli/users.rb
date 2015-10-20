# Copyright (c) The Cocktail Experience S.L. (2015)
require_relative '../users'

module Redminerb
  module Cli
    # 'users' Thor subcommand definition
    class Users < Thor
      default_command :list
  
      desc 'list', 'Shows the current users in our Redmine.'
      option :fields, aliases: :f, banner: 'id:login:email'
      option :name,   aliases: [:q, '--query'], banner: '<FILTER>'
      option :offset, aliases: :o
      option :limit, aliases: :l
      option :all, type: :boolean

      def list(user_id = nil)
        if user_id
          show user_id
        else
          Redminerb.init!
          fields = options.delete(:fields) || 'id:login:mail'
          Redminerb::Users.list(options).each do |user|
            puts fields.split(':').map {|f| user.send(f)}.join("\t").green
          end
        end
      end
 
      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      # (i'd move code from here but inheriting from Thor i still don't know how :(
      desc 'create', 'Creates a user.'
      option :ask, type: :boolean, default: true
      option :login,     aliases: [:n, '--name']
      option :password,  aliases: [:p, '--pass']
      option :firstname, aliases: [:f, '--fn']
      option :lastname,  aliases: [:l, '--ln']
      option :mail,      aliases: [:m, '--email']
      def create
        Redminerb.init!
        if options[:ask]
          loop do
            initializer_data = @_initializer.detect do |internal|
              internal.is_a?(Hash) && internal.keys.include?(:current_command)
            end
            initializer_data[:current_command].options.keys.each do |option|
              next if option == :ask
              value = ask("#{option.capitalize} [#{options[option]}]:", Thor::Shell::Color::GREEN)
              options[option] = value unless value.empty?
            end
            break if yes?('Is everything OK? (NO/yes)')
          end
        end
        puts Redminerb::Users.create(options).green
      end
      # rubocop:enabled Metrics/AbcSize, Metrics/MethodLength
  
      desc 'me', 'Shows the info of the owner of the API key.'
      def me
        Redminerb.init!
        Redminerb::Users.me.each do |field, value|
          puts "#{field}: ".blue + value.to_s.green
        end
      end

      desc 'show <id>', 'Shows a user (SHORTCUT: "redminerb users <id>").'
      option :template, aliases: :t
      def show(user_id)
        Redminerb.init!
        puts Redminerb::Template.render(:user, Redminerb::Users.read(user_id), options)
      end
    end
  end
end
