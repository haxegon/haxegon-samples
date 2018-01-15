import haxegon.*;

class Keygroup {
  public function new(_name:String, _list:Array<Key>) {
		name = _name;
		list = _list;
	}
	
	public var name:String;
	public var list:Array<Key>;
	public var held:Int = 0;
}

@:access(haxegom.Mouse)
class Controls {
	public static function init() {
		keyindex = new Map<String, Int>();
		
		keygroups = [];
		keygroups.push(new Keygroup("up", [Key.UP, Key.W]));
		keygroups.push(new Keygroup("down", [Key.DOWN, Key.S]));
		keygroups.push(new Keygroup("left", [Key.LEFT, Key.A]));
		keygroups.push(new Keygroup("right", [Key.RIGHT, Key.D]));
		keygroups.push(new Keygroup("menu", [Key.TAB]));
		keygroups.push(new Keygroup("action", [Key.SPACE, Key.Z, Key.X, Key.ENTER]));
		keygroups.push(new Keygroup("esc", [Key.ESCAPE]));
		
		for (i in 0 ... keygroups.length) {
		  keyindex.set(keygroups[i].name, i);	
		}
	}
	
	public static function held(name:String):Int {
		currentkey = keyindex.get(name);
		return keygroups[currentkey].held;
	}
	
	public static function setheld(name:String, value:Int) {
		currentkey = keyindex.get(name);
		keygroups[currentkey].held = value;
	}
	
	public static function justpressed(name:String):Bool {
		currentkey = keyindex.get(name);
		if (pressed(name)) {
		  keygroups[currentkey].held++;
		}else {
		  keygroups[currentkey].held = 0;	
		}
		
		i = 0;
		while (i < keygroups[currentkey].list.length) {
		  if (Input.justpressed(keygroups[currentkey].list[i])) return true;
			i++;
		}
	  return false;
	}
	
	public static function delaypressed(name:String, repeatframes:Int, ?instantreps:Int=-1):Bool {
		currentkey = keyindex.get(name);
		
		if (pressed(name)) {
		  keygroups[currentkey].held++;
		}else {
		  keygroups[currentkey].held = 0;	
		}
		
		var returnval:Bool = false;
		var shortestkeypress:Int = -1;
		i = 0;
		while (i < keygroups[currentkey].list.length) {
			var presstime:Int = Input.pressheldtime(keygroups[currentkey].list[i]);
		  if (presstime >= 0 && (shortestkeypress == -1 || presstime < shortestkeypress)) {
				shortestkeypress = presstime;
				returnval = Input.delaypressed(keygroups[currentkey].list[i], repeatframes);
			}
			i++;
		}
	  return returnval;
	}
	
	public static function pressed(name:String):Bool {
		i = 0;
		currentkey = keyindex.get(name);
		while (i < keygroups[currentkey].list.length) {
		  if (Input.pressed(keygroups[currentkey].list[i])) return true;
			i++;
		}
	  return false;
	}
	
	public static function forcerelease(name:String) {
		i = 0;
		currentkey = keyindex.get(name);
		keygroups[currentkey].held = 0;
		while (i < keygroups[currentkey].list.length) {
			Input.forcerelease(keygroups[currentkey].list[i]);
			i++;
		}
	}
	
	public static function showfirstassigned(name:String):String {
		i = 0;
		currentkey = keyindex.get(name);
		if (keygroups[currentkey].list.length > 0) {
		  return Input.keyname(keygroups[currentkey].list[0]);	
		}
		
	  return "Unassigned";
	}
	
	public static function showallassigned(name:String):String {
		keyname = "";
		i = 0;
		currentkey = keyindex.get(name);
		if (keygroups[currentkey].list.length > 0) {
			while (i < keygroups[currentkey].list.length) {
				keyname += Input.keyname(keygroups[currentkey].list[i]);
				i++;
				if (i < keygroups[currentkey].list.length) keyname += " / ";
			}
			return keyname;
		}
		
	  return "Unassigned";
	}
	
	
	public static function clearassigned(name:String) {
		currentkey = keyindex.get(name);
		keygroups[currentkey].list = [];
	}
	
	public static function assign(name:String, k:Key) {
		currentkey = keyindex.get(name);
		keygroups[currentkey].list.push(k);
	}
	
	public static function assigned(name:String, k:Key):Bool {
		currentkey = keyindex.get(name);
		if (keygroups[currentkey].list.indexOf(k) != -1) return true;
		return false;
	}
	
	private static function processdelaypress(heldframes:Int, repeatframes:Int, ?instantreps:Int =-1):Bool {
		if (heldframes >= 1) {
			if (heldframes == 1) {
				return true;
			} else {
				var repeatheld:Int = heldframes - Std.int(2.35 * repeatframes) - 1;
				if (repeatheld >= 0 && (repeatheld % repeatframes) == 0) {
					return true;
				} else if (instantreps >= 1 && repeatheld >= instantreps * repeatframes) {
					return true;
				}
			}
		}
		return false;
	}
	
	public static function keydelaypressed(k:Key, repeatframes:Int, ?instantreps:Int =-1):Bool {
		return processdelaypress(Input.pressheldtime(k), repeatframes, instantreps);
	}
	
	/*public static function mouseleftdelaypressed(repeatframes:Int, ?instantreps:Int =-1):Bool {
		return processdelaypress(Mouse._held, repeatframes, instantreps);
	}
	
	public static function mouserightdelaypressed(repeatframes:Int, ?instantreps:Int=-1):Bool {
		return processdelaypress(Mouse._rightheld, repeatframes, instantreps);
	}
	*/
	public static var keyindex:Map<String, Int>;
	public static var keygroups:Array<Keygroup>;
	
	private static var keyname:String;
	private static var i:Int;
	private static var currentkey:Int;
}	