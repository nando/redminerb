# Copyright (c) The Cocktail Experience S.L. (2015)
require 'terminfo'
require_relative 'redminerb/version'
require_relative 'redminerb/config'
require_relative 'redminerb/client'
require_relative 'redminerb/cli'
require_relative 'redminerb/template'

# Main module 
module Redminerb
  class UninitializedError < StandardError; end
  class NotFoundError < StandardError; end

  module_function

  @initialized = false

  # Module initialization needed before doing anything. It looks ~/.redminerb.yml
  # to get the authentication info to connect with the Redmine REST API.
  #
  # Example:
  #   >> Reminerb.init!
  #   => true
  def init!
    @initialized = true
    @config = Redminerb::Config.new
    @client = Redminerb::Client.new(@config)
  end

  # NOTICE: method needed by the build. Clean the module for the next test.
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

  def separator
    @separator ||= ('-' * TermInfo.screen_columns).green
  end
end
