# frozen_string_literal: true

class Planner < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 50 }
  validates :email,
            format: { with: Devise.email_regexp },
            uniqueness: { case_sensitive: false }
  validates :description, presence: true, length: { maximum: 255 }

  has_many :meetings, dependent: :destroy

  class << self
    def search_planners_by_empty_slot(date)
      Planner.includes(:meetings).where(meetings: { client_id: nil, start_time: date })
    end

    def convert_to_datetime(date, time)
      Time.zone.parse("#{date} #{time}")
    end

    def search_planners_by_empty_range(range)
      start_datetime = convert_to_datetime(range[:date], range[:start_time])
      end_datetime = convert_to_datetime(range[:date], range[:end_time])

      Planner.includes(:meetings).where(meetings: { client_id: nil, start_time: start_datetime...end_datetime })
    end
  end
end
