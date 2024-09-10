# frozen_string_literal: true

class Meeting < ApplicationRecord
  # attr_accessor :client_id, :planner_id, start_time, end_time

  belongs_to :client, optional: true
  belongs_to :planner

  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_time_after_start_time
  validate :prevent_duplicate_slot_for_planner, on: :create
  validate :prevent_duplicate_slot_for_client, on: :update
  validate :prevent_overwrite_existing_client, on: :update

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

    return unless Meeting.exists?(planner_id:, start_time:)

    errors.add(:start_time, 'は既に予定されています')
  end

  def prevent_duplicate_slot_for_client
    return if start_time.blank? || end_time.blank?

    return unless Meeting.exists?(client_id:, start_time:)

    errors.add(:start_time, '同じ時間の予約があります')
  end

  def prevent_overwrite_existing_client
    return if client_id_was.nil? # 古いclient_idがnilならスキップ（初回登録など）
    return unless will_save_change_to_client_id? # client_idが変更されないならスキップ

    errors.add(:start_time, 'この枠は既に埋まっています') if client_id.present?
  end
end
