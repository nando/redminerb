# Copyright (c) The Cocktail Experience S.L. (2015)
require_relative 'redminerb/version'
require_relative 'redminerb/config'
require_relative 'redminerb/client'
require_relative 'redminerb/cli'

# Main module 
module Redminerb
  class UninitializedError < StandardError; end

  module_function

  @initialized = false

  def init!
    @initialized = true
    @config = Redminerb::Config.new
    @client = Redminerb::Client.new(@config)
  end

  def end!
    @initialized = false
    @config = nil
    @client = nil
  end

  def initialized?
    @initialized
  end

  def init_required!
    fail(UninitializedError, 'Call Redminerb.init! first') unless @initialized
  end

  def config
    @config
  end

  def client
    @client
  end
end
