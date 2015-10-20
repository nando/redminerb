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

  describe '.line(string)' do
    let(:simple_string) { 'The sky is blue.' }
    let(:string_with_color) { "The sky is #{'blue'.blue}." }

    it 'returns the string between ASCII thick bars' do
      TermInfo.stub(:screen_columns, simple_string.size + 4) do
        _(Redminerb.line(simple_string)).must_equal "│ #{simple_string} │"
      end
    end

    it 'fills the line with spaces until the end of the line' do
      TermInfo.stub(:screen_columns, simple_string.size + 6) do
        _(Redminerb.line(simple_string)).must_equal "│ #{simple_string}   │"
      end
    end

    it 'uncolorizes the string to calculate its output' do
      TermInfo.stub(:screen_columns, simple_string.size + 4) do
        _(Redminerb.line(string_with_color)[-3..-1]).must_equal '. │'
      end
    end
  end
end
