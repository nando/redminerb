# Copyright 2015 The Cocktail Experience, S.L.
require_relative '../spec_helper'

describe Redminerb::Config do
  after do
    Redminerb.end!
  end

  describe '.new' do
    before do
      @real_home = ENV['HOME']
      ENV['HOME'] = SPECS_TMP_DIR
      FileUtils.rm_rf SPECS_TMP_DIR
    end

    after do
      ENV['HOME'] = @real_home
    end

    it 'should fail if called without config file' do
      proc do
        Redminerb::Config.new
      end.must_raise Errno::ENOENT
    end

    describe 'with a good config file (e.g. spec/fixtures/home/.redminerb.yml)' do
      before do
        @real_home = ENV['HOME']
        ENV['HOME'] = SPECS_HOME_DIR
      end

      after do
        ENV['HOME'] = @real_home
      end

      subject { Redminerb::Config.new }

      it 'should load auth params from ~/.redminerb.yml' do
        Redminerb.init!
        _(subject.url).must_equal 'http://localhost:3000/'
      end

      [:url, :api_key].each do |config_method|
        describe "##{config_method}" do
          it 'fails unless Redminerb.init! has been called' do
            proc do
              subject.send config_method
            end.must_raise Redminerb::UninitializedError
          end
        end
      end
    end
  end
end
