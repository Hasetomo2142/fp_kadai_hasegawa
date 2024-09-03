# frozen_string_literal: true

module Meetings
  class MeetingsController < ApplicationController
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

    def index
      @meetings = Meeting.all
    end

    def edit
      redirect_to root_path
    end

    def update
      @meeting = Meeting.find(params[:id])
      @meeting.update(client_id: current_client.id)
      flash[:notice] = '予約が完了しました'
      redirect_to clients_home_path
    end

    private

    def range_params
      params.require(:range).permit(:date, :start_time, :end_time)
    end
  end
end
