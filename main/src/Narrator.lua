Narrator = Class{}

function Narrator:init(x,y,sign,dialogue)
    self.x,self.y = x,y
    self.width,self.height = 37,51
    self.sign = sign
    self.spriteSheet = love.graphics.newImage('src/graphics/Narrator-Sheet.png')
    local grid = anim8.newGrid(self.width, self.height, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.animation = anim8.newAnimation(grid('1-19',1), 0.1)
    self.interactible = false
    self.dialogue = dialogue or '...'
end

function Narrator:update(dt,px,py)
    self.animation:update(dt)
    if self:checkInteraction(px, py) then
        self.interactible = true
        if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] or love.keyboard.keysPressed['e'] then
            if self.sign then
                dialogManager:show({
                    title = 'The Guide',
                    text = self.dialogue,
                    position = 'bottom',
                    background = {
                        image = love.graphics.newImage('src/graphics/Corner.png'),
                        type = dialove.backgroundTypes.clamped
                        },
                })
            else
                dialogManager:show({
                    title = 'Narrator',
                    text = self.dialogue,
                    position = 'bottom',
                    background = {
                        image = love.graphics.newImage('src/graphics/Corner.png'),
                        type = dialove.backgroundTypes.clamped
                        },
                })
            end
        end
    else
        self.interactible = false
    end
end

function Narrator:render(dark)
    local r,g,b,a = love.graphics.getColor()
    self.animation:draw(self.spriteSheet, self.x, self.y)
    if self.sign then
        love.graphics.draw(objects.sign, self.x+30, self.y+21)
    end
    if dark then
        if self.interactible then
            love.graphics.setColor(r,g,b,a)
            love.graphics.print("[E]", self.x+self.width-4, self.y-10)
            love.graphics.setColor(0,0,0,1)
            love.graphics.print("[E]", self.x+self.width-6, self.y-12)
        end
    else
        if self.interactible then
            love.graphics.setFont(fonts.proggyS)
            love.graphics.setColor(0,0,0,1)
            love.graphics.print("[E]", self.x+self.width-4, self.y-10)
            love.graphics.setColor(r*2,g*2,b*2,a)
            love.graphics.print("[E]", self.x+self.width-6, self.y-12)
        end
    end
    love.graphics.setColor(r,g,b,a)
end

function Narrator:checkInteraction(px, py)
    if px >= self.x-15 and px <= self.x+50 and py >= self.y-25 and py <= self.y+50 then
        return true
    end
    return false
end