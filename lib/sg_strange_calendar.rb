# frozen_string_literal: true

require 'date'

# class for output strange calendar
class SgStrangeCalendar
  MONTHS = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].freeze
  WEEKDAYS = %w[Su Mo Tu We Th Fr Sa].freeze
  DAY_LABELS = [*WEEKDAYS * 5, 'Su', 'Mo'].freeze

  FIRST_COLUMN_WIDTH = 4
  HORIZONTAL_COLUMN_WIDTH = 2
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

      days_info = Array.new(offset, { month: month_name, day: nil })
      (first_day..last_day).each do |day|
        days_info << { month: month_name, day: day }
      end
      padding_range = days_info.size..(DAY_LABELS.size - 1)
      days_info.fill({ month: month_name, day: nil }, padding_range)

      days_info
    end
  end

  def render_horizontal(calendar_data)
    rows = calendar_data.map do |month_data|
      month_name_str = month_data[0][:month].ljust(FIRST_COLUMN_WIDTH)

      days = ''
      previous_day = nil

      month_data.each do |day_info|
        days += format_day(day_info[:day], previous_day)
        previous_day = day_info[:day]
      end

      [month_name_str, days].join(' ').rstrip
    end
    "#{horizontal_header}\n#{rows.join("\n")}"
  end

  def horizontal_header
    "#{@year} #{DAY_LABELS.join(' ')}"
  end

  def render_vertical(transposed_calendar_data)
    rows = transposed_calendar_data.map.with_index do |date_data, index|
      date_name_str = DAY_LABELS[index].ljust(FIRST_COLUMN_WIDTH)

      dates = ''
      previous_day = nil

      date_data.each do |day_info|
        dates += format_day(day_info[:day], previous_day, vertical: true)
        previous_day = day_info[:day]
      end

      [date_name_str, dates].join(' ').rstrip
    end
    "#{vertical_header}\n#{rows.join("\n")}"
  end

  def vertical_header
    "#{@year} #{MONTHS.join(' ')}"
  end

  def format_day(day, previous_day, vertical: false)
    base_width = vertical ? VERTICAL_COLUMN_WIDTH : HORIZONTAL_COLUMN_WIDTH

    if blank_day?(day)
      format_blank_day(previous_day, base_width)
    elsif emphasis_day?(day)
      format_emphasis_day(day, previous_day, base_width)
    else
      format_normal_day(day, previous_day, base_width)
    end
  end

  def format_blank_day(previous_day, base_width)
    add_width_for_blank = emphasis_day?(previous_day) || blank_day?(previous_day) ? 1 : 2
    ''.rjust(base_width + add_width_for_blank)
  end

  def format_emphasis_day(day, previous_day, base_width)
    add_width_for_emphasis = blank_day?(previous_day) ? 1 : 2
    "[#{day.day}]".rjust(base_width + add_width_for_emphasis)
  end

  def format_normal_day(day, previous_day, base_width)
    prefix_blank = generate_prefix_blank(previous_day)
    "#{prefix_blank}#{day.day.to_s.rjust(base_width)}"
  end

  def generate_prefix_blank(previous_day)
    return '' if blank_day?(previous_day)
    return '' if emphasis_day?(previous_day)

    ' '
  end

  def blank_day?(day)
    day.nil?
  end

  def emphasis_day?(day)
    day == @today
  end
end
