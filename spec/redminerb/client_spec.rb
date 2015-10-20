# Copyright 2015 The Cocktail Experience, S.L.
require_relative '../spec_helper'

describe Redminerb::Client do
  describe '#get_json(path)' do
    it 'fails unless Redminerb.init! has been called first' do
      proc do
        Redminerb.client.get_json('/users.json')
      end.must_raise Redminerb::UninitializedError
    end
  end
end
