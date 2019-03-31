# frozen_string_literal: true

require_relative 'time_tracker'

module Durt
  class UpworkTracker < TimeTracker
    def self.open_edit_memo
      `xdotool key super+7`

      reset_workspace

      `xdotool key ctrl+alt+e`
    end

    def self.edit_memo(issue)
      `xdotool key ctrl+shift+BackSpace`

      `xdotool type '#{issue}'`
      sleep(0.5)

      `xdotool key Tab`
      `xdotool key Tab`
      `xdotool key Return`
      sleep(0.5)
    end

    def self.close_edit_memo
      `xdotool key ctrl+alt+t`
      `xdotool key super+7`
      sleep(1)
    end

    def self.enter(issue)
      open_edit_memo
      edit_memo(issue)
      close_edit_memo

      stop
    end

    def self.start
      `xdotool key ctrl+alt+0x005D`
    end

    def self.stop
      `xdotool key ctrl+alt+0x005B`
    end

    def self.switch_project(project)
      open_edit_memo

      `xdotool key Escape`
      sleep(0.5)

      toggle_fullscreen

      `xdotool mousemove --sync 400 50 click 1`
      sleep(0.5)

      `xdotool key Tab`
      sleep(0.5)

      `xdotool type #{project.name}`
      sleep(0.5)

      `xdotool mousemove --sync 400 150 click 1`
      sleep(0.5)

      toggle_fullscreen

      close_edit_memo
    end

    def self.toggle_fullscreen
      `xdotool key super+f`
      sleep(0.5)
    end

    # private

    def self.reset_workspace
      # Ensure that the time tracking window moves to current workspace
      `xdotool key ctrl+alt+t`
      `xdotool key ctrl+alt+t`
      sleep(0.5)
    end
  end
end
