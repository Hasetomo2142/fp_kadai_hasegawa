# frozen_string_literal: true

require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Planner do
  describe 'validations' do

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:description) }

    it { is_expected.to validate_length_of(:name).is_at_most(50) }
    it { is_expected.to validate_length_of(:email).is_at_most(255)}
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
    it { is_expected.to validate_length_of(:description).is_at_most(255) }
    
    describe 'validate_uniqueness' do
      before { create(:planner) }
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end
  end
  describe 'Planner' do
    it 'is valid with a name, email, password, and description' do
      expect(build(:planner)).to be_valid
    end

    it 'is invalid without a name' do
      planner = build(:planner, name: nil)
      planner.valid?
      expect(planner.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without an email' do
      planner = build(:planner, email: nil)
      planner.valid?
      expect(planner.errors[:email]).to include("can't be blank")
    end

    it 'is invalid without a password' do
      planner = build(:planner, password: nil)
      planner.valid?
      expect(planner.errors[:password]).to include("can't be blank")
    end

    it 'is invalid without a description' do
      planner = build(:planner, description: nil)
      planner.valid?
      expect(planner.errors[:description]).to include("can't be blank")
    end
  end
end
