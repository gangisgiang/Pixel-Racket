require 'ruby2d'
set title: 'Snake Game'
set fps_cap: 20
set background: 'black'

# Hoa Phat Thai - 104803588
#Last update: 31/05/2024

# height = 640 / 20 = 32
# width = 480 / 20 = 24
CELL_SIZE = 18
HEIGHT = 640
WIDTH = 480
GRID_WIDTH = Window.width / CELL_SIZE
GRID_HEIGHT = Window.height / CELL_SIZE

# Define the snake........
class Snake
    attr_accessor :segments, :direction
    def initialize
        @segments = [[2, 1], [3, 1], [4, 1], [5, 1]]
        @direction = 'right'
        @growing = false
    end

    def draw_snake
        @segments.each do |segment| 
            Square.new(x: segment[0] * CELL_SIZE, y: segment[1] * CELL_SIZE, size: CELL_SIZE - 1, color: 'yellow')
        end
    end

    def move
        if !@growing 
            @segments.shift
        end
        case @direction

            when 'right' || 'd'
                @segments.push(new_coordinates(head[0] + 1, head[1]))
            
            when 'up'
                @segments.push(new_coordinates(head[0], head[1] - 1))
            
            when 'down'
                @segments.push(new_coordinates(head[0], head[1] + 1))
            
            when 'left'
                @segments.push(new_coordinates(head[0] - 1, head[1]))
            end
        @growing = false
    end

    def new_direction_check(new_dirrection)
        if (new_dirrection == 'right' && @direction != 'left')
            return true
        elsif new_dirrection == 'left' && @direction != 'right'
            return true
        elsif new_dirrection == 'up' && @direction != 'down'
            return true
        elsif new_dirrection == 'down' && @direction != 'up'
            return true
        end 
        return false
    end

    def x 
        head[0]
    end

    def y
        head[1]
    end 

    def grow
        @growing = true
    end

    def hit_itself
        if @segments.uniq.length == @segments.length
            return false
        end
        return true
    end

    #add function below here!!!!!!!!!!!!!!!!!!
    private

    def new_coordinates(x, y)
        [x % GRID_WIDTH, y % GRID_HEIGHT]
    end 
    def head 
        @segments.last
    end
end

# Game elements...

class Game
    attr_accessor :score, :food_x, :food_y, :obtacles_1
    def initialize
        # Define score board!
        @score = 0
        @Highest_score = 0
        
        #Food elements
        @food_x = rand(GRID_WIDTH)
        @food_y = rand(GRID_HEIGHT)
        
        #Game
        @finish = false

        #Define obtacles
        @obtacles_1 = [[3, 5], [4, 5], [5, 5], [6, 5], [7, 5], [8, 5], [9, 5], [10, 5], [11, 5], [12, 5]]
        @obtacles_2 = [[17, 8], [18, 8], [19, 8], [20, 8], [21, 8], [22, 8]]
        @obtacles_3 = [[13, 15], [13, 16], [13, 17], [13, 18], [13, 19]]

    end
    
# food --- hiting food...................
    def draw_food
        unless finished
            Square.new(x: food_x * CELL_SIZE, y: food_y * CELL_SIZE, size: CELL_SIZE, color: 'red')
            Text.new("Score: #{@score}", color: "white", x: 10, y: 10, size: 15)
        end
        if finished
            Text.new("Score: #{@score}", color: "white", x: 25, y: 25, size: 25)
        end
    end 

    def snake_hit_food(x, y)
        x == @food_x && y == @food_y
    end

# Food end!

# Draw obtacles --- hitting obtacles

    def draw_obtacle1
        @obtacles_1.each do |obtacle|
            Square.new(x: obtacle[0] * CELL_SIZE, y: obtacle[1] *  CELL_SIZE, size: CELL_SIZE, color: 'gray')
        end
    end

    def draw_obtacle2
        @obtacles_2.each do |obtacle|
            Square.new(x: obtacle[0] * CELL_SIZE, y: obtacle[1] *  CELL_SIZE, size: CELL_SIZE, color: 'gray')
        end
    end

    def draw_obtacle3
        @obtacles_3.each do |obtacle|
            Square.new(x: obtacle[0] * CELL_SIZE, y: obtacle[1] *  CELL_SIZE, size: CELL_SIZE, color: 'gray')
        end
    end

# Hitting obtacles

    def snake_hit_obtacles(x, y)
        @obtacles_1.each do |hit|
            if x == hit[0] && y == hit[1]
                return true
            end
        end

        @obtacles_2.each do |hit|
            if x == hit[0] && y == hit[1]
                return true
            end
        end

        @obtacles_3.each do |hit|
            if x == hit[0] && y == hit[1]
                return true
            end
        end

        return false
    end

    def draw_obtacles
        draw_obtacle1
        draw_obtacle2
        draw_obtacle3
    end
    # Draw obtacles end!

    #draw Gameover menu

    def gameover
        if finished
            if (@Highest_score <= @score)
                @Highest_score = @score
                Text.new("New record: #{@Highest_score}", color: "white", x: WIDTH / 2 - 8, y: HEIGHT / 2 - 130, size: 20)
            else Text.new("Record: #{@Highest_score}", color: "white", x: WIDTH / 2, y: HEIGHT / 2 - 130, size: 20)
            end
            Text.new("Game Over", color: "white", x: WIDTH / 2 - 10, y: HEIGHT / 2 - 100, size: 25)
            Text.new("Press Enter to play again!", color: "white", x: 400, y: 20, size: 18)
            
        end
    end

#end!

# Player score board

    def score_hit 
        @score += 1
        @food_x = rand(GRID_WIDTH)
        @food_y = rand(GRID_HEIGHT)
    end

    def finish
        @finish = true
    end

    def finished
     @finish
    end
end

snake = Snake.new
game = Game.new

# Game update!
update do
    clear

    # background_image.draw # Draw the background image first

    unless game.finished
        snake.move
    end
    
    snake.draw_snake
    game.draw_food
    game.draw_obtacles

    if game.snake_hit_food(snake.x, snake.y)
        game.score_hit
        snake.grow
    end

    if game.snake_hit_obtacles(snake.x, snake.y)
        game.finish
        game.gameover
    end

    if snake.hit_itself
        game.finish 
        game.gameover
    end
end

on :key_down do |event|
    if ['up', 'down', 'right', 'left'].include?(event.key)
        if snake.new_direction_check(event.key)
            snake.direction = event.key
        end
    elsif event.key == 'return'
        snake = Snake.new
        game = Game.new 
    end
end
show