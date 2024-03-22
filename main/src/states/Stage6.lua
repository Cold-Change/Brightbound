Stage6 = Class{__includes = BaseState}

function Stage6:init()
    self.platforms = {
        area1 = {
            Platform(0, WINDOW_HEIGHT-40, WINDOW_WIDTH, 40, 'Default', true),
            Hazard(200, WINDOW_HEIGHT-140, 30, 15, 'up', 3, true),
            Hazard(285, WINDOW_HEIGHT-70, 30, 30, 'up', 3, true),
            Hazard(370, WINDOW_HEIGHT-140, 30, 15, 'up', 3, true),
            Hazard(200, WINDOW_HEIGHT-125, 30, 15, 'down', 3, true),
            Hazard(370, WINDOW_HEIGHT-125, 30, 15, 'down', 3, true),
            Hazard(540, WINDOW_HEIGHT-140, 30, 15, 'up', 3, true),
            Hazard(540, WINDOW_HEIGHT-125, 30, 15, 'down', 3, true),
            Hazard(455, WINDOW_HEIGHT-70, 30, 30, 'up', 3, true),
            Hazard(625, WINDOW_HEIGHT-70, 30, 30, 'up', 3, true),

            Platform(700, WINDOW_HEIGHT-100, 80, 30, 'OneWay', true),
            Platform(700, WINDOW_HEIGHT-160, 80, 30, 'OneWay', true),
            Platform(700, WINDOW_HEIGHT-220, 80, 30, 'OneWay', true),
            Hazard(20, WINDOW_HEIGHT-220, 600, 20, 'up', 30, true),
            Platform(650, WINDOW_HEIGHT-280, 10, 30, 'Default', true),
            Platform(550, WINDOW_HEIGHT-290, 10, 30, 'Default', true),
            Platform(450, WINDOW_HEIGHT-300, 10, 30, 'Default', true),
            Platform(350, WINDOW_HEIGHT-310, 10, 30, 'Default', true),
            Platform(250, WINDOW_HEIGHT-300, 10, 30, 'Default', true),
            Platform(150, WINDOW_HEIGHT-290, 10, 30, 'Default', true),
            Platform(20, WINDOW_HEIGHT-280, 100, 30, 'Default', true),
            Platform(20, WINDOW_HEIGHT-340, 100, 30, 'OneWay', true),
            Platform(20, WINDOW_HEIGHT-400, 100, 30, 'OneWay', true),
            Platform(20, WINDOW_HEIGHT-460, 100, 30, 'OneWay', true),
            Platform(20, WINDOW_HEIGHT-520, 100, 30, 'OneWay', true),

            Hazard(140, WINDOW_HEIGHT-520, 15, 80, 'left', 6, true),
            Hazard(155, WINDOW_HEIGHT-520, 15, 80, 'right', 6, true),
            Hazard(250, WINDOW_HEIGHT-520, 15, 80, 'left', 6, true),
            Hazard(265, WINDOW_HEIGHT-520, 15, 80, 'right', 6, true),
            Hazard(350, WINDOW_HEIGHT-520, 15, 80, 'left', 6, true),
            Hazard(365, WINDOW_HEIGHT-520, 15, 80, 'right', 6, true),
            Hazard(450, WINDOW_HEIGHT-520, 15, 80, 'left', 6, true),
            Hazard(465, WINDOW_HEIGHT-520, 15, 80, 'right', 6, true),
            Hazard(550, WINDOW_HEIGHT-520, 15, 80, 'left', 6, true),
            Hazard(565, WINDOW_HEIGHT-520, 15, 80, 'right', 6, true),
            Hazard(650, WINDOW_HEIGHT-520, 15, 80, 'left', 6, true),
            Hazard(665, WINDOW_HEIGHT-520, 15, 80, 'right', 6, true),
        },
        area2 = {
            Hazard(200, WINDOW_HEIGHT-70, 30, 30, 'up', 3),
            Hazard(370, WINDOW_HEIGHT-70, 30, 30, 'up', 3),
            
            Hazard(285, WINDOW_HEIGHT-140, 30, 15, 'up', 3),
            Hazard(285, WINDOW_HEIGHT-125, 30, 15, 'down', 3),

            Platform(200, WINDOW_HEIGHT-460, 30, 30, 'Default'),
            Platform(300, WINDOW_HEIGHT-460, 30, 30, 'Default'),
            
        },
        area3 = {
            Hazard(540, WINDOW_HEIGHT-70, 30, 30, 'up', 3),

            Hazard(455, WINDOW_HEIGHT-140, 30, 15, 'up', 3),
            Hazard(625, WINDOW_HEIGHT-140, 30, 15, 'up', 3),
            Hazard(455, WINDOW_HEIGHT-125, 30, 15, 'down', 3),
            Hazard(625, WINDOW_HEIGHT-125, 30, 15, 'down', 3),

            Platform(400, WINDOW_HEIGHT-460, 30, 30, 'Default'),
            Platform(500, WINDOW_HEIGHT-460, 30, 30, 'Default'),
            Platform(600, WINDOW_HEIGHT-460, 30, 30, 'Default'),
            Platform(700, WINDOW_HEIGHT-460, 80, 30, 'Default'),
        }
    }

    self.collectible = Object(objects.door,730,WINDOW_HEIGHT-510,'Collectible','static')

    self.player = Player(40, WINDOW_HEIGHT-65)

    self.narrator = Narrator(100, WINDOW_HEIGHT-91, true, 'Jumping into spikes over and over is rather painful. At least there are some save points up ahead so you can get back up on your feet faster.')

    self.savePoint1 = Object(objects.respawnAnchor1, 730, WINDOW_HEIGHT-250, 'SavePoint', 'static')
    self.savePoint2 = Object(objects.respawnAnchor1, 60, WINDOW_HEIGHT-550, 'SavePoint', 'static')
    self.save = 0
