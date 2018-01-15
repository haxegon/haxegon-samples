import haxegon.*;

class Main {
	function new() {
		//Use the entire window, with a height of 480
		Gfx.resizescreen(0, 480);
		
		//Load in data/graphics/sky.jpg, a split it into 20x20 tiles
		Gfx.loadtiles("sky", 20, 20);
		Gfx.linethickness = 25;
	}
	
	function update() {
		//Loop over the screen and draw each tile offset 
		//from what it should be as time passes
		var width:Int = Convert.toint(Gfx.screenwidth / 20) + 1;
		var height:Int = Convert.toint(Gfx.screenheight / 20) + 1;
		for (j in 0 ... height) {
			for (i in 0 ... width) {
				Gfx.drawtile(i * 20, j * 20, "sky", Std.int(i + (j * (38 + Core.time))) % Gfx.numberoftiles("sky"));
			}
		}
		
		//Draw a hexagon in the middle of the screen
		Gfx.drawhexagon(Gfx.screenwidthmid, Gfx.screenheightmid, 180, Core.time, Col.WHITE);
	}
}