# frozen_string_literal: true

module Meetings
  class MeetingsController < ApplicationController
    before_action :authenticate_user!

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
      @is_reservation_page = false
      render 'meetings/search'
    end

    def index
      # @meetings = Meeting.all
      if current_client
        @meetings = Meeting.where(client_id: current_client.id,
                                start_time: Time.zone.now...).order(:start_time).page(params[:page]).per(5)
        @is_reservation_page = true
      elsif current_planner
        @meetings = Meeting.where(planner_id: current_planner.id,
                                start_time: Time.zone.now...).order(:start_time).page(params[:page]).per(5)
      end

      render 'meetings/index'
    end

    def edit
      redirect_to root_path
    end

    def update
      meeting = Meeting.find(params[:id])
      begin
        meeting.update!(client_id: current_client.id)
      rescue StandardError
        flash[:alert] = "予約に失敗しました：#{meeting.errors[:start_time].first}"
        redirect_to clients_home_path
        return
      end
      flash[:notice] =
        "予約が完了しました　　#{meeting.start_time.strftime('%-m月%-d日 %H:%M')}〜#{meeting.end_time.strftime('%H:%M')}の枠"
      redirect_to clients_home_path
    end

    def cancel
      meeting = Meeting.find(params[:id])
      if meeting.client_id == current_client.id
        # rubocop:disable Rails/SkipsModelValidations
        meeting.update_columns(client_id: nil)
        # rubocop:enable Rails/SkipsModelValidations
        flash[:notice] = '予約をキャンセルしました'
        redirect_to meetings_path
      else
        flash[:alert] = '他のユーザーの予約はキャンセルできません'
        redirect_to clients_home_path
      end
    end

    private

    def range_params
      params.require(:range).permit(:date, :start_time, :end_time)
    end

    def authenticate_user!
      if current_client.nil? && current_planner.nil?
        flash[:alert] = 'ログインもしくはアカウント登録してください。' 
        redirect_to root_path
      elsif current_client
        authenticate_client!
      elsif current_planner
        authenticate_planner!
      end
    end
  end
end
