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
    rows = MONTHS.each.with_index(1).map do |month_name, month_index|
      first_day = Date.new(@year, month_index, 1)
      last_day = Date.new(@year, month_index, -1)
      blanks_before_first_day = Array.new(first_day.wday, ''.rjust(HORIZONTAL_OTHER_COLUMNS_WIDTH))

      [
        month_name.ljust(FIRST_COLUMN_WIDTH),
        *blanks_before_first_day,
        *(first_day..last_day).each.map { |day| day.day.to_s.rjust(HORIZONTAL_OTHER_COLUMNS_WIDTH) }
      ].join(' ')
    end
    "#{header}\n#{rows.join("\n")}"
  end
end
