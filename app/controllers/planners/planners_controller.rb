# frozen_string_literal: true

module Planners
  class PlannersController < ApplicationController
    before_action :authenticate_client!

    def home
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
  end
end
