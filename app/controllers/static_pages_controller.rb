class StaticPagesController < ApplicationController
  before_action :authenticate_client!, only: :home

  def home
  end

  def help
  end

  def about
  end
end
