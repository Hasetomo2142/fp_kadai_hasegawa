# frozen_string_literal: true

require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Client do
  describe 'validations' do
    it "has a valid factory" do
      expect(build(:client)).to be_valid
    end

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }

    it { is_expected.to validate_length_of(:name).is_at_most(50) }
    it { is_expected.to validate_length_of(:email).is_at_most(255) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
  end
end
