local Graphics = Graphics

local Sprite = {
    size = {1,1};
    origin = {0.5,0.5};
    anim = 1;
    color = {1,1,1,1};
    frame = 0;
    rate = 0;
    angle = 0;
    visible = true;
}


function Sprite:GetSize()
    if not self._drawable or not self.src then
        error("No sprite to look into")
    end
    local anim = self.src.anim[self.anim]
    return anim[3], anim[4]
end

function Sprite:PlayAnim( anim, loop, rate, len, start)
    start = start or 1
    if anim > #self.src.anim or anim < 1 then 
        return error("PlayAnim: No animation "..tostring(anim))
    end
    if self.anim ~= anim then
        self.frame = 1
        self.anim = anim
    end
    
    self.rate = self.rate + 1
    
    if self.rate > rate then
        local af = self.frame
        
        self.frame = self.frame + 1

        if self.frame > len then
            if loop then
                self.frame = start
            else
                self.frame = 0
            end
        end
        
        
        self.rate = 1
        
        return;
    end
    
end

function Sprite.newSimple(new)
    new = new or {}
    local _ENV = new
    pos = pos or {0,0,0}
    origin = origin or {0.5,0.5}
    color = color or {1,1,1,1}
    size = size or {1,1}
    angle = angle or 0
    visible = visible or true

    Load = Load or Graphics.LoadSprite
    Draw = Draw or Graphics.DrawSprite
    CopySprite = Sprite.CopySprite
    isSprite = Sprite.isSprite

    return new
end

function Sprite.newSheet(new)
    new = new or {}
    local _ENV = new
    pos = pos or {0,0,0}
    origin = origin or {0.5,0.5}
    color = color or {1,1,1,1}
    size = size or {1,1}
    angle = angle or 0
    anim = anim or 1
    frame = frame or 1
    rate = rate or 1
    visible = visible or true
    
    Load = Load or Graphics.LoadSpriteSheet
    Draw = Draw or Graphics.DrawSpriteSheet
    PlayAnim = Sprite.PlayAnim
    CopySprite = Sprite.CopySprite
    GetSize = Sprite.GetSize
    isSprite = Sprite.isSprite
    
    return new
end

function Sprite:CopySprite(copy)
    copy._drawable = self._drawable
    copy.size = self.size
    copy.origin = self.origin
    copy.color = self.color
    copy.src = self.src
    copy.Draw = self.Draw
    copy.Load = self.Load
    copy.GetSize = self.GetSize
    copy.visible = self.visible
end

function Sprite:isSprite(spr)
    local t = type(spr)
    if t == 'userdata' then
        return self._drawable == spr;
    elseif t == 'table' then
        return self._drawable == spr._drawable;
    end

    return nil
end



return OOP.class('Sprite', Sprite)
