# Copyright 2015 The Cocktail Experience, S.L.
require_relative '../spec_helper'
include Redminerb::Spec

describe Redminerb::CLI do
  before do
    @real_home = ENV['HOME']
    ENV['HOME'] = SPECS_HOME_DIR
  end

  after do
    ENV['HOME'] = @real_home
    Redminerb.end!
  end

  subject { Redminerb::CLI.new }
  describe 'users command' do
    describe 'list subcommand ($ redminerb users list<INTRO>:)' do
      before do
        VCR.insert_cassette 'users_list'
      end

      after do
        VCR.eject_cassette
      end

      let(:output) { capture(:stdout) { subject.users 'list' } }

      it 'give us all the users in our Redmine', :vcr do
        output.must_include "\tnando\t"
      end
    end
  end
end
