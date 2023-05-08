
package.loaded.name = "loaded"
---------------------------------       ENGINE_PART        ----------------------------------

OOP = require"modules.OOP"

Util = require"modules.Util"

EmptyFunc = function() end

require"modules.Controls"



Fonts = Fonts or "C:/Windows/Fonts/" -- Windows font's folder


local screen = _en.screen

_mouse = {0,0}

local Destructor = {
    __gc = 
    function(self)
        self:Delete()
    end
}

local EmptyFunc = EmptyFunc
local DrawScene = Graphics.DrawScene
local setmetatable = setmetatable
local format = string.format
local rand = math.random
local seed = math.randomseed
local clock = os.clock

function NewScene(scene)
    scene = scene or {}
    
    scene.Load = EmptyFunc;
    scene.Draw = EmptyFunc;
    scene.Update = EmptyFunc;
    scene.Delete = EmptyFunc;
    scene.KeyPress = EmptyFunc;
    scene.KeyRelease = EmptyFunc;
    scene.Motion = EmptyFunc;
    scene.Button = EmptyFunc;
    scene.Resize = EmptyFunc;

    scene.name = scene.name or format("%x",rand(1,30000000))

    setmetatable(scene, Destructor)
    return scene
end

function LE.ChangeSceneStr(folder)
    local l = package.loaded[folder..".root"]
    local i = 0
    
    for j = 1, #(SceneEnum) do
        if folder == SceneEnum[j] then
            i = j
            break
        end
    end
    if i ~= 0 then
        LE.ChangeScene(i)
    end
end

function LE.isSceneLoaded(folder)
    return package.loaded[folder..".root"]
end

Layer = require"classes.Layer"
Text = require"classes.Text"
Sprite = require"classes.Sprite"
Mob = require"classes.Mob"
Vector = require"classes.Vector"
Color = require"classes.Color"

Color.white = Color{1,1,1,1}
Color.black = Color{0,0,0,1}
Color.red = Color{1,0,0,1}
Color.green = Color{0,1,0,1}
Color.blue = Color{0,0,1,1}
Color.yellow = Color{1,1,0,1}
Color.purple = Color{1,0,1,1}
Color.none = Color{0,0,0,0}

_default = NewScene()

