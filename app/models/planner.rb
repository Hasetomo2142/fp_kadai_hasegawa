# frozen_string_literal: true

class Planner < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, length: { maximum: 255 }
  validates :description, presence: true,length: { maximum: 255 }
end
