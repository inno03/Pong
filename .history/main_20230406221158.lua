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


function love.update(dt)
    if gameState == 'start' then
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            gameState = 'serve'
        end
    elseif gameState == 'serve' then
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            gameState = 'play'
            ball.dy = math.random(-50, 50)
            if servingPlayer == 1 then
                ball.dx = math.random(140, 200)
            else
                ball.dx = -math.random(140, 200)
            end
        end

        elseif gameState == 'play' then
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5
            if ball.y < player1.y + player1.height / 2 then
                ball.dy = -math.random(50, 100) * (player1.y + 
                    (player1.height / 2)) / ball.y
            else
                ball.dy = math.random(50, 100) * 
                    (player1.y + player1.height) / ball.y
            end

            sounds['paddle_hit']:play()
        end
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            if ball.y < player2.y + player2.height / 2 then
                ball.dy = -math.random(50, 100) * (player2.y + 
                    (player2.height / 2)) / ball.y
            else
                ball.dy = math.random(50, 100) * 
                    (player2.y + player2.height) / ball.y
            end

            sounds['paddle_hit']:play()
        end
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end
        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            sounds['score']:play()
            if player2Score == 10 then
                winningPlayer = 2
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end
        