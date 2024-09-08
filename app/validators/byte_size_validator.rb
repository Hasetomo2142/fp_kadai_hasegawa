# frozen_string_literal: true

class ByteSizeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    unavailable_chars = value.scan(/[^\u0000-\uFFFF]/)
    record.errors.add(attribute, 'に使用できない文字が含まれています') if unavailable_chars.present?
  end
end
