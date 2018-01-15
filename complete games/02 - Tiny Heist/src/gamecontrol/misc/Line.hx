package gamecontrol.misc;

class Line {
	//Dirt simple line class
	public function new(_x1:Int = 0, _y1:Int = 0, _x2:Int = 0, _y2:Int = 0) {
		x1 = _x1;
		y1 = _y1;
		x2 = _x2;
		y2 = _y2;
	}
	
	public function setto(_x1:Int = 0, _y1:Int = 0, _x2:Int = 0, _y2:Int = 0):Void {
		x1 = _x1;
		y1 = _y1;
		x2 = _x2;
		y2 = _y2;
	}
	
	public function tostring():String {
		return "(" + Std.string(x1) + "," + Std.string(y1) + ") - (" + Std.string(x2) + "," + Std.string(y2) + ")";
	}
	
	public var x1:Int;
	public var y1:Int;
	public var x2:Int;
	public var y2:Int;
}