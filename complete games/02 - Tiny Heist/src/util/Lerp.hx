package util;
/* 
	TERMS OF USE - EASING EQUATIONS
	---------------------------------------------------------------------------------
	Open source under the BSD License.

	Copyright © 2001 Robert Penner All rights reserved.

	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:

	Redistributions of source code must retain the above copyright notice, this
	list of conditions and the following disclaimer. Redistributions in binary
	form must reproduce the above copyright notice, this list of conditions and
	the following disclaimer in the documentation and/or other materials provided
	with the distribution. Neither the name of the author nor the names of
	contributors may be used to endorse or promote products derived from this
	software without specific prior written permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
	FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
	DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
	SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
	CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
	OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
	OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	---------------------------------------------------------------------------------
*/

class Lerp {
	private static var PI_M2:Float = Math.PI*2;
	private static var PI_D2:Float = Math.PI/2;

  /*
	Linear
	---------------------------------------------------------------------------------
	*/
	public static function easeLinear (t:Float, b:Float, c:Float, d:Float):Float{
		return c*t/d + b;
	}

	/*
	Sine
	---------------------------------------------------------------------------------
	*/
	public static function easeInSine (t:Float, b:Float, c:Float, d:Float):Float{
		return -c * Math.cos(t/d * PI_D2) + c + b;
	}
	
	public static function easeOutSine (t:Float, b:Float, c:Float, d:Float):Float{
		return c * Math.sin(t/d * PI_D2) + b;
	}

	/*
	Back
	---------------------------------------------------------------------------------
	*/
	public static function easeOutBack (t:Float, b:Float, c:Float, d:Float, s:Float=1.70158):Float{
		return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
	}
	
	/*
	Bounce
	---------------------------------------------------------------------------------
	*/
	public static function easeInBounce (t:Float, b:Float, c:Float, d:Float):Float{
		return c - easeOutBounce (d-t, 0, c, d) + b;
	}
	
	public static function easeOutBounce (t:Float, b:Float, c:Float, d:Float):Float{
		if ((t/=d) < (1/2.75)) {
			return c*(7.5625*t*t) + b;
		} else if (t < (2/2.75)) {
			return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
		} else if (t < (2.5/2.75)) {
			return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
		} else {
			return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
		}
	}

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
					return easeInSine(variable, start, end - start, max);
				case "sine_out":
					return easeOutSine(variable, start, end - start, max);
				case "back_out":
					return easeOutBack(variable, start, end - start, max);
				case "bounce_in":
					return easeInBounce(variable, start, end - start, max);
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