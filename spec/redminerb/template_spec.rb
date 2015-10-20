# Copyright 2015 The Cocktail Experience, S.L.
require_relative '../spec_helper'

describe Redminerb::Template do
  let(:url)     { 'http://myredmine.org/' }
  let(:api_key) { '121addfde66a9546bfc8d43536787544bff8d72a' }
  let(:nice_env) do
    {
      'REDMINERB_URL'     => url,
      'REDMINERB_API_KEY' => api_key
    }
  end

  after do
    Redminerb.end!
  end

  describe '.render(name, resource)' do
    # Fake home pointing to spec/fixtures
    before do
      @real_home = ENV['HOME']
    end

    after do
      ENV['HOME'] = @real_home
    end

    let(:user_id) { 42 }

    it 'should use local templates when present' do
      ENV['HOME'] = SPECS_FIXTURES_DIR # SEE ITS HIDDEN .redminerb SUBDIRECTORY
      user = OpenStruct.new(id: user_id)
      _(Redminerb::Template.render(:user, user).chomp).must_equal user_id.to_s
    end

    describe 'gem template' do
      include Redminerb::Spec

      before do
        ENV['HOME'] = SPECS_TMP_DIR
        FileUtils.rm_rf SPECS_TMP_DIR
      end

      let(:user) { OpenStruct.new(json_from_fixture('user')['user']) }
      let(:user_title) { "Id: ##{user.id}" }
      let(:issue) { RecursiveOpenStruct.new(json_from_fixture('issue')['issue']) }
      let(:issue_title) { "Redminerb 2015##{issue.id}" }

      it 'should be used by default for a user' do
        _(Redminerb::Template.render(:user, user)).must_include user_title
      end

      it 'should be used by default for an issue' do
        ClimateControl.modify nice_env do
          Redminerb.init!
          _(Redminerb::Template.render(:issue, issue)).must_include issue_title
        end
      end
    end
  end
end
