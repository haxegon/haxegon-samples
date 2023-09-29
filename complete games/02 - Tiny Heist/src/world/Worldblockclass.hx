package world;

class Worldblockclass {
	public function new() {
		
	}
	
	/** Create a block type*/
	public function set(_charcode_lit:Int, _charcode_fog:Int, _front_lit:Int, _front_fog:Int, _back_lit:Int = 0x113f79, _back_fog:Int = 0x112945) {
		charcode_lit = _charcode_lit;
		charcode_fog = _charcode_fog;
		front_lit = _front_lit;
		front_fog = _front_fog;
		back_lit = _back_lit;
		back_fog = _back_fog;
		flamable = 30;
	}
	
	public function setcol(_front_lit:Int, _front_fog:Int, _back_lit:Int = 0x113f79, _back_fog:Int = 0x112945) {
		front_lit = _front_lit;
		front_fog = _front_fog;
		back_lit = _back_lit;
		back_fog = _back_fog;
		flamable = 30;
	}
	
	public var charcode_lit:Int;
	public var charcode_fog:Int;
	public var front_lit:Int;
	public var front_fog:Int;
	public var back_lit:Int;
	public var back_fog:Int;
	public var flamable:Int;
}