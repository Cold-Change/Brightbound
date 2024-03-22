require 'src/Dependencies'

function love.load()
    debugging = false

    WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getWidth(), love.graphics.getHeight()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    canvas = love.graphics.newCanvas(360, 200)
    dialogManager = dialove.init({
        font = love.graphics.newFont('src/fonts/ProggyTiny.ttf', 16),
        numberOfLines = 3,
        typingVolume = 0.5,
        optionsSeparation = 10,
        viewportW = canvas:getWidth(),
        viewportH = canvas:getHeight(),
      })
    
    
    math.randomseed(os.time())

    world = wf.newWorld(0,800,true)
    world:addCollisionClass('OneWay')
    world:addCollisionClass('Hazard')
    world:addCollisionClass('Solid')
    world:addCollisionClass('Collectible', {ignores = {'Default'}})
    world:addCollisionClass('Teleporter', {ignores = {'Default'}})
    world:addCollisionClass('SavePoint', {ignores = {'Default'}})
    world:addCollisionClass('Ghost', {ignores = {'Default'}})

    borders = {
        world:newRectangleCollider(0,0,love.graphics.getWidth(),10),
        world:newRectangleCollider(0,0,10,love.graphics.getHeight()),
        world:newRectangleCollider(0,love.graphics.getHeight()-10,love.graphics.getWidth(),10),
        world:newRectangleCollider(love.graphics.getWidth()-10,0,10,love.graphics.getHeight())
    }
    for i,v in ipairs(borders) do
        v:setType('static')
        v:setCollisionClass('Solid')
    end

    fonts = {
        proggyS = love.graphics.newFont('src/fonts/ProggyTiny.ttf', 16),
        proggyM = love.graphics.newFont('src/fonts/ProggyTiny.ttf', 24),
        proggyL = love.graphics.newFont('src/fonts/ProggyTiny.ttf', 36),
    }

    brightness = {
        {1,1,1,1},
        {.8,.8,.8,1},
        {.6,.6,.6,1},
        {.4,.4,.4,1},
        {.2,.2,.2,1}
    }

    volume = {
        1,
        .75,
        .5,
        .25,
        0
    }

    sounds = {
        -- music = {
        --     love.audio.newSource('src/sounds/Ambient 1.wav', 'stream'),
        --     love.audio.newSource('src/sounds/Ambient 2.wav', 'stream'),
        --     love.audio.newSource('src/sounds/Ambient 3.wav', 'stream'),
        --     love.audio.newSource('src/sounds/Ambient 4.wav', 'stream'),
        --     love.audio.newSource('src/sounds/Ambient 5.wav', 'stream'),
        -- },
        blip = {
            love.audio.newSource('src/sounds/Blip1.wav', 'static'),
            love.audio.newSource('src/sounds/Blip2.wav', 'static'),
            love.audio.newSource('src/sounds/Blip3.wav', 'static'),
        },
        hurt = {
            love.audio.newSource('src/sounds/Hurt1.wav', 'static'),
            love.audio.newSource('src/sounds/Hurt2.wav', 'static'),
            love.audio.newSource('src/sounds/Hurt3.wav', 'static'),
        },
        newItem = {
            love.audio.newSource('src/sounds/newItem1.wav', 'static'),
            love.audio.newSource('src/sounds/newItem2.wav', 'static'),
        },
        teleport = {
            love.audio.newSource('src/sounds/Teleport1.wav', 'static'),
            love.audio.newSource('src/sounds/Teleport2.wav', 'static'),
        },
        jump = love.audio.newSource('src/sounds/Jump1.wav', 'static'),
        save = love.audio.newSource('src/sounds/Save.wav', 'static'),
    }

    

    -- for i,v in ipairs(sounds.music) do
    --     v:setLooping(true)
    -- end

    cursorUnlocked = false
    audioUnlocked = false
    brightnessUnlocked = false
    colorUnlocked = false
    audioMenu = false
    brightnessMenu = false
    colorMenu = false
    darkUI = true
    
    currentColor = {1,1,1,1}
    currentBrightness = brightness[1]
    currentVolume = volume[3]
    -- currentSong = sounds.music[1]
    -- currentSongNumber = 1

    objects = {
        cursor = love.graphics.newImage('src/graphics/Cursor.png'),
        brightnessIcon = love.graphics.newImage('src/graphics/BrightnessIcon.png'),
        soundIcon = love.graphics.newImage('src/graphics/SoundIcon.png'),
        door = love.graphics.newImage('src/graphics/Door.png'),
        key = love.graphics.newImage('src/graphics/Key.png'),
        colorWheel = love.graphics.newImage('src/graphics/ColorWheel.png'),
        respawnAnchor1 = love.graphics.newImage('src/graphics/RespawnAnchor(inactive).png'),
        respawnAnchor2 = love.graphics.newImage('src/graphics/RespawnAnchor(active).png'),
        teleporter = love.graphics.newImage('src/graphics/Teleporter.png'),
        sign = love.graphics.newImage('src/graphics/Sign.png'),
    }

    love.graphics.setFont(fonts.proggyM)
    love.audio.setVolume(currentVolume)

    gStateMachine = StateMachine {
        ['stage1'] = function() return Stage1() end,
        ['stage2'] = function() return Stage2() end,
        ['stage3'] = function() return Stage3() end,
        ['stage4'] = function() return Stage4() end,
        ['stage5'] = function() return Stage5() end,
        ['stage6'] = function() return Stage6() end,
        ['stage7'] = function() return Stage7() end,
        ['stage8'] = function() return Stage8() end,
        ['stage9'] = function() return Stage9() end,
        ['stage10'] = function() return Stage10() end,
    }

    gStateMachine:change('stage1')

    love.keyboard.keysPressed = {}

    love.keyboard.keysReleased = {}

    love.mouse.buttonsPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        gStateMachine:change(gStateMachine.currentState)
    end
    if key == 'f' then
        dialogManager:complete()
    elseif key == 'g' then
        dialogManager:pop(true)
        dialogManager = dialove.init({
            font = love.graphics.newFont('src/fonts/ProggyTiny.ttf', 16),
            numberOfLines = 3,
            typingVolume = 0.5,
            optionsSeparation = 10,
            viewportW = canvas:getWidth(),
            viewportH = canvas:getHeight(),
          })
    end
