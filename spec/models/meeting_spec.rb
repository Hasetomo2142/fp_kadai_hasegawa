# frozen_string_literal: true

require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Meeting do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:start_time) }
    it { is_expected.to validate_presence_of(:end_time) }
    it { is_expected.to validate_presence_of(:planner_id) }

    it 'is invaild that the end_time is faster than the start_time' do
      meeting = build(:meeting, start_time: Time.zone.now, end_time: Time.zone.now.ago(1.hour))
      meeting.valid?
      expect(meeting.errors[:end_time]).to include('終了時間は開始時間より後の時間を選択してください')
    end

    it 'is invaild that duplicate slot for plannner' do
      start_time = Time.new(2024, 1, 1, 10, 0, 0) # Replace with your desired start time
      end_time = Time.new(2024, 1, 1, 10, 30, 0) # Replace with your desired end time
      create(:meeting, start_time: start_time, end_time: end_time)
      meeting = build(:meeting, start_time: start_time, end_time: end_time)
      meeting.valid?
      expect(meeting.errors[:start_time]).to include('は既に予定されています')
    end
  end
end
