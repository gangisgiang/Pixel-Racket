class ModeSelect
    attr_accessor :modes, :difficulties, :selected_mode, :selected_difficulty, :difficulty_text
    def initialize
      @modes = ['1 VS 1', 'VS Computer']
      @difficulties = ['Easy', 'Medium', 'Hard']
      @difficulty_text = false
      @selected_mode = nil
      @selected_difficulty = 0
    end
end

def draw_mode_select(cur_screen)
  Text.new('Pixel Racket', x: 177, y: 80,
           size: 25, color: 'black',
           font: 'font/PressStart2P.ttf')
  Text.new('Leaderboard', x: 224, y: 170,
          size: 18, color: cur_screen.type.selected_mode.nil? ? 'blue' : 'white',
          font: 'font/PressStart2P.ttf')
  mode_select_screen = cur_screen.type
  Text.new('Select Mode', x: 225, y: 250,
           size: 18, color: 'white',
           font: 'font/PressStart2P.ttf')

  mode_select_screen.modes.each_with_index do |mode, index|
    Text.new(mode, x: 140 + index * 250, y: 340, size: 14,
             color: index == mode_select_screen.selected_mode ? 'blue' : 'white',
             font: 'font/PressStart2P.ttf')
    mode_select_screen = cur_screen.type
    if mode_select_screen.selected_mode == 1  # Show difficulty text only for VS Computer mode
      mode_select_screen.difficulties.each_with_index do |difficulties, i|
        Text.new(difficulties, x: 430, y: 364 + i * 30, size: 14,
                 color: i == mode_select_screen.selected_difficulty ? 'blue' : 'white',
                 font: 'font/PressStart2P.ttf')
      end
    else
      mode_select_screen.difficulty_text = false  # Hide difficulty text for other modes
    end
  end
end


def handle_input_mode_select(cur_screen, event)
  mode_select_screen = cur_screen.type
  case event.type
    when :down
      case event.key
      when 'left'
        if mode_select_screen.selected_mode == nil
          mode_select_screen.selected_mode = 0
        else
          mode_select_screen.selected_mode = (mode_select_screen.selected_mode.to_i - 1) % 2
        end
      when 'right'
          mode_select_screen.selected_mode = (mode_select_screen.selected_mode.to_i + 1) % 2
      when 'up'
      if mode_select_screen.selected_mode == 1
         mode_select_screen.selected_difficulty = (mode_select_screen.selected_difficulty.to_i - 1) % 3
      end
      if mode_select_screen.selected_mode == 0 || mode_select_screen.selected_mode == 1 && mode_select_screen.selected_difficulty == nil
        mode_select_screen.selected_mode = nil
      end
      when 'down'
      if mode_select_screen.selected_mode.nil?
        mode_select_screen.selected_mode = 0
      end
      if mode_select_screen.selected_mode == 1
         mode_select_screen.selected_difficulty = (mode_select_screen.selected_difficulty.to_i + 1) % 3
      end
      when 'return'
        if mode_select_screen.selected_mode == 0 || mode_select_screen.selected_difficulty == 0
         cur_screen.type = GameScreen.new(mode_select_screen.selected_mode,
                                            mode_select_screen.difficulties[mode_select_screen.selected_difficulty])
        end
    end
  end
  end






