# frozen_string_literal: true

module Planners
  class SearchController < ApplicationController
    before_action :authenticate_client!
    def search
      @planners = 
          if params[:date].present? 
            Planner.search_planners_by_date(params[:date])
          else
            Planner.all
          end
      render 'planners/search'
    end
  end
end
