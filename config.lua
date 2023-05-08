startscene = 1

SceneEnum = {
    "menu";
    "Info";
    "res";
    name = "SceneEnum"
}

defaultScene = "res.default";

-- fullscreen = true
fixedframed = true
PLAY = 'both'
CHAR_CHOICE = false
luatitle = "Catch O\'Run"
_en ={
    dt = 1/64;
    screen = {size = "640x320", name = "screen"};
    1;
    name = "_en";
}

_en.screen.w, _en.screen.h = LE.WxHtoints(_en.screen.size)