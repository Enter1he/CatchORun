local root = NewScene{blend = 0}
local screen = _en.screen
local w, h = screen.asize()
local sw, sh = screen.w, screen.h
local ax, ay = (sw/w), (sh/h)


local layer = Layer.new(root);

local WIN = false
local debug = false

local text = Text.newText("",23, "res/Catchofont.ttf")
text.poses = {[1] = {120, 120, 0}, [2] = {150, 150, 0}}
text.pos = text.poses[1]

local mult, mult1 = 1.5, 1.2
local Catchrite = Catchrite;  
local Catcher = Mob.newMob({anim = 3}, 0, 0, 500);
local CatcherBar = Sprite.newSheet{origin = {0,0}, value = 90*3*60,  frame = 0}
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
    -- [12] = {112, 38, 0};
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
Catcher.text = [[Runner Catched
                    
  press r to restart
                                  
                      or
                        
          press esc to leave]]
CatcherBar.flame.pos = CatcherBar.flame.poses[1]

local Runerite = Runerite;
local Runner = Mob.newMob({anim = 4}, 0, 0, 400);
local RunnerGauge = Sprite.newSimple{origin = {0,0}, value = 0}
Runner.text = 
[[Catcher was Outrun
                    
      press r to restart
                           
                       or
                                    
           press esc to leave]]

-- text.value = Runner.text


Controls.AddCommand(B.r, 
    function()
        local w, h = Catcher:GetSize()
        Catcher.frame = 1
        Catcher.anim = 3
        Catcher.pos[1] = screen.w*0.33
        Catcher.pos[2] = screen.h*0.5 - h*0.5
        w,h = Runner:GetSize()
        Runner.frame = 1
        Runner.anim = 4
        Runner.pos[1] = screen.w*0.66 - w
        Runner.pos[2] = Catcher.pos[2] + h*mult1
        RunnerGauge.color = Color.white
        text.value = ""
        CatcherBar.color = Color.white
        CatcherBar.flame.pos = CatcherBar.flame.poses[1]
        CatcherBar.flame.color = Color.white
        CatcherBar.flame.curp = 0
        CatcherBar.frame = 0
        CatcherBar.anim = 1
        CatcherBar.value = 90*3*60
        RunnerGauge.value = 0
        WIN = false
    end
)


local Collide = require"Collision"

local CatcherBox = {
    pos = Catcher.pos;
}
if debug then
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

local RunnerBox = {
    pos = Runner.pos;
    
}
local function Catcher_dir()
    local c, r = Catcher, Runner
    local rx = r.pos[1]
    local rr = rx + 40
    local rn = rx + 20
    local cb, rb = CatcherBox, RunnerBox
    local cl, cn, cr = c.pos[1], c.pos[1] + 20, c.pos[1] + 80
    if rr < cn then
        c.anim = 4
    end
    
    if rr > cr then
        c.anim = 3
    end   
    if rn > cn and rx <= cr then
        if c.pos[2] + 50 > r.pos[2]  then
            c.anim = 2
        else
            c.anim = 1
        end
        
    end
end
if debug then
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
do 
    local w = {48, 108, 188}
    local ys = {0, 2, 5}
    function RunnerGauge:Draw()
        if self.color == Color.none then
            return nil
        end
        local x, y = self.pos[1]+25, self.pos[2] + 70
        local h = y + 18
        
        Graphics.color = Color.yellow
        Graphics.DrawRect(true, x, y, self.value+x, h)
        
        Graphics.color = Color.black
        Graphics.DrawRect(true, x+48, y, x+108, y+3)
        Graphics.DrawRect(true, x+108, y, x+138, y+5)
        Graphics.DrawRect(true, x+138, y, x+189, y+5)
        Graphics.DrawSprite(self)
        Graphics.color = Color.white
    end
end
local ptime = Lalloc(1)

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
local abs = math.abs


function CatcherBox.Update()
    local anim, ranim = Catcher.anim, Runner.anim
    if anim < 5 then
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
        RunnerGauge.color = Color.none
    end
end

