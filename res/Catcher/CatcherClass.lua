local screen = _en.screen
local Collide = Collision

local w, h = screen.asize()
local sw, sh = screen.w, screen.h
local ax, ay = (sw/w), (sh/h)
local nax, nay = 1/ax, 1/ay
local mult, mult1 = 1.5, 1.2
local Catchrite = Catchrite;  
local Catcher = Mob.newMob({anim = 3, origin = {0,0}}, 0, 0, 500);
local CatchBcount = 0
local CatcherBar = Sprite.newSheet{origin = {0,0}, value = CatchBcount,  frame = 0}
CatcherBar.flame = Sprite.newSheet{origin = {0,0},  size= {1.8, 1.5}, frame = 0}
CatcherBar.flame.curp = 0;
CatcherBar.flame.poses = {
    [1] = {182, 15, 0};
    [2] = {182, 15, 0};
    [3] = {182, 22, 0};
    [4] = {176, 29, 0};
    [5] = {170, 29, 0};
    [6] = {158, 29, 0};
    [7] = {148, 38, 0};
    [8] = {143, 46, 0};
    [9] = {132, 50, 0};
    [10] = {125, 50, 0};
    [11] = {118, 42, 0};
    [12] = {106, 38, 0};
    [13] = {95, 38, 0};
    [14] = {88, 44, 0};
    [15] = {75, 46, 0};
    [16] = {67, 44, 0};
    [17] = {56, 40, 0};
    [18] = {37, 40, 0};
    [19] = {32, 50, 0};
    [20] = {22, 50, 0};
    [21] = {16, 45, 0};
    [22] = {10, 38, 0};
    [23] = {-2, 38, 0};
    [24] = {-5, 30, 0};
    [25] = {-12, 19, 0};
    
}
-- don't touch the string or tabs dissapear!ф
Catcher.text = string.format("   Runner  will  be\n \nthe greatest  supper\n \n \n press  r  to  restart\n \n        or \n \n press  esc  to  leave")
CatcherBar.flame.pos = CatcherBar.flame.poses[1]
local Hit_sound = Sound.new{
        pos = Catcher.pos;
        pitch =3;
        max_distance = 10;
        rolloff = 1;
        gain = 1;
    };
local Run_sound = Sound.new{
    pos = Catcher.pos;
    pitch =3;
    max_distance = 10;
    rolloff = 1;
    looping = true;
    gain = 0.1;
}
function Catcher.reset()
    local w, h = Catcher:GetSize()
    Catcher.frame = 0
    Catcher.anim = 3
    Catcher.hit = false
    Catcher.pos[1] = screen.w*0.33
    Catcher.pos[2] = screen.h*0.66 - h
    Catcher.color = Color.white
    CatcherBar.color = Color.white
    CatcherBar.flame.pos = CatcherBar.flame.poses[1]
    CatcherBar.flame.color = Color.white
    CatcherBar.flame.curp = 0
    CatcherBar.frame = 0
    CatcherBar.anim = 1
    CatcherBar.value = CatchBcount
    if Run_sound._core and Hit_sound._core then
        Run_sound:Stop()
        Hit_sound:Stop()
    end
end

local CatcherBox = {
    pos = Catcher.pos;
}

