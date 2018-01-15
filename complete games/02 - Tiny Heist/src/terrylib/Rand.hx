package terrylib;

import flash.display.BitmapData;
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
	
  private static var P = [
    151,160,137,91,90,15,131,13,201,95,
    96,53,194,233,7,225,140,36,103,30,69,
    142,8,99,37,240,21,10,23,190,6,148,
    247,120,234,75,0,26,197,62,94,252,
    219,203,117,35,11,32,57,177,33,88,
    237,149,56,87,174,20,125,136,171,
    168,68,175,74,165,71,134,139,48,27,
    166,77,146,158,231,83,111,229,122,
    60,211,133,230,220,105,92,41,55,46,
    245,40,244,102,143,54,65,25,63,161,
    1,216,80,73,209,76,132,187,208,89,
    18,169,200,196,135,130,116,188,159,
    86,164,100,109,198,173,186,3,64,52,
    217,226,250,124,123,5,202,38,147,118,
    126,255,82,85,212,207,206,59,227,47,
    16,58,17,182,189,28,42,223,183,170,
    213,119,248,152,2,44,154,163,70,221,
    153,101,155,167,43,172,9,129,22,39,
    253,19,98,108,110,79,113,224,232,
    178,185,112,104,218,246,97,228,251,
    34,242,193,238,210,144,12,191,179,
    162,241,81,51,145,235,249,14,239,
    107,49,192,214,31,181,199,106,157,
    184,84,204,176,115,121,50,45,127,4,
    150,254,138,236,205,93,222,114,67,29,
    24,72,243,141,128,195,78,66,215,61,
    156,180,151,160,137,91,90,15,131,13,
    201,95,96,53,194,233,7,225,140,36,
    103,30,69,142,8,99,37,240,21,10,23,
    190,6,148,247,120,234,75,0,26,197,
    62,94,252,219,203,117,35,11,32,57,
    177,33,88,237,149,56,87,174,20,125,
    136,171,168,68,175,74,165,71,134,139,
    48,27,166,77,146,158,231,83,111,229,
    122,60,211,133,230,220,105,92,41,55,
    46,245,40,244,102,143,54,65,25,63,
    161,1,216,80,73,209,76,132,187,208,
    89,18,169,200,196,135,130,116,188,
    159,86,164,100,109,198,173,186,3,64,
    52,217,226,250,124,123,5,202,38,147,
    118,126,255,82,85,212,207,206,59,
    227,47,16,58,17,182,189,28,42,223,
    183,170,213,119,248,152,2,44,154,
    163,70,221,153,101,155,167,43,172,9,
    129,22,39,253,19,98,108,110,79,113,
    224,232,178,185,112,104,218,246,97,
    228,251,34,242,193,238,210,144,12,
    191,179,162,241,81,51,145,235,249,
    14,239,107,49,192,214,31,181,199,
    106,157,184,84,204,176,115,121,50,
    45,127,4,150,254,138,236,205,93,
    222,114,67,29,24,72,243,141,128,
    195,78,66,215,61,156,180
  ];

  public static var perlinoctaves:Int;

  public static var aOctFreq:Array<Float>; // frequency per octave
  public static var aOctPers:Array<Float>; // persistence per octave
  public static var fPersMax:Float;// 1 / max persistence

  public static var iXoffset:Float;
  public static var iYoffset:Float;
  public static var iZoffset:Float;

  public static var baseFactor:Float;

  public static function initperlin( _perlinseed:Int = 123, _perlinoctaves:Int = 4, _falloff:Float = 0.5):Void {
    perlinoctaves = _perlinoctaves;
		
		baseFactor = 1 / 64;
    seedOffset(_perlinseed);
    octFreqPers(_falloff);
  }

  public static function perlinfill(bitmap:BitmapData, _x:Float, _y:Float, _z:Float, ?_):Void {
    var baseX:Float;
		
    baseX = _x * baseFactor + iXoffset;
    _y = _y * baseFactor + iYoffset;
    _z = _z * baseFactor + iZoffset;
		
    var width:Int = bitmap.width;
    var height:Int = bitmap.height;
		
    var p = P;
    var octaves = perlinoctaves;
    var aOctFreq = aOctFreq;
    var aOctPers = aOctPers;
		
    for ( py in 0...height ){
      _x = baseX;
      for ( px in 0...width ){
        var s = 0.;
				
        for ( i in 0...octaves ){
          var fFreq = aOctFreq[i];
          var fPers = aOctPers[i];
					
          var x = _x * fFreq;
          var y = _y * fFreq;
          var z = _z * fFreq;
					
          var xf = x - (x % 1);
          var yf = y - (y % 1);
          var zf = z - (z % 1);
					
          var X = Std.int(xf) & 255;
          var Y = Std.int(yf) & 255;
          var Z = Std.int(zf) & 255;
					
          x -= xf;
          y -= yf;
          z -= zf;
					
          var u = x * x * x * (x * (x*6 - 15) + 10);
          var v = y * y * y * (y * (y*6 - 15) + 10);
          var w = z * z * z * (z * (z * 6 - 15) + 10);
					
          var A  = (p[X]) + Y;
          var AA = (p[A]) + Z;
          var AB = (p[A+1]) + Z;
          var B  = (p[X+1]) + Y;
          var BA = (p[B]) + Z;
          var BB = (p[B + 1]) + Z;
					
          var x1 = x-1;
          var y1 = y-1;
          var z1 = z - 1;
					
          var hash = (p[BB+1]) & 15;
          var g1 = ((hash & 1) == 0 ? (hash < 8 ? x1 : y1) : (hash < 8 ? -x1 : -y1)) + ((hash & 2) == 0 ? hash < 4 ? y1 : ( hash == 12 ? x1 : z1 ) : hash < 4 ? -y1 : ( hash == 14 ? -x1 : -z1 ));
					
          hash = (p[AB+1]) & 15;
          var g2 = ((hash & 1) == 0 ? (hash < 8 ? x  : y1) : (hash < 8 ? -x  : -y1)) + ((hash & 2) == 0 ? hash < 4 ? y1 : ( hash == 12 ? x  : z1 ) : hash < 4 ? -y1 : ( hash == 14 ? -x : -z1 ));
					
          hash = (p[BA+1]) & 15;
          var g3 = ((hash & 1) == 0 ? (hash < 8 ? x1 : y ) : (hash < 8 ? -x1 : -y )) + ((hash & 2) == 0 ? hash < 4 ? y  : ( hash == 12 ? x1 : z1 ) : hash < 4 ? -y  : ( hash == 14 ? -x1 : -z1 ));
					
          hash = (p[AA+1]) & 15;
          var g4 = ((hash & 1) == 0 ? (hash < 8 ? x  : y ) : (hash < 8 ? -x  : -y )) + ((hash & 2) == 0 ? hash < 4 ? y  : ( hash == 12 ? x  : z1 ) : hash < 4 ? -y  : ( hash == 14 ? -x  : -z1 ));
					
          hash = (p[BB]) & 15;
          var g5 = ((hash & 1) == 0 ? (hash < 8 ? x1 : y1) : (hash < 8 ? -x1 : -y1)) + ((hash & 2) == 0 ? hash < 4 ? y1 : ( hash == 12 ? x1 : z  ) : hash < 4 ? -y1 : ( hash == 14 ? -x1 : -z  ));
					
          hash = (p[AB]) & 15;
          var g6 = ((hash & 1) == 0 ? (hash < 8 ? x  : y1) : (hash < 8 ? -x  : -y1)) + ((hash & 2) == 0 ? hash < 4 ? y1 : ( hash == 12 ? x  : z  ) : hash < 4 ? -y1 : ( hash == 14 ? -x  : -z  ));
					
          hash = (p[BA]) & 15;
          var g7 = ((hash & 1) == 0 ? (hash < 8 ? x1 : y ) : (hash < 8 ? -x1 : -y )) + ((hash & 2) == 0 ? hash < 4 ? y  : ( hash == 12 ? x1 : z  ) : hash < 4 ? -y  : ( hash == 14 ? -x1 : -z  ));
					
          hash = (p[AA]) & 15;
          var g8 = ((hash & 1) == 0 ? (hash < 8 ? x  : y ) : (hash < 8 ? -x  : -y )) + ((hash & 2) == 0 ? hash < 4 ? y  : ( hash == 12 ? x  : z  ) : hash < 4 ? -y  : ( hash == 14 ? -x  : -z  ));
					
          g2 += u * (g1 - g2);
          g4 += u * (g3 - g4);
          g6 += u * (g5 - g6);
          g8 += u * (g7 - g8);
					
          g4 += v * (g2 - g4);
          g8 += v * (g6 - g8);
					
          s += ( g8 + w * (g4 - g8)) * fPers;
        }
        var color = Std.int( ( s * fPersMax + 1 ) * 128 );
        bitmap.setPixel32( px, py, 0xff000000 | color << 16 | color << 8 | color );
        _x += baseFactor;
      }
			
      _y += baseFactor;
    }
  }

  public static function octFreqPers( fPersistence ):Void {
    var fFreq:Float, fPers:Float;
		
    aOctFreq = [];
    aOctPers = [];
    fPersMax = 0;
		
    for ( i in 0...perlinoctaves ) {
      fFreq = Math.pow(2,i);
      fPers = Math.pow(fPersistence,i);
      fPersMax += fPers;
      aOctFreq.push( fFreq );
      aOctPers.push( fPers );
    }
		
    fPersMax = 1 / fPersMax;
  }

  public static function seedOffset( iSeed : Int ):Void {
    iXoffset = iSeed = Std.int((iSeed * 16807.) % 2147483647);
    iYoffset = iSeed = Std.int((iSeed * 16807.) % 2147483647);
    iZoffset = iSeed = Std.int((iSeed * 16807.) % 2147483647);
  }
}