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
  validates :description, presence: true, length: { maximum: 1000 }

  has_many :meetings, dependent: :destroy

  def fetch_empty_slots
    Meeting.where(client_id: nil, planner_id: id, start_time: Time.zone.now..3.months.since)
  end

  def find_next_meeting
    Meeting.order(start_time: :asc).find do |meeting|
      meeting.planner_id == id && meeting.start_time > Time.zone.now && !meeting.client_id.nil?
    end
  end

  class << self
    def search_planners_by_empty_slot(date)
      Planner.includes(:meetings).where(meetings: { client_id: nil, start_time: date })
    end

    def search_planners_by_name(name)
      Planner.where('name LIKE ?', "%#{name}%")
    end

    def search_planners_by_keyword(keyword)
      Planner.where('name LIKE ? OR description LIKE ?', "%#{keyword}%", "%#{keyword}%")
    end

    def search_planner_by_name_and_keyword(name, keyword)
      Planner.where('name LIKE ? AND (name LIKE ? OR description LIKE ?)',
                    "%#{name}%", "%#{keyword}%", "%#{keyword}%")
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
