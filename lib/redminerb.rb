# Copyright (c) The Cocktail Experience S.L. (2015)
require 'redminerb/version'

# Main module 
module Redminerb
  module_function

  @initialized = false

  def init!
    @initialized = true
  end

  def initialized?
    @initialized
  end
end
