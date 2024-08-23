# frozen_string_literal: true

module ApplicationHelper
  def convert_to_time_with_zone(date, hour, minute)
    Time.zone.local(date.year, date.month, date.day, hour, minute)
  end

  def convert_empty_slot_to_symbol(empty_slot)
    case empty_slot
      
    when 6..Float::INFINITY
      '○'
    when 1..5
      '△'
    else
      '×'
    end
  end
end
