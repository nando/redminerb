# Copyright 2015 The Cocktail Experience, S.L.
require_relative 'spec_helper'

describe Redminerb do
  after do
    Redminerb.end!
  end

  describe 'initialization' do
    it 'should not be initialized before calling .init!' do
      _(Redminerb).wont_be :initialized?
    end

    it 'should be initialized after calling .init!' do
      real_home = ENV['HOME']
      ENV['HOME'] = SPECS_HOME_DIR
      Redminerb.init!
      _(Redminerb).must_be :initialized?
      ENV['HOME'] = real_home
    end
  end

  describe '.init!' do
    before do
      @real_home = ENV['HOME']
      ENV['HOME'] = SPECS_HOME_DIR

      Redminerb.init!
    end

    after do
      ENV['HOME'] = @real_home
    end

    it 'creates a Config instance' do
      _(Redminerb.config).must_be_kind_of Redminerb::Config
    end

    it 'creates a Client instance and exposes it' do
      _(Redminerb.client).must_be_kind_of Redminerb::Client
    end
  end
end
