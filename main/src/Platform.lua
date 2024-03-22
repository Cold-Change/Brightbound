Platform = Class{}

function Platform:init(x,y,width,height,kind,immutable)
    self.x, self.y = x or 0, y or 0
    self.width, self.height = width or 100, height or 30
    self.immutable = immutable
    self.kind = kind or 'Default'

    self.collider = world:newRectangleCollider(self.x, self.y, self.width, self.height)
    self.collider:setType('static')
    self.collider:setCollisionClass(self.kind)
end

function Platform:render()
    local r,g,b,a = love.graphics.getColor()
    if self.immutable then
        love.graphics.setColor(0,0,0,1)
    end
    if self.kind == "Default" then
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    elseif self.kind == 'OneWay' then
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height/2)
    elseif self.kind == "Solid" then
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end
    love.graphics.setColor(r,g,b,a)
end