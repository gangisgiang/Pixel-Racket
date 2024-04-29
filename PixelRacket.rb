class Racket
  attr_accessor :side, :direction, :movement, :x, :y
  def initialize(side, movement)
    @side = side
    @movement = movement
    @direction = nil
    @y = 180
    if side == :left
      @x = 50
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
                          y: ball.y,
                          size: HeightBall, color: 'aqua')
  shape_racket = Rectangle.new(x: racket.x, y: racket.y,
                               width: 15, height: HeightRacket, color: 'aqua')
  shape_ball && [[shape_ball.x1, shape_ball.y1], [shape_ball.x2, shape_ball.y2],
                 [shape_ball.x3, shape_ball.y3], [shape_ball.x4, shape_ball.y4]].any? do |coordinates|
    shape_racket.contains?(coordinates[0], coordinates[1])
  end
end


def cal_max_y_racket()
  Window.height - HeightRacket
end

class Ball
  attr_accessor :shape, :x, :y, :y_velocity, :x_velocity,
                :speed, :last_hit_side, :serve_side

  def initialize(speed, serve_side)
    @x = 314.5
    @y = 240
    @speed = speed
    @y_velocity = [4, 5, 6, 7, -4, -5, -6, -7].shuffle.first
    @x_velocity = [6, 7, 8, 9].shuffle.first * (serve_side == 0 ? 1 : -1)
  end
end

def move_ball(ball)
  ball.y_velocity = -ball.y_velocity if hit_bottom?(ball) || hit_top?(ball)
  ball.x += ball.x_velocity
  ball.y += ball.y_velocity
end

def track_ball(racket, ball)
  if cal_y_middle(ball) > cal_y_middle(racket) + 15
    racket.y += racket.movement
  elsif cal_y_middle(ball) < cal_y_middle(racket) - 15
    racket.y -= racket.movement
  end
end

def draw_ball(ball)
  Square.new(x: ball.x,
             y: ball.y,
             size: HeightBall, color: 'blue')
end

def bounce(racket, ball)
  shape_ball = Square.new(x: ball.x,
                          y: ball.y,
                          size: HeightBall, color: 'aqua')

  shape_racket = Rectangle.new(x: racket.x, y: racket.y,
                               width: 15, height: HeightRacket, color: 'aqua')
  if ball.last_hit_side != racket.side
    position = ((shape_ball.y1 - shape_racket.y1) / HeightRacket.to_f)
    angle = position.clamp(0.2, 0.8) * Math::PI

    if racket.side == :left
      ball.x_velocity = Math.sin(angle) * ball.speed
      ball.y_velocity = -Math.cos(angle) * ball.speed
    else
      ball.x_velocity = -Math.sin(angle) * ball.speed
      ball.y_velocity = -Math.cos(angle) * ball.speed
    end

    ball.last_hit_side = racket.side

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

def draw_line
  10.times do |i|
    Rectangle.new(x: (Window.width - 10) / 2, y: (Window.height / 10) * i, height: 15, width: 12, color: 'white')
  end
end

