require_relative 'PixelRacket'

PONG_SOUND = Sound.new('sound/pong.wav')
PING_SOUND = Sound.new('sound/ping.wav')

class GameScreen
  attr_accessor :ball_velocity, :mode,
                :difficulty,
                :player1, :player2,
                :player_scores, :ball_moving,
                :serve_side, :ball,
                :start_game, :end_game

  def initialize(mode, difficulty)
    @mode = mode # 0: 1vs1, 1: AI

    if mode == 0
      @ball_velocity = 7
    end

    # @difficulties = ['Easy', 'Medium', 'Hard']
    @difficulty = difficulty
    case difficulty
    when 'Easy'
      @ball_velocity = 8
      @player2 = Racket.new(:right, mode == 0 ? 8 : 4)
    when 'Medium'
      @ball_velocity = 9
      @player2 = Racket.new(:right, mode == 0 ? 8 : 6)
    when 'Hard'
      @ball_velocity = 10
      @player2 = Racket.new(:right, mode == 0 ? 8 : 8)
    end

    @player1 = Racket.new(:left, 8)

    @player_scores = [0, 0]
    @ball_moving = false
    @serve_side = 0

    @ball = Ball.new(@ball_velocity, @serve_side)

    @start_game = true

    @end_game = false
  end
end

def draw_game_screen(cur_screen)
  game_screen = cur_screen.type
  save_score(game_screen.player_scores, game_screen.mode, game_screen.difficulty)

  player1 = game_screen.player1
  player2 = game_screen.player2
  ball = game_screen.ball

  if hit_ball?(ball, player1)
    bounce(player1, ball)
    PING_SOUND.play
  end

  if hit_ball?(ball, player2)
    bounce(player2, ball)
    PING_SOUND.play
  end

  draw_dividing_line

  move_racket(player1)
  draw_racket(player1)

  if game_screen.mode == 0
    move_racket(player2)
  else
    track_ball(player2, ball)
  end
  draw_racket(player2)

  move_ball(ball) if game_screen.ball_moving
  PONG_SOUND.play if hit_bottom?(ball) || hit_top?(ball)
  draw_ball(ball)

  if out_of_bounds?(ball)
    game_screen.ball_moving = false
    if ball.x + HeightBall >= Window.width - 1
      game_screen.player_scores[0] += 1
      game_screen.serve_side = 0
    else
      game_screen.player_scores[1] += 1
      game_screen.serve_side = 1
    end
    game_screen.ball = Ball.new(game_screen.ball_velocity, game_screen.serve_side)
  end

  #if the score of each side is 10, the game will be reset
  if game_screen.mode == 0
      if game_screen.player_scores[0] == 11
        game_screen.end_game = true
          Rectangle.new(x: 150, y: 140,
                        width: 354, height: 170, 
                        color: 'navy', z: 1)
          Text.new("PLAYER 1 WIN!", x: 208, y: 160,
                  size: 18, color: 'white', z: 2,
                  font: 'font/PressStart2P.ttf')
          Text.new("Press 'return' to restart", x: 164, y: 250,
                  size: 13, color: 'aqua', z: 2,
                  font: 'font/PressStart2P.ttf')
      elsif game_screen.player_scores[1] == 11
        game_screen.end_game = true
          Rectangle.new(x: 150, y: 140,
                        width: 354, height: 170, 
                        color: 'navy', z: 1)
          Text.new("PLAYER 2 WIN!", x: 208, y: 160,
                  size: 18, color: 'white', z: 2,
                  font: 'font/PressStart2P.ttf')
          Text.new("Press 'return' to restart", x: 164, y: 250,
                  size: 13, color: 'aqua', z: 2,
                  font: 'font/PressStart2P.ttf')
      end

  else

      if game_screen.player_scores[0] == 99
        game_screen.end_game = true
          Rectangle.new(x: 150, y: 140,
                      width: 354, height: 170, 
                      color: 'navy', z: 1)
          Text.new("YOU WIN!", x: 240, y: 160,
                  size: 18, color: 'white', z: 2,
                  font: 'font/PressStart2P.ttf')
          Text.new("Press 'return' to restart", x: 164, y: 250,
                  size: 13, color: 'aqua', z: 2,
                  font: 'font/PressStart2P.ttf')
      elsif game_screen.player_scores[1] == 99
        game_screen.end_game = true
          Rectangle.new(x: 150, y: 140,
                      width: 354, height: 170, 
                      color: 'navy', z: 1)
          Text.new("YOU LOSE!", x: 240, y: 160,
                  size: 18, color: 'white', z: 2,
                  font: 'font/PressStart2P.ttf')
          Text.new("Press 'return' to restart", x: 164, y: 250,
                  size: 13, color: 'aqua', z: 2,
                  font: 'font/PressStart2P.ttf')
      end
  end

  if game_screen.player_scores[0] < 10
  Text.new("#{game_screen.player_scores[0]}", x: 240, y: 20, size: 65,
           color: 'blue', font: 'font/Bradley Hand Bold.ttf')
  end
  if game_screen.player_scores[0] >= 10
  Text.new("#{game_screen.player_scores[0]}", x: 230, y: 20, size: 65,
          color: 'blue', font: 'font/Bradley Hand Bold.ttf')
  end
  Text.new("#{game_screen.player_scores[1]}", x: 360, y: 20, size: 65,
           color: 'blue', font: 'font/Bradley Hand Bold.ttf')

  if game_screen.mode == 1
    high_scores = get_high_score
  
    case game_screen.difficulty
    when 'Easy'
      Text.new("High Score: #{high_scores[0]}", x: 470, y: 10, size: 12,
              color: 'black', font: 'font/PressStart2P.ttf')
    when 'Medium'
      Text.new("High Score: #{high_scores[1]}", x: 470, y: 10, size: 12,
              color: 'black', font: 'font/PressStart2P.ttf')
    when 'Hard'
      Text.new("High Score: #{high_scores[2]}", x: 470, y: 10, size: 12,
              color: 'black', font: 'font/PressStart2P.ttf')
    end
  end

  Text.new("'r' - restart", x: 10, y: 10, size: 10,
           color: 'black', font: 'font/PressStart2P.ttf')
  Text.new("'esc' - menu", x: 10, y: 28, size: 10,
           color: 'black', font: 'font/PressStart2P.ttf')

  if game_screen.start_game == true
    Text.new("Press 'space' to start", x: 165, y: 116,
             size: 15, color: 'black',
             font: 'font/PressStart2P.ttf')
    if game_screen.mode == 0
    Text.new("Reach 11 points first to win", x: 144, y: 161,
              size: 14, color: 'black',
              font: 'font/PressStart2P.ttf')
    else
    Text.new("Reach 99 points first to win", x: 144, y: 161,
             size: 14, color: 'black',
             font: 'font/PressStart2P.ttf')
    end
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
      if game_screen.end_game == true
        game_screen.ball_moving = false
      end
    when 'r', 'esc'
      cur_screen.type = GameScreen.new(game_screen.mode, game_screen.difficulty)
    when 'escape'
      cur_screen.type = ModeSelect.new
    when 'return'
      if game_screen.end_game == true
        cur_screen.type = GameScreen.new(game_screen.mode, game_screen.difficulty)
      end
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

