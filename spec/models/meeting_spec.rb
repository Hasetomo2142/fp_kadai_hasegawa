# frozen_string_literal: true

require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Meeting do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:start_time) }
    it { is_expected.to validate_presence_of(:end_time) }
    it { is_expected.to validate_presence_of(:planner_id) }

    it 'is necessary that the end_time is later than the start_time' do
      meeting = build(:meeting, start_time: Time.zone.now, end_time: Time.zone.now.ago(1.hour))
      meeting.valid?
      expect(meeting.errors[:end_time]).to include('終了時間は開始時間より後の時間を選択してください')
    end
  end
end
