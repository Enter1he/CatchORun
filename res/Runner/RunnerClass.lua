local screen = _en.screen
local mult, mult1 = 1.5, 1.2
local w, h = screen.asize()
local sw, sh = screen.w, screen.h
local Runerite = Runerite;
local Runner = Mob.newMob({anim = 4}, 0, 0, 400);
local RunnerGauge = Sprite.newSimple{origin = {0,0}, value = 0}
local Collision = Collision
-- don't touch the string or tabs dissapear!
Runner.text = [[
       Catcher 
                                
dissipates  from  hunger
                    
  press  r  to  restart
      
         or
                                    
  press  esc  to  leave]]

-- text.value = Runner.text

local RunnerBox = {
    pos = Runner.pos;
    
}

if DEBUG then
    function Runerite:Draw()
        Graphics.DrawSpriteSheet(self)
        if Runerite.src then
            local ranim = Runner.anim
            local rpos, roff = Runner.pos, RunnerBox.off[ranim]
            local rx, ry = rpos[1] + roff[1], roff[2] + rpos[2]
            local rw ,rh = RunnerBox.off[ranim][3], RunnerBox.off[ranim][4]
            Graphics.DrawRect(false, rx, ry, rx + rw, ry + rh)
            Graphics.DrawRect(false, 0, 0, rx + 20, ry )
        end
    end
end

local function Dir_Controls(npc) -- adjusting directions for moving mobs
    if npc.vel[1] > 0 then
        npc.anim = 3
    elseif npc.vel[1] < 0 then
        npc.anim = 4
    end
    if npc.vel[2] > 0 then
        npc.anim = 1
    elseif npc.vel[2] < 0 then
        npc.anim = 2
    end
end

do 
    local w = {48, 108, 188}
    local ys = {0, 2, 5}
    function RunnerGauge:Draw()
        if self.color == Color.none then
            return nil
        end
        local x, y = self.pos[1]+25, self.pos[2] + 70
        local h = y + 18
        
        Graphics.SetColor(0.5, 0.5, 0.5, 1)
        Graphics.DrawRect(true, x, y, self.value+x, h)
        
        Graphics.SetColor(0,0,0,1)
        Graphics.DrawRect(true, x+48, y, x+108, y+3)
        Graphics.DrawRect(true, x+108, y, x+138, y+5)
        Graphics.DrawRect(true, x+138, y, x+189, y+5)
        Graphics.DrawSprite(self)
        Graphics.SetColor(1,1,1,1)
    end
end

function Runner.reset(Catcher)
    local w,h = Runner:GetSize()
    Runner.frame = 1
    Runner.anim = 4
    Runner.pos[1] = screen.w*0.66 - h
    Runner.pos[2] = screen.h*0.66 - h
    Runner.color = Color.white
    RunnerGauge.color = Color.white
    RunnerGauge.value = 0
    if Runner.bark then
        Runner.bark:Stop()
    end
end

function Runner.load(layer, Catcher)
    --Loading textures for Runner and setting it's position
    if not Runerite._drawable then
        Runerite:Load("res/Runner/Runner")
    end
    Runerite:CopySprite(Runner)
    Runner.reset()
    Runner.bark = Sound.new{
        pos = Runner.pos;
        pitch = 2;
        max_distance = 10;
        rolloff = 2;
        gain = 10;
    };
    Audio.LoadSound(Runner.bark, "res/Runner/RunnerBark.ogg")
    RunnerGauge:Load("res/Runner/RunnerBar.png")
    RunnerGauge.pos = {screen.w-240, screen.h - 120}
    
    --Adding every object to layer

    
    layer:AddDrawable(Runner)
    layer:AddDrawable(RunnerGauge)

    --Setting the sizes of hitboxes
    RunnerBox.off ={
        {9, 4, Runerite.src.anim[1][3], Runerite.src.anim[1][4]},
        {8, 5, Runerite.src.anim[2][3], Runerite.src.anim[2][4]},
        {5, 5, Runerite.src.anim[3][3], Runerite.src.anim[3][4]},
        {10,5, Runerite.src.anim[4][3], Runerite.src.anim[4][4]}
    }
    
