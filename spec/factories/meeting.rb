# frozen_string_literal: true

FactoryBot.define do
  factory :meeting do
    start_time { Time.now }
    end_time { Time.now + 30.minutes }
    association :planner
  end
end
