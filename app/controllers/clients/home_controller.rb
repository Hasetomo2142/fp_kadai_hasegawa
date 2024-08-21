# frozen_string_literal: true

module Clients
  class HomeController < ApplicationController
    before_action :authenticate_client!
    def home
      render 'clients/home'
    end
  end
end
