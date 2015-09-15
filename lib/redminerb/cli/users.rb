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
  end
end
