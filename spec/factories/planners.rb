# frozen_string_literal: true

FactoryBot.define do
  factory :planner do
    sequence(:name) { |n| "PlannerTester#{n}" }
    sequence(:email) { |n| "tester#{n}@example.com"}
    description { Faker::Lorem.sentence }
    password { "password" }
    password_confirmation { "password" }
  end
end
