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

    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    -- place a ball in the middle of the screen
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- initialize score variables
    player1Score = 0
    player2Score = 0

    -- either going to be 1 or 2; whomever is scored on gets to serve the
    -- following turn
    servingPlayer = 1

    -- player who won the game; not set to a proper value until we reach
    -- that state in the game
    winningPlayer = 0

    -- the state of our game; can be any of the following:
    -- 1. 'start' (the beginning of the game, before first serve)
    -- 2. 'serve' (waiting on a key press to serve the ball)
    -- 3. 'play' (the ball is in play, bouncing between paddles)
    -- 4. 'done' (the game is over, with a victor, ready for restart)
    gameState = 'start'
    love.keyboard.keysPressed = {}
end