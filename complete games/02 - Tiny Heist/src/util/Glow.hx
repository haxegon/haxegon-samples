package util;
	
class Glow {
	public static function init():Void {
		glow = 0;
		glowdir = 0;
		longglow = 0;
		longglowdir = 0;
		fastglow = 0;
		fastglowdir = 0;
		slowsine = 0;
		tenseconds = 0;
	}
	
	public static function update():Void {
		tenseconds+=2;
		if (tenseconds >= 600) tenseconds = 0;
		
		slowsine+=2;
		if (slowsine >= 64) slowsine = 0;
		
		if (longglowdir == 0) {
			longglow += 2; 
			if (longglow >= 2400) longglowdir = 1;
		}else {
			longglow -= 2;
			if (longglow < 1) longglowdir = 0;
		}
		
		
		if (glowdir == 0) {
			glow += 2;
			if (glow >= 63) glowdir = 1;
		}else {
			glow -= 2;
			if (glow < 1) glowdir = 0;
		}
		
		if (fastglowdir == 0) {
			fastglow += 4; 
			if (fastglow >= 62) fastglowdir = 1;
		}else {
			fastglow -= 4;
			if (fastglow < 2) fastglowdir = 0;
		}
	}
	
	public static var longglow:Int;
	public static var longglowdir:Int;
	public static var glow:Int;
	public static var glowdir:Int;
	public static var fastglow:Int;
	public static var fastglowdir:Int;
	public static var slowsine:Int;
	public static var tenseconds:Int;
	public static var tempstring:String;
}
