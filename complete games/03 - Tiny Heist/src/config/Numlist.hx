package config;

class Numlist {
	//Just a struct for a list of strings
	public function new() {
	  for (i in 0 ... 30) {
			list.push("");
			length = 0;
		}
	}
	
	public function add(t:String):Void {
		list[length] = t;
		length++;
		if (length > list.length) list.push("");
	}
	
	public function clear():Void {
		length = 0;
	}
	
	public function printout():String {
		var tstring:String = "";
		for (i in 0 ... length) {
			tstring = tstring + list[i];
			if (i != length - 1) {
				tstring += ", ";
			}
		}
		if (tstring == "") return "nothing";
		return tstring;
	}
	
	public var list:Array<String> = new Array<String>();
	public var length:Int;
}