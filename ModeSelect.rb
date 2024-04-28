class ModeSelect
    attr_accessor :modes, :selected_mode, :mode_text
    def initialize
      @modes = ['1 VS 1', 'VS Computer']
      @selected_mode = 0
      @mode_text = nil
    end
end
  
def draw_mode_select(cur_screen)
  mode_select_screen = cur_screen.type
  Text.new("Select Mode", x: 185, y: 100,
           size: 25, color: 'white',
           font: 'font/PressStart2P.ttf')

  mode_select_screen.modes.each_with_index do |mode, index|
    Text.new(mode, x: 140 + index * 250, y: 250,
             size: 15, color: index == mode_select_screen.selected_mode ? 'blue' : 'white',
             font: 'font/PressStart2P.ttf')
  end
end
  
def handle_input_mode_select(cur_screen, event)
  mode_select_screen = cur_screen.type
  case event.type
  when :down
    case event.key
    when "left"
      mode_select_screen.selected_mode = (mode_select_screen.selected_mode.to_i - 1) % 2
    when "right"
      mode_select_screen.selected_mode = (mode_select_screen.selected_mode.to_i + 1) % 2
    when "return"
      cur_screen.type = GameScreen.new
    end
  end
  cur_screen.need_render = true
end

