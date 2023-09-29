package util;
	
class Direction {	
	public static var NONE:Int = -1;
	public static var UP:Int = 0;
	public static var DOWN:Int = 1;
	public static var LEFT:Int = 2;
	public static var RIGHT:Int = 3;
	
	public static function random():Int { 
		return Std.int(Math.random() * 4); 
	}
	
	public static function convertcardinaltoangle(t:Int):Int {
		if (t == UP) return 90;
		if (t == DOWN) return 270;
		if (t == LEFT) return 180;
		if (t == RIGHT) return 0;
		return 0;
	}
	
	public static function opposite(t:Int):Int {
		if (t == UP) return DOWN;
		if (t == DOWN) return UP;
		if (t == LEFT) return RIGHT;
		if (t == RIGHT) return LEFT;
		return UP;
	}
	
	public static function anticlockwise(t:Int, times:Int = 1):Int {
		if (times > 1) t = anticlockwise(t, times - 1);
		if (t == UP) return LEFT;
		if (t == LEFT) return DOWN;
		if (t == DOWN) return RIGHT;
		if (t == RIGHT) return UP;
		return UP;
	}
	
	public static function clockwise(t:Int, times:Int = 1):Int {
		if (times > 1) t = clockwise(t, times - 1);
		if (t == UP) return RIGHT;
		if (t == RIGHT) return DOWN;
		if (t == DOWN) return LEFT;
		if (t == LEFT) return UP;
		return UP;
	}
}
