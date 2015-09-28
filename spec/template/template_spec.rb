# Copyright 2015 The Cocktail Experience, S.L.
require_relative '../spec_helper'

describe Redminerb::Template do
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
      ENV['HOME'] = SPECS_FIXTURES_DIR # SEE ITS .redminerb SUBDIRECTORY
      user = OpenStruct.new(id: user_id)
      _(Redminerb::Template.render(:user, user).chomp).must_equal user_id.to_s
    end

    it 'should use gem templates by default' do
      ENV['HOME'] = SPECS_TMP_DIR
      FileUtils.rm_rf SPECS_TMP_DIR
      user = OpenStruct.new(json_from_fixture('user')['user'])
      _(Redminerb::Template.render(:user, user)).must_include "Id: #{user.id}"
    end
  end
end
