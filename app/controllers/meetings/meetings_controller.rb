# frozen_string_literal: true

module Meetings
  class MeetingsController < ApplicationController
    before_action :authenticate_user!

    def index
      if current_client
        @meetings = Meeting.where('client_id = ? AND start_time > ?', current_client.id,
                                  Time.zone.now).order(start_time: 'ASC').page(params[:page]).per(5)
        render 'meetings/index_for_client'
      elsif current_planner
        @meetings = Meeting.where(planner_id: current_planner.id).order(start_time: 'ASC').page(params[:page]).per(5)
        @reservation = @meetings.where.not(client_id: nil)
        @slot = @meetings.where(client_id: nil, start_time: Time.zone.now..)
        render 'meetings/index_for_planner'
      end
    end

    def new
      @meeting = Meeting.create!(planner_id: current_planner.id, start_time: params[:start_time],
                                 end_time: params[:end_time])
      redirect_to planners_home_path
    end

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

    def destroy
      if current_planner.nil?
        flash[:alert] = 'プランナー権限がありません'
        redirect_to root_path
        return
      end
      meeting = Meeting.find(params[:id])
      if meeting.planner_id == current_planner.id && meeting.client_id.nil?
        meeting.destroy
        flash[:notice] = '空き枠を削除しました'
      else
        flash[:alert] = '権限がありません'
      end
      redirect_to planners_home_path
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
