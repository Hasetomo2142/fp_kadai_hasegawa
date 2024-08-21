# frozen_string_literal: true

class Clients::HomeController < ApplicationController
  before_action :authenticate_client!
  def home
    render 'clients/home'
  end
end
