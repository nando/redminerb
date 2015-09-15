# Copyright (c) The Cocktail Experience S.L. (2015)
require_relative 'redminerb/version'
require_relative 'redminerb/cli'
require_relative 'redminerb/config'
require_relative 'redminerb/client'

# Main module 
module Redminerb
  module_function

  @initialized = false

  def init!
    @config = Redminerb::Config.new
    @client = Redminerb::Client.new(@config)
    @initialized = true
  end

  def end!
    @config = nil
    @client = nil
    @initialized = false
  end

  def initialized?
    @initialized
  end

  def config
    @config
  end

  def connection
    @client.connection
  end
end
