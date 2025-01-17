# frozen_string_literal: true

require 'date'

# class for output strange calendar
class SgStrangeCalendar
  MONTHS = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].freeze
  WEEKDAYS = %w[Su Mo Tu We Th Fr Sa].freeze

  HORIZONTAL_HEADER_SUFFIX = [*WEEKDAYS * 5, 'Su', 'Mo'].join(' ')

  FIRST_COLUMN_WIDTH = 4
  HORIZONTAL_COLUMN_WIDTH = 2

  def initialize(year, today = nil)
    @year = year
    @today = today
  end

  def generate
    header = "#{@year} #{HORIZONTAL_HEADER_SUFFIX}"
    rows = MONTHS.each.with_index(1).map do |month_name, month_index|
      first_day = Date.new(@year, month_index, 1)
      last_day = Date.new(@year, month_index, -1)

      month = month_name.ljust(FIRST_COLUMN_WIDTH)
      blanks_before_first_day = Array.new(first_day.wday, ''.rjust(HORIZONTAL_COLUMN_WIDTH))
      days = ''
      (first_day..last_day).each do |day|
        if emphasis_day?(day)
          add_width_for_emphasis = day == first_day ? 1 : 2
          days += "[#{day.day}]".rjust(HORIZONTAL_COLUMN_WIDTH + add_width_for_emphasis)
        else
          prefix_blank = day == first_day || @today == day - 1 ? '' : ' '
          days += "#{prefix_blank}#{day.day.to_s.rjust(HORIZONTAL_COLUMN_WIDTH)}"
        end
      end

      [month, *blanks_before_first_day, days].join(' ')
    end
    "#{header}\n#{rows.join("\n")}"
  end

  private

  def emphasis_day?(day)
    day == @today
  end
end
