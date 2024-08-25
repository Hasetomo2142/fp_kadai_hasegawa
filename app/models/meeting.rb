# frozen_string_literal: true

class Meeting < ApplicationRecord
  # attr_accessor :client_id, :planner_id, start_time, end_time

  belongs_to :client, optional: true
  belongs_to :planner

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :planner_id, presence: true
  validate :end_time_after_start_time
  validate :prevent_duplicate_slot_for_planner

  class << self
    def fetch_previous_and_next_three_month(current_date)
      previous_month = current_date.ago(3.months)
      next_month = current_date.since(3.months)
      @fetch_previous_and_next_three_month = Meeting.where(client_id: nil, start_time: previous_month..next_month)
    end

    def count_empty_slots_in_frames
      @current_meetings = fetch_previous_and_next_three_month(Time.zone.now)
      @grouped_meetings = @current_meetings.group_by(&:start_time)
    end

    def search_meetings_by_empty_slot(date)
      Meeting.includes(:planner).where(client_id: nil, start_time: date)
    end

    def convert_to_datetime(date, time)
      Time.zone.parse("#{date} #{time}")
    end

    def search_meetings_by_empty_range(range)
      start_datetime = convert_to_datetime(range[:date], range[:start_time])
      end_datetime = convert_to_datetime(range[:date], range[:end_time])

      Meeting.includes(:planner).where(client_id: nil, start_time: start_datetime...end_datetime)
    end
  end

  private

  def end_time_after_start_time
    return if start_time.blank? || end_time.blank?
    errors.add(:end_time, '終了時間は開始時間より後の時間を選択してください') if start_time >= end_time
  end

  def prevent_duplicate_slot_for_planner
    return if start_time.blank? || end_time.blank?
    if Meeting.where(planner_id: planner_id, start_time: start_time).exists?
      errors.add(:start_time, 'は既に予定されています')
    end
  end
end
