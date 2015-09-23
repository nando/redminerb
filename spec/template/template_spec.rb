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
      ENV['HOME'] = SPECS_FIXTURES_DIR
    end

    after do
      ENV['HOME'] = @real_home
    end

    let(:user_id) { 42 }

    it 'should use local templates when present' do
      user = OpenStruct.new(id: user_id)
      _(Redminerb::Template.render(:user, user).chomp).must_equal user_id.to_s
    end
  end
end
