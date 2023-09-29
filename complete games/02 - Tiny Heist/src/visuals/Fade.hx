package visuals;

import gamecontrol.Game;
import entities.Obj;
import world.World;
import haxegon.Gfx;
import haxegon.Col;
import util.Lerp;

class Fade{
	//Fade Transition (room changes, game state changes etc)
	public inline static var FADED_IN:Int = 0;
	public inline static var FADED_OUT:Int = 1;
	public inline static var FADE_OUT:Int = 2;
	public inline static var FADING_OUT:Int = 3;
	public inline static var FADE_IN:Int = 4;
	public inline static var FADING_IN:Int = 5;
	
	public static var fademode:Int;
	public static var fadeamount:Int;
	public static var fadeaction:String;
	
  public static function draw():Void {
		if (fademode == FADED_OUT) {
			Gfx.clearscreen(Col.BLACK);
		}else if (fademode == FADING_OUT) {
			Gfx.fillbox(0, 0, Std.int((fadeamount * (Gfx.screenwidth / 20)) / 10), Gfx.screenheight, Col.BLACK);
			Gfx.fillbox(Std.int(Gfx.screenwidth - ((fadeamount * (Gfx.screenwidth / 20)) / 10)), 0, Gfx.screenwidthmid, Gfx.screenheight, Col.BLACK);
			Gfx.fillbox(0, 0, Gfx.screenwidth, Std.int((fadeamount * (Gfx.screenheight / 20)) / 10), Col.BLACK);
			Gfx.fillbox(0, Std.int(Gfx.screenheight - ((fadeamount * (Gfx.screenheight / 20)) / 10)), Gfx.screenwidth,  Gfx.screenheightmid, Col.BLACK);
		}else if (fademode == FADING_IN) {
			Gfx.fillbox(0, 0, Std.int((fadeamount * (Gfx.screenwidth / 20)) / 10), Gfx.screenheight, Col.BLACK);
			Gfx.fillbox(Std.int(Gfx.screenwidth - ((fadeamount * (Gfx.screenwidth / 20)) / 10)), 0, Gfx.screenwidthmid, Gfx.screenheight, Col.BLACK);
			Gfx.fillbox(0, 0, Gfx.screenwidth, Std.int((fadeamount * (Gfx.screenheight / 20)) / 10), Col.BLACK);
			Gfx.fillbox(0, Std.int(Gfx.screenheight - ((fadeamount * (Gfx.screenheight / 20)) / 10)), Gfx.screenwidth, Gfx.screenheightmid, Col.BLACK);
		}
	}
	
	public static function draw_topoint_withoutmap(px:Int, py:Int, fadelevel:Int):Void {
		for (j in 0 ... Draw.screentileheight + 1) {
			for (i in 0 ... Draw.screentilewidth + 1) {
				if (Math.abs(px - i) / 2 >= fadelevel || Math.abs(py - j) >= fadelevel) {
					Draw.filltile((i * Draw.tilewidth) - (Camera.x * Draw.tilewidth), (j * Draw.tileheight) - (Camera.y * Draw.tileheight), Col.BLACK);
				}
			}
		}
	}
	
	public static function draw_topoint(px:Int, py:Int, fadelevel:Int):Void {
		if (Camera.disable_all) {
			Camera.x = 0; Camera.y = 0;
		}else{
			if (Camera.disable_horizontal) Camera.x = 0; if (Camera.disable_vertical) Camera.y = 0;
		}
		
		if (Obj.getplayer() > -1) {
			Camera.x = Obj.entities[Obj.getplayer()].xp - 16;
			if (Camera.x < 0) Camera.x = 0;
			if (Camera.x + 32 > World.mapwidth) Camera.x = World.mapwidth - 32;
			
			Camera.y = Obj.entities[Obj.getplayer()].yp - 10;
			if (Camera.y < 0) Camera.y = 0;
			if (Camera.y + 19 > World.mapheight) Camera.y = World.mapheight - 19;
		}
		
		for (j in Camera.y ... Draw.screentileheight + 1 + Camera.y) {
			for (i in Camera.x ... Draw.screentilewidth + 1 + Camera.x) {
				if (Math.abs(px - i) / 2 >= fadelevel || Math.abs(py - j) >= fadelevel) {
					Draw.filltile((i * Draw.tilewidth) - (Camera.x * Draw.tilewidth), (j * Draw.tileheight) - (Camera.y * Draw.tileheight), Col.BLACK);
				}
			}
		}
	}
	
	//Fade functions
	public static function update():Void {
		if (fademode > FADED_OUT) {
			if (fademode == FADE_OUT) {
				//prepare fade out
				fadeamount = 0;
				fademode = FADING_OUT;
				Lerp.start("fadeout", 20);
			}else if (fademode == FADING_OUT) {
				fadeamount = Lerp.to(0, 100, "fadeout", "sine_out");
				if (Lerp.justfinished("fadeout")) {
					fademode = FADED_OUT; //faded
				}
			}else if (fademode == FADE_IN) {
				//prepare fade in
				fademode = FADING_IN;
				Lerp.start("fadein", 20);
			}else if (fademode == FADING_IN) {
				fadeamount = Lerp.to(100, 0, "fadein", "sine_in");
				if (Lerp.justfinished("fadein")) {
					fademode = FADED_IN; //normal
				}
			}
		}
	}
	
	public static function fadeout(t:String = "nothing"):Void {
		fademode = FADE_OUT;
		fadeaction = t;
	}
	
	public static function fadein():Void {
		fademode = FADE_IN;
	}
	
	public static function fadelogic():Void {
		if (fademode == FADED_OUT) {
			if (fadeaction == "title") {
				Game.changestate(Game.TITLEMODE);
				fademode = FADE_IN; fadeaction = "nothing";
			}else{
				fademode = FADE_IN; fadeaction = "nothing";
			}
		}
	}
}