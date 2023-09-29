package visuals;

import haxegon.Gfx;
import haxegon.Random;

class Starfield{
	//Create some arrays for the starfield.
	public static var x:Array<Float> = [];
	public static var y:Array<Float> = [];
	public static var speed:Array<Float> = [];
	public static var twinkle:Int;
	
	public static function init() {
		//Initalise the arrays, and put some default values in them.
		x = []; y = []; speed = [];
		
		for (i in 0 ... 50) {
			x.push(Random.int(0, Gfx.screenwidth));  //Random x position on screen
			y.push(Random.int(0, Gfx.screenheight)); //Random y position on screen
			speed.push(Random.float(0.25, 2.5));    //Random speed between 8/16 pixels per frame
		}
	}
	
	public static function updatetwinkle(i:Int, j:Int){
		//Draw.filltile(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight), 0x000022);
		twinkle = (flash.Lib.getTimer() + ((j + i) * 100)) % 1000;
		if (twinkle >= 800) {
			twinkle = twinkle - 800;
			if (twinkle >= 100) {
				twinkle = 2;
			}else {
				twinkle = 1;	
			}
		}else {
			twinkle = 0;	
		}
	}
	
	public static function draw() {
	  Gfx.clearscreen(0x000022);
		
		for (i in 0 ... 50) {
			//Draw slow stars darker than bright stars to give a parallex effect.
			twinkle = (flash.Lib.getTimer() + (Std.int(y[i]) * 100)) % 1000;
			if (twinkle >= 800) {
				twinkle = twinkle - 800;
				if (twinkle >= 100) {
					twinkle = 2;
				}else {
					twinkle = 1;	
				}
			}else {
				twinkle = 0;	
			}
			Draw.precoloured_drawtile(Gfx.screenwidth - x[i], y[i], 23 + twinkle);
			
			//Move the star position by the speed value
			x[i] -= speed[i];
			
			if (x[i] < -30) {
				//If the star is off screen, move it to the right hand side.
				x[i] += Gfx.screenwidth + 40;
				y[i] = Random.int(0, Gfx.screenheight);
				speed[i] = Random.float(0.25, 2.5);
			}
		}	
	}
}