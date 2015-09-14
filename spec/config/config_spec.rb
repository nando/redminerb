# Copyright 2015 The Cocktail Experience, S.L.
require_relative '../spec_helper'

describe Redminerb::Config do
  after do
    Redminerb.end!
  end

  describe '.new' do
    subject { Redminerb::Config.new }

    it 'should fail if called without config file' do
      real_home = ENV['HOME']
      spec_home = SPECS_TMP_DIR
      FileUtils.rm_rf spec_home
      ENV['HOME'] = spec_home
      proc do
        Redminerb::Config.new
      end.must_raise Errno::ENOENT
      ENV['HOME'] = real_home
    end

    it 'should load auth params from the config file (~/.redminerb.yml)' do
      real_home = ENV['HOME']
      ENV['HOME'] = SPECS_HOME_DIR

      # read from ./spec/fixtures/home/.redminerb.yml
      _(subject.url).must_equal 'http://localhost:3000/'

      ENV['HOME'] = real_home
    end
  end
end
