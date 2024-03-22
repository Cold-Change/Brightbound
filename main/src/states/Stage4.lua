Stage4 = Class{__includes = BaseState}

function Stage4:init()
    self.platforms = {
        area1 = {
            Platform(0, WINDOW_HEIGHT-40, WINDOW_WIDTH, 40),
            Hazard(200, WINDOW_HEIGHT-55, 600, 15, 'up', 30),
            Platform(260, WINDOW_HEIGHT-100, 30, 30, 'Default'),
            Platform(370, WINDOW_HEIGHT-100, 30, 30, 'Default'),
            Platform(480, WINDOW_HEIGHT-100, 30, 30, 'Default'),
            Platform(590, WINDOW_HEIGHT-100, 30, 30, 'Default'),
            Platform(700, WINDOW_HEIGHT-100, 80, 30, 'Default'),
            Platform(700, WINDOW_HEIGHT-160, 80, 30, 'OneWay'),
            Platform(700, WINDOW_HEIGHT-220, 80, 30, 'OneWay'),
            Platform(700, WINDOW_HEIGHT-280, 80, 30, 'OneWay'),
            Platform(580, WINDOW_HEIGHT-280, 30, 30, 'Default'),
            Platform(460, WINDOW_HEIGHT-280, 30, 30, 'Default'),
            Platform(310, WINDOW_HEIGHT-280, 30, 30, 'Default'),
            Platform(190, WINDOW_HEIGHT-280, 30, 30, 'Default'),
            Platform(20, WINDOW_HEIGHT-280, 120, 30, 'Default'),
        },
        area2 = {
            Platform(400, WINDOW_HEIGHT-440, 380, 30, 'Default'),
        },
        area3 = {
            Hazard(370, WINDOW_HEIGHT-410, 15, 110, 'left', 8),
            Hazard(385, WINDOW_HEIGHT-410, 15, 110, 'right', 8),
            Platform(20, WINDOW_HEIGHT-360, 120, 30, 'OneWay'),
            Platform(20, WINDOW_HEIGHT-440, 120, 30, 'OneWay'),
            Platform(190, WINDOW_HEIGHT-440, 210, 30, 'Default'),
        },
        area4 = {
            Hazard(190, WINDOW_HEIGHT-485, 180, 15, 'up', 10),
            Hazard(190, WINDOW_HEIGHT-470, 180, 15, 'down', 10),
        },
        area5 = {
            Hazard(430, WINDOW_HEIGHT-485, 180, 15, 'up', 10),
            Hazard(430, WINDOW_HEIGHT-470, 180, 15, 'down', 10),
        }
    }

    self.collectible = Object(objects.door,740,WINDOW_HEIGHT-490,'Collectible','static')

    self.player = Player(40, WINDOW_HEIGHT-60)

    self.narrator = Narrator(100, WINDOW_HEIGHT-91, true, 'You are now are able to manipulate the brightness seting of the game using the new icon in the bottom right! Click on it to test it out.')

    self.sign = Sign(460, WINDOW_HEIGHT-310, 'What cannot be seen cannot hurt you.')
end

function Stage4:update(dt)
    world:update(dt)
    self.player:update(dt)
    self.sign:update(dt,self.player.x,self.player.y)
    self.narrator:update(dt,self.player.x,self.player.y)
    if self.collectible then
        self.collectible:update(dt)
    end
    for k,value in pairs(self.platforms) do
        for i,v in ipairs(value) do
            v.collider:setCollisionClass(v.kind)
        end
    end 
    if currentBrightness == brightness[2] then
        for i,v in ipairs(self.platforms.area2) do
            v.collider:setCollisionClass('Ghost')
        end
    elseif currentBrightness == brightness[4] then
        for i,v in ipairs(self.platforms.area3) do
            v.collider:setCollisionClass('Ghost')
        end
    elseif currentBrightness == brightness[3] then
        for i,v in ipairs(self.platforms.area4) do
            v.collider:setCollisionClass('Ghost')
        end
    elseif currentBrightness == brightness[5] then
        for i,v in ipairs(self.platforms.area5) do
            v.collider:setCollisionClass('Ghost')
        end
    end

    if self.player.collider:enter('Collectible') then
        local collision_data = self.player.collider:getEnterCollisionData('Collectible')
        if collision_data.collider == self.collectible.collider then
            self.collectible.collider:destroy()
            self.collectible = nil
            gStateMachine:change('stage5')
        end
    end
end

function Stage4:render()
    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(brightness[4][1],brightness[4][2],brightness[4][3],brightness[4][4])
    love.graphics.rectangle('fill',0,0,WINDOW_WIDTH/2,WINDOW_HEIGHT/2)
    love.graphics.setColor(brightness[2][1],brightness[2][2],brightness[2][3],brightness[4][4])
    love.graphics.rectangle('fill',WINDOW_WIDTH/2,0,WINDOW_WIDTH/2,WINDOW_HEIGHT/2)
    love.graphics.setColor(brightness[3][1],brightness[3][2],brightness[3][3],brightness[3][4])
    love.graphics.rectangle('fill',0,0,WINDOW_WIDTH/2,WINDOW_HEIGHT/4)
    love.graphics.setColor(brightness[5][1],brightness[5][2],brightness[5][3],brightness[4][4])
    love.graphics.rectangle('fill',WINDOW_WIDTH/2,0,WINDOW_WIDTH/2,WINDOW_HEIGHT/4)
    love.graphics.setColor(r,g,b,a)
    for k,value in pairs(self.platforms) do
        for i,v in ipairs(value) do
            v:render()
        end
    end
    self.narrator:render()
    self.sign:render(true)
    self.player:render()
    if self.collectible then
        self.collectible:render()
    end
end

function Stage4:exit()
    self.player.collider:destroy()
    for k,value in pairs(self.platforms) do
        for i,v in ipairs(value) do
            v.collider:destroy()
        end
    end
    if self.collectible then
        self.collectible.collider:destroy()
    end
end