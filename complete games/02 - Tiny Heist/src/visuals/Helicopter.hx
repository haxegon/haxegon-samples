package visuals;

import haxegon.Gfx;

class Helicopter{
	public static function draw(x:Int, y:Int, scale:Float) {
		var heliframe:Int = (((flash.Lib.getTimer() % 200) > 100)?0:3);
		
		Gfx.scale(scale, scale);
		Gfx.resetcolor();
		Gfx.drawtile(x, y, "terminal", 138 + heliframe);
		Gfx.drawtile(x + (Draw.tilewidth * scale), y, "terminal", 139 + heliframe);
		Gfx.drawtile(x + (Draw.tilewidth * scale) * 2, y, "terminal", 140 + heliframe);
		Gfx.drawtile(x, y + (Draw.tileheight * scale), "terminal", 154 + heliframe);
		Gfx.drawtile(x + (Draw.tilewidth * scale), y + (Draw.tileheight * scale), "terminal", 155 + heliframe);
		Gfx.drawtile(x + (Draw.tilewidth * scale) * 2, y + (Draw.tileheight * scale), "terminal", 156 + heliframe);
		
		Gfx.drawtile(x + (Draw.tilewidth * scale), y + (Draw.tileheight * scale) * 2, "terminal", 26);
		
		Gfx.imagecolor = 0xffea03;	
		Gfx.drawtile(x + (Draw.tilewidth * scale) * 1.5,  y + (Draw.tileheight * scale) * 3, "terminal", 27);
		Gfx.resetcolor();
		
		Gfx.scale(1, 1);
	}
}