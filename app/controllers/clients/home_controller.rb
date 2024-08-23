# frozen_string_literal: true

module Clients
  class HomeController < ApplicationController
    before_action :authenticate_client!
    def home
      @meetings = Meeting.fetch_previous_and_next_three_month(Time.now)
      @is_client = true
      render 'clients/home'
    end
  end
end
