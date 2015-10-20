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
    fail(UninitializedError, 'call Redminerb.init! first') unless @initialized
  end

  def config
    init_required!
    @config
  end

  def client
    init_required!
    @client
  end

  # ASCII old-school box's part output functions
  def separator
    @separator ||= '─' * TermInfo.screen_columns
  end
  
  def top
    '┌' + separator[0..-3] + '┐'
  end
  
  def middle
    '├' + separator[0..-3] + '┤'
  end
  
  def bottom
    '└' + separator[0..-3] + '┘'
  end
  
  def max_length
    TermInfo.screen_columns - 4
  end
  
  def line(string)
    uncolorized = string.uncolorize
    if uncolorized.size > max_length
      "│ #{string[0..(max_length - 1)]} │\n#{line(string[max_length..-1])}" if string
    else
      "│ #{string}#{fill_with_spaces(uncolorized)} │"
    end
  end

  def fill_with_spaces(string)
    ' ' * (max_length - string.size)
  end
end
