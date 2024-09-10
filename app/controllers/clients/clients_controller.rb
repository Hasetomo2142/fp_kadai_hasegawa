# frozen_string_literal: true

module Clients
  class ClientsController < ApplicationController
    before_action :authenticate_client!

    def home
      @grouped_day = Meeting.count_empty_slots_in_frames
      @meetings = Meeting.fetch_previous_and_next_three_month(Time.zone.now)
      @next_meeting = current_client.find_next_meeting
      @is_client_page = true
      render 'clients/home'
    end
  end
end
