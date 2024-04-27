HeightRacket = 90
HeightBall = 15

class Racket
  attr_accessor :side, :direction, :movement, :x, :y
  def initialize
    @side = side
    @movement = movement
    @direction = nil
    @y = 180
    if side == :left
      @x = 40
    elsif side == :right
      @x = 580
    end
  end
end

def move_racket(racket)
    if racket.direction == :up
      racket.y = [racket.y - racket.movement, 0].max
    elsif racket.direction == :down
      racket.y = [ racket.y + racket.movement, max_y].min
    end
end

def draw_racket(racket)

end

def hit_ball?(ball, racket)
      ball.shape && [[ball.shape.x1, ball.shape.y1],
                 [ball.shape.x2, ball.shape.y2],
                 [ball.shape.x3, ball.shape.y3],
                 [ball.shape.x4, ball.shape.y4]].any? do |coordinates|
        racket.shape.contains?(coordinates[0], coordinates[1])
  end
end

def track_ball(ball)
  if ball.y_middle > y_middle + 10
    ball.y += ball.movement
  elsif ball.y_middle < y_middle - 10
    @y -= @movement
  end
end

def y1(racket)
  racket.shape.y1
end

def y_middle_racket(racket)
  racket.y + (HeightRacket / 2)
end

def max_y_racket()
  Window.height - HeightRacket
end

class Ball
  attr_accessor :shape, :x, :y, :y_velocity, :x_velocity, :speed
  def initialize
    @x = 322.9
    @y = 240
    @speed = speed
    @y_velocity = [-11, -10, -9, -8, 8, 9, 10, 11].shuffle.first
    @x_velocity = [-11, -10, -9, -8, 8, 9, 10, 11].shuffle.first
  end
end

def move_ball(ball)
  ball.y_velocity = -ball.y_velocity if hit_bottom? || hit_top?
  ball.x += ball.x_velocity
  ball.y += ball.y_velocity
end

def draw_ball(ball)

end

def bounce(racket, ball)
  if ball.last_hit_side != racket.side
    position = ((shape.y1 - racket.y1) / Paddle::HEIGHT.to_f)
    angle = position.clamp(0.2, 0.8) * Math::PI

    if racket.side == :left
      ball.x_velocity = Math.sin(angle) * ball.speed
      ball.y_velocity = Math.cos(angle) * ball.speed
    else
      ball.x_velocity = -Math.sin(angle) * ball.speed
      ball.y_velocity = -Math.cos(angle) * ball.speed
    end

    ball.last_hit_side = racket.side

  end
end

def y_middle_ball(ball)
  ball.y + (HeightBall / 2)
end

def out_of_bounds?(ball)
  ball.x <= 0 || ball.x2 >= Window.height
end

def hit_bottom?(ball)
  ball.y + HeightBall >= Window.height
end

def hit_top?(ball)
  ball.y <= 0
end