function root.Load()
    --Loading textures for text
    text:Load()
    
    --Loading textures for Catcher and setting it's position
    if not Catchrite._sprite then 
        Catchrite:Load("res/Catcher/Catcher")
    end
    Catchrite:CopySprite(Catcher)
    local w, h = Catcher:GetSize()
    Catcher.pos[1] = screen.w*0.33
    Catcher.pos[2] = screen.h*0.5 - h*0.5
    CatcherBar:Load("res/Catcher/CatcherBar")
    CatcherBar.pos = {0 , 0}
    CatcherBar.flame:Load("res/Catcher/CatcherFlame")
    
    

    --Loading textures for Runner and setting it's position
    if not Runerite._sprite then
        Runerite:Load("res/Runner/Runner")
    end
    Runerite:CopySprite(Runner)
    w,h = Runner:GetSize()
    Runner.pos[1] = screen.w*0.66 - w
    Runner.pos[2] = Catcher.pos[2] + h*mult1
    RunnerGauge:Load("res/Runner/RunnerBar.png")
    RunnerGauge.pos = {screen.w-240, screen.h - 120}
    
    --Adding every object to layer
    layer:AddDrawable(Runner)
    layer:AddDrawable(Catcher)
    layer:AddDrawable(text)
    layer:AddDrawable(CatcherBar)
    layer:AddDrawable(CatcherBar.flame)
    layer:AddDrawable(RunnerGauge)

    --Setting the sizes of hitboxes
    CatcherBox.off = {
        [5] = {12, 75, 60, 40};
        [6] = {12, 10, 60, 40};
        [7] = {58, 52, 80, 30};
        [8] = {-50, 50, 80, 30}
    }
    RunnerBox.off ={
        {9, 4, Runerite.src.anim[1][3], Runerite.src.anim[1][4]},
        {8, 5, Runerite.src.anim[2][3], Runerite.src.anim[2][4]},
        {5, 5, Runerite.src.anim[3][3], Runerite.src.anim[3][4]},
        {10,5, Runerite.src.anim[4][3], Runerite.src.anim[4][4]}
    }
end
local cntr = 0
local tim = 60
function CatcherBar:Update()
    local flame = self.flame
    if CatcherBar.value%90 == 0 then
        cntr = 0
        if self.frame < 2 then
            self.frame = self.frame + 1

            if self.anim == 9 and self.frame == 2 then
                text.pos = text.poses[1]
                text.value = Runner.text
                CatcherBar.color = Color.none
                CatcherBar.flame.color = Color.none
                RunnerGauge.color = Color.none
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
    self.value = self.value - 1
    if tim == 0 then
        tim = 60
    end
    tim = tim - 1
end

function root:Update()
    Catcher:Stop()
    if Catcher.dx then
        Catcher:MoveTo(Catcher.dx, Catcher.dy)
    end
    if Runner:isMoving() then
        Runner.speed =200 + 400*(RunnerGauge.value/188)
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
    if WIN then 
        return nil
    end
    CatcherBar:Update()
    CatcherBar.flame:PlayAnim(1, false, 9,4)
    if Catcher:isMoving() then
        Catcher_dir()
        Catcher:PlayAnim(Catcher.anim, true, 5, 6)
    elseif not Catcher.hit then
        Catcher_dir()
        Catcher.frame = 0
        Catcher.origin[1] = 0
    end
    if Catcher.hit then
        if Catcher.frame > 3 then
            CatcherBox.Update()
        end
        Catcher:PlayAnim(Catcher.anim < 5 and Catcher.anim + 4 or Catcher.anim , false, 2, 6)
        Catcher.origin[1] = Catcher.anim > 7 and -0.5 or 0
        if Catcher.frame == 0 then
            Catcher.over = true
            Catcher.origin[1] = 0
            Catcher.hit = false
            Catcher.anim = Catcher.anim - 4
        end
    end
end

function root:KeyPress(key, down)
    Runner:Stop()
    if WIN then
        return nil
    end
    local ranim = Runner.anim
    local rw, rh = RunnerBox.off[ranim][3] + 10, RunnerBox.off[ranim][4] + 10
    if key[B.s] and Runner.pos[2] + rh < sh then
        Runner.vel[2] = 1
    end
    if key[B.w] and Runner.pos[2] > 0 then
        Runner.vel[2] = -1
    end
    if key[B.d] and Runner.pos[1] + rw< sw then
        Runner.vel[1] = 1
    end
    if key[B.a] and Runner.pos[1] > 0 then
        Runner.vel[1] = -1
    end
    
    if Runner:isMoving() then
        Dir_Controls(Runner)
        Runner:Vel_Move()
        Runner:PlayAnim(Runner.anim, true, 4, 4)
    else
        Runner.frame = 0
    end
end


function root:Resize(w, h)
    print(w, h, _en.screen.asize())
    ax, ay = (sw/w), (sh/h)
end

function root.Button(x, y, status)
    
    if WIN then
        return nil
    end
    local pos, vel = Catcher.pos, Catcher.vel
    if status(2) == '1' then
        local dy = int(y*ay)
        local dx = int(x*ax)
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
    if status(4) == '3' then
        local ranim = Runner.anim
        local dx, dy = Runner.pos[1] + RunnerBox.off[ranim][3]//2 , Runner.pos[2] + RunnerBox.off[ranim][4]//2 
        if not Catcher.hit then
            local canim = Catcher.anim
            local x, y = pos[1] - dx, pos[2] - dy + Catchrite.src.anim[canim][4]//((Runner.pos[2] > pos[2]) and 0.8 or 2)
            Catcher:Stop()
            Catcher.dx = nil
            Catcher.hit = true
            local c = Catcher
            
        end
    end
end


return root