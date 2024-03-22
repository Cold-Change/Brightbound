Hazard = Class{}

function Hazard:init(x,y,width,height,direction,spikes, immutable)
    self.x, self.y = x or 0, y or 0
    self.colX, self.colY = self.x, self.y
    self.width, self.height = width or 60, height or 30
    self.colWidth, self.colHeight = self.width, self.height
    self.colCorner = nil
    self.direction = direction or 'up'
    self.spikes = spikes or 2
    self.kind = 'Hazard'
    self.immutable = immutable

    if self.direction == 'up' then
        self.colX, self.colY, self.colWidth, self.colHeight = self.x+3, self.y+6, self.width-6, self.height-6
    elseif self.direction == 'left' then
        self.colX, self.colY, self.colWidth, self.colHeight = self.x+6, self.y+3, self.width-6, self.height-6
    elseif self.direction == 'right' then
        self.colX, self.colY, self.colWidth, self.colHeight = self.x, self.y+3, self.width-6, self.height-6
    elseif self.direction == 'down' then
        self.colX, self.colY, self.colWidth, self.colHeight = self.x+3, self.y, self.width-6, self.height-6
    end
    
    if self.colWidth > 59 and self.colHeight > 59 then self.colCorner = 20
    elseif self.colWidth > 29 and self.colHeight > 29 then self.colCorner = 15
    elseif self.colWidth > 15 and self.colHeight > 15 then self.colCorner = 8
    elseif self.colWidth > 9 and self.colHeight > 9 then self.colCorner = 5
    else self.colCorner = 0 end
    
    self.collider = world:newBSGRectangleCollider(self.colX, self.colY, self.colWidth, self.colHeight, self.colCorner)
    self.collider:setType('static')
    self.collider:setCollisionClass(self.kind)
end

function Hazard:update(dt)
    self:sync()
end

function Hazard:render()
    local r,g,b,a = love.graphics.getColor()
    if self.immutable then
        love.graphics.setColor(0,0,0,1)
    end
    if self.direction == 'up' then
        local spikeWidth = self.width/self.spikes
        for i=1, self.spikes do
            local spike = {}
            table.insert(spike, self.x+((i-1)*spikeWidth))
            table.insert(spike, self.y+self.height)
            
            table.insert(spike, self.x+((i-1)*spikeWidth)+spikeWidth/2)
            table.insert(spike, self.y)

            table.insert(spike, self.x+((i-1)*spikeWidth)+spikeWidth)
            table.insert(spike, self.y+self.height)
            love.graphics.polygon("fill", spike)
        end
    elseif self.direction == 'down' then
        local spikeWidth = self.width/self.spikes
        for i=1, self.spikes do
            local spike = {}
            table.insert(spike, self.x+((i-1)*spikeWidth))
            table.insert(spike, self.y)
            
            table.insert(spike, self.x+((i-1)*spikeWidth)+spikeWidth/2)
            table.insert(spike, self.y+self.height)

            table.insert(spike, self.x+((i-1)*spikeWidth)+spikeWidth)
            table.insert(spike, self.y)
            love.graphics.polygon("fill", spike)
        end
    elseif self.direction == 'left' then
        local spikeWidth = self.height/self.spikes
        for i=1, self.spikes do
            local spike = {}
            table.insert(spike, self.x+self.width)
            table.insert(spike, self.y+((i-1)*spikeWidth))
            
            table.insert(spike, self.x)
            table.insert(spike, self.y+((i-1)*spikeWidth)+spikeWidth/2)

            table.insert(spike, self.x+self.width)
            table.insert(spike, self.y+((i-1)*spikeWidth)+spikeWidth)
            love.graphics.polygon("fill", spike)
        end
    elseif self.direction == 'right' then
        local spikeWidth = self.height/self.spikes
        for i=1, self.spikes do
            local spike = {}
            table.insert(spike, self.x)
            table.insert(spike, self.y+((i-1)*spikeWidth))
            
            table.insert(spike, self.x+self.width)
            table.insert(spike, self.y+((i-1)*spikeWidth)+spikeWidth/2)

            table.insert(spike, self.x)
            table.insert(spike, self.y+((i-1)*spikeWidth)+spikeWidth)
            love.graphics.polygon("fill", spike)
        end
    end
    love.graphics.setColor(r,g,b,a)
end

function Hazard:sync()
    local x, y = self.collider:getPosition()
    self.colX, self.colY = x-self.width/2, y-self.height/2
end