package terrylib;

import terrylib.util.*;

class Lerp {
	public static function init():Void {
		for (i in 0...100) {
			lerptimer.push(0);
			completelist.push("null");
		}
		numlerptimer = 0;
		numcompletelist = 0;
	}
	
	//Lerp functions expect variable to go from 0 to max. 
	//If they go the other way, just use the opposite function
	public static function to(start:Float, end:Float, timer:String, type:String = "linear"):Int {
		var t:Int = timerindex.get(timer);
		return Std.int(to_value(start, end, lerptimer[t], lerptimermax[t], type));
	}
	
	public static function from(start:Float, end:Float, timer:String, type:String = "linear"):Int {
		return to(end, start, timer, type);
	}
	
	public static function to_float(start:Float, end:Float, timer:String, type:String = "linear"):Float {
		var t:Int = timerindex.get(timer);
		return to_value(start, end, lerptimer[t], lerptimermax[t], type);
	}
	
	public static function from_float(start:Float, end:Float, timer:String, type:String = "linear"):Float {
		return to_float(end, start, timer, type);
	}
	
	public static function to_value(start:Float, end:Float, variable:Float, max:Float, type:String = "linear"):Float {
		if (variable >= 0 && variable <= max) {
			switch(type) {
				case "linear":
					return end + ((start - end) * ((max - variable) / max));
				case "sine_in":
					return Easing.easeInSine(variable, start, end - start, max);
				case "sine_out":
					return Easing.easeOutSine(variable, start, end - start, max);
				case "sine_inout":
					return Easing.easeInOutSine(variable, start, end - start, max);
				case "quint_in":
					return Easing.easeInQuint(variable, start, end - start, max);
				case "quint_out":
					return Easing.easeOutQuint(variable, start, end - start, max);
				case "quint_inout":
					return Easing.easeInOutQuint(variable, start, end - start, max);
				case "quart_in":
					return Easing.easeInQuart(variable, start, end - start, max);
				case "quart_out":
					return Easing.easeOutQuart(variable, start, end - start, max);
				case "quart_inout":
					return Easing.easeInOutQuart(variable, start, end - start, max);
				case "quad_in":
					return Easing.easeInQuad(variable, start, end - start, max);
				case "quad_out":
					return Easing.easeOutQuad(variable, start, end - start, max);
				case "quad_inout":
					return Easing.easeInOutQuad(variable, start, end - start, max);
				case "expo_in":
					return Easing.easeInExpo(variable, start, end - start, max);
				case "expo_out":
					return Easing.easeOutExpo(variable, start, end - start, max);
				case "expo_inout":
					return Easing.easeInOutExpo(variable, start, end - start, max);
				case "circular_in":
					return Easing.easeInCircular(variable, start, end - start, max);
				case "circular_out":
					return Easing.easeOutCircular(variable, start, end - start, max);
				case "circular_inout":
					return Easing.easeInOutCircular(variable, start, end - start, max);
				case "cubic_in":
					return Easing.easeInCubic(variable, start, end - start, max);
				case "cubic_out":
					return Easing.easeOutCubic(variable, start, end - start, max);
				case "cubic_inout":
					return Easing.easeInOutCubic(variable, start, end - start, max);
				case "back_in":
					return Easing.easeInBack(variable, start, end - start, max);
				case "back_out":
					return Easing.easeOutBack(variable, start, end - start, max);
				case "back_inout":
					return Easing.easeInOutBack(variable, start, end - start, max);
				case "bounce_in":
					return Easing.easeInBounce(variable, start, end - start, max);
				case "bounce_out":
					return Easing.easeOutBounce(variable, start, end - start, max);
				case "bounce_inout":
					return Easing.easeInOutBounce(variable, start, end - start, max);
			}
			return start;
	  }else {
			return start;
		}
	}
	
	public static function from_value(end:Float, start:Float, variable:Float, max:Float, type:String = "linear"):Float {
		return to_value(start, end, variable, max, type);
	}
	
	public static function update():Void {
		//Update all lerp timers, and remove used ones.
		var t:Int;
		for (i in timerindex.keys()) {
			t = timerindex.get(i);
			if (lerptimer[t] < lerptimermax[t]) {
				lerptimer[t]++;
			}else {
				addtocomplete(i);
				timerindex.remove(i);
			}
		}
		
		t = numlerptimer - 1; 
		while (t >= 0 && lerptimer[t] >= lerptimermax[t]) {
			numlerptimer--; t--; 
		}
	}
	
	public static function finished(name:String):Bool {
		if (timerindex.exists(name)) return false;
		return true;
	}
	
	public static function justfinished(name:String):Bool {
		if (incompletelist(name)){
			removefromcomplete(name);
			return true;
		}
		return false;
	}
	
	public static function start(name:String, time:Int):Void {
		lerptimermax[numlerptimer] = time;
		lerptimer[numlerptimer] = 0;
		numlerptimer++;
		timerindex.set(name, numlerptimer - 1);
		
		mode = name;
	}
	
	public static function addtocomplete(t:String):Void {
		completelist[numcompletelist] = t;
		numcompletelist++;
	}
	
	public static function removefromcomplete(t:String):Void {
		for (i in 0 ... numcompletelist) {
			if (completelist[i] == t) {
				for (j in i ... numcompletelist-1) {
					completelist[j] = completelist[j + 1];
				}
				numcompletelist -= 1;
			}
		}
	}
	
	
	public static function incompletelist(t:String):Bool {
		for (i in 0 ... numcompletelist) {
			if (completelist[i] == t) {
				return true;
			}
		}
		return false;
	}
	
	public static var lerptimer:Array<Int> = new Array<Int>();
	public static var lerptimermax:Array<Int> = new Array<Int>();
	public static var timerindex:Map<String,Int> = new Map<String,Int>();
	public static var numlerptimer:Int;
	
	public static var completelist:Array<String> = new Array<String>();
	public static var numcompletelist:Int;
	
	public static var mode:String;
}