Stage8 = Class{__includes = BaseState}

function Stage8:init()
    self.platforms = {
        area1 = {
            Platform(0, WINDOW_HEIGHT-40, WINDOW_WIDTH, 40, 'Default', true),
            Platform(195, 0, 10, WINDOW_HEIGHT, 'Solid', true),
            Platform(595, 0, 10, WINDOW_HEIGHT, 'Solid', true),
            Platform(220, WINDOW_HEIGHT-280, 30, 30, 'Default', true),
            Platform(390, WINDOW_HEIGHT-280, 30, 30, 'Default', true),
            Platform(550, WINDOW_HEIGHT-280, 30, 30, 'Default', true),
        },
        area2 = {
            Platform(30, WINDOW_HEIGHT-100, 30, 30, 'Default'),
            Hazard(75, WINDOW_HEIGHT-160, 15, 20, 'left', 2),
            Platform(90, WINDOW_HEIGHT-160, 30, 30, 'Default'),
            Hazard(135, WINDOW_HEIGHT-220, 15, 20, 'left', 2),
            Platform(150, WINDOW_HEIGHT-220, 30, 30, 'Default'),
            Platform(30, WINDOW_HEIGHT-280, 150, 30, 'OneWay'),
            Platform(30, WINDOW_HEIGHT-340, 30, 30, 'Default'),
            Hazard(75, WINDOW_HEIGHT-400, 15, 20, 'left', 2),
            Platform(90, WINDOW_HEIGHT-400, 30, 30, 'Default'),
            Hazard(135, WINDOW_HEIGHT-460, 15, 20, 'left', 2),
            Platform(150, WINDOW_HEIGHT-460, 30, 30, 'Default'),
            Platform(30, WINDOW_HEIGHT-520, 150, 30, 'OneWay'),

            Platform(625, WINDOW_HEIGHT-100, 40, 30, 'OneWay'),
            Platform(625, WINDOW_HEIGHT-160, 40, 30, 'OneWay'),
            Hazard(685, WINDOW_HEIGHT-220, 15, 120, 'left', 8),
            Hazard(700, WINDOW_HEIGHT-220, 15, 120, 'right', 8),
            Platform(730, WINDOW_HEIGHT-220, 40, 30, 'OneWay'),
            Platform(730, WINDOW_HEIGHT-280, 40, 30, 'OneWay'),
            Platform(730, WINDOW_HEIGHT-340, 40, 30, 'OneWay'),
            Platform(730, WINDOW_HEIGHT-400, 40, 30, 'OneWay'),
            Hazard(685, WINDOW_HEIGHT-460, 15, 180, 'left', 12),
            Hazard(700, WINDOW_HEIGHT-460, 15, 180, 'right', 12),
            Platform(625, WINDOW_HEIGHT-460, 40, 30, 'OneWay'),
            Platform(625, WINDOW_HEIGHT-520, 145, 30, 'OneWay'),

            Platform(350, WINDOW_HEIGHT-100, 100, 30, 'OneWay'),
            Platform(350, WINDOW_HEIGHT-160, 100, 30, 'OneWay'),
            Platform(290, WINDOW_HEIGHT-220, 30, 30, 'Default'),
        },
        area3 = {
            Platform(550, WINDOW_HEIGHT-340, 30, 30, 'OneWay'),
            Hazard(420, WINDOW_HEIGHT-340, 130, 30, 'up', 5),
            Platform(390, WINDOW_HEIGHT-340, 30, 30, 'Default'),
            Hazard(250, WINDOW_HEIGHT-340, 140, 30, 'up', 5),
            Platform(220, WINDOW_HEIGHT-340, 30, 30, 'Default'),
            Platform(220, WINDOW_HEIGHT-400, 30, 30, 'OneWay'),
            Platform(220, WINDOW_HEIGHT-460, 30, 30, 'OneWay'),
            Platform(390, WINDOW_HEIGHT-460, 30, 30, 'OneWay'),
            Platform(550, WINDOW_HEIGHT-460, 30, 30, 'OneWay'),
        },
    }

    self.collectible = Object(objects.colorWheel,550,WINDOW_HEIGHT-570,'Collectible','kinematic', true)

    self.teleporter1 = Object(objects.teleporter,90,WINDOW_HEIGHT-575,'Teleporter','kinematic', true)
    self.teleporter2 = Object(objects.teleporter,690,WINDOW_HEIGHT-575,'Teleporter','kinematic', true)

    self.savePoint1 = Object(objects.respawnAnchor1,387,WINDOW_HEIGHT-70,'SavePoint','static')
    self.save1 = false

    self.player = Player(40, WINDOW_HEIGHT-65)

    self.narrator = Narrator(100, WINDOW_HEIGHT-91, true, 'It looks like there is another tool for you to use up there. You should be able to handle this challenge with ease.')
end

function Stage8:update(dt)
    world:update(dt)
    self.player:update(dt)
    self.narrator:update(dt, self.player.x, self.player.y)
    self.teleporter1:update(dt)
    self.teleporter2:update(dt)
    if self.collectible then
        self.collectible:update(dt)
    end
    for k,value in pairs(self.platforms) do
        for i,v in ipairs(value) do
            v.collider:setCollisionClass(v.kind)
        end
    end 
    if currentBrightness == brightness[1] then
        for i,v in ipairs(self.platforms.area2) do
            v.collider:setCollisionClass('Ghost')
        end
    elseif currentBrightness == brightness[3] then
        for i,v in ipairs(self.platforms.area3) do
            v.collider:setCollisionClass('Ghost')
        end
    end

    if self.player.collider:enter('Collectible') then
        local collision_data = self.player.collider:getEnterCollisionData('Collectible')
        if collision_data.collider == self.collectible.collider then
            self.collectible.collider:destroy()
            self.collectible = nil
            colorUnlocked = true
            gStateMachine:change('stage9')
        end
    end
    if (not self.save1) and self.player.collider:enter('SavePoint') then
        local x,y = self.player.x, self.player.y
        local vx,vy = self.player.collider:getLinearVelocity()
        self.player.collider:destroy()
        self.player = Player(x,y)
        self.player.collider:setLinearVelocity(vx,vy)
        self.savePoint1.sprite = objects.respawnAnchor2
        self.save1 = true
    end
    if self.player.x < 400 and self.player.collider:enter('Teleporter') then
        self.player.collider:setPosition(740, WINDOW_HEIGHT-55)
        self.player.collider:setLinearVelocity(0,0)
    elseif self.player.x > 400 and self.player.collider:enter('Teleporter') then
        self.player.collider:setPosition(400, WINDOW_HEIGHT-55)
        self.player.collider:setLinearVelocity(0,0)
    end
end

function Stage8:render()
    local r,g,b,a = love.graphics.getColor()
    love.graphics.clear(1,1,1,1)
    love.graphics.setColor(brightness[3][1],brightness[3][2],brightness[3][3],brightness[3][4])
    love.graphics.rectangle('fill',200,0,400,WINDOW_HEIGHT/2)
    love.graphics.setColor(r,g,b,a)
    for k,value in pairs(self.platforms) do
        for i,v in ipairs(value) do
            v:render()
        end
    end
    self.teleporter1:render()
    self.teleporter2:render()
    self.savePoint1:render()
    self.narrator:render(true)
    self.player:render()
    if self.collectible then
        self.collectible:render()
    end
end

function Stage8:enter()
    darkUI = false
end

function Stage8:exit()
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
    self.teleporter1.collider:destroy()
    self.teleporter2.collider:destroy()
    self.savePoint1.collider:destroy()
end