return {
    name = "Catcher_Sprite";
	w = 56;
	h = 64;

	fmt = ".png";
	numf = 28;
	anim = {
		[1] = {0, 0, 56, 64, 6}; --Down
		[2] = {0, 66, 56, 64, 6}; --Up
		[3] = {0, 134, 56, 64, 6}; --Right
		[4] = {0, 200, 56, 64, 6}; --Left
		[5] = {0, 264, 54, 96, 5};
		[6] = {0, 360, 54, 70, 5};
		[7] = {0, 428, 96, 68, 5};
		[8] = {0, 496, 96, 66, 5};
		
		name = "anim"
	}
}