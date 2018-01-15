package terrylib.util;

class Tmap {
	public static function init():Void {
		for (i in 0...100) {
			contents.push("");
		}
		
		index = 0;
	}
	
	public static function reset():Void {
		index = 0;
	}
	
	public static function push(t:String):Void {
		contents[index] = t;
		index++;
	}
	
	public static var contents:Array<String> = new Array<String>();
	public static var index:Int;
}