end

function Stage6:update(dt)
    world:update(dt)
    self.player:update(dt)
    self.narrator:update(dt,self.player.x,self.player.y)
    if self.collectible then
        self.collectible:update(dt)
    end
    for k,value in pairs(self.platforms) do
        for i,v in ipairs(value) do
            v.collider:setCollisionClass(v.kind)
        end
    end 
    if currentBrightness == brightness[5] then
        for i,v in ipairs(self.platforms.area2) do
            v.collider:setCollisionClass('Ghost')
        end
    elseif currentBrightness == brightness[4] then
        for i,v in ipairs(self.platforms.area3) do
            v.collider:setCollisionClass('Ghost')
        end
    end
    if self.player.x > 400 and self.save ~= 1 and self.player.collider:enter('SavePoint') then
        local x,y = self.player.x, self.player.y
        local vx,vy = self.player.collider:getLinearVelocity()
        self.player.collider:destroy()
        self.player = Player(x,y)
        self.player.startingX, self.player.startingY = 730, WINDOW_HEIGHT-245
        self.player.collider:setLinearVelocity(vx,vy)
        self.save = 1
    elseif self.player.x < 400 and self.save ~= 2 and self.player.collider:enter('SavePoint') then
        local x,y = self.player.x, self.player.y
        local vx,vy = self.player.collider:getLinearVelocity()
        self.player.collider:destroy()
        self.player = Player(x,y)
        self.player.startingX, self.player.startingY = 60, WINDOW_HEIGHT-545
        self.player.collider:setLinearVelocity(vx,vy)
        self.save = 2
    end
    if self.save == 1 then
        self.savePoint1.sprite = objects.respawnAnchor2
        self.savePoint2.sprite = objects.respawnAnchor1
    elseif self.save == 2 then
        self.savePoint1.sprite = objects.respawnAnchor1
        self.savePoint2.sprite = objects.respawnAnchor2
    else
        self.savePoint1.sprite = objects.respawnAnchor1
        self.savePoint2.sprite = objects.respawnAnchor1
    end
    if self.player.collider:enter('Collectible') then
        local collision_data = self.player.collider:getEnterCollisionData('Collectible')
        if collision_data.collider == self.collectible.collider then
            self.collectible.collider:destroy()
            self.collectible = nil
            gStateMachine:change('stage7')
        end
    end
end

function Stage6:render()
    local r,g,b,a = love.graphics.getColor()
    love.graphics.clear(.2,.2,.2,1)
    love.graphics.setColor(brightness[4][1],brightness[4][2],brightness[4][3],brightness[4][4])
    love.graphics.rectangle('fill',WINDOW_WIDTH/2,0,WINDOW_WIDTH/2,WINDOW_HEIGHT)
    love.graphics.setColor(r,g,b,a)
    for k,value in pairs(self.platforms) do
        for i,v in ipairs(value) do
            v:render()
        end
    end
    self.narrator:render()
    self.savePoint1:render()
    self.savePoint2:render()
    self.player:render()
    if self.collectible then
        self.collectible:render()
    end
end

function Stage6:enter()
    darkUI = false
end

function Stage6:exit()
    darkUI = true
    self.player.collider:destroy()
    for k,value in pairs(self.platforms) do
        for i,v in ipairs(value) do
            v.collider:destroy()
        end
    end
    if self.collectible then
        self.collectible.collider:destroy()
    end
    self.savePoint1.collider:destroy()
    self.savePoint2.collider:destroy()
end