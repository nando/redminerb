# Copyright 2015 The Cocktail Experience, S.L.
require_relative '../lib/redminerb'

require 'pry'
require 'minitest/spec'
require 'minitest/autorun'

require 'minitest-vcr'
require 'webmock'
require 'climate_control'

SPECS_TMP_DIR      = './tmp/specs'
SPECS_FIXTURES_DIR = './spec/fixtures'
SPECS_HOME_DIR     = SPECS_FIXTURES_DIR + '/home'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
end

MinitestVcr::Spec.configure!

module Redminerb
  module Spec
    def fixture_path(filename)
      File.join(File.dirname(__FILE__), 'fixtures', filename)
    end
    
    def json_from_fixture(fixture)
      JSON.parse(File.read(fixture_path("#{fixture}.json")))
    end

    def capture(stream)
      # rubocop:disable Lint/Eval
      begin
        stream = stream.to_s
        eval "$#{stream} = StringIO.new"
        yield
        result = eval("$#{stream}").string
      ensure
        eval("$#{stream} = #{stream.upcase}")
      end
      result
      # rubocop:enable Lint/Eval
    end
  end
end
