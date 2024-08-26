# frozen_string_literal: true

module Clients
  class HomeController < ApplicationController
    before_action :authenticate_client!

    def home
      @groped_day = fetch_empty_slots
      @meetings = fetch_current_meetings
      @next_meeting = find_next_meeting
      @is_client_page = true
      render 'clients/home'
    end

    private

    def fetch_empty_slots
      Meeting.count_empty_slots_in_frames
    end

    def fetch_current_meetings
      Meeting.fetch_previous_and_next_three_month(Time.zone.now).order(start_time: :asc)
    end

    def find_next_meeting
      Meeting.all.find { |meeting| meeting.client_id == current_client.id && meeting.start_time > Time.zone.now }
    end
  end
end
