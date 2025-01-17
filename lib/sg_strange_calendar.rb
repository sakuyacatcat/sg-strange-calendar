# frozen_string_literal: true

require 'date'

# class for output strange calendar
class SgStrangeCalendar
  MONTHS = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].freeze
  WEEKDAYS = %w[Su Mo Tu We Th Fr Sa].freeze

  FIRST_COLUMN_WIDTH = 4

  HORIZONTAL_HEADER_COLUMN = [*WEEKDAYS * 5, 'Su', 'Mo'].freeze
  HORIZONTAL_HEADER = HORIZONTAL_HEADER_COLUMN.join(' ')
  HORIZONTAL_COLUMN_WIDTH = 2

  VERTICAL_HEADER = MONTHS.join(' ')
  VERTICAL_COLUMN_WIDTH = 3

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
      days_info = Array.new(offset, { month: month_name, day: '' })
      (first_day..last_day).each do |day|
        days_info << { month: month_name, day: day }
      end
      days_info.fill({ month: month_name, day: '' }, days_info.size..(HORIZONTAL_HEADER_COLUMN.size - 1))

      days_info
    end
  end

  def render_horizontal(calendar_data)
    header = "#{@year} #{HORIZONTAL_HEADER}"

    rows = calendar_data.map do |month_data|
      month_name_str = month_data[0][:month].ljust(FIRST_COLUMN_WIDTH)
      days = ''
      previous_day = ''
      month_data.each do |day_info|
        days += format_day(day_info[:day], previous_day)
        previous_day = day_info[:day]
      end

      [month_name_str, days].join(' ').rstrip
    end
    "#{header}\n#{rows.join("\n")}"
  end

  def render_vertical(transposed_calendar_data)
    header = "#{@year} #{VERTICAL_HEADER}"

    rows = transposed_calendar_data.map.with_index do |date_data, index|
      date_name_str = HORIZONTAL_HEADER_COLUMN[index].ljust(FIRST_COLUMN_WIDTH)
      dates = ''
      previous_day = ''
      date_data.each do |day_info|
        dates += format_day(day_info[:day], previous_day, vertical: true)
        previous_day = day_info[:day]
      end

      [date_name_str, dates].join(' ').rstrip
    end
    "#{header}\n#{rows.join("\n")}"
  end

  def format_day(day, previous_day, vertical: false)
    base_width = vertical ? VERTICAL_COLUMN_WIDTH : HORIZONTAL_COLUMN_WIDTH

    if blank_day?(day)
      add_width_for_blank = emphasis_day?(previous_day) || blank_day?(previous_day) ? 1 : 2
      return ''.rjust(base_width + add_width_for_blank)
    end

    if emphasis_day?(day)
      add_width_for_emphasis = blank_day?(previous_day) ? 1 : 2
      "[#{day.day}]".rjust(base_width + add_width_for_emphasis)
    else
      prefix_blank = generate_prefix_blank(day, previous_day, vertical)
      "#{prefix_blank}#{day.day.to_s.rjust(base_width)}"
    end
  end

  def blank_day?(day)
    day == ''
  end

  def emphasis_day?(day)
    day == @today
  end

  def generate_prefix_blank(_day, previous_day, _vertical)
    return '' if blank_day?(previous_day)
    return '' if emphasis_day?(previous_day)

    ' '
  end
end
