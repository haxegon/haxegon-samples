package gamecontrol.misc;

import openfl.geom.Point;
import haxegon.*;
import terrylib.*;

class Placementclass {
	public function new(_name:String) {
		name = _name;
		for (i in 0 ... 50) {
			list.push(new Point());
			contents.push("");
			odds.push(0);
		}
		length = 0;
	}
	
	public function add(tx:Int, ty:Int, _contents:String, _odds:Int):Void {
		list[length].setTo(tx, ty);
		odds[length] = _odds;
		contents[length] = _contents;
		length++;
	}
	
	public function getodds(t:Int):Int {
		return Std.int(odds[t]);
	}
	
	public function x(t:Int):Int {
		return Std.int(list[t].x);
	}
	
	public function y(t:Int):Int {
		return Std.int(list[t].y);
	}
	
	public function pick(thing:String = ""):Void {
		//if (thing == "") {
		if (length > 0) {
			selection = Rand.pint(0, length - 1);
		}else{
			selection = -1;
		}
		//}
	}
	
	public function remove():Void {
		for (i in selection ... length) {
			list[i].setTo(list[i + 1].x, list[i + 1].y);
			contents[i] = contents[i + 1];
			odds[i] = odds[i + 1];
		}
		length--;
	}
	
	public function shift(t:Int, xoff:Int, yoff:Int) {
		list[t].x += xoff;
		list[t].y += yoff;
	}
	
	public function clear():Void {
		length = 0;
	}
	
	public var name:String;
	public var list:Array<Point> = new Array<Point>();
	public var contents:Array<String> = new Array<String>();
	public var odds:Array<Int> = new Array<Int>();
	public var length:Int;
	public var selection:Int;
}