local w,h = 240, 100

local CatcherBar = {
    name = "CatcherBar";
	w = w;
	h = h;

	fmt = ".png";
	numf = 1;
	anim = {
		[1] = { 0, 0, w, h, 3};
        [2] = { 0, h, w, h, 3};
        [3] = { 0, h*2, w, h, 3};
        [4] = { 0, h*3, w, h, 3};
        [5] = { 0, h*4, w, h, 3};
		[6] = { 0, h*5, w, h, 3};
        [7] = { 0, h*6, w, h, 3};
        [8] = { 0, h*7, w, h, 3};
        [9] = { 0, h*8, w, h, 3};
		name = "CatcherBar_anim";
	}
}

return CatcherBar