# frozen_string_literal: true

class Planner < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 50 }
  validates :email,
            format: { with: Devise.email_regexp },
            uniqueness: { case_sensitive: true }
  validates :description, presence: true, length: { maximum: 255 }
end
