# frozen_string_literal: true

module Planners
  class SearchController < ApplicationController
    before_action :authenticate_client!
    def search
      @planners = 
          if params[:date].present? 
            array = Planner.search_planners_by_date(params[:date])
            Kaminari.paginate_array(array).page(params[:page]).per(5)
          else
            Planner.page(params[:page]).per(5)
          end
      render 'planners/search'
    end
  end
end
