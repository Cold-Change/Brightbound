Stage9 = Class{__includes = BaseState}

function Stage9:init()
    self.platforms = {
        Platform(0, WINDOW_HEIGHT-40, WINDOW_WIDTH, 40),
    }

    self.collectible = Object(objects.door,700,WINDOW_HEIGHT-90,'Collectible','static')

    self.player = Player(40, WINDOW_HEIGHT-65)

    self.narrator = Narrator(100, WINDOW_HEIGHT-91, false, 'An unfinished game is a tragedy. Alas, create a color to your liking and step through the door when you are ready.')
end

function Stage9:update(dt)
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
            gStateMachine:change('stage10')
        end
    end
end

function Stage9:render()
    for i,v in ipairs(self.platforms) do
        v:render()
    end
    self.narrator:render()
    self.player:render()
    if self.collectible then
        self.collectible:render()
    end
end

function Stage9:enter()
    darkUI = false
end

function Stage9:exit()
    darkUI = true
    self.player.collider:destroy()
    for i,v in ipairs(self.platforms) do
        v.collider:destroy()
    end
    if self.collectible then
        self.collectible.collider:destroy()
    end
end