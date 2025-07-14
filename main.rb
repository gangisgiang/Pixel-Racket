require 'ruby2d'
require_relative 'ModeSelect'
require_relative 'GameScreen'
HeightRacket = 90
HeightBall = 15

set background: 'aqua'
set title: 'Pixel Racket'
set width: 640
set height: 480

class CurrentScreen
  attr_accessor :type
  def initialize
    @type = ModeSelect.new
  end
end

# main part
cur_screen = CurrentScreen.new

update do
  clear
  case cur_screen.type
  when ModeSelect
    draw_mode_select(cur_screen)
  when GameScreen
    draw_game_screen(cur_screen)
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