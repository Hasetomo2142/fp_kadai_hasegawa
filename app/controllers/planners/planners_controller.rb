# frozen_string_literal: true

module Planners
  class PlannersController < ApplicationController
    before_action :authenticate_client!

    # def show
    #   @planner = Planner.find(params[:id])
    # end

    def search
      @planners = Planner.all

      if params[:name].present? && params[:keyword].present?
        @planners = @planners.where("name LIKE ? AND (name LIKE ? OR description LIKE ?)", 
                                    "%#{params[:name]}%", "%#{params[:keyword]}%", "%#{params[:keyword]}%")
      elsif params[:name].present?
        @planners = @planners.where("name LIKE ?", "%#{params[:name]}%")
      elsif params[:keyword].present?
        @planners = @planners.where("name LIKE ? OR description LIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%")
      end

      @planners = @planners.page(params[:page]).per(5)
      render 'planners/search'
    end

    private

    def planner_params
      params.require(:planner).permit(:name, :description)
    end
  end
end
