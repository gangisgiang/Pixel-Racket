require 'ruby2d'
require_relative 'ModeSelect'
require_relative 'GameScreen'


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

# main part
cur_screen = CurrentScreen.new

update do
  case cur_screen.need_render
  when true
    clear
    cur_screen.need_render = false
    case cur_screen.type
    when ModeSelect
      draw_mode_select(cur_screen)
    when GameScreen
      draw_game_screen(cur_screen)
    end
  end
end

on :key do |event|
  case cur_screen.type
  when ModeSelect
    handle_input_mode_select(cur_screen, event)
  when GameScreen
    handle_input_game_screen(cur_screen, event)
  end
end

show