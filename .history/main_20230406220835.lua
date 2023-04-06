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
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
    player1Score = 0
    player2Score = 0
    servingPlayer = 1
    winningPlayer = 0
    gameState = 'start'
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

--[[
    Called every frame, passing in `dt` since the last frame. `dt`
    is short for `deltaTime` and is measured in seconds. Multiplying
    this by any changes we wish to make in our game will allow our
    game to perform consistently across all hardware; otherwise, any
    changes we make will be applied as fast as possible and will vary
    across system hardware.
]]
function love.update(dt)
    if gameState == 'start' then
        -- pressing enter will begin the game
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            gameState = 'serve'
        end
    elseif gameState == 'serve' then
        -- pressing enter will serve the ball
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            gameState = 'play'

            -- before switching to play, initialize ball's velocity based
            -- on player who last scored
            ball.dy = math.random(-50, 50)
            if servingPlayer == 1 then
                ball.dx = math.random(140, 200)
            else
                ball.dx = -math.random(140, 200)
            end
        end