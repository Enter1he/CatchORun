local w, h = 40, 32
return {
    name = "Runner_Sprite";
	w = 40;
	h = 32;

	fmt = ".png";
	numf = 17;
	anim = {
		[1]= {0, 0, 33, h, 4}; --Down
		[2]= {0, h, 33, h, 4}; --Up
		[3]= {0, 2*h, w, h, 4}; --Right
		[4]= {0, 3*h, w, h, 4}; --Left
        [5]= {0, 4*h, h, h, 1}; -- rest
		[6]= {0, 5*h, 33, h, 4}; -- idle down
		[7]= {0, 6*h, 33, h, 4}; -- idle up
		[8]= {0, 7*h, 31, h, 4}; -- idle right
		[9]= {0, 8*h, 31, h, 4}; -- idle left
		name = "anim"
	}
}