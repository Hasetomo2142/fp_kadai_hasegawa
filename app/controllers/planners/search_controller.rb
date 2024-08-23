# frozen_string_literal: true

module Planners
  class SearchController < ApplicationController
    before_action :authenticate_client!
    def search
      if params[:date].present?
        
      else
        # @planners = Planner.all
      end
      render 'planners/search'
    end
  end
end
