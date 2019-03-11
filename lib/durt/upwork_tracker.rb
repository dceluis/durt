# frozen_string_literal: true

require_relative 'time_tracker'

module Durt
  class UpworkTracker < TimeTracker
    def self.enter(issue)
      system('xdotool key super+7')
      system('xdotool key ctrl+alt+t')
      system('xdotool key ctrl+alt+t')
      sleep(0.5)
      system('xdotool key ctrl+alt+e')

      system('xdotool key ctrl+shift+BackSpace')

      system("xdotool type '#{issue}'")
      sleep(0.5)
      system('xdotool key Tab')
      system('xdotool key Tab')
      system('xdotool key Return')

      sleep(0.5)
      system('xdotool key ctrl+alt+t')
      system('xdotool key super+7')
      sleep(1)
      stop
    end

    def self.start
      system('xdotool key ctrl+alt+0x005D')
    end

    def self.stop
      system('xdotool key ctrl+alt+0x005B')
    end
  end
end
