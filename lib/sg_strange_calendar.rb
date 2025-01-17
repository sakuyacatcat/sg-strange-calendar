# frozen_string_literal: true

require 'date'

# class for output strange calendar
class SgStrangeCalendar
  MONTHS = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].freeze
  WEEKDAYS = %w[Su Mo Tu We Th Fr Sa].freeze

  HORIZONTAL_HEADER_COLUMN = [*WEEKDAYS * 5, 'Su', 'Mo']
  HORIZONTAL_HEADER = [*WEEKDAYS * 5, 'Su', 'Mo'].join(' ')

  FIRST_COLUMN_WIDTH = 4
  HORIZONTAL_COLUMN_WIDTH = 2

  def initialize(year, today = nil)
    @year = year
    @today = today
  end

  def generate(vertical: false)
    calendar_data = build_calendar_data

    vertical ? render_vertical(calendar_data.transpose) : render_horizontal(calendar_data)
  end

  def build_calendar_data
    MONTHS.each.with_index(1).map do |month_name, month_index|
      first_day = Date.new(@year, month_index, 1)
      last_day = Date.new(@year, month_index, -1)

      offset = first_day.wday
      days_info = Array.new(offset, { day: '' })
      (first_day..last_day).each do |day|
        days_info << { day: day }
      end
      days_info.fill({ day: '' }, days_info.size..HORIZONTAL_HEADER_COLUMN.size)

      { month_name: month_name, days: days_info }
    end
  end

  def render_horizontal(calendar_data)
    header = "#{@year} #{HORIZONTAL_HEADER}"

    rows = calendar_data.map do |month_data|
      month_name_str = month_data[:month_name].ljust(FIRST_COLUMN_WIDTH)
      days = ''
      month_data[:days].map do |day_info|
        days += format_day(day_info[:day])
      end

      [month_name_str, days].join(' ').rstrip
    end
    "#{header}\n#{rows.join("\n")}"
  end

  def format_day(day)
    if blank_day?(day)
      add_width_for_blank = 1
      return ''.rjust(HORIZONTAL_COLUMN_WIDTH + add_width_for_blank)
    end

    if emphasis_day?(day)
      add_width_for_emphasis = day.day == 1 ? 1 : 2
      "[#{day.day}]".rjust(HORIZONTAL_COLUMN_WIDTH + add_width_for_emphasis)
    else
      prefix_blank = day.day == 1 || @today == day - 1 ? '' : ' '
      "#{prefix_blank}#{day.day.to_s.rjust(HORIZONTAL_COLUMN_WIDTH)}"
    end
  end

  def blank_day?(day)
    day == ''
  end

  def emphasis_day?(day)
    day == @today
  end
end
