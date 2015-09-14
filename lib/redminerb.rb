# Copyright (c) The Cocktail Experience S.L. (2015)
require_relative 'redminerb/version'
require_relative 'redminerb/config'

# Main module 
module Redminerb
  module_function

  @initialized = false

  def init!
    @config = Redminerb::Config.new
    @initialized = true
  end

  def end!
    @config = nil
    @initialized = false
  end

  def initialized?
    @initialized
  end

  def config
    @config
  end
end
