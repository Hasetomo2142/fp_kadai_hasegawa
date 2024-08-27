# frozen_string_literal: true

class Meeting < ApplicationRecord
  # attr_accessor :client_id, :planner_id, start_time, end_time

  belongs_to :client, optional: true
  belongs_to :planner

  class << self
    def fetch_previous_and_next_three_month(current_date)
      previous_month = current_date.ago(3.months)
      next_month = current_date.since(3.months)
      @fetch_previous_and_next_three_month ||= Meeting.where(start_time: previous_month..next_month)
    end

    def count_empty_slots_in_frames
      @current_meetings ||= fetch_previous_and_next_three_month(Time.zone.now)
      @grouped_meetings = @current_meetings.group_by(&:start_time)
    end
  end
end
