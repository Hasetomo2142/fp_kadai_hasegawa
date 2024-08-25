# frozen_string_literal: true

FactoryBot.define do
  factory :meeting do
    start_time { Time.now }
    end_time { Time.now + 30.minutes }

    factory :empty_slot do
      association :planner
    end

    factory :reservation do
      association :planner
      association :client
    end
  end
end
