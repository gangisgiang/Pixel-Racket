require_relative 'PixelRacket1vs1'

class GameScreen1vs1
  attr_accessor :high_score, :dividing_line,
                :ball, :player_score,
                :player1, :player2,
                :ball_velocity, :ball_moving
  def initialize

    @player_score = [0, 0]
    @ball_velocity = 12
    @ball_moving = false

    @player1 = Racket.new(:left, 8)
    @player2 = Racket.new(:right, 8)
    @ball = Ball.new(@ball_velocity)

    @high_score = @player_score.max

  end
end

def draw_game_screen_manual(cur_screen)
  game_screen = cur_screen.type
  player1 = game_screen.player1
  player2 = game_screen.player2
  ball = game_screen.ball

  if hit_ball?(ball, player1)
    bounce(player1, ball)
  end

  if hit_ball?(ball, player2)
    bounce(player2, ball)
  end

  move_racket(player1)
  draw_racket(player1)

  move_racket(player2)
  draw_racket(player2)

  move_ball(ball) if game_screen.ball_moving
  draw_ball(ball)

  if out_of_bounds?(ball)
    game_screen.ball_moving = false
    if ball.x + HeightBall >= Window.width - 1
      game_screen.player_score[0] += 1
    else
      game_screen.player_score[1] += 1
    end
    game_screen.ball = Ball.new(game_screen.ball_velocity)
  end

  Text.new("#{game_screen.player_score[0]}", x: 267, y: 20, size: 65,
           color: 'blue', font: 'font/Bradley Hand Bold.ttf')
  Text.new("#{game_screen.player_score[1]}", x: 360, y: 20, size: 65,
           color: 'blue', font: 'font/Bradley Hand Bold.ttf')
  # Text.new("High Score: #{game_screen.high_score.retrieve}", x: 450, y: 10, size: 12,
  #          color: 'black', font: 'font/PressStart2P.ttf')
  Text.new("'m' - mute", x: 10, y: 10, size: 10,
           color: 'black', font: 'font/PressStart2P.ttf')
  Text.new("'r' - restart", x: 10, y: 28, size: 10,
           color: 'black', font: 'font/PressStart2P.ttf')

end

def handle_input_game_screen_manual(cur_screen, event)
  game_screen = cur_screen.type
  player1 = game_screen.player1
  player2 = game_screen.player2

  case event.type
  when :down
    case event.key
    when 'w'
      player1.direction = :up
    when 's'
      player1.direction = :down
    when 'up'
      player2.direction = :up
    when 'down'
      player2.direction = :down
    when 'space'
      # Check if the ball is not already moving
      unless game_screen.ball_moving
        game_screen.ball_moving = true unless game_screen.ball_moving
      end
    when 'r'
      game_screen.player_score = [0, 0]
      game_screen.ball_moving = false
      game_screen.ball = Ball.new(game_screen.ball_velocity)
    end
  when :up
    if event.key == 'w' || event.key == 's'
      player1.direction = nil
    elsif event.key == 'up' || event.key == 'down'
      player2.direction = nil
    end
  end
  cur_screen.need_render = true
end