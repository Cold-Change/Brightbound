Stage1 = Class{__includes = BaseState}

function Stage1:init()
    self.platforms = {
        Platform(0, WINDOW_HEIGHT-40, WINDOW_WIDTH, 40),
        Platform(700, WINDOW_HEIGHT-100, 80, 30, 'OneWay'),
        Platform(700, WINDOW_HEIGHT-160, 80, 30, 'OneWay'),
        Platform(700, WINDOW_HEIGHT-220, 80, 30, 'OneWay'),
        Platform(700, WINDOW_HEIGHT-280, 80, 30, 'OneWay'),
        Platform(600, WINDOW_HEIGHT-280, 30, 30, 'Default'),
        Platform(500, WINDOW_HEIGHT-280, 30, 30, 'Default'),
        Platform(400, WINDOW_HEIGHT-280, 30, 30, 'Default'),
        Platform(300, WINDOW_HEIGHT-280, 30, 30, 'Default'),
        Platform(20, WINDOW_HEIGHT-220, 200, 30, 'Default'),
        Platform(20, WINDOW_HEIGHT-280, 80, 30, 'OneWay'),
        Platform(20, WINDOW_HEIGHT-340, 80, 30, 'OneWay'),
        Platform(20, WINDOW_HEIGHT-400, 80, 30, 'OneWay'),
        Platform(150, WINDOW_HEIGHT-420, 30, 30, 'Default'),
        Platform(250, WINDOW_HEIGHT-460, 30, 30, 'Default'),
        Platform(350, WINDOW_HEIGHT-500, 30, 30, 'Default'),
        Platform(450, WINDOW_HEIGHT-460, 30, 30, 'Default'),
        Platform(550, WINDOW_HEIGHT-500, 30, 30, 'Default'),

        Platform(650, 100, 125, 30, 'Default'),

    }

    self.collectible = Object(objects.cursor,700,60,'Collectible','kinematic', true)

    self.player = Player(40, WINDOW_HEIGHT-65)

    self.narrator = Narrator(100, WINDOW_HEIGHT-91, true, 'Welcome to BrightBound! Your first task is to grab that cursor in the top right corner. Use "A"/"D" to move left/right and "Space" to jump.')

    love.mouse.setVisible(false)
end

function Stage1:update(dt)
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
            love.mouse.setVisible(true)
            cursorUnlocked = true
            gStateMachine:change('stage2')
        end
    end
end

function Stage1:render()
    for i,v in ipairs(self.platforms) do
        v:render()
    end
    self.narrator:render()
    self.player:render()
    if self.collectible then
        self.collectible:render()
    end
end

function Stage1:exit()
    self.player.collider:destroy()
    for i,v in ipairs(self.platforms) do
        v.collider:destroy()
    end
    if self.collectible then
        self.collectible.collider:destroy()
    end
end