local info = NewScene{blend = 0}
local layer = Layer.new(info)
local sprite = Sprite.newSimple{origin = {0,0}, pos = {0,0}}
local mult, mult1 = 1.5, 1.2
local catcher = Sprite.newSheet{size = {mult, mult1}, origin = {0,0}, pos = {15,30}, anim = 3}
local catcher2 = Sprite.newSheet{size = {mult, mult1}, origin = {0,0}, pos = {160,30}, anim = 7}
local text = Text.newText("press enter to start",13, "res/Catchofont.ttf")
local runner = Sprite.newSheet{size = {mult, mult1}, origin = {0,0}, pos = {450, 80}, anim = 4}
text.pos = {200, 25}
Controls.AddCommand(B.enter, 
function()
    ChangeScene(2)
    Controls.AddCommand(B.enter, nil)
end
)
Controls.AddCommand(B.esc, Close)

Runerite = Sprite.newSheet{size= {mult, mult1}, origin= {0, 0}}
Catchrite = Sprite.newSheet{size = {mult, mult1}, origin = {0,0}}

function info.Load()
    text:Load()
    catcher:Load("res/Catcher/Catcher")
    sprite:Load("Info/Tutor.png")
    runner:Load("res/Runner/Runner")
    catcher:CopySprite(catcher2)
    runner:CopySprite(Runerite)
    catcher:CopySprite(Catchrite)

    
    layer:AddDrawable(sprite)
    layer:AddDrawable(text)
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

return info