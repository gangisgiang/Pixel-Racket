require 'ruby2d'

class Leaderboard

  attr_accessor :high_score
  def initialize
    @high_score = get_high_score
  end

end

def get_high_score()
  high_score = 0
  if File.exist?("high_score.txt")
    file = File.new('high_score.txt', 'r')
    high_score = file.gets.to_i
    file.close
  end
  return high_score
end

def save_score(player_scores, mode)
  old_high_score = get_high_score
  file = File.new('high_score.txt', 'w')
  if mode == 0
    high_score = [old_high_score, player_scores.max].max
  else
    high_score = [old_high_score, player_scores[0]].max
  end

  file.puts high_score
  file.close
end


def draw_leaderboard_screen(cur_screen)
  leaderboard_screen = cur_screen.type
  Text.new("High Score: #{get_high_score}", x: 10, y: 10, size: 20, color: 'white')
  leaderboard_screen.
end
def handle_input_leaderboard_screen(cur_screen, event)
  case event.type
  when :held
  when 'escape'
  cur_screen.type = ModeSelect.new
  end
end

def draw_leaderboard(high_score)
  Text.new("High Score: #{high_score}", x: 10, y: 10, size: 20, color: 'white')
end

def update_leaderboard(player_scores)
  old_high_score = get_high_score
  new_high_score = [old_high_score, player_scores.max].max
  save_score(new_high_score)
  return new_high_score
end
