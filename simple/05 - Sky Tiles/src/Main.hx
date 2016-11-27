import haxegon.*;

class Main {
	function new() {
		//Load in data/graphics/sky.jpg, a split it into 20x20 tiles
		Gfx.loadtiles("sky", 20, 20);
		Gfx.linethickness = 25;
	}
	
	function update() {
		//Loop over the screen and draw each tile offset 
		//from what it should be as time passes
		for (j in 0 ... 24) {
			for (i in 0 ... 39) {
				Gfx.drawtile(i * 20, j * 20, "sky", Std.int(i + (j * (38 + Core.time))) % Gfx.numberoftiles("sky"));
			}
		}
		
		//Draw a hexagon in the middle of the screen
		Gfx.drawhexagon(Gfx.screenwidthmid, Gfx.screenheightmid, 180, Core.time, Col.WHITE);
	}
}