end
local bark_m = math.random(10,25)
local bark_t = 0
local is_bark = false
function Runner.update(Catcher)
    if Runner:isMoving() then
        Runner.speed = 200 + 200*(RunnerGauge.value/188)
        if RunnerGauge.value < 189 then
            local offset = 1
            if RunnerGauge.value == 1 then 
                offset = 5
            elseif RunnerGauge.value >= 54 then
                offset = 1
            elseif RunnerGauge.value >= 108 then
                offset = 3
            end
            RunnerGauge.value = RunnerGauge.value + offset
        end
    else 
        if RunnerGauge.value > 0 then
            RunnerGauge.value = RunnerGauge.value - 1
        end
    end
    if Catcher.anim <= 8 and Catcher.anim > 4 then
        is_bark = math.random(1,10) > 4
    end
    if is_bark then
        if bark_t >= bark_m then
            bark_t = 0
            bark_m = math.random(5,15)
            is_bark = false
            Runner.bark:Play()
        else
            bark_t = bark_t + 1
        end
    end
end
local coms = {}

local m_tmax = 20
local m_time = m_tmax
function Runner.Act(Catcher)
    if m_time < m_tmax then
        m_time = m_time + 1
    else
        for k,v in pairs(coms) do
            coms[k] = false
        end
        local cx, cy, rx, ry = Catcher.pos[1], Catcher.pos[2], Runner.pos[1], Runner.pos[2]
        local dx, dy = cx - rx, cy - ry
        
        local dir = math.random(8)
        m_tmax = math.random(20)
        if dir == 1 then
            coms[B.w] = true
            coms[B.a] = true
        elseif dir == 2 then
            coms[B.w] = true
        elseif dir == 3 then
            coms[B.w] = true
            coms[B.d] = true
        elseif dir == 4 then
            coms[B.d] = true
        elseif dir == 5 then
            coms[B.d] = true
            coms[B.s] = true
        elseif dir == 6 then
            coms[B.s] = true
        elseif dir == 7 then
            coms[B.s] = true
            coms[B.a] = true
        elseif dir == 8 then
            coms[B.a] = true
        end
        m_time = 0
    end
    Runner.KeyPress(coms, 0)
end

function Runner.KeyPress(key, down)
    Runner:Stop()
    local ranim = Runner.anim
    if ranim ~= 5 then
        if ranim > 5 then
            ranim = ranim - 5
        end
        local rw, rh = RunnerBox.off[ranim][3] + 10, RunnerBox.off[ranim][4] + 10
        if key[B.s] and Runner.pos[2] + rh < sh then
            Runner.vel[2] = 1
        end
        if key[B.w] and Runner.pos[2] > 0 then
            Runner.vel[2] = -1
        end
        if key[B.d] and Runner.pos[1] + rw < sw then
            Runner.vel[1] = 1
        end
        if key[B.a] and Runner.pos[1] > 0 then
            Runner.vel[1] = -1
        end
        if Runner.pos[2] + rh > sh or Runner.pos[2] < 0 or Runner.pos[1] + rw > sw or Runner.pos[1] < 0 then
            m_time = m_tmax
        end
    end    
    if Runner:isMoving() then
        Dir_Controls(Runner)
        Runner:Vel_Move()
        Runner:PlayAnim(Runner.anim, true, 4, 4)
    else
        if Runner.anim < 5 then
            Runner.anim = Runner.anim + 5
            Runner.frame = 0
        end
        Runner:PlayAnim(Runner.anim, true, 8, 3, 0)
        -- Runner.frame = 0
    end
end


return {Runner, RunnerBox, RunnerGauge}