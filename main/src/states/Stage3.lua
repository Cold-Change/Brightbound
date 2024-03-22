Stage3 = Class{__includes = BaseState}

function Stage3:init()
    self.platforms = {
        Platform(0, WINDOW_HEIGHT-40, WINDOW_WIDTH, 40),
        Hazard(200, WINDOW_HEIGHT-85, 45, 45, 'up', 2),
        Hazard(300, WINDOW_HEIGHT-85, 45, 45, 'up', 2),
        Hazard(420, WINDOW_HEIGHT-100, 250, 15, 'down', 25),
        Hazard(420, WINDOW_HEIGHT-115, 250, 15, 'up', 25),
        Hazard(670, WINDOW_HEIGHT-235, 15, 120, 'left', 12),
        Hazard(685, WINDOW_HEIGHT-235, 15, 120, 'right', 12),
        Platform(715, WINDOW_HEIGHT-100, 60, 30, 'OneWay'),
        Platform(715, WINDOW_HEIGHT-160, 60, 30, 'OneWay'),
        Platform(715, WINDOW_HEIGHT-220, 60, 30, 'OneWay'),
        Platform(715, WINDOW_HEIGHT-280, 60, 30, 'OneWay'),
        Platform(500, WINDOW_HEIGHT-280, 200, 30, 'Default'),
        Hazard(430, WINDOW_HEIGHT-265, 70, 15, 'up', 5),
        Platform(400, WINDOW_HEIGHT-280, 30, 30, 'Default'),
        Hazard(330, WINDOW_HEIGHT-265, 70, 15, 'up', 5),
        Platform(300, WINDOW_HEIGHT-280, 30, 30, 'Default'),
        Hazard(230, WINDOW_HEIGHT-265, 70, 15, 'up', 5),
        Platform(200, WINDOW_HEIGHT-280, 30, 30, 'Default'),
        Hazard(130, WINDOW_HEIGHT-265, 70, 15, 'up', 5),
        Platform(10, WINDOW_HEIGHT-280, 120, 30, 'Default'),
        Platform(20, WINDOW_HEIGHT-340, 100, 30, 'OneWay'),
        Platform(20, WINDOW_HEIGHT-400, 100, 30, 'OneWay'),
        Platform(20, WINDOW_HEIGHT-460, 100, 30, 'OneWay'),
        Platform(20, WINDOW_HEIGHT-520, 630, 30, 'OneWay'),
        Hazard(275, 10, 10, 70, 'left', 5),
        Hazard(285, 10, 10, 70, 'right', 5),
        Hazard(475, 10, 10, 70, 'left', 5),
        Hazard(485, 10, 10, 70, 'right', 5),
        Hazard(170, WINDOW_HEIGHT-460, 60, 50, 'up', 3),
        Platform(230, WINDOW_HEIGHT-440, 100, 30, 'Default'),
        Hazard(330, WINDOW_HEIGHT-460, 100, 50, 'up', 5),
        Platform(430, WINDOW_HEIGHT-440, 100, 30, 'Default'),
        Hazard(530, WINDOW_HEIGHT-460, 100, 50, 'up', 5),
        Platform(650, WINDOW_HEIGHT-520, 125, 30, 'Default'),

    }

    self.collectible = Object(objects.brightnessIcon,700,40,'Collectible','kinematic', true)

    self.player = Player(40, WINDOW_HEIGHT-60)

    self.narrator = Narrator(100, WINDOW_HEIGHT-91, true, 'Nice work! You now are able to use your cursor. Go grab that brightness icon up there, you will need it. Beware of spikes.')

    self.sign1 = Sign(50, WINDOW_HEIGHT-550, 'Try using "S" to fall through one-way platforms.')
    self.sign2 = Sign(585, WINDOW_HEIGHT-310, 'Switch the song you are listening to by right clicking the icon.')
end

function Stage3:update(dt)
    world:update(dt)
    self.player:update(dt)
    self.narrator:update(dt,self.player.x,self.player.y)
    self.sign1:update(dt,self.player.x,self.player.y)
    self.sign2:update(dt,self.player.x,self.player.y)
    if self.collectible then
        self.collectible:update(dt)
    end
    if self.player.collider:enter('Collectible') then
        local collision_data = self.player.collider:getEnterCollisionData('Collectible')
        if collision_data.collider == self.collectible.collider then
            self.collectible.collider:destroy()
            self.collectible = nil
            brightnessUnlocked = true
            gStateMachine:change('stage4')
        end
    end
end

function Stage3:render()
    for i,v in ipairs(self.platforms) do
        v:render()
    end
    self.narrator:render()
    self.sign1:render()
    self.sign2:render()
    self.player:render()
    if self.collectible then
        self.collectible:render()
    end
end

function Stage3:exit()
    self.player.collider:destroy()
    for i,v in ipairs(self.platforms) do
        v.collider:destroy()
    end
    if self.collectible then
        self.collectible.collider:destroy()
    end
end