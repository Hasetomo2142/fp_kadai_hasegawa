# frozen_string_literal: true

module ApplicationHelper
  def convert_to_time_with_zone(date, hour, minute)
    Time.zone.local(date.year, date.month, date.day, hour, minute)
  end

  def convert_empty_slot_to_symbol(empty_slot)
    return '○' if empty_slot >= 6
    return '△' if empty_slot >= 3
    '×'
  end
end
