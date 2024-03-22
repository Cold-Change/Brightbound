Object = Class{}

function Object:init(object,x,y,kind,colliderType, idle)
    self.sprite = object or objects.cursor
    self.scale = 1
    if self.sprite == objects.cursor then
        self.scale = .7
    end
    self.x, self.y = x or 0, y or 0
    self.startingX, self.startingY = self.x, self.y
    self.width, self.height = self.sprite:getWidth()*self.scale, self.sprite:getHeight()*self.scale
    self.kind = kind or "Collectible"
    self.colliderType = colliderType or 'Default'
    self.moving = idle
    if self.moving then
        self.idleSpeed = math.random(6,9)
    end

    self.collider = world:newRectangleCollider(self.x, self.y, self.width, self.height)
    self.collider:setType(self.colliderType)
    self.collider:setCollisionClass(self.kind)
    if self.moving then
        self.collider:setLinearVelocity(0,self.idleSpeed)
    end
end

function Object:update(dt)
    self:sync()
    if self.moving then
        self:idle(dt)
    end
end

function Object:render()
    local r,g,b,a = currentColor[1]*currentBrightness[1],currentColor[2]*currentBrightness[2],currentColor[3]*currentBrightness[3],currentColor[4]*currentBrightness[4]
    love.graphics.setColor(currentColor[1]*brightness[1][1],currentColor[2]*brightness[1][2],currentColor[3]*brightness[1][3],currentColor[4]*brightness[1][4])
    love.graphics.draw(self.sprite,self.x,self.y,nil,self.scale)
    love.graphics.setColor(r,g,b,a)
end

function Object:sync()
    local x, y = self.collider:getPosition()
    self.x, self.y = x-self.width/2, y-self.height/2
end

function Object:idle(dt)
    if self.y > self.startingY+5 then
        self.collider:setLinearVelocity(0,-self.idleSpeed)
    elseif self.y < self.startingY-5 then
        self.collider:setLinearVelocity(0,self.idleSpeed)
    end
end