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
      ENV['HOME'] = './fixtures/home'
      Redminerb.init!
      _(Redminerb).must_be :initialized?
      ENV['HOME'] = real_home
    end
  end
end
