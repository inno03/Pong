Class = require 'class'
require 'Paddle'
require 'Ball'
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243
PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
   
    math.randomseed(os.time())
    
    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav'),
        ['score'] = love.audio.newSource('sounds/score.wav'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav')
    }

    