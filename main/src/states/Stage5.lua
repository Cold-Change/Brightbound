Stage5 = Class{__includes = BaseState}

function Stage5:init()
    self.platforms = {
        area1 = {
            Platform(0, WINDOW_HEIGHT-40, WINDOW_WIDTH, 40, 'Default', true),
            Hazard(180, WINDOW_HEIGHT-70, 20, 30, 'up', 1, true),
            Hazard(200, WINDOW_HEIGHT-100, 30, 60, 'up', 1, true),
            Hazard(230, WINDOW_HEIGHT-70, 20, 30, 'up', 1, true),
            Hazard(290, WINDOW_HEIGHT-70, 20, 30, 'up', 1, true),
            Hazard(310, WINDOW_HEIGHT-100, 30, 60, 'up', 1, true),
            Hazard(340, WINDOW_HEIGHT-70, 20, 30, 'up', 1, true),
            Hazard(400, WINDOW_HEIGHT-70, 20, 30, 'up', 1, true),
            Hazard(420, WINDOW_HEIGHT-100, 30, 60, 'up', 1, true),
            Hazard(450, WINDOW_HEIGHT-70, 20, 30, 'up', 1, true),
            Hazard(510, WINDOW_HEIGHT-70, 20, 30, 'up', 1, true),
            Hazard(530, WINDOW_HEIGHT-100, 30, 60, 'up', 1, true),
            Hazard(560, WINDOW_HEIGHT-70, 20, 30, 'up', 1, true),
            Hazard(620, WINDOW_HEIGHT-70, 20, 30, 'up', 1, true),
            Hazard(640, WINDOW_HEIGHT-100, 30, 60, 'up', 1, true),
            Hazard(670, WINDOW_HEIGHT-70, 20, 30, 'up', 1, true),
            Platform(695, WINDOW_HEIGHT-70, 85, 30, 'Default', true),
            Platform(695, WINDOW_HEIGHT-130, 85, 30, 'OneWay', true),
            Platform(695, WINDOW_HEIGHT-190, 85, 30, 'OneWay', true),
            Platform(695, WINDOW_HEIGHT-250, 85, 30, 'OneWay', true),
            Platform(585, WINDOW_HEIGHT-250, 30, 30, 'Default', true),
            Platform(475, WINDOW_HEIGHT-250, 30, 30, 'Default', true),
            Platform(365, WINDOW_HEIGHT-250, 30, 30, 'Default', true),
            Platform(255, WINDOW_HEIGHT-250, 30, 30, 'Default', true),
            Platform(145, WINDOW_HEIGHT-250, 30, 30, 'Default', true),
            Platform(20, WINDOW_HEIGHT-250, 45, 30, 'Default', true),
            Platform(20, WINDOW_HEIGHT-310, 45, 30, 'OneWay', true),
            Platform(20, WINDOW_HEIGHT-370, 45, 30, 'OneWay', true),
            Platform(20, WINDOW_HEIGHT-430, 45, 30, 'OneWay', true),
            Platform(145, WINDOW_HEIGHT-430, 30, 30, 'Default', true),
            Platform(255, WINDOW_HEIGHT-430, 30, 30, 'Default', true),
            Platform(365, WINDOW_HEIGHT-430, 30, 30, 'Default', true),
            Platform(475, WINDOW_HEIGHT-430, 30, 30, 'Default', true),
            Platform(585, WINDOW_HEIGHT-430, 30, 30, 'Default', true),
            Platform(695, WINDOW_HEIGHT-430, 85, 30, 'Default', true),
        },
        area2 = {
            Platform(585, WINDOW_HEIGHT-70, 30, 30, 'Default'),
            Platform(475, WINDOW_HEIGHT-70, 30, 30, 'Default'),
            Platform(365, WINDOW_HEIGHT-70, 30, 30, 'Default'),
            Platform(255, WINDOW_HEIGHT-70, 30, 30, 'Default'),
            Platform(145, WINDOW_HEIGHT-70, 30, 30, 'Default'),
            Hazard(585, WINDOW_HEIGHT-265, 30, 15, 'up', 3),
            Hazard(475, WINDOW_HEIGHT-265, 30, 15, 'up', 3),
            Hazard(365, WINDOW_HEIGHT-265, 30, 15, 'up', 3),
            Hazard(255, WINDOW_HEIGHT-265, 30, 15, 'up', 3),
            Hazard(145, WINDOW_HEIGHT-265, 30, 15, 'up', 3),
            Hazard(20, WINDOW_HEIGHT-280, 45, 30, 'up', 1),
        },
        area3 = {
            Hazard(145, WINDOW_HEIGHT-445, 30, 15, 'up', 3),
            Hazard(255, WINDOW_HEIGHT-445, 30, 15, 'up', 3),
            Hazard(365, WINDOW_HEIGHT-445, 30, 15, 'up', 3),
            Hazard(475, WINDOW_HEIGHT-445, 30, 15, 'up', 3),
            Hazard(585, WINDOW_HEIGHT-445, 30, 15, 'up', 3),
        },
    }

    self.collectible = Object(objects.door,725,WINDOW_HEIGHT-480,'Collectible','static')

    self.player = Player(30, WINDOW_HEIGHT-65)

    self.narrator = Narrator(70, WINDOW_HEIGHT-91, true, 'The black platforms and spikes are unaffected by changes in brightness. This can be both a blessing and a curse.')
end

function Stage5:update(dt)
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
    if currentBrightness == brightness[3] then
        for i,v in ipairs(self.platforms.area2) do
            v.collider:setCollisionClass('Ghost')
        end
    elseif currentBrightness == brightness[1] then
        for i,v in ipairs(self.platforms.area3) do
            v.collider:setCollisionClass('Ghost')
        end
    end

    if self.player.collider:enter('Collectible') then
        local collision_data = self.player.collider:getEnterCollisionData('Collectible')
        if collision_data.collider == self.collectible.collider then
            self.collectible.collider:destroy()
            self.collectible = nil
            gStateMachine:change('stage6')
        end
    end
end

function Stage5:render()
    local r,g,b,a = love.graphics.getColor()
    love.graphics.clear(1,1,1,1)
    love.graphics.setColor(brightness[3][1],brightness[3][2],brightness[3][3],brightness[3][4])
    love.graphics.rectangle('fill',0,200,WINDOW_WIDTH,400)
    love.graphics.setColor(r,g,b,a)
    for k,value in pairs(self.platforms) do
        for i,v in ipairs(value) do
            v:render()
        end
    end
    self.narrator:render(true)
    self.player:render()
    if self.collectible then
        self.collectible:render()
    end
end

function Stage5:enter()
    darkUI = false
end

function Stage5:exit()
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
end