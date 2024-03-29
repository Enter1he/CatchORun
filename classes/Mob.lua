local dt = 1/64

local Sprite = require"classes.Sprite"

local Mob = {
    pos = {0,0,0};
    vel = {0,0};
    over = true;
    to = 1;
    speed = 1;
    sight = 1;
}

function Mob.newMob(new, x, y, speed)
    local x, y, speed = x or 0, y or 0, speed or 10
    new = new or {}
    local _ENV = new
    pos = pos or {0, 0, 0}; pos[1] = x; pos[2] = y
    vel = vel or {0,0,0}
    over = true
    to = 1
    new.speed = new.speed or speed
    Stop = Mob.Stop
    isMoving = Mob.isMoving
    Vel_Move = Mob.Vel_Move
    MoveTo = Mob.MoveTo
    RMoveTo = Mob.RMoveTo
    RVel_Move = Mob.RVel_Move
    GetTo = Mob.GetTo
    return Sprite.newSheet(new)
end



function Mob:Stop()
    self.vel[1] = 0; self.vel[2] = 0;
end

function Mob:Liberate()
    self.vel = {0,0}
end

function Mob:isMoving()
    return self.vel[1] ~= 0 or self.vel[2] ~= 0
end

function Mob:Tile_Move()
    local s = self.speed
end
local hlfv = 0.85090352453412 -- sin 45
local int = int
function Mob:Vel_Move()
    local sdt = self.speed * dt
    local pos, vel = self.pos, self.vel
    if vel[1] ~= 0 and vel[2] ~= 0 then
        vel[1] = hlfv*vel[1]; vel[2] = hlfv*vel[2]
    end
    pos[1] = pos[1] + LE.int(vel[1] * sdt)
    pos[2] = pos[2] + LE.int(vel[2] * sdt)
end

local atan = math.atan
local sin, cos = math.sin, math.cos
local offset = 10
function Mob:MoveTo( x, y)
    if self.over == false then
        local pos, vel = self.pos, self.vel
        local ox, oy = pos[1], pos[2]

        if oy > y then vel[2] = -1; 
        elseif oy < y then vel[2] = 1;  end

        if ox > x then vel[1] = -1; 
        elseif ox < x then vel[1] = 1; end
        self:Vel_Move()

        ox, oy = pos[1], pos[2]
        local c1 = (ox >= x - offset and ox <= x + offset)
        local c2 = (oy >= y - offset and oy <= y + offset)
        pos[1] = c1 and x or ox
        pos[2] = c2 and y or oy
        self.over = c1 and c2
        return x
    end
    if self.over == true then
        self.over = false
        return self.over
    end
end

function Mob:RMoveTo(from, to)
    if self.over == false then
        local pos, vel = self.pos, self.vel
        local ox, oy = pos[1], pos[2]
        if not self.rx then
            self.rx = math.random(from[1], from[2])
            self.ry = math.random(to[1], to[2])
        end
        local x, y = self.rx, self.ry
        vel[1], vel[2] = 0, 0

        if oy > y then vel[2] = -1;
        elseif oy < y then vel[2] = 1;  end

        if ox > x then vel[1] = -1;
        elseif ox < x then vel[1] = 1; end
        self:Vel_Move()

        ox, oy = pos[1], pos[2]
        local c1 = (ox >= x - offset and ox <= x + offset)
        local c2 = (oy >= y - offset and oy <= y + offset)
        pos[1] = c1 and x or ox
        pos[2] = c2 and y or oy
        self.over = c1 and c2
        if self.over then
            self.rx = false
            self.ry = false
        end
        return true
    else
        self.rx = math.random(from[1], from[2])
        self.ry = math.random(to[1], to[2])
        self.over = false
        return self.over
    end
end

local ptime = LE.Lalloc(1)
local sqrt = math.sqrt
function Mob:GetTo(x,y, time)
    time = time or 1
    local atime = self[ptime] or time
    local pos, vel = self.pos, self.vel
    if self.over == true then
        local ox, oy = pos[1], pos[2]
        local dx, dy = x - ox, y - oy
        -- print("getting pos",dx,dy)
        if dx ~= 0 or dy ~= 0 then
            self.over = false
            self.speed = 1
            vel[1], vel[2] = dx/atime, dy/atime
            -- print("getting ready",dx, dy,atime, vel[1], vel[2])
            self[ptime] = atime
        end
    end
    if self.over == false then
        pos[1] = pos[1] + vel[1]
        pos[2] = pos[2] + vel[2]
        self[ptime] = self[ptime] - 1
        -- print("on my way",self[ptime], self.pos[1], pos[2], vel[1], vel[2])
        if self[ptime] == 0 then
            self.over = true
            self.dx, self.dy = nil, nil
            self[ptime] = nil
            vel[1], vel[2] = 0, 0
            -- print("got it",pos[1], vel[1])
        end
    end
end

function Mob:Patrol(s_pos, f_pos)
    if self.to == 1 then
        self.to = self:MoveTo( s_pos[1], s_pos[2]) and 1 or 2
       return;
    end
    if self.to == 2 then
        self.to = self:MoveTo(f_pos[1], f_pos[2]) and 2 or 1
        return;
    end
end


function Mob:Path(args)
    if self.to <= #args then
        local i = self.to
        self.to = self:MoveTo(args[i][1], args[i][2]) and i or (i + 1)
    end
end






return OOP.class('Mob', Mob)