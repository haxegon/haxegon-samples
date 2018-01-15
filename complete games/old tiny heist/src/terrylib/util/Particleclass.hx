package terrylib.util;
	
import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;

class Particleclass {
	public function new() {
		clear();
	}
	
	public function clear():Void {
		//Set all values to a default, required for creating a new entity
		active = false;
		type = "null";
		tile = 0; life = 0; colour = 0; 
		state = 0; statedelay = 0;
		
		xp = 0; yp = 0; ax = 0; ay = 0; vx = 0; vy = 0;
	}
	
	//Fundamentals
	public var active:Bool;
	public var type:String;
	public var tile:Int;
	public var life:Int;
	public var colour:Int;
	public var state:Int;
	public var statedelay:Int;
	//Position and velocity
	public var xp:Float;
	public var yp:Float;
	public var ax:Float;
	public var ay:Float;
	public var vx:Float;
	public var vy:Float;
}
