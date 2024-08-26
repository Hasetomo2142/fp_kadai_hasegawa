# frozen_string_literal: true

module Clients
  class HomeController < ApplicationController
    before_action :authenticate_client!
    def home
      @groped_day = Meeting.count_empty_slots_in_frames
      @meetings = Meeting.fetch_previous_and_next_three_month(Time.zone.now)
      @is_client_page = true
      render 'clients/home'
    end
  end
end
