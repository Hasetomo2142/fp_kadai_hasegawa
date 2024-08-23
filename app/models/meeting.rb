# frozen_string_literal: true

class Meeting < ApplicationRecord
  # attr_accessor :client_id, :planner_id, start_time, end_time

  belongs_to :client, optional: true
  belongs_to :planner


  class << self

    def fetch_previous_and_next_three_month(current_date)
      previous_month = current_date.ago(3.months)
      next_month = current_date.since(3.months)
      @current_meetings ||= begin
        Meeting.where(start_time: previous_month..next_month)
      end
    end
  end
end
