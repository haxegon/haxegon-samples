package terrylib;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;

class Flag {
	public static function init():Void {
		for (i in 0...300) flags.push(0);
	}
	
	public static function resetflags():Void {
		for (i in 0...300) {
			flags[i] = 0;
		}
	}
	
	public static function istrue(t:String):Bool {
		if (!flagindex.exists(t)) {
			return false;
		}else{
			if (flags[flagindex.get(t)] == 1) return true;
		}
		return false;
	}
	
	public static function isfalse(t:String):Bool {
		return !istrue(t);
	}
	
	public static function settrue(t:String):Void {
		if (!flagindex.exists(t)) {
			flagindex.set(t, numflag);
			numflag++;
			flags[flagindex.get(t)] = 1;
		}else {
			flags[flagindex.get(t)] = 1;
		}
	}
	
	public static function setfalse(t:String):Void {
		if (!flagindex.exists(t)) {
			flagindex.set(t, numflag);
			numflag++;
			flags[flagindex.get(t)] = 0;
		}else {
			flags[flagindex.get(t)] = 0;
		}
	}
	
	public static var flags:Array<Int> = new Array<Int>();
	public static var flagindex:Map<String, Int> = new Map<String, Int>(); //Holds the indexes!
	public static var numflag:Int = 0;
}
