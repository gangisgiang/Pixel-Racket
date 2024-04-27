require 'ruby2d'

set background: 'aqua'
set title: 'Pong'
set width: 640
set height: 480

on :key_down do |event|
    puts event.key
end

puts(-1 % 2)
# show