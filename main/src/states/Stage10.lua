Stage10 = Class{__includes = BaseState}

function Stage10:init()
    self.spriteSheet = love.graphics.newImage('src/graphics/Narrator+Heart(mono)-Sheet.png')
    local grid = anim8.newGrid(37, 51, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.animation = anim8.newAnimation(grid('1-19',1), 0.1)
end

function Stage10:update(dt)
    self.animation:update(dt)
    if love.keyboard.keysPressed['escape'] then
        love.event.quit()
    elseif love.keyboard.keysPressed['r'] then
        gStateMachine:change('stage1')
    end
end

function Stage10:render()
    local r,g,b,a = love.graphics.getColor()
    love.graphics.clear()
    love.graphics.setColor(currentColor[1]*.7,currentColor[2]*.7,currentColor[3]*.7,currentColor[4])
    love.graphics.setFont(fonts.proggyL)
    love.graphics.printf('Thank you for playing!', 0, 400, WINDOW_WIDTH, 'center')
    love.graphics.setFont(fonts.proggyM)
    love.graphics.printf('"Escape" to quit or "R" to restart', 0, 450, WINDOW_WIDTH, 'center')
    love.graphics.setColor(.5,.5,.5,.5)
    love.graphics.setFont(fonts.proggyL)
    love.graphics.printf('Thank you for playing!', 2, 402, WINDOW_WIDTH+2, 'center')
    love.graphics.setFont(fonts.proggyM)
    love.graphics.printf('"Escape" to quit or "R" to restart', 2, 452, WINDOW_WIDTH+2, 'center')
    love.graphics.setColor(currentColor[1],currentColor[2],currentColor[3],currentColor[4])
    self.animation:draw(self.spriteSheet, 320, 180, 0, 4)
    love.graphics.setColor(r,g,b,a)
end

function Stage10:enter()
    darkUI = false
end

function Stage10:exit()
    darkUI = true
    cursorUnlocked = false
    audioUnlocked = false
    audioMenu = false
    brightnessUnlocked = false
    brightnessMenu = false
    colorUnlocked = false
    colorMenu = false
    currentColor = {1,1,1,1}
    currentBrightness = brightness[1]
    currentVolume = volume[1]
    love.mouse.setVisible(false)
    love.audio.setVolume(currentVolume)
end
