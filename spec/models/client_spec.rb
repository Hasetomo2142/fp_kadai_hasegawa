# frozen_string_literal: true

require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Client do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }

    it { is_expected.to validate_length_of(:name).is_at_most(50) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }

    describe 'validate_uniqueness' do
      before { create(:client) }

      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end
  end

  describe 'Client' do
    it 'is valid with a name, email, and password' do
      expect(build(:client)).to be_valid
    end

    it 'is invalid without a name' do
      client = build(:client, name: nil)
      client.valid?
      expect(client.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without an email' do
      client = build(:client, email: nil)
      client.valid?
      expect(client.errors[:email]).to include("can't be blank")
    end

    it 'is invalid wrong email format' do
      client = build(:client, email: 'wrongemail')
      client.valid?
      expect(client.errors[:email]).to include('is invalid')
    end
  end
end
