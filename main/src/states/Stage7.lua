Stage7 = Class{__includes = BaseState}

function Stage7:init()
    self.platforms = {
        area1 = {
            Platform(0, WINDOW_HEIGHT-40, WINDOW_WIDTH, 40, 'Default', true),
            Platform(0, WINDOW_HEIGHT-230, WINDOW_WIDTH, 30, 'Default', true),
            Platform(0, WINDOW_HEIGHT-420, WINDOW_WIDTH, 30, 'Default', true),
            
            Hazard(240, WINDOW_HEIGHT-75, 35, 40, 'up', 3, true),
            Hazard(525, WINDOW_HEIGHT-75, 35, 40, 'up', 3, true),
            Hazard(240, WINDOW_HEIGHT-265, 35, 40, 'up', 3, true),
            Hazard(525, WINDOW_HEIGHT-265, 35, 40, 'up', 3, true),
            Hazard(240, WINDOW_HEIGHT-455, 35, 40, 'up', 3, true),
            Hazard(525, WINDOW_HEIGHT-455, 35, 40, 'up', 3, true),

            Hazard(340, WINDOW_HEIGHT-90, 10, 50, 'left', 5, true),
            Hazard(340, WINDOW_HEIGHT-280, 10, 50, 'left', 5, true),
            Hazard(340, WINDOW_HEIGHT-470, 10, 50, 'left', 5, true),
            Hazard(350, WINDOW_HEIGHT-90, 10, 50, 'right', 5, true),
            Hazard(350, WINDOW_HEIGHT-280, 10, 50, 'right', 5, true),
            Hazard(350, WINDOW_HEIGHT-470, 10, 50, 'right', 5, true),

            Hazard(440, WINDOW_HEIGHT-90, 10, 50, 'left', 5, true),
            Hazard(440, WINDOW_HEIGHT-280, 10, 50, 'left', 5, true),
            Hazard(440, WINDOW_HEIGHT-470, 10, 50, 'left', 5, true),
            Hazard(450, WINDOW_HEIGHT-90, 10, 50, 'right', 5, true),
            Hazard(450, WINDOW_HEIGHT-280, 10, 50, 'right', 5, true),
            Hazard(450, WINDOW_HEIGHT-470, 10, 50, 'right', 5, true),
        },
        area2 = {
            Platform(390, WINDOW_HEIGHT-200, 20, 160, 'Solid'),
        },
        area3 = {
            Platform(390, WINDOW_HEIGHT-390, 20, 160, 'Solid'),
        },
        area4 = {
            Platform(390, WINDOW_HEIGHT-590, 20, 170, 'Solid'),
        },
    }

    self.collectible = Object(objects.door,740,WINDOW_HEIGHT-470,'Collectible','static')

    self.player = Player(40, WINDOW_HEIGHT-65)

    self.narrator = Narrator(100, WINDOW_HEIGHT-91, true, 'Look in awe at the technology of they future! Teleporters. Who knows how they work? Well, you will be seeing some of them from now on.')

    self.teleporter1 = Object(objects.teleporter, 700, WINDOW_HEIGHT-100, 'Teleporter', 'kinematic', true)
    self.teleporter2 = Object(objects.teleporter, 50, WINDOW_HEIGHT-290, 'Teleporter', 'kinematic', true)
end

function Stage7:update(dt)
    world:update(dt)
    self.teleporter1:update(dt)
    self.teleporter2:update(dt)
    self.player:update(dt)
    self.narrator:update(dt, self.player.x, self.player.y)
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
    elseif currentBrightness == brightness[5] then
        for i,v in ipairs(self.platforms.area4) do
            v.collider:setCollisionClass('Ghost')
        end
    end
    if self.player.y > 400 and self.player.collider:enter('Teleporter') then
        self.player.collider:setPosition(750,WINDOW_HEIGHT-255)
        self.player.collider:setLinearVelocity(0,0)
    elseif self.player.y < 400 and self.player.collider:enter('Teleporter') then
        self.player.collider:setPosition(50,WINDOW_HEIGHT-445)
        self.player.collider:setLinearVelocity(0,0)
    end
    if self.player.collider:enter('Collectible') then
        local collision_data = self.player.collider:getEnterCollisionData('Collectible')
        if collision_data.collider == self.collectible.collider then
            self.collectible.collider:destroy()
            self.collectible = nil
            gStateMachine:change('stage8')
        end
    end
end

function Stage7:render()
    local r,g,b,a = love.graphics.getColor()
    love.graphics.clear(1,1,1,1)
    love.graphics.setColor(brightness[3][1],brightness[3][2],brightness[3][3],brightness[3][4])
    love.graphics.rectangle('fill',0,0,WINDOW_WIDTH,400)
    love.graphics.setColor(brightness[5][1],brightness[5][2],brightness[5][3],brightness[5][4])
    love.graphics.rectangle('fill',0,0,WINDOW_WIDTH,200)
    love.graphics.setColor(r,g,b,a)
    for k,value in pairs(self.platforms) do
        for i,v in ipairs(value) do
            v:render()
        end
    end
    self.teleporter1:render()
    self.teleporter2:render()
    self.narrator:render(true)
    self.player:render()
    if self.collectible then
        self.collectible:render()
    end
end

function Stage7:enter()
    darkUI = false
end

function Stage7:exit()
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
end