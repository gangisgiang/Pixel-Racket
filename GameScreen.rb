require_relative 'PixelRacket'

class GameScreen
  attr_accessor :high_score, :dividing_line,
                :ball, :player_score,
                :player1, :player2,
                :ball_velocity, :ball_moving,
                :mode, :start_game, :done_game, :serve_side
  def initialize(mode)

    @mode = mode # 0: 1vs1, 1: AI
    @player_score = [0, 0]
    @ball_velocity = 10
    @ball_moving = false

    @player1 = Racket.new(:left, 8)
    @player2 = Racket.new(:right, 8)

    @serve_side = 0
    @ball = Ball.new(@ball_velocity, @serve_side)


    @start_game = true
    @done_game = false

    @high_score = @player_score.max

  end
end

def draw_game_screen(cur_screen)
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

  draw_line

  move_racket(player1)
  draw_racket(player1)

  if game_screen.mode == 0
    move_racket(player2)
  else
    track_ball(player2, ball)
  end
  draw_racket(player2)

  move_ball(ball) if game_screen.ball_moving
  draw_ball(ball)

  if out_of_bounds?(ball)
    game_screen.ball_moving = false
    if ball.x + HeightBall >= Window.width - 1
      game_screen.player_score[0] += 1
      game_screen.serve_side = 0
    else
      game_screen.player_score[1] += 1
      game_screen.serve_side = 1
    end
    game_screen.ball = Ball.new(game_screen.ball_velocity, game_screen.serve_side)
  end

  Text.new("#{game_screen.player_score[0]}", x: 249, y: 20, size: 65,
           color: 'blue', font: 'font/Bradley Hand Bold.ttf')
  Text.new("#{game_screen.player_score[1]}", x: 360, y: 20, size: 65,
           color: 'blue', font: 'font/Bradley Hand Bold.ttf')
  # Text.new("High Score: #{game_screen.high_score.retrieve}", x: 450, y: 10, size: 12,
  #          color: 'black', font: 'font/PressStart2P.ttf')
  Text.new("'m' - mute", x: 10, y: 10, size: 10,
           color: 'black', font: 'font/PressStart2P.ttf')
  Text.new("'r' - restart", x: 10, y: 28, size: 10,
           color: 'black', font: 'font/PressStart2P.ttf')

  if game_screen.start_game == true
    Text.new("Press 'space' to start", x: 165, y: 120, size: 15, color: 'black',font: 'font/PressStart2P.ttf')
  end
end

def handle_input_game_screen(cur_screen, event)
  game_screen = cur_screen.type
  player1 = game_screen.player1
  player2 = game_screen.player2

  case event.type
  when :held
    case event.key
    when 'w'
      if game_screen.mode == 0
        player1.direction = :up
      end
    when 's'
      if game_screen.mode == 0
        player1.direction = :down
      end
    when 'up'
      if game_screen.mode == 0
        player2.direction = :up
      else
        player1.direction = :up
      end
    when 'down'
      if game_screen.mode == 0
        player2.direction = :down
      else
        player1.direction = :down
      end
    when 'space'
      # Check if the ball is not already moving
      unless game_screen.ball_moving
        game_screen.ball_moving = true unless game_screen.ball_moving
      end
      if game_screen.start_game == true
        game_screen.start_game = false
      end
    when 'r'
      cur_screen.type = GameScreen.new(game_screen.mode)
    end
    when :up
      case event.key
      when 'w', 's'
        if game_screen.mode == 0
          player1.direction = nil
        end
      when 'up', 'down'
        if game_screen.mode == 0
          player2.direction = nil
        else
          player1.direction = nil
        end
      end
    end
end

