package terrylib.util;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;

class Blockclass {
	public function new() {
		clear();
	}
	
	public function clear():Void {
		active = false;
		type = 0; trigger = "null";
		
		xp = 0; yp = 0; wp = 0; hp = 0;
		rect = new Rectangle();
		rect.x = xp; rect.y = yp; rect.width = wp; rect.height = hp;
		destx = 0; desty = 0;
		doorname = "";
	}
	
	public function rectset(xi:Int, yi:Int, wi:Int, hi:Int):Void {
		rect.x = xi; rect.y = yi; rect.width = wi; rect.height = hi;
	}
	
	//Fundamentals
	public var active:Bool;
	public var rect:Rectangle;
	public var type:Int;
	public var trigger:String;
	public var destx:Int;
	public var desty:Int;
	
	public var xp:Int;
	public var yp:Int;
	public var wp:Int;
	public var hp:Int;
	
	public var doorname:String;
}
