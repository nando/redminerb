# Copyright 2015 The Cocktail Experience, S.L.
require_relative '../spec_helper'

describe Redminerb::Config do
  after do
    Redminerb.end!
  end

  describe '.new' do
    # Fake home without YAML
    before do
      @real_home = ENV['HOME']
      ENV['HOME'] = SPECS_TMP_DIR
      FileUtils.rm_rf SPECS_TMP_DIR
    end

    after do
      ENV['HOME'] = @real_home
    end

    let(:clean_env) do
      {
        'REDMINERB_URL'     => nil,
        'REDMINERB_API_KEY' => nil
      }
    end

    let(:url)     { 'http://myredmine.org/' }
    let(:api_key) { '121addfde66a9546bfc8d43536787544bff8d72a' }
    let(:nice_env) do
      {
        'REDMINERB_URL'     => url,
        'REDMINERB_API_KEY' => api_key
      }
    end

    describe 'on a "nice" environment (w/ REDMINERB_URL&REDMINERB_API_KEY)' do
      subject { Redminerb::Config.new }
      it 'should load auth params from it' do
        ClimateControl.modify nice_env do
          Redminerb.init!
          _(subject.url).must_equal url
          _(subject.api_key).must_equal api_key
        end
      end

      [:url, :api_key].each do |config_method|
        describe "##{config_method}" do
          it 'fails unless Redminerb.init! has been called' do
            ClimateControl.modify nice_env do
              proc do
                subject.send config_method
              end.must_raise Redminerb::UninitializedError
            end
          end
        end
      end
    end

    describe 'on a "clean" environment' do
      it 'should fail if called without config file' do
        ClimateControl.modify clean_env do
          proc do
            Redminerb::Config.new
          end.must_raise Errno::ENOENT
        end
      end

      describe 'with a good YAML (e.g. spec/fixtures/home/.redminerb.yml)' do
        subject { Redminerb::Config.new }
        before do
          @real_home = ENV['HOME']
          ENV['HOME'] = SPECS_HOME_DIR
        end
  
        after do
          ENV['HOME'] = @real_home
        end
  
        it 'should load auth params from ~/.redminerb.yml' do
          Redminerb.init!
          _(subject.url).must_equal 'http://localhost:3000/' # as in spec/fixtures
          _(subject.api_key).must_equal '23b17d15e66a9546bfc8d48f86087d44bff8d72c'
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
end
