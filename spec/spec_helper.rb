# Copyright 2015 The Cocktail Experience, S.L.
require_relative '../lib/redminerb'

require 'pry'
require 'minitest/spec'
require 'minitest/autorun'

require 'climate_control'
require 'json'

SPECS_TMP_DIR      = './tmp/specs'
SPECS_FIXTURES_DIR = './spec/fixtures'
SPECS_HOME_DIR     = SPECS_FIXTURES_DIR + '/home'

def json_from_fixture(fixture)
  JSON.parse(File.read(fixture_path("#{fixture}.json")))
end

def fixture_path(filename)
  File.join(File.dirname(__FILE__), 'fixtures', filename)
end
