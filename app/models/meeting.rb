# frozen_string_literal: true

class Meeting < ApplicationRecord
  belongs_to :client, optional: true
  belongs_to :planner
end
