# frozen_string_literal: true

require_relative './lib/sg_strange_calendar'

today = Date.new(2024, 1, 2)
calendar = SgStrangeCalendar.new(2024, today)
puts calendar.generate(vertical: true)
