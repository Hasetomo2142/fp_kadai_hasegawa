# frozen_string_literal: true

module ApplicationHelper
  def convert_to_time_with_zone(date, hour, minute)
    Time.zone.local(date.year, date.month, date.day, hour, minute)
  end

  # {"date"=>"2024-08-27", "start_time"=>"10:00", "end_time"=>"18:00"}から日本語のメッセージを生成
  def convert_to_message(range)
    date = I18n.l(range[:date].to_date, format: :long)
    start_time = range[:start_time]
    end_time = range[:end_time]
    "#{date}の#{start_time}から#{end_time}までの予定"
  end

  def convert_empty_slot_to_symbol(empty_slot)
    return '○' if empty_slot >= 6
    return '△' if empty_slot >= 3

    '×'
  end
end
