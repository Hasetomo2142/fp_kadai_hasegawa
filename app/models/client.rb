# frozen_string_literal: true

class Client < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 50 }
  validates :email,
            format: { with: Devise.email_regexp },
            uniqueness: { case_sensitive: false }

  def find_next_meeting
    Meeting.order(start_time: :asc).find do |meeting|
      meeting.client_id == id && meeting.start_time > Time.zone.now
    end
  end
end
