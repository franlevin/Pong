function love.load(arg)

  playerWidth = 10
  playerHeight = 80
  playerSpeed = 30
  screenWidth = love.graphics.getWidth() --800
  screenHeight = love.graphics.getHeight() --600

  player1 = {x = 20, y = 100, score = 0}

  player2 = {x = screenWidth - 20, y = 100, score = 0}

  -- direction: 0 = left, 1 = right
  -- next direction: 0 = right-up, 1 = left-up, 2 = left-down, 3 = right-down
  ball = {show = 1,
          initX = 300,
          initY = 300,
          x = 300,
          y = 300,
          radius = 7.5,
          direction = 0,
          speed = 8}

  topColission = 0 + ball.radius
  botColission = screenHeight - ball.radius
  leftColission = player1.x + playerWidth + ball.radius
  rightColission = player2.x - ball.radius

end

function love.update(dt)

  ballColission()
  ballMovement()
  scoreInstance()

  if love.keyboard.isDown('w') then
    if player1.y > 0 then
      player1.y = player1.y - playerSpeed
    end
  end

  if love.keyboard.isDown('s') then
    if player1.y < screenHeight - playerHeight then
       player1.y = player1.y + playerSpeed
    end
  end

  if love.keyboard.isDown('up') then
    if player2.y > 0 then
      player2.y = player2.y - playerSpeed
    end
  end

  if love.keyboard.isDown('down') then
    if player2.y < screenHeight - playerHeight then
      player2.y = player2.y + playerSpeed
    end
  end

end

function love.draw()
  myFont = love.graphics.newFont(40)

  love.graphics.print(player1.score, 200, 0)
  love.graphics.print(player2.score, 600, 0)

  love.graphics.setColor(1, 1, 1)

  -- Draw players
  love.graphics.rectangle("fill", player1.x, player1.y, playerWidth, playerHeight)
  love.graphics.rectangle("fill", player2.x, player2.y, playerWidth, playerHeight)

  -- Draw ball
  if ball.show == 1 then
    love.graphics.circle("fill", ball.x, ball.y, ball.radius, 20)
  end

  love.graphics.rectangle("line", 0, 0, screenWidth, screenHeight)
end

function love.keypressed(key, scancode, isrepeat)

  if key == 'escape' then
    love.event.quit(exitstatus)
  end

  if key == 'r' then love.load() end

end

function ballMovement()
  if ball.direction == 0 then
    ball.x = ball.x + ball.speed
    ball.y = ball.y - ball.speed
  elseif ball.direction == 1 then
    ball.x = ball.x + ball.speed
    ball.y = ball.y + ball.speed
  elseif ball.direction == 2 then
    ball.x = ball.x - ball.speed
    ball.y = ball.y + ball.speed
  else
    ball.x = ball.x - ball.speed
    ball.y = ball.y - ball.speed
  end
end

function ballColission()
  horizontalColission()
  verticalColission()
end

function horizontalColission()
  if ball.x <= leftColission then
    if ball.y >= player1.y and ball.y <= player1.y + playerHeight then
      if ball.direction == 2 then ball.direction = 1
      else ball.direction = 0 end
    end

  elseif ball.x >= rightColission then
    if ball.y >= player2.y and ball.y <= player2.y + playerHeight then
      if ball.direction == 0 then ball.direction = 3
      else ball.direction = 2 end
    end
  end
end

function verticalColission()
  if ball.y <= 0 + ball.radius and ball.direction == 0 then
    ball.direction = 1
 elseif ball.y <= 0 + ball.radius and ball.direction == 3 then
    ball.direction = 2
  elseif ball.y >= screenHeight - ball.radius and ball.direction == 1 then
    ball.direction = 0
  elseif ball.y >= screenHeight - ball.radius and ball.direction == 2 then
    ball.direction = 3
  end
end

function scoreInstance()
  if ball.x <= 0 - ball.radius then
    player2.score = player2.score + 1
    ball.direction = 4
  elseif ball.x >= screenWidth + ball.radius then
    player1.score = player1.score + 1
    ball.direction = 4
  end

  if ball.direction == 4 then
    ball.direction = math.random(4)
    ball.x = ball.initX
    ball.y = ball.initY
  end
end
