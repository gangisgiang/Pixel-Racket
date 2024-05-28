require 'ruby2d'

class Leaderboard

  attr_accessor :high_score
  def initialize
    @high_score = get_high_score
  end

end

# read in the score for each mode of the game and the difficulty
def get_high_score
  scores = []
  File.open('high_score.txt', 'r') do |file|
    file.each_line do |line|
      scores << line.to_i
    end
  end
  scores
end

# save the score for each mode of the game and the difficulty
def save_score(scores, mode)
  File.open('high_score.txt', 'w') do |file|
    scores.each do |score|
      file.puts score
    end
  end
end


