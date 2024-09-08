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

      if params[:name].present? || params[:keyword].present?
        @planners = search_planners(params[:name], params[:keyword]).page(params[:page]).per(5)
      end

      render 'planners/search'
    end

    private

    def search_planners(name, keyword)
      if name.present? && keyword.present?
        Planner.search_planner_by_name_and_keyword(name, keyword)
      elsif name.present?
        Planner.search_planners_by_name(name)
      elsif keyword.present?
        Planner.search_planners_by_keyword(keyword)
      else
        Planner.all
      end
    end
  end
end
