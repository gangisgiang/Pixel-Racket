require 'ruby2d'
require_relative 'ModeSelect'

set background: 'aqua'
set title: 'Pong'
set width: 640
set height: 480

class CurrentScreen
  attr_accessor :type, :need_render
  def initialize
    @type = ModeSelect.new
    @need_render = true
  end
end

class TestScreen
  attr_accessor :mode
  def initialize(mode)
    @mode = mode
  end
end

def render_test_screen(cur_screen)
  test_screen = cur_screen.type
  Text.new(test_screen.mode.to_s, color: 'white')
end

def handle_input_test_screen(cur_screen, event)
  # case event.key
end

# main part
cur_screen = CurrentScreen.new

update do
  case cur_screen.need_render
  when true
    clear
    cur_screen.need_render = false
    case cur_screen.type
    when ModeSelect
      render_mode_select(cur_screen)
    when TestScreen
      render_test_screen(cur_screen)
    end
  end
end

on :key_down do |event|
  case cur_screen.type
  when ModeSelect
    handle_input_mode_select(cur_screen, event)
  end
end

show