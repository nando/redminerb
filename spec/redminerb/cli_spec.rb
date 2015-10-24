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
    VCR.eject_cassette
    Redminerb.end!
  end

  subject { Redminerb::CLI.new }

  describe 'users command' do
    describe 'list subcommand' do
      let(:output) { capture_io { subject.users :list }[0] }

      describe 'default behaviour (without any option)' do
        before do
          VCR.insert_cassette 'users_list'
        end
  
        it 'shows users from our Redmine', :vcr do
          _(output).must_include "\tnando\t"
        end
      end

      describe 'the --all option' do
        before do
          VCR.insert_cassette 'users_list_all'
        end
  
        subject do
          Redminerb::CLI.new.tap do |cli|
            cli.options = { all: true }
          end
        end

        it 'shows all the users (429) with several (5) requests', :vcr do
          _(output.lines.count).must_equal 429
          _(Redminerb.client.requests).must_equal 5
        end
      end
    end
  end

  describe 'projects command' do
    describe 'list subcommand' do
      let(:output) { capture_io { subject.projects :list }[0] }

      describe 'default behaviour (without any option)' do
        before do
          VCR.insert_cassette 'projects_list'
        end
 
        it 'give us the first page of projects we have access to', :vcr do
          _(output.lines.count).must_equal 25 # Default results per page
        end
      end
  
      describe 'the --all option' do
        before do
          VCR.insert_cassette 'projects_list_all'
        end
  
        subject do
          Redminerb::CLI.new.tap do |cli|
            cli.options = { all: true }
          end
        end

        it 'shows all the projects (310) with several (4) requests', :vcr do
          _(output.lines.count).must_equal 310
          _(Redminerb.client.requests).must_equal 4
        end
      end

      describe 'the "--query <FILTER>" option' do
        let(:important_project) { "\tAcción Contra El Hambre" }
        let(:other_project) { "\tPrimeroto" }
        let(:last_project) { "\tProject #275" }

        before do
          VCR.insert_cassette 'projects_list_query'
        end
  
        subject do
          Redminerb::CLI.new.tap do |cli|
            cli.options = { name: 'HAMBRE' }
          end
        end

        let(:output) { capture_io { subject.projects :list }[0] }

        it 'filters the results using case unsensitive comparison', :vcr do
          _(output).must_include important_project
          _(output).wont_include other_project
        end

        describe 'with results after first page' do
          subject do
            Redminerb::CLI.new.tap do |cli|
              cli.options = { name: '#275' }
            end
          end

          it 'should work' do
            skip # to let the query command be reliable we should query --all
            _(output).must_include last_project
          end
        end
      end
    end
  end
end
