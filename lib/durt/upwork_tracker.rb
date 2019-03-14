# frozen_string_literal: true

require_relative 'time_tracker'

module Durt
  class UpworkTracker < TimeTracker
    def self.enter(issue)
      `xdotool key super+7`
      `xdotool key ctrl+alt+t`
      `xdotool key ctrl+alt+t`
      sleep(0.5)
      `xdotool key ctrl+alt+e`

      `xdotool key ctrl+shift+BackSpace`

      `xdotool type '#{issue}'`
      sleep(0.5)
      `xdotool key Tab`
      `xdotool key Tab`
      `xdotool key Return`

      sleep(0.5)
      `xdotool key ctrl+alt+t`
      `xdotool key super+7`
      sleep(1)
      stop
    end

    def self.start
      `xdotool key ctrl+alt+0x005D`
    end

    def self.stop
      `xdotool key ctrl+alt+0x005B`
    end
  end
end
