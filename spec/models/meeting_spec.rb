# frozen_string_literal: true

require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Meeting do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:start_time) }
    it { is_expected.to validate_presence_of(:end_time) }
    it { is_expected.to validate_presence_of(:planner_id) }

    it 'is invaild that the end_time is faster than the start_time' do
      empty_slot = build(:empty_slot, start_time: Time.zone.now, end_time: Time.zone.now.ago(1.hour))
      empty_slot.valid?
      expect(empty_slot.errors[:end_time]).to include('終了時間は開始時間より後の時間を選択してください')
    end

    it 'is invaild that duplicate slot for plannner' do
      start_time = Time.zone.local(2024, 1, 1, 10, 0, 0) # Replace with your desired start time
      end_time = Time.zone.local(2024, 1, 1, 10, 30, 0) # Replace with your desired end time
      tmp_slot = create(:empty_slot, start_time:, end_time:)
      empty_slot = build(:empty_slot, start_time:, end_time:, planner_id: tmp_slot.planner_id)
      empty_slot.valid?
      expect(empty_slot.errors[:start_time]).to include('は既に予定されています')
    end

    it 'is invalid when trying to overwrite an existing client' do
      client_1 = create(:client)
      client_2 = create(:client)

      reservation = create(:reservation, client_id: client_1.id)
      reservation.update(client_id: client_2.id)
      expect(reservation.errors[:start_time]).to include('この枠は既に埋まっています')
    end
  end
end
