# frozen_string_literal: true

module Meetings
  class SearchController < ApplicationController
    before_action :authenticate_client!
    def search
      @meetings =
          if params[:date].present?
            @date = params[:date]
            array = Meeting.search_meetings_by_empty_slot(params[:date])
            Kaminari.paginate_array(array).page(params[:page]).per(5)
          elsif range_params[:date].present?
            @range = range_params
            array = Meeting.search_meetings_by_empty_range(range_params)
            Kaminari.paginate_array(array).page(params[:page]).per(5)
          else
            Meeting.page(params[:page]).per(5)
          end
      render 'meetings/search'
    end
    
    private

    def range_params
      params.require(:range).permit(:date, :start_time, :end_time)
    end
  end
end
