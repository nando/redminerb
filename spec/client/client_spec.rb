# Copyright 2015 The Cocktail Experience, S.L.
require_relative '../spec_helper'

describe Redminerb::Client do
  after do
    Redminerb.end!
  end

  describe '.new(conf)' do
    let(:url) { 'http://expectations/' }
    it 'calls Faraday.new and exposes its connection' do
      skip # Still not able to test this :(
      cfg = Minitest::Mock.new
      cfg.expect(:url, url)
      Faraday.stub(:new, cfg) do
        Redminerb::Client.new(cfg)
      end
    end
  end
end
