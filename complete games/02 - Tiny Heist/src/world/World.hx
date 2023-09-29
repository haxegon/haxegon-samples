package world;

import haxegon.Geom;
import visuals.Draw;
import world.Localworld;
import util.Glow;

class World {
	public static function init():Void {
		//Start here!
		mapwidth = 0; mapheight = 0;
		
		//We create a blank map 
		for (j in 0 ... 100) {
			for (i in 0 ... 100) {
				contents.push(0);
				lighting.push(0);
				highlight.push(0);
				laser.push(0);
				fog.push(0);
				fire.push(0);
			}
		}
		
		for (i in 0 ... 2000) {
			collisionarray.push(0);
		}
		
		Localworld.initcollisionarray();
	}
	
	public static function sc(t:Int):Void { //Set collision
		collisionarray[t] = 1;
	}	
	
	public static function changemapsize(x:Int, y:Int):Void {
		mapwidth = x; mapheight = y;
	}
	
	public static function collide(x:Int, y:Int):Bool {
		//which tiles are collidable?
		if (x < 0 || y < 0 || x >= mapwidth || y >= mapheight) return false;
		if (collisionarray[contents[x + (y * mapwidth)]] == 1) return true;
		return false;
	}
	
	public static function anydoor(t:Int):Bool {
		if (t == Localworld.LOCKEDDOOR) return true;
		if (t == Localworld.DOOR) return true;
		if (t == Localworld.OPENDOOR) return true;
		if (t == Localworld.CONSIDERLOCKEDDOOR) return true;
		if (t == Localworld.CONSIDERLOCKEDEXIT_A) return true;
		if (t == Localworld.CONSIDERLOCKEDEXIT_B) return true;
	  return false;	
	}
	
	public static function placetile(xp:Int, yp:Int, t:Int):Void {
		if (Geom.inbox(xp, yp, 0, 0, mapwidth, mapheight)) {
			contents[xp + (yp * mapwidth)] = t;
		}
	}
	
	public static function at(xp:Int, yp:Int):Int {
		xp = xp * Draw.tilewidth;
		xp = Std.int(xp / Draw.tilewidth);
		
		yp = yp * Draw.tileheight;
		yp = Std.int(yp / Draw.tileheight);
		
		if (xp >= 0 && yp >= 0 && xp < mapwidth && yp < mapheight) {
			return contents[xp + (yp * mapwidth)];
		}
		return 0;
	}
	
	public static function clearmap():Void {
		for (j in 0 ... mapheight) {
			for (i in 0 ... mapwidth) {
				contents[i + (j * mapwidth)] = 1;
			}
		}
	}
	
	public static var collisionarray:Array<Int> = [];
	public static var contents:Array<Int> = [];
	public static var highlight:Array<Int> = [];
	public static var lighting:Array<Int> = [];
	public static var laser:Array<Int> = [];
	public static var fog:Array<Int> = [];
	public static var fire:Array<Int> = [];
	
	public static var background:Int;
	public static var mapwidth:Int;
	public static var mapheight:Int;
}