end

function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
    if button == 1 then
        if audioUnlocked then
            if x >= 600 and x <= 600+objects.soundIcon:getWidth() and y >= WINDOW_HEIGHT-35 and y <= WINDOW_HEIGHT-35+objects.soundIcon:getHeight() then
                if audioMenu then
                    audioMenu = false
                else
                    audioMenu = true
                end
            end
        end
        if brightnessUnlocked then
            if x >= 650 and x <= 650+objects.brightnessIcon:getWidth() and y >= WINDOW_HEIGHT-35 and y <= WINDOW_HEIGHT-35+objects.brightnessIcon:getHeight() then
                if brightnessMenu then
                    brightnessMenu = false
                else
                    brightnessMenu = true
                end
            end
        end
        if colorUnlocked then
            if x >= 700 and x <= 700+objects.colorWheel:getWidth() and y >= WINDOW_HEIGHT-35 and y <= WINDOW_HEIGHT-35+objects.colorWheel:getHeight() then
                if colorMenu then
                    colorMenu = false
                else
                    colorMenu = true
                end
            end
        end
        if audioMenu then
            for i=1, 5 do
                if x >= 608 and x <= 618 and y >= WINDOW_HEIGHT-114+(i*12) and y <= WINDOW_HEIGHT-114+(i*12)+10 then
                    currentVolume = volume[i] 
                    love.audio.play(sounds.blip[1])
                    love.audio.setVolume(currentVolume)
                end
            end
        end
        if brightnessMenu then
            for i=1, 5 do
                if x >= 658 and x <= 668 and y >= WINDOW_HEIGHT-114+(i*12) and y <= WINDOW_HEIGHT-114+(i*12)+10 then
                    currentBrightness = brightness[i] 
                end
            end
        end
        if colorMenu then
            for i=1, 5 do
                if x >= 699 and x <= 709 and y >= WINDOW_HEIGHT-114+(i*12) and y <= WINDOW_HEIGHT-114+(i*12)+10 then
                    currentColor[1] = 1 - (i-1)*.2
                elseif x >= 710 and x <= 720 and y >= WINDOW_HEIGHT-114+(i*12) and y <= WINDOW_HEIGHT-114+(i*12)+10 then
                    currentColor[2] = 1 - (i-1)*.2
                elseif x >= 721 and x <= 731 and y >= WINDOW_HEIGHT-114+(i*12) and y <= WINDOW_HEIGHT-114+(i*12)+10 then
                    currentColor[3] = 1 - (i-1)*.2
                end
            end
        end
    elseif button == 2 then
        -- if audioUnlocked then
        --     if x >= 600 and x <= 600+objects.soundIcon:getWidth() and y >= WINDOW_HEIGHT-35 and y <= WINDOW_HEIGHT-35+objects.soundIcon:getHeight() then
        --         love.audio.stop()
        --         if currentSongNumber < 5 then
        --             currentSongNumber = currentSongNumber + 1
        --         else
        --             currentSongNumber = 1
        --         end
        --         currentSong = sounds.music[currentSongNumber]
        --         love.audio.play(currentSong)
        --     end
        -- end
    end
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)
    gStateMachine:update(dt)

    dialogManager:update(dt)      

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    local r,g,b,a = currentColor[1]*currentBrightness[1],currentColor[2]*currentBrightness[2],currentColor[3]*currentBrightness[3],currentColor[4]*currentBrightness[4]
    love.graphics.setColor(r,g,b,a)
    gStateMachine:render()
    for i,v in ipairs(borders) do
        if i ~= 3 then
            local w, h = 10,10
            if i == 1 then
                w,h = love.graphics:getWidth(),10
            elseif i == 2 then
                w,h = 10,love.graphics.getHeight()
            elseif i == 4 then
                w,h = 10,love.graphics:getHeight()
            end
            love.graphics.rectangle('fill', v:getX()-w/2, v:getY()-h/2, w, h)
        end
    end
    love.graphics.setColor(currentColor[1]*brightness[1][1],currentColor[2]*brightness[1][2],currentColor[3]*brightness[1][3],currentColor[4]*brightness[1][4])
    love.graphics.setFont(fonts.proggyM)
    if audioUnlocked then
        love.graphics.draw(objects.soundIcon, 600, WINDOW_HEIGHT-35)
    end
    if brightnessUnlocked then
        if darkUI then
            love.graphics.draw(objects.brightnessIcon, 650, WINDOW_HEIGHT-35)
            love.graphics.setColor(r*2,g*2,b*2,a)
            love.graphics.print("Brightness: "..tostring(currentBrightness[1]*100).."%", 32, WINDOW_HEIGHT-26)
            love.graphics.setColor(0,0,0,1)
            love.graphics.print("Brightness: "..tostring(currentBrightness[1]*100).."%", 30, WINDOW_HEIGHT-28)
        else
            love.graphics.draw(objects.brightnessIcon, 650, WINDOW_HEIGHT-35)
            love.graphics.setColor(0,0,0,1)
            love.graphics.print("Brightness: "..tostring(currentBrightness[1]*100).."%", 32, WINDOW_HEIGHT-26)
            love.graphics.setColor(r*2,g*2,b*2,a)
            love.graphics.print("Brightness: "..tostring(currentBrightness[1]*100).."%", 30, WINDOW_HEIGHT-28)
        end
    end
    love.graphics.setColor(currentColor[1]*brightness[1][1],currentColor[2]*brightness[1][2],currentColor[3]*brightness[1][3],currentColor[4]*brightness[1][4])
    if colorUnlocked then
        if darkUI then
            love.graphics.draw(objects.colorWheel, 700, WINDOW_HEIGHT-35)
            love.graphics.setColor(r*2,g*2,b*2,a)
            love.graphics.print("Red: "..tostring(currentColor[1]*100).."%", 202, WINDOW_HEIGHT-26)
            love.graphics.print("Green: "..tostring(currentColor[2]*100).."%", 302, WINDOW_HEIGHT-26)
            love.graphics.print("Blue: "..tostring(currentColor[3]*100).."%", 422, WINDOW_HEIGHT-26)
            love.graphics.setColor(0,0,0,1)
            love.graphics.print("Red: "..tostring(currentColor[1]*100).."%", 200, WINDOW_HEIGHT-28)
            love.graphics.print("Green: "..tostring(currentColor[2]*100).."%", 300, WINDOW_HEIGHT-28)
            love.graphics.print("Blue: "..tostring(currentColor[3]*100).."%", 420, WINDOW_HEIGHT-28)
        else
            love.graphics.draw(objects.colorWheel, 700, WINDOW_HEIGHT-35)
            love.graphics.setColor(0,0,0,1)
            love.graphics.print("Red: "..tostring(currentColor[1]*100).."%", 202, WINDOW_HEIGHT-26)
            love.graphics.print("Green: "..tostring(currentColor[2]*100).."%", 302, WINDOW_HEIGHT-26)
            love.graphics.print("Blue: "..tostring(currentColor[3]*100).."%", 422, WINDOW_HEIGHT-26)
            love.graphics.setColor(r*2,g*2,b*2,a)
            love.graphics.print("Red: "..tostring(currentColor[1]*100).."%", 200, WINDOW_HEIGHT-28)
            love.graphics.print("Green: "..tostring(currentColor[2]*100).."%", 300, WINDOW_HEIGHT-28)
            love.graphics.print("Blue: "..tostring(currentColor[3]*100).."%", 420, WINDOW_HEIGHT-28)
        end
    end
    if audioMenu then
        love.graphics.setColor(.5,.5,.5,.5)
        love.graphics.rectangle('fill', 605.5, WINDOW_HEIGHT-105, 15, 63)
        for i=1, 5 do
            love.graphics.setColor(brightness[i][1],brightness[i][2],brightness[i][3],brightness[i][4])
            love.graphics.rectangle('fill', 608, WINDOW_HEIGHT-114+(i*12), 10, 10)
        end
    end
    if brightnessMenu then
        love.graphics.setColor(.5,.5,.5,.5)
        love.graphics.rectangle('fill', 655.5, WINDOW_HEIGHT-105, 15, 63)
        for i=1, 5 do
            love.graphics.setColor(brightness[i][1],brightness[i][2],brightness[i][3],brightness[i][4])
            love.graphics.rectangle('fill', 658, WINDOW_HEIGHT-114+(i*12), 10, 10)
        end
    end
    if colorMenu then
        love.graphics.setColor(.5,.5,.5,.5)
        love.graphics.rectangle('fill', 696, WINDOW_HEIGHT-105, 38, 63)
        for i=1, 5 do
            love.graphics.setColor(brightness[i][1],0,0,1)
            love.graphics.rectangle('fill', 699, WINDOW_HEIGHT-114+(i*12), 10, 10)
            love.graphics.setColor(0,brightness[i][2],0,1)
            love.graphics.rectangle('fill', 710, WINDOW_HEIGHT-114+(i*12), 10, 10)
            love.graphics.setColor(0,0,brightness[i][3],1)
            love.graphics.rectangle('fill', 721, WINDOW_HEIGHT-114+(i*12), 10, 10)
        end
    end
    love.graphics.setColor(1,1,1,1)
    if dialove:getActiveDialogList() then
        love.graphics.draw(love.graphics.newImage('src/graphics/titleBack.png'), 24, 368)
    end
    love.graphics.setCanvas{canvas, stencil = true}
    love.graphics.clear()
    dialogManager:draw()
    love.graphics.setCanvas()
    love.graphics.draw(canvas, 0, 0, 0, love.graphics.getWidth() / canvas:getWidth(), love.graphics.getHeight() / canvas:getHeight())
    if dialove:getActiveDialogList() then
        love.graphics.setFont(fonts.proggyM)
        love.graphics.print('"F" to skip', 630, 510)
        love.graphics.print('"G" to close', 630, 530)
    end
    love.graphics.setColor(r,g,b,a)
end

