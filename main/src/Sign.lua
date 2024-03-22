Sign = Class{}

function Sign:init(x,y,dialogue)
    self.sprite = love.graphics.newImage('src/graphics/Sign.png')
    self.x,self.y = x,y
    self.width,self.height = 32,30
    self.interactible = false
    self.dialogue = dialogue or '...'
end

function Sign:update(dt,px,py)
    if self:checkInteraction(px, py) then
        self.interactible = true
        if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] or love.keyboard.keysPressed['e'] then
            dialogManager:show({
                title = 'Lone Sign',
                text = self.dialogue,
                position = 'bottom',
                background = {
                    image = love.graphics.newImage('src/graphics/Corner.png'),
                    type = dialove.backgroundTypes.clamped
                    },
            }) 
        end
    else
        self.interactible = false
    end
end

function Sign:render(dark)
    local r,g,b,a = love.graphics.getColor()
    love.graphics.draw(objects.sign, self.x, self.y)
    if dark then
        if self.interactible then
            love.graphics.setColor(r,g,b,a)
            love.graphics.print("[E]", self.x+self.width+2, self.y-18)
            love.graphics.setColor(0,0,0,1)
            love.graphics.print("[E]", self.x+self.width, self.y-20)
        end
    else
        if self.interactible then
            love.graphics.setFont(fonts.proggyS)
            love.graphics.setColor(0,0,0,1)
            love.graphics.print("[E]", self.x+self.width+2, self.y-18)
            love.graphics.setColor(r*2,g*2,b*2,a)
            love.graphics.print("[E]", self.x+self.width, self.y-20)
        end
    end
    love.graphics.setColor(r,g,b,a)
end

function Sign:checkInteraction(px, py)
    if px >= self.x-18 and px <= self.x+18 and py >= self.y-18 and py <= self.y+18 then
        return true
    end
    return false
end