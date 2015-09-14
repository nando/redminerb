# Copyright (c) The Cocktail Experience S.L. (2015)
require_relative 'redminerb/version'
require_relative 'redminerb/config'

# Main module 
module Redminerb
  module_function

  @initialized = false

  def init!
    @initialized = true
  end

  def end!
    @initialized = false
  end

  def initialized?
    @initialized
  end
end
