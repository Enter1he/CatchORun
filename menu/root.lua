local menu = NewScene{name = "menu"}
local text = Text.newText("",13, "res/Catchofont.ttf")
local pic = Sprite.newSimple{pos = {0,0,0}, origin = {0,0}, color = {1,1,1,1}}
local screen = _en.screen
local L = Layer.new{}
Controls.AddCommand(B.esc, LE.Close)
local sw, sh = screen.asize()
local ax, ay = screen.w/sw, screen.h/sh

local x, y = screen.w/3, 28 + screen.h/3
local w,h = 100, 30 
local button = {
    [1] = {
        x = x;
        y = y;
        x1 = x+x;
        y1 = y + h;
    };
    [2] = {
        x = x;
        y = y + 43;
        x1 = x + x;
        y1 = y + h + 43;
    };
    [3] = {
        x = x;
        y = y + 125;
        x1 = x + x;
        y1 = y + h + 125;
    };
}
local SetCommands = function()
    CHAR_CHOICE = false
    Controls.AddCommand(B.esc, LE.Close)
    local res = LE.isSceneLoaded"res"
    if res then
        res.reset()
    end
    WIN = false
    LE.ChangeSceneStr"menu"
end

local forbutton = button[1]
function forbutton.Act()
    CHAR_CHOICE = true
    local info = LE.isSceneLoaded"Info"
    if info then
        info.reset()
    end
    
    Controls.AddCommand(B.esc, SetCommands)
    LE.ChangeSceneStr"Info"
end

forbutton = button[2]
function forbutton.Act()
    CHAR_CHOICE = false
    local info = LE.isSceneLoaded"Info"
    if info then
        info.reset()
    end
    Controls.AddCommand(B.esc, SetCommands)
    LE.ChangeSceneStr"Info"
end

forbutton = button[3]
function forbutton.Act()
    LE.Close()
end

function menu:Load()
    text:Load()
    text.pos = {x,y+20}
    pic:Load("menu/Screen.png")
    
    L:AddDrawable(pic)
    L:AddDrawable(text)
end

function menu:Update()
    
end

function menu:Resize(w, h)
    
    ax, ay = (screen.w/w), (screen.h/h)
end

function menu.Button(x,y, status)
    x,y = LE.int(x*ax), LE.int(y*ay)
    local chosen = 0
    for i = 1, #button do
        if x >= button[i].x and x <= button[i].x1 then
            if  y >= button[i].y and y <= button[i].y1 then
                chosen = i
                break
            end
        end
    end
    if button[chosen] then
        button[chosen].Act()
    end
end

function menu:Draw()
    
    L:Draw()
    if DEBUG then
        for i = 1, #button do
            local x,y, x1, y1 = button[i].x, button[i].y, button[i].x1, button[i].y1
            Graphics.DrawRect(false, x, y, x1, y1)
        end
    end
end

return menu