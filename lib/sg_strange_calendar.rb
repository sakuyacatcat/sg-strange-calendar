# frozen_string_literal: true

require 'date'

# class for output strange calendar
class SgStrangeCalendar
  MONTHS = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].freeze
  WEEKDAYS = %w[Su Mo Tu We Th Fr Sa].freeze

  HORIZONTAL_HEADER_SUFFIX = [*WEEKDAYS * 5, 'Su', 'Mo'].join(' ')

  FIRST_COLUMN_WIDTH = 4
  HORIZONTAL_OTHER_COLUMNS_WIDTH = 2
  VERTICAL_OTHER_COLUMNS_WIDTH = 3

  def initialize(year, today = nil)
    @year = year
    @today = today
  end

  def generate(vertical: false)
    header = "#{@year} #{HORIZONTAL_HEADER_SUFFIX}"
    rows = []
    MONTHS.each.with_index(1) do |month_name, month_index|
      row = []
      first_day = Date.new(@year, month_index, 1)
      last_day = Date.new(@year, month_index, -1)
      blanks_before_first_day = Array.new(first_day.wday, ''.rjust(HORIZONTAL_OTHER_COLUMNS_WIDTH))

      row << month_name.ljust(FIRST_COLUMN_WIDTH)
      row << blanks_before_first_day if blanks_before_first_day.any?
      row << (first_day..last_day).each.map { |day| day.day.to_s.rjust(HORIZONTAL_OTHER_COLUMNS_WIDTH) }
      rows << row.join(' ')
    end
    "#{header}\n#{rows.join("\n")}"
  end
end