if DEBUG then
    function Catchrite:Draw()
        Graphics.DrawSpriteSheet(self)
        local anim = Catcher.anim
        if CatcherBox.off[anim] then
            local off, pos = CatcherBox.off[anim], Catcher.pos
            local cx, cy = pos[1] + off[1], pos[2] + off[2]
            local cw, ch = CatcherBox.off[anim][3], CatcherBox.off[anim][4]
            Graphics.DrawRect(false, cx, cy, cx + cw, cy + ch)
            
        end
        Graphics.DrawRect(false, Catcher.pos[1]+20, Catcher.pos[2]+80, Catcher.pos[1] + 60, Catcher.pos[2]+80)
        Graphics.DrawRect(false, 0, 0, Catcher.pos[1] + 20, Catcher.pos[2] + Catchrite.src.anim[anim][4]//2)
    end
end

local function Catcher_dir(r, rb)
    local c = Catcher
    local rx = r.pos[1]
    local rr = rx + 40
    local rn = rx + 20
    local cb = CatcherBox
    local cl, cn, cr = c.pos[1], c.pos[1] + 20, c.pos[1] + 50
    if rr < cn then
        c.anim = 4
    end
    
    if rr > cr then
        c.anim = 3
    end   
    if rn > cn and rx < cr then
        if c.pos[2] + 50 > r.pos[2]  then
            c.anim = 2
        else
            c.anim = 1
        end
        
    end
end

local cntr = 0
local tim = 60
function CatcherBar:Update(text, Runner, RunnerGauge)
    local flame = self.flame
    if self.value%72 == 0 then
        cntr = 0
        if self.frame < 2 then
            self.frame = self.frame + 1

            if self.anim == 9 and self.frame == 2 then
                text.pos = text.poses[1]
                text.value = Runner.text
                CatcherBar.color = Color.none
                CatcherBar.flame.color = Color.none
                Catcher.color = Color.none

                RunnerGauge.color = Color.none
                Runner.anim = 5
                Runner.frame = 0
                WIN = true
            end
        else

            if self.anim < 9 then
                self.anim = self.anim + 1
            end
            self.frame = 0
        end
        flame.curp = flame.curp + 1
        flame.pos = flame.poses[flame.curp]
    end
    self.value = self.value + 10
    if tim == 0 then
        tim = 60
        if DEBUG then
            DEBUG.count = DEBUG.count + 1
        end
    end
    tim = tim - 1
end

function Catcher.load(layer)
    if not Catchrite._drawable then 
        Catchrite:Load("res/Catcher/Catcher")
    end
    Catchrite:CopySprite(Catcher)
    Catcher.reset()
    CatcherBar:Load("res/Catcher/CatcherBar")
    CatcherBar.pos = {0 , 0}
    CatcherBar.flame:Load("res/Catcher/CatcherFlame")
    Audio.LoadSound(Hit_sound, "res/Catcher/Flop.ogg")
    Audio.LoadSound(Run_sound, "res/Catcher/Run8bit.ogg")
    CatcherBox.off = {
        [5] = {12, 75, 60, 40};
        [6] = {12, 10, 60, 40};
        [7] = {70, 50, 60, 20};
        [8] = {-70, 50, 60, 20}
    }
    layer:AddDrawable(Catcher)
    layer:AddDrawable(CatcherBar)
    layer:AddDrawable(CatcherBar.flame)
end

function CatcherBox.Update(Runner, RunnerBox, RunnerGauge, text)
    local anim, ranim = Catcher.anim, Runner.anim
    
    if ranim > 5 then
        ranim = ranim - 5
    end
    if anim < 5 and anim > 8 then
        return nil
    end
    local rpos, roff = Runner.pos, RunnerBox.off[ranim]
    local off, pos = CatcherBox.off[anim], Catcher.pos
    local cx, cy = pos[1] + off[1], pos[2] + off[2]
    local cw, ch = off[3], off[4]
    local rx, ry = rpos[1] + roff[1], rpos[2] + roff[2]
    local rw ,rh = RunnerBox.off[ranim][3], RunnerBox.off[ranim][4]
    if Collide.StS(rx, ry, rw, rh, cx, cy, cw, ch) then
        WIN = true
        text.pos = text.poses[2]
        text.value = Catcher.text
        CatcherBar.color = Color.none
        CatcherBar.flame.color = Color.none
        Catcher.anim = 13
        Catcher.frame = 0
        
        Runner.color = Color.none
        RunnerGauge.color = Color.none
        return true
    end
end
local sound_played = false
function Catcher.update(Runner, RunnerBox, RunnerGauge, text)
    Catcher:Stop()
    if Catcher.dx then
        Catcher:MoveTo(Catcher.dx, Catcher.dy)
    end
    if WIN then
        Catcher:Stop()
    end
    CatcherBar:Update(text, Runner, RunnerGauge)
    CatcherBar.flame:PlayAnim(1, false, 9,4)
    if Catcher:isMoving() then
        if not sound_played then
            Run_sound:Play()
            sound_played = true
        end
        Catcher_dir(Runner, RunnerBox)
        if Catcher.anim > 8 then
            Catcher.anim = Catcher.anim - 8
        end 

        Catcher:PlayAnim(Catcher.anim, true, 5, 6)
    else
        -- Catcher_dir(Runner, RunnerBox)
        if sound_played then
            Run_sound:Stop()
            sound_played = false
        end
        Catcher:PlayAnim(Catcher.anim < 5 and Catcher.anim + 8 or Catcher.anim, true, 12, 3 )
        
    end
    if Catcher.hit then
        
        if Catcher.anim < 5 then
            Catcher.anim = Catcher.anim + 4
        end

        if Catcher.anim > 8 then
            Hit_sound:Play()
            
            Catcher.anim = Catcher.anim - 4
        end 

        if Catcher.frame == 4 then
            
            if CatcherBox.Update(Runner, RunnerBox, RunnerGauge, text) then
                return;
            end
        end
        
        Catcher:PlayAnim(Catcher.anim , false, 5, 6)
        Catcher.origin[1] = Catcher.anim == 8 and -0.7 or 0
        Catcher.origin[2] =( Catcher.anim == 7 or Catcher.anim == 8) and 0.1 or 0
        if Catcher.frame == 0 then
            Catcher.over = true
            Catcher.origin[1] = 0
            Catcher.origin[2] = 0

            Catcher.hit = false
            Catcher.anim = Catcher.anim - 4
        end
    end
end

local m_tmax = 20
local m_time = m_tmax
function Catcher.Act(Runner, RunnerBox)
    local status = "     "
    local left, right = 32, 32
    if Collide.CtC(Runner.pos[1]+10, Runner.pos[2]+10, 20, Catcher.pos[1]+25, Catcher.pos[2]+25, 100) then
        right = string.byte('3')
    end
    left = string.byte('1')
    status = string.format("  %c %c", left, right)
    if m_time < m_tmax then
        m_time = m_time + 1
    else
        
        local x = Runner.pos[1] + Runner.vel[1]*math.random(-20, 100)
        local y = Runner.pos[2] + Runner.vel[2]*math.random(-20, 100)

        -- x = x*ax
        -- y = y*ay
        if x < 0 then 
            x = 1
        elseif x > screen.w then
            x = screen.w
        end
        if y < 0 then 
            y = 1
        elseif y > screen.h then
            y = screen.h
        end
        
        m_time = 0
        Catcher.Button(Runner, RunnerBox, x*nax, y*nay, status)
    end
end

function Catcher.Button(Runner, RunnerBox, x, y, status)
    
    local pos, vel = Catcher.pos, Catcher.vel
    if status(4) == '3' then
        
        if not Catcher.hit then
            local canim = Catcher.anim
            Catcher_dir(Runner, RunnerBox)
            Catcher:Stop()
            Catcher.dx = nil
            Catcher.hit = true
            Catcher.frame = 0
            return
        end
    end
    if status(2) == '1' then
        
        Catcher.hit = false
        -- if not Catcher.over then
        --     return
        -- end
        local dy = LE.int(y*ay)
        local dx = LE.int(x*ax)
        Catcher.dx = dx
        Catcher.dy = dy

        if dx < pos[1] then
            Catcher.dx = dx
        elseif dx > pos[1] then
            Catcher.dx = dx - Catcher.size[1]
        end

        if dy < Catcher.pos[2] then
            Catcher.dy = dy
            Catcher.dx = dx - 32 
        elseif dy > Catcher.pos[2] then 
            Catcher.dy = dy - 64
            Catcher.dx = dx - 27  
        end
    end
    
end

return {Catcher, CatcherBox, CatcherBar}