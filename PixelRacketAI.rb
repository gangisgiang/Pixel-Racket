HeightRacket = 90
HeightBall = 15

class Racket
  attr_accessor :side, :direction, :movement, :x, :y
  def initialize(side, movement)
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
    racket.y = [racket.y + racket.movement, cal_max_y_racket].min
  end
end

def draw_racket(player)
  Rectangle.new(x: player.x, y: player.y,
                width: 15, height: HeightRacket, color: 'white')
end

def hit_ball?(ball, racket)
  shape_ball = Square.new(x: ball.x,
                          y: ball.y, z: -1,
                          size: HeightBall, color: 'blue')
  shape_racket = Rectangle.new(x: racket.x, y: racket.y, z: -1,
                               width: 15, height: HeightRacket, color: 'white')
  shape_racket.contains?(shape_ball.x, shape_ball.y)
end

def track_ball(racket, ball)
  if cal_y_middle(ball) > cal_y_middle(racket) + 10
    racket.y += racket.movement
  elsif cal_y_middle(ball) < cal_y_middle(racket) - 10
    racket.y -= racket.movement
  end
end

def cal_max_y_racket()
  Window.height - HeightRacket
end

class Ball
  attr_accessor :shape_ball, :x, :y, :y_velocity, :x_velocity,
                :speed, :last_hit_side

  def initialize(speed)
    @x = 322.9
    @y = 240
    @speed = speed
    @y_velocity = [-11, -10, -9, -8, 8, 9, 10, 11].shuffle.first
    @x_velocity = [-11, -10, -9, -8, 8, 9, 10, 11].shuffle.first
  end
end

def move_ball(ball)
  ball.y_velocity = -ball.y_velocity if hit_bottom?(ball) || hit_top?(ball)
  ball.x += ball.x_velocity
  ball.y += ball.y_velocity
end

def draw_ball(ball)
  Square.new(x: ball.x,
             y: ball.y,
             size: HeightBall, color: 'blue')
end

def bounce(racket, ball)
  if ball.last_hit_side != racket.side
    shape_racket = Rectangle.new(x: racket.x, y: racket.y,
                                 width: 15, height: HeightRacket, color: 'white')

    if shape_racket.contains?(ball.x, ball.y)
      position = ((ball.y - racket.y) / HeightRacket.to_f).clamp(0.2, 0.8)
      angle = position * Math::PI

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
end

def out_of_bounds?(ball)
  ball.x <= 0 || ball.x + HeightBall >= Window.width
end

def hit_bottom?(ball)
  ball.y + HeightBall >= Window.height
end

def hit_top?(ball)
  ball.y <= 0
end

def cal_y_middle(object)
  case object
  when Racket
    return object.y + (HeightRacket / 2.0)
  when Ball
    return object.y + (HeightBall / 2.0)
  end
end
