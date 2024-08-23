# frozen_string_literal: true

module Planners
  class SearchController < ApplicationController
    before_action :authenticate_client!
    def search
      @planners = 
          if params[:date].present? 
            array = Planner.search_planners_by_empty_slot(params[:date])
            Kaminari.paginate_array(array).page(params[:page]).per(5)
          elsif range_params[:date].present?
            array = Planner.search_planners_by_empty_range(range_params)
            Kaminari.paginate_array(array).page(params[:page]).per(5)
          else
            Planner.page(params[:page]).per(5)
          end
      render 'planners/search'
    end
    
    private

    def range_params
      params.require(:range).permit(:date, :start_time, :end_time)
    end
  end
end
