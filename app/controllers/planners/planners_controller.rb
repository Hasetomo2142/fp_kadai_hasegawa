# frozen_string_literal: true

module Planners
  class PlannersController < ApplicationController
    before_action :authenticate_client!, only: %i[show search]
    before_action :authenticate_planner!, only: %i[home]

    def home
      @next_meeting = current_planner.find_next_meeting
      @is_planner_page = true
      @role = 'planner'
      @reservations = Meeting.fetch_reservation_for_planner(current_planner.id)
      @empty_slots = current_planner.fetch_empty_slots
      render 'planners/home'
    end

    def show
      @planner = Planner.find(params[:id])
      @is_planner_page = true
      @role = 'client'
      @empty_slots = @planner.fetch_empty_slots
      render 'planners/show'
    end

    def search
      @planners = Planner.page(params[:page]).per(5)
      if params[:name].present? && params[:keyword].present?
        @planners = Planner.search_planner_by_name_and_keyword(params[:name],
                                                               params[:keyword]).page(params[:page]).per(5)
      elsif params[:name].present?
        @planners = Planner.search_planners_by_name(params[:name]).page(params[:page]).per(5)
      elsif params[:keyword].present?
        @planners = Planner.search_planners_by_keyword(params[:keyword]).page(params[:page]).per(5)
      end
      render 'planners/search'
    end
  end
end
