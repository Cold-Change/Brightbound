Stage2 = Class{__includes = BaseState}

function Stage2:init()
    self.platforms = {
        Platform(0, WINDOW_HEIGHT-40, WINDOW_WIDTH, 40, 'Default'),
        Platform(360, WINDOW_HEIGHT-100, 80, 30, 'OneWay'),
        Platform(360, WINDOW_HEIGHT-160, 80, 30, 'OneWay'),
        Platform(360, WINDOW_HEIGHT-220, 80, 30, 'OneWay'),
        Platform(540, WINDOW_HEIGHT-220, 30, 30, 'Default'),
        Platform(670, WINDOW_HEIGHT-220, 110, 30, 'Default'),
        Platform(670, WINDOW_HEIGHT-280, 110, 30, 'OneWay'),
        Platform(670, WINDOW_HEIGHT-340, 110, 30, 'OneWay'),
        Platform(670, WINDOW_HEIGHT-400, 110, 30, 'OneWay'),
        Platform(670, WINDOW_HEIGHT-460, 110, 30, 'OneWay'),
        Platform(540, WINDOW_HEIGHT-460, 30, 30, 'Default'),
        Platform(440, WINDOW_HEIGHT-470, 30, 30, 'Default'),
        Platform(340, WINDOW_HEIGHT-480, 30, 30, 'Default'),
        Platform(240, WINDOW_HEIGHT-470, 30, 30, 'Default'),
        Platform(140, WINDOW_HEIGHT-460, 30, 30, 'Default'),
        Platform(20, WINDOW_HEIGHT-220, 100, 30, 'Default'),
    }

    self.collectible = Object(objects.soundIcon,50, WINDOW_HEIGHT-260,'Collectible','kinematic', true)

    self.player = Player(40, WINDOW_HEIGHT-65)

    self.narrator = Narrator(100, WINDOW_HEIGHT-91, true, 'The atmosphere is a bit dull, don\'t you think? Go grab that speaker icon above you so you can listen to some tunes.')
end

function Stage2:update(dt)
    world:update(dt)
    self.player:update(dt)
    self.narrator:update(dt,self.player.x,self.player.y)
    if self.collectible then
        self.collectible:update(dt)
    end
    if self.player.collider:enter('Collectible') then
        local collision_data = self.player.collider:getEnterCollisionData('Collectible')
        if collision_data.collider == self.collectible.collider then
            self.collectible.collider:destroy()
            self.collectible = nil
            audioUnlocked = true
            love.audio.play(currentSong)
            gStateMachine:change('stage3')
        end
    end
end

function Stage2:render()
    for i,v in ipairs(self.platforms) do
        v:render()
    end
    self.narrator:render()
    self.player:render()
    if self.collectible then
        self.collectible:render()
    end
end

function Stage2:exit()
    self.player.collider:destroy()
    for i,v in ipairs(self.platforms) do
        v.collider:destroy()
    end
    if self.collectible then
        self.collectible.collider:destroy()
    end
end