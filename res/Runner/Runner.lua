local w, h = 40, 32
return {
    name = "Runner_Sprite";
	w = 40;
	h = 32;

	fmt = ".png";
	numf = 17;
	anim = {
		{0, 0, h, h, 4}; --Down
		{0, h, h, h, 4}; --Up
		{0, 2*h, w, h, 4}; --Right
		{0, 3*h, w, h, 4}; --Left
        {0, 4*h, h, h, 1};
		name = "anim"
	}
}