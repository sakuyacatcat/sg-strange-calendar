# frozen_string_literal: true

require 'date'

# class for output strange calendar
class SgStrangeCalendar
  MONTHS = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].freeze

  def initialize(year, today = nil)
    @year = year
    @today = today
  end

  def generate(vertical: false)
    header = "#{@year} Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo Tu We Th Fr Sa Su Mo"
    rows = []
    MONTHS.each.with_index(1) do |month_name, month_index|
      row = []
      first_day = Date.new(@year, month_index, 1)
      last_day = Date.new(@year, month_index, -1)
      blanks_before_first_day = Array.new(first_day.wday, '  ')

      row << "#{month_name} "
      row << blanks_before_first_day if blanks_before_first_day.any?
      row << (first_day..last_day).each.map do |day|
        value = day.day.to_s
        value = " #{value}" if value.length == 1
        value
      end

      rows << row.join(' ')
    end
    "#{header}\n#{rows.join("\n")}"
  end
end
