# frozen_string_literal: true

class Meeting < ApplicationRecord
  belongs_to :client
  belongs_to :planner
end
