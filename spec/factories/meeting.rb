# frozen_string_literal: true

FactoryBot.define do
  factory :meeting do
    start_time { Time.zone.now }
    end_time { 30.minutes.from_now }

    factory :empty_slot do
      planner
    end

    factory :reservation do
      planner
      client
    end
  end
end
