package visuals;

import haxegon.Core;
import haxegon.Gfx;

class Backdrop{
	public static var scrolloffset:Int;
	
	public static function standardbacking() {
		//Draw a quick starfield
		Starfield.draw();
		
		//Draw a little background
		draw(3, Gfx.screenheightmid - 60, 50, 0x05240f, 20, 0);
		draw(5, Gfx.screenheightmid - 30, 50, 0x054119, 40, 0);
		draw(8, Gfx.screenheightmid + 30, 30, 0x0d7e31, 60, 0);
		
		//Helicopter
		Helicopter.draw(40, 40 + Std.int((Math.sin(flash.Lib.getTimer() / 800) * 20)), 3);
	}
	
	public static function draw(divisions:Int, position:Int, height:Int, col:Int, speed:Int, dir:Int) {
		var peaks:Int = Std.int((Gfx.screenwidth / divisions));
		scrolloffset = - Std.int(((Core.time * speed) % peaks));
		
		if(dir < 0){
			for (j in 0 ... divisions + 1) {
				Gfx.filltri((j * peaks) - scrolloffset - peaks, position + height, (j + 1) * peaks - scrolloffset, position, (j + 1) * peaks - scrolloffset, position + height, col); 
			}
		}else if (dir > 0) {
			for (j in 0 ... divisions + 1) {
				Gfx.filltri((j * peaks) - scrolloffset - peaks, position, (j + 1) * peaks - scrolloffset, position + height, j * peaks - scrolloffset, position + height, col); 
			}
		}else {
			for (j in 0 ... divisions + 1) {
				Gfx.filltri((j * peaks) - scrolloffset - peaks, position + height, (j + 0.5) * peaks - scrolloffset - peaks, position, (j + 0.5) * peaks - scrolloffset - peaks, position + height, col); 
				Gfx.filltri(((j + 0.5) * peaks) - scrolloffset - peaks, position, (j + 1) * peaks - scrolloffset - peaks, position + height, (j + 0.5) * peaks - scrolloffset - peaks, position + height, col); 
			}
		}	
		
		Gfx.fillbox(0, position + height, Gfx.screenwidth, Gfx.screenheight - (position + height), col);
	}
}