# frozen_string_literal: true

module Planners
  class SearchController < ApplicationController
    before_action :authenticate_client!
    def search
      @planners = Planner.all
      render 'planners/index'
    end
  end
end
