package gamecontrol.misc;

import haxegon.*;
import gamecontrol.*;
import terrylib.*;

class Roomconnection {
	public function new() {
		clear();
	}
	
	public function clear():Void {
		x = 0; y = 0; inuse = false; dir = Help.NODIRECTION;
	}
	
	public function set(_x:Int, _y:Int, _dir:Int):Void {
		inuse = true;
		x = _x;
		y = _y;
		dir = _dir;
	}
	
	public function use():Void {
		inuse = false;
	}
	
	public var x:Int;
	public var y:Int;
	public var inuse:Bool;
	public var dir:Int;
}