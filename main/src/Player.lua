Player = Class{}

function Player:init(x, y)
    self.speed, self.direction = 200, 'right'
    self.startingX, self.startingY = x, y
    self.x, self.y = x, y
    self.width, self.height = 25, 25
    self.jumps = 1
    self.jumpBuffer = 0

    self.state = 'grounded'

    self.collider = world:newRectangleCollider(self.x, self.y, self.width, self.height)
    self.collider:setFixedRotation(true)
    self.collider:setFriction(.05)

    self.collider:setPreSolve(function(collider_1, collider_2, contact)        
        if collider_1.collision_class == 'Default' and collider_2.collision_class == 'OneWay' then
            local playerX, playerY = collider_1:getPosition()            
            local platX, platY = collider_2:getPosition() 
            if playerY + self.height > platY then
                contact:setEnabled(false)
                self.state = 'falling'
            elseif playerY + self.height <= platY then
                self.state = 'grounded'
            end
            if love.keyboard.isDown('s') then
                contact:setEnabled(false)
            end
        end
        if collider_1.collision_class == 'Default' and collider_2.collision_class == 'Default' then
            local playerX, playerY = collider_1:getPosition()            
            local platX, platY = collider_2:getPosition() 
            if playerY + self.height > platY then
                self.state = 'falling'
            elseif playerY + self.height <= platY then
                self.state = 'grounded'
            end
        end   
    end)
end

function Player:update(dt)
    self:sync()
    self:move(dt)
    self:updateState()
    self:updateTimers(dt)
    if debugging then
        if love.mouse.buttonsPressed[2] then
            local x,y = love.mouse.getPosition()
            self.collider:setPosition(x, y)
        end
    end
end

function Player:render()
    local r,g,b,a = love.graphics.getColor()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    if currentBrightness == brightness[1] then
        love.graphics.setColor(currentColor[1]*brightness[2][1],currentColor[2]*brightness[2][2],currentColor[3]*brightness[2][3],currentColor[4]*brightness[2][4])
    elseif currentBrightness == brightness[2] then
        love.graphics.setColor(currentColor[1]*brightness[3][1],currentColor[2]*brightness[3][2],currentColor[3]*brightness[3][3],currentColor[4]*brightness[3][4])
    elseif currentBrightness == brightness[3] then
        love.graphics.setColor(currentColor[1]*brightness[4][1],currentColor[2]*brightness[4][2],currentColor[3]*brightness[4][3],currentColor[4]*brightness[4][4])
    elseif currentBrightness == brightness[4] then
        love.graphics.setColor(currentColor[1]*brightness[3][1],currentColor[2]*brightness[3][2],currentColor[3]*brightness[3][3],currentColor[4]*brightness[3][4])
    elseif currentBrightness == brightness[5] then
        love.graphics.setColor(currentColor[1]*brightness[4][1],currentColor[2]*brightness[4][2],currentColor[3]*brightness[4][3],currentColor[4]*brightness[4][4])
    end

    love.graphics.draw(love.graphics.newImage('src/graphics/Heart.png'), self.x+6, self.y+6.5)
    love.graphics.setColor(r,g,b,a)
end

function Player:sync()
    local x, y = self.collider:getPosition()
    self.x, self.y = x-self.width/2, y-self.height/2
end

function Player:move(dt)
    local vx, vy = self.collider:getLinearVelocity()
    if vy > -400 then
        vy = vy + 200*dt
    end
    if vy > -200 then
        vy = vy + 200*dt
    end
    if vy > 0 then
        vy = vy + 400*dt
    end

    if self.direction == 'left' then
        if love.keyboard.isDown('a') then
            vx = -self.speed
            if love.keyboard.keysPressed['d'] then
                self.direction = 'right'
            end
        elseif love.keyboard.isDown('d') then
            vx = self.speed
        else
            vx = self:applyFriction(dt,vx)
        end
    elseif self.direction == 'right' then
        if love.keyboard.isDown('d') then
            vx = self.speed
            if love.keyboard.keysPressed['a'] then
                self.direction = 'left'
            end
        elseif love.keyboard.isDown('a') then
            vx = -self.speed
        else
            vx = self:applyFriction(dt,vx)
        end
    end

    if dialove:getActiveDialogList() then
        self.collider:setType('static')
    else
        self.collider:setType('dynamic')
    end
    self.collider:setLinearVelocity(vx, vy)

    self:jump()
end

function Player:jump()
    local vx,vy = self.collider:getLinearVelocity()
    if love.keyboard.isDown('space') then
        self.jumpBuffer = .05
    end
    if self.state == 'grounded' and self.jumpBuffer > 0 then
        self.collider:setLinearVelocity(vx, -400)
        self.state = 'falling'
        love.audio.play(sounds.jump)
    end
end

function Player:applyFriction(dt,vx)
    if vx < 0 then
        vx = math.min(vx+3*self.speed*dt, 0)
        if self.state == 'grounded' then
            vx = math.min(vx+6*self.speed*dt, 0)
        end
    elseif vx > 0 then
        vx = math.max(vx-3*self.speed*dt, 0)
        if self.state == 'grounded' then
            vx = math.max(vx-6*self.speed*dt, 0)
        end
    end
    return vx
end

function Player:updateState()
    if self.collider:exit('Default') or self.collider:exit('OneWay') then
        self.state = 'falling'
    end
    if self.collider:enter('Hazard') then
        local num = math.random(1,3)
        love.audio.play(sounds.hurt[num])
        self:reset()
    end
    if self.collider:enter('Collectible') then
        local num = math.random(1,2)
        love.audio.play(sounds.newItem[num])
    end
    if self.collider:enter('Teleporter') then
        local num = math.random(1,2)
        love.audio.play(sounds.teleport[num])
    end
    if self.collider:enter('SavePoint') then
        love.audio.play(sounds.save)
    end
    if self.x < -self.width or self.x > love.graphics.getWidth() or self.y > love.graphics.getHeight() then
        self:reset()
    end
end

function Player:updateTimers(dt)
    self.jumpBuffer = math.max(self.jumpBuffer-dt, 0)
end

function Player:reset()
    self.collider:setPosition(self.startingX, self.startingY)
    self.collider:setLinearVelocity(0, 0)
end
