package visuals;

import openfl.geom.Rectangle;
import starling.core.Starling;
import haxegon.Random;

class ScreenEffects{
	public static var screenshake:Int;
		
	static var screenshakestart:Bool = false;
	static var realviewportx:Float;
	static var realviewporty:Float;
	
	public static function updatescreenshake(){
		if (screenshake > 0) {
			var viewPortRectangle:Rectangle = Starling.current.viewPort;
			if(!screenshakestart){
				realviewportx = viewPortRectangle.x;
				realviewporty = viewPortRectangle.y;
				screenshakestart = true;
			}
			
			viewPortRectangle.x = realviewportx + Random.int( -4, 4);
			viewPortRectangle.y = realviewporty + Random.int( -4, 4);
			Starling.current.viewPort = viewPortRectangle;
			
			screenshake--;
			
			if (screenshake <= 0) {
				viewPortRectangle.x = realviewportx;
				viewPortRectangle.y = realviewporty;
				Starling.current.viewPort = viewPortRectangle;
				screenshakestart = false;
			}
		}
	}
}