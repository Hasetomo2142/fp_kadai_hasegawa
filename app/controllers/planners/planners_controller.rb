# frozen_string_literal: true

module Planners
  class PlannersController < ApplicationController
    before_action :authenticate_user!

    def home
      redirect_to root_path if !current_planner
      @next_meeting = find_next_meeting
      @is_planner_page = true
      @role = 'planner'
      @reservations = Meeting.where(planner_id: current_planner.id).where.not(client_id: nil)
      @empty_slots = Meeting.where(planner_id: current_planner.id, client_id: nil)
      render 'planners/home'
    end

    def show
      @planner = Planner.find(params[:id])
      @is_planner_page = true
      @role = 'client' if current_client
      @role = 'planner' if current_planner
      @empty_slots = @planner.fetch_empty_slots
      render 'planners/show'
    end

    def search
      @planners = Planner.all

      if params[:name].present? && params[:keyword].present?
        @planners = @planners.where('name LIKE ? AND (name LIKE ? OR description LIKE ?)',
                                    "%#{params[:name]}%", "%#{params[:keyword]}%", "%#{params[:keyword]}%")
      elsif params[:name].present?
        @planners = @planners.where('name LIKE ?', "%#{params[:name]}%")
      elsif params[:keyword].present?
        @planners = @planners.where('name LIKE ? OR description LIKE ?', "%#{params[:keyword]}%",
                                    "%#{params[:keyword]}%")
      end

      @planners = @planners.page(params[:page]).per(5)
      render 'planners/search'
    end

    private

    def find_next_meeting
      Meeting.order(start_time: :asc).find do |meeting|
        meeting.planner_id == current_planner.id && meeting.start_time > Time.zone.now
      end
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
