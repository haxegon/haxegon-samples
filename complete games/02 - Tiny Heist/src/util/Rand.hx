package util;

import openfl.display.BitmapData;
/****
* Copyright (c) 2013 Jason O'Neil
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
* 
****/
	/**
Title:      Perlin noise
Version:    1.3
Author:      Ron Valstar
Author URI:    http://www.sjeiti.com/
Original code port from http://mrl.nyu.edu/~perlin/noise/
and some help from http://freespace.virgin.net/hugo.elias/models/m_perlin.htm
AS3 optimizations by Mario Klingemann http://www.quasimondo.com
Haxe port and optimization by Nicolas Cannasse http://haxe.org
*/

//Some of this code is from Jason O'Neil's class, some is some other stuff I found online,
//some is mine (the messy stuff)

class Rand{
	/** Return a pseudorandom boolean value (true or false) */
	public static inline function pbool():Bool
	{
		return prandom() < 0.5;
	}
	
	/** True about 1/5th of the time */
	public static inline function poccasional():Bool
	{
		return prandom() < 0.2;
	}

	/** True about 5% or 1/20th of the time */
	public static inline function prare():Bool
	{
		return prandom() < 0.05;
	}
	
	/** True about 2% or 1/50th of the time */
	public static inline function psuperrare():Bool
	{
		return prandom() < 0.02;
	}
	
	/** Return a pseudorandom integer between 'from' and 'to', inclusive. */
	public static inline function pint(from:Int, to:Int):Int
	{
		return from + Math.floor(((to - from + 1) * prandom()));
	}
	
	/** Return a pseudorandom float between 'from' and 'to', inclusive. */
	public static inline function pfloat(from:Float, to:Float):Float
	{
		return from + ((to - from) * prandom());
	}

	/** Shuffle an Array.  This operation affects the array in place, and returns that array.
		The shuffle algorithm used is a variation of the [Fisher Yates Shuffle](http://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle) */
	public static function pshuffle<T>(arr:Array<T>):Array<T>
	{
		if (arr!=null) {
			for (i in 0 ... arr.length) {
				var j = pint(0, arr.length - 1);
				var a = arr[i];
				var b = arr[j];
				arr[i] = b;
				arr[j] = a;
			}
		}
		return arr;
	}
	
	//These functions are pretty ugly, but useful!
	/** Return a random string from a list of up to 12 strings. */
	public static function ppickstring(s1:String, s2:String, s3:String = "", s4:String = "",
																					 s5:String = "", s6:String = "", s7:String = "", s8:String = "",
																					 s9:String = "", s10:String = "", s11:String = "",s12:String = ""):String{
	  temp = 2;
		if (s3 != "") temp = 3;
	  if (s4 != "") temp = 4;
	  if (s5 != "") temp = 5;
	  if (s6 != "") temp = 6;
	  if (s7 != "") temp = 7;
	  if (s8 != "") temp = 8;
	  if (s9 != "") temp = 9;
	  if (s10 != "") temp = 10;
	  if (s11 != "") temp = 11;
	  if (s12 != "") temp = 12;
		
		switch(pint(1, temp)) {
			case 1: return s1;
			case 2: return s2;
			case 3: return s3;
			case 4: return s4;
			case 5: return s5;
			case 6: return s6;
			case 7: return s7;
			case 8: return s8;
			case 9: return s9;
			case 10: return s10;
			case 11: return s11;
			case 12: return s12;
		}
		
		return s1;
	}
	
	/** Return a random Int from a list of up to 12 Ints. */
	public static function ppickint(s1:Int, s2:Int, s3:Int = -10000, s4:Int = -10000,
																					 s5:Int = -10000, s6:Int = -10000, s7:Int = -10000, s8:Int = -10000,
																					 s9:Int = -10000, s10:Int = -10000, s11:Int = -10000,s12:Int = -10000):Int{
	  temp = 2;
    if (s3 != -10000) temp = 3;
	  if (s4 != -10000) temp = 4;
	  if (s5 != -10000) temp = 5;
	  if (s6 != -10000) temp = 6;
	  if (s7 != -10000) temp = 7;
	  if (s8 != -10000) temp = 8;
	  if (s9 != -10000) temp = 9;
	  if (s10 != -10000) temp = 10;
	  if (s11 != -10000) temp = 11;
	  if (s12 != -10000) temp = 12;
		
		switch(pint(1, temp)) {
			case 1: return s1;
			case 2: return s2;
			case 3: return s3;
			case 4: return s4;
			case 5: return s5;
			case 6: return s6;
			case 7: return s7;
			case 8: return s8;
			case 9: return s9;
			case 10: return s10;
			case 11: return s11;
			case 12: return s12;
		}
		
		return s1;
	}
	
	/** Return a random Float from a list of up to 12 Floats. */
	public static function ppickfloat(s1:Float, s2:Float, s3:Float = -10000, s4:Float = -10000,
																					 s5:Float = -10000, s6:Float = -10000, s7:Float = -10000, s8:Float = -10000,
																					 s9:Float = -10000, s10:Float = -10000, s11:Float = -10000,s12:Float = -10000):Float{
	  temp = 2;
    if (s3 != -10000) temp = 3;
	  if (s4 != -10000) temp = 4;
	  if (s5 != -10000) temp = 5;
	  if (s6 != -10000) temp = 6;
	  if (s7 != -10000) temp = 7;
	  if (s8 != -10000) temp = 8;
	  if (s9 != -10000) temp = 9;
	  if (s10 != -10000) temp = 10;
	  if (s11 != -10000) temp = 11;
	  if (s12 != -10000) temp = 12;
		
		switch(pint(1, temp)) {
			case 1: return s1;
			case 2: return s2;
			case 3: return s3;
			case 4: return s4;
			case 5: return s5;
			case 6: return s6;
			case 7: return s7;
			case 8: return s8;
			case 9: return s9;
			case 10: return s10;
			case 11: return s11;
			case 12: return s12;
		}
		
		return s1;
	}
	
  public static function ppick<T>(arr:Array<T>):T {
		return arr[pint(0, arr.length - 1)];
	}
	
	public static function prandom():Float {
		seed = (seed * 16807) % 2147483647;
		return Math.abs(seed / (2147483647));
	}
	
	
	public static function setseed(s:Int):Void {
		seed = Std.int(Math.abs(s % 2147483647));
	}
	
	public static var temp:Int;
	public static var seed:Int = 0;

  public static var perlinoctaves:Int;

  public static var aOctFreq:Array<Float>; // frequency per octave
  public static var aOctPers:Array<Float>; // persistence per octave
  public static var fPersMax:Float;// 1 / max persistence

  public static var iXoffset:Float;
  public static var iYoffset:Float;
  public static var iZoffset:Float;

  public static var baseFactor:Float;

  public static function seedOffset( iSeed : Int ):Void {
    iXoffset = iSeed = Std.int((iSeed * 16807.) % 2147483647);
    iYoffset = iSeed = Std.int((iSeed * 16807.) % 2147483647);
    iZoffset = iSeed = Std.int((iSeed * 16807.) % 2147483647);
  }
}