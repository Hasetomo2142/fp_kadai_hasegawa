# frozen_string_literal: true

module Planners
  class PlannersController < ApplicationController
    before_action :authenticate_planner!

    def show
      @planner = Planner.find(params[:id])
    end

    private

    def planner_params
      params.require(:planner).permit(:name, :description)
    end
  end
end
