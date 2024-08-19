# frozen_string_literal: true

FactoryBot.define do
  factory :client do
    sequence(:name) { |n| "ClientTester#{n}" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
