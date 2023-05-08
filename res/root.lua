local root = NewScene{}
local screen = _en.screen
local w, h = screen.asize()
local sw, sh = screen.w, screen.h
local ax, ay = (sw/w), (sh/h)


local layer = Layer.new{blend = 0};

WIN = false
-- DEBUG = Text.newText("debug", 14, Fonts.."Arial.ttf")

local text = Text.newText("",23, "res/Catchofont.ttf")
text.poses = {[1] = {70, 40, 0}, [2] = {115, 40, 0}}
text.pos = text.poses[1]

local CatcherModule = require"res.Catcher.CatcherClass"
local Catcher, CatcherBox, CatcherBar = CatcherModule[1], CatcherModule[2], CatcherModule[3]
local RunnerModule = require"res.Runner.RunnerClass"
local Runner, RunnerBox, RunnerGauge = RunnerModule[1], RunnerModule[2], RunnerModule[3]

local Theme = Sound.new{
        pos = {0,0,0};
        pitch = 1.5;
        max_distance = 10;
        rolloff = 1;
        gain = 0.3;
        looping = true;
    };

Controls.AddCommand(B.r, 
    function()
        Catcher.reset()
        Runner.reset(Catcher)
        
        text.value = ""
        
        WIN = false
    end
)


local ptime = LE.Lalloc(1)


local abs = math.abs

function root.reset()
    Catcher.reset()
    Runner.reset()
    text.value= ""
end

function root.Load()
    if DEBUG then
        DEBUG:Load()
        DEBUG.pos = {screen.w*0.5, screen.h*0.5}
        DEBUG.count = 0
        layer:AddDrawable(DEBUG)
    end
    
    --Loading textures for text
    text:Load()
    layer:AddDrawable(text)

    Catcher.load(layer)
    Runner.load(layer)
    Audio.LoadSound(Theme, "res/CatchOTheme.ogg", true)
    
end
local song = true
function root:Update()
    -- if song then
    --     Theme:Play()
    --     song = false
    -- else
    --     Theme:Update()
    -- end
    
    
    if DEBUG then
        DEBUG.value = tostring(Runner.speed)
    end
    if WIN then
        return
    end
    if PLAY == 'Runner' then
        Catcher.Act(Runner, RunnerBox)
    elseif PLAY == 'Catcher' then
        Runner.Act(Catcher)
    end
    
    Runner.update(Catcher)
    Catcher.update(Runner, RunnerBox, RunnerGauge, text)
    
   Audio.Listener.pos = {sw*0.5, sh*0.5}
end


function root:KeyPress(key, down)
    
    if WIN then
        return nil
    end
    if PLAY == 'both' or PLAY == 'Runner' then
        Runner.KeyPress(key, down)
    end
end


function root:Resize(w, h)
    
    ax, ay = (sw/w), (sh/h)
end

function root.Button(x, y, status)
    
    if WIN then -- if someone wins it's no longer necessary
        Catcher:Stop()

        return nil
    end
    if PLAY == 'both' or PLAY == 'Catcher' then
        Catcher.Button(Runner, RunnerBox, x, y, status)
    end
end

function root.Draw()
    layer:Draw()
    local offx = 25 
    if DEBUG then
        Graphics.DrawCircle(false, Runner.pos[1] + offx, Runner.pos[2]+23, 20)
        Graphics.DrawCircle(false, Catcher.pos[1]+25, Catcher.pos[2]+28, 100)
    end
end


return root