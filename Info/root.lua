local screen = _en.screen
local w, h = screen.asize()
local info = NewScene{blend = 0}
local layer = Layer.new()
local sprite = Sprite.newSimple{origin = {0,0}, pos = {0,0}}
local mult, mult1 = 1.5, 1.2
local catcher = Sprite.newSheet{size = {mult, mult1}, origin = {0,0}, pos = {15,30}, anim = 3}
local catcher2 = Sprite.newSheet{size = {mult, mult1}, origin = {0,0}, pos = {160,30}, anim = 7}
local text = Text.newText("press enter to start",13, "res/Catchofont.ttf")
local text2 = Text.newText("press esc to leave", 13, "res/Catchofont.ttf")
local runner = Sprite.newSheet{size = {mult, mult1}, origin = {0.5*mult,0}, pos = {450, 80}, anim = 4}
local sw, sh = screen.w, screen.h
local ax, ay = (sw/w), (sh/h)
text.pos = {200, 25}
text2.pos = {215, _en.screen.h - 12}


Runerite = Sprite.newSheet{size= {mult, mult1}, origin= {0, 0}}
Catchrite = Sprite.newSheet{size = {mult, mult1}, origin = {0,0}}

function info.reset()
    if CHAR_CHOICE then
        text.value = "choose character with mouse"
        text.pos[1] = 150
        function info.Button(x, y, status)
            if status(2) == '1' then
                local dy = LE.int(y*ay)
                local dx = LE.int(x*ax)
                if dx < sw*0.5 then
                    PLAY = 'Catcher'
                else
                    PLAY = 'Runner'
                end
                -- local res = LE.isSceneLoaded"res" 
                -- if res then
                --     res.reset()
                -- end
                LE.ChangeSceneStr"res"
            end
        end
    else 
        PLAY = 'both'
        text.value = "press enter to start"
        text.pos[1] = 200
        Controls.AddCommand(B.enter, 
        function()
            -- local res = LE.isSceneLoaded"res" 
            -- if res then
            --     res.reset()
            -- end
            LE.ChangeSceneStr"res"
            Controls.AddCommand(B.enter, nil)
        end
        )
    end
    
end

function info.Load()
    text:Load()
    text2:Load()
    catcher:Load("res/Catcher/Catcher")
    sprite:Load("Info/Tutor.png")
    runner:Load("res/Runner/Runner")
    catcher:CopySprite(catcher2)
    runner:CopySprite(Runerite)
    catcher:CopySprite(Catchrite)
    
    info.reset()
    layer:AddDrawable(sprite)
    layer:AddDrawable(text)
    layer:AddDrawable(text2)
    layer:AddDrawable(catcher)
    layer:AddDrawable(catcher2)
    layer:AddDrawable(runner)
end
local ranims = {1, 3, 2, 4}
local canim = 1

function info.Update()
    catcher:PlayAnim(3, true, 5, 6)
    catcher2:PlayAnim(7, true, 5, 6)
    if runner.frame == 4  then
        if canim < 4 then
            canim = canim + 1
        else
            canim = 1
        end
        runner.anim = ranims[canim]
        if runner.anim <= 2 then
            runner.origin[1] = 0.2
        else
            runner.origin[1] = 0
        end
        runner.frame = 1
    end
    runner:PlayAnim(runner.anim, true, 5, 4)
end

function info.Draw()
    layer:Draw()
    if DEBUG then
        Graphics.DrawRect(false, 0,0, screen.w*0.5, screen.h)
    end
end

return info