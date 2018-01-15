package terrylib;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;
import haxe.crypto.Base64;

using StringTools;
	
class Help {	
	public static var NODIRECTION:Int = -1;
	public static var UP:Int = 0;
	public static var DOWN:Int = 1;
	public static var LEFT:Int = 2;
	public static var RIGHT:Int = 3;
	
	public static function init():Void {
		for(i in 0...360){
			sine[i] = Math.sin((i * 6.283) / 360);
			cosine[i] = Math.cos((i * 6.283) / 360);
			
			bresx.push(0);
			bresy.push(0);
			bresswap.push(0);
		}
		
		bressize = 0;
		
		glow = 0;
		glowdir = 0;
		longglow = 0;
		longglowdir = 0;
		fastglow = 0;
		fastglowdir = 0;
		slowsine = 0;
		tenseconds = 0;
	}
	
	public static function randomdirection():Int { 
		return Std.int(Math.random() * 4); 
	}
	
	public static function convertcardinaltoangle(t:Int):Int {
		if (t == UP) return 90;
		if (t == DOWN) return 270;
		if (t == LEFT) return 180;
		if (t == RIGHT) return 0;
		return 0;
	}
	
	public static function oppositedirection(t:Int):Int {
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
	
	public static function RGB(red:Int, green:Int, blue:Int):Int {
		return (blue | (green << 8) | (red << 16));
	}
	
	public static function wrap(t:Int, start:Int, end:Int):Int {
		while (t < start) t += (end - start);
		return (t % (end - start)) + start;
	}
	
	public static function getarctan(i:Int, j:Int):Float {
		return (360 - ((getarctan_rad(i, j) * 360) / 6.283)) % 360;
	}

	
	public static function getarctan_rad(i:Int, j:Int):Float {
		return Math.atan2(Obj.entities[i].yp - Obj.entities[j].yp, Obj.entities[i].xp - Obj.entities[j].xp);
	}
	
	public static function fixangle(t:Float):Float {
		while (t < 0) t += 360;
		while (t >= 360) t -= 360;
		return t;
	}
	
	public static function seekangle(a:Float, b:Float, d:Int):Float {
		//Starting at angle a, turn d degres to angle b.
		//If the difference is less than d, set the angle to exactly b.
		if (fixangle(b - a) > fixangle(a - b)) {
			if (Math.abs(a - b) < d) return b;
			return fixangle(a - d);
		}else {
			if (Math.abs(a - b) < d) return b;
			return fixangle(a + d);
		}
		return a;
	}
	
	public static function toangle(a:Float):Int {
		//Convert rad a to angle
		return Std.int((360 - ((a * 360) / 6.283))) % 360;
	}
	
	public static function torad(a:Float):Float {
		//Convert angle a to rad
		return (((Math.PI * 2) - ((a * (Math.PI * 2)) / 360))) % (Math.PI * 2);
	}
	
	public static function sign(p1_x:Float, p1_y:Float, p2_x:Float, p2_y:Float, p3_x:Float, p3_y:Float):Float {
		return (p1_x - p3_x) * (p2_y - p3_y) - (p2_x - p3_x) * (p1_y - p3_y);
	}

	public static function PointInTriangle(pt_x:Float, pt_y:Float, v1_x:Float, v1_y:Float, v2_x:Float, v2_y:Float, v3_x:Float, v3_y:Float):Bool {
		var b1:Bool, b2:Bool, b3:Bool;
		
		b1 = (sign(pt_x, pt_y, v1_x, v1_y, v2_x, v2_y) < 0.0);
		b2 = (sign(pt_x, pt_y, v2_x, v2_y, v3_x, v3_y) < 0.0);
		b3 = (sign(pt_x, pt_y, v3_x, v3_y, v1_x, v1_y) < 0.0);
		
		return ((b1 == b2) && (b2 == b3));
	}
	
	public static function number(t:Int):String {
		switch(t) {
			case 0: return "Zero";
			case 1: return "One";
			case 2: return "Two";
			case 3: return "Three";
			case 4: return "Four"; 
			case 5: return "Five";
			case 6: return "Six";
			case 7: return "Seven";
			case 8: return "Eight";
			case 9: return "Nine";
			case 10: return "Ten";
			case 11: return "Eleven";
			case 12: return "Twelve";
			case 13: return "Thirteen";
			case 14: return "Fourteen";
			case 15: return "Fifteen";
			case 16: return "Sixteen";
			case 17: return "Seventeen";
			case 18: return "Eighteen";
			case 19: return "Nineteen";
			case 20: return "Twenty";
			case 30: return "Thirty";
			case 40: return "Forty";
			case 50: return "Fifty";
			case 60: return "Sixty";
			case 70: return "Seventy";
			case 80: return "Eighty";
			case 90: return "Ninety";
		}
		if (t > 20 && t < 30) return number(20) + " " + number(t - 20);
		if (t > 30 && t < 40) return number(30) + " " + number(t - 30);
		if (t > 40 && t < 50) return number(40) + " " + number(t - 40);
		if (t > 50 && t < 60) return number(50) + " " + number(t - 50);
		if (t > 60 && t < 70) return number(60) + " " + number(t - 60);
		if (t > 70 && t < 80) return number(70) + " " + number(t - 70);
		if (t > 80 && t < 90) return number(80) + " " + number(t - 80);
		if (t > 90 && t < 100) return number(90) + " " + number(t - 90);
		if (t >= 100 && t < 1000) {
			if (t % 100 == 0) {
				return number(Std.int((t - (t % 100)) / 100)) + " hundred";
			}else{
				return number(Std.int((t - (t % 100)) / 100)) + " hundred and " + number(t % 100);
			}
		}
		if (t >= 1000) {
			if ((t % 1000) == 0) {
				return number(Std.int((t - (t % 1000)) / 1000)) + " thousand";
			}else if ((t % 1000) < 100) {
				return number(Std.int((t - (t % 1000)) / 1000)) + " thousand and " + number(t % 1000);
			}else{
				return number(Std.int((t - (t % 1000)) / 1000)) + " thousand, " + number(t % 1000);
			}
		}
		return "Some";
	}
	
	public static function updateglow():Void {
		tenseconds+=2;
		if (tenseconds >= 600) tenseconds = 0;
		
		slowsine+=2;
		if (slowsine >= 64) slowsine = 0;
		
		if (longglowdir == 0) {
			longglow += 2; 
			if (longglow >= 2400) longglowdir = 1;
		}else {
			longglow -= 2;
			if (longglow < 1) longglowdir = 0;
		}
		
		
		if (glowdir == 0) {
			glow += 2;
			if (glow >= 63) glowdir = 1;
		}else {
			glow -= 2;
			if (glow < 1) glowdir = 0;
		}
		
		if (fastglowdir == 0) {
			fastglow += 4; 
			if (fastglow >= 62) fastglowdir = 1;
		}else {
			fastglow -= 4;
			if (fastglow < 2) fastglowdir = 0;
		}
	}
	
	public static function inbox(xc:Int, yc:Int, x1:Int, y1:Int, x2:Int, y2:Int):Bool {
		if (xc >= x1 && xc <= x2) {
			if (yc >= y1 && yc <= y2) {
				return true;
			}
		}
		return false;
	}
	
	public static function inboxw(xc:Int, yc:Int, x1:Int, y1:Int, x2:Int, y2:Int):Bool {
		if (xc >= x1 && xc <= x1+x2) {
			if (yc >= y1 && yc <= y1+y2) {
				return true;
			}
		}
		return false;
	}
	
	public static function twodigits(t:Int):String {
		if (t < 10) return "0" + Std.string(t);
		if (t > 100) return Std.string(twodigits(t % 100));
		return Std.string(t);
	}
	
	public static function threedigits(t:Int):String {
		if (t < 10) return "00" + Std.string(t);
		if (t < 100) return "0" + Std.string(t);
		return Std.string(t);
	}
	
	public static function thousand(t:Int):String {
		if (t < 1000) {
			return "$"+Std.string(t);	
		}else if (t < 1000000) {
			return "$"+Std.string((t - (t % 1000)) / 1000) + "," + threedigits(t % 1000);
		}else {
			var temp:Int;
			temp = Std.int((t - (t % 1000)) / 1000);
			return "$" + Std.string((temp - (temp % 1000)) / 1000) + "," 
								 + threedigits(temp % 1000) + "," + threedigits(t % 1000);
		}
	}
	
	public static function removenewlines(s:String):String {
		//Remove newlines from string s
		return removefromstring(removefromstring(s, "\n"), "\r");
	}
	
	public static function removefromstring(s:String, c:String):String {
		//Remove all instances of c from string s
		var t:Int = Instr(s, c);
		if (t == 0) {
			return s;
		}else {
			return removefromstring(getroot(s, c) + getbranch(s, c), c);
		}
	}
	
	
	public static function isinstring(s:String, c:String):Bool {
		if (s.indexOf(c, 0) > -1) return true;
		return false;
	}
	
	
	public static function Instr(s:String, c:String, start:Int = 1):Int {
		return (s.indexOf(c, start - 1) + 1);
	}
	
	public static function Mid(s:String, start:Int = 0, length:Int = 1):String {
		return s.substr(start,length);
	}
	
	public static function Left(s:String, length:Int = 1):String {
		return s.substr(0,length);
	}
	
	public static function Right(s:String, length:Int = 1):String {
		return s.substr(s.length - length, length);
	} 
	
	public static function stringplusplus(t:String):String {
		return Left(t, t.length - 1) + Std.string(Std.parseInt(Right(t, 1)) + 1);
	}
	
	public static function reversetext(t:String):String {
		var t2:String = "";
		
		for (i in 0...t.length) {
			t2 += Mid(t, t.length-i-1, 1);
		}
		return t2;
	}
	
	public static function replacechar(t:String, ch:String = "|", ch2:String = ""):String {
		var fixedstring:String = "";
		for (i in 0...t.length) {
			if (Help.Mid(t, i) == ch) {
				fixedstring += ch2;
			}else {
				fixedstring += Help.Mid(t, i);
			}
		}
		return fixedstring;
	}
	
	public static function getlastbranch(n:String, ch:String):String {
		//Given a string n, return everything after the LAST occurance of the "ch" character
		var i:Int = n.length - 1;
		while (i >= 0) {
			if (Mid(n, i, 1) == ch) {
				return Mid(n, i + 1, n.length - i - 1);
			}
			i--;
		}
		return n;
	}
	
	public static function getroot(n:String, ch:String):String {
		//Given a string n, return everything before the first occurance of the "ch" character
		for (i in 0...n.length) {
			if (Mid(n, i, 1) == ch) {
				return Mid(n, 0, i);
			}
		}
		return n;
	}
	
	public static function getbranch(n:String, ch:String):String {
		//Given a string n, return everything after the first occurance of the "ch" character
		for (i in 0...n.length) {
			if (Mid(n, i, 1) == ch) {
				return Mid(n, i + 1, n.length - i - 1);
			}
		}
		return n;
	}
	
	public static function getbrackets(n:String):String {
		//Given a string n, return everything between the first and the last bracket
		while (Mid(n, 0, 1) != "(" && n.length > 0)	n = Mid(n, 1, n.length - 1);
		while (Mid(n, n.length-1, 1) != ")" && n.length > 0) n = Mid(n, 0, n.length - 1);
		
		if (n.length <= 0) return "";
		return Mid(n, 1, n.length - 2);
	}
	
	public static function trimspaces(n:String):String {
		//Given a string n, remove the spaces around it
		while (Mid(n, 0, 1) == " " && n.length > 0)	n = Mid(n, 1, n.length - 1);
		while (Mid(n, n.length - 1, 1) == " " && n.length > 0) n = Mid(n, 0, n.length - 1);
		
		while (Mid(n, 0, 1) == "\t" && n.length > 0)	n = Mid(n, 1, n.length - 1);
		while (Mid(n, n.length - 1, 1) == "\t" && n.length > 0) n = Mid(n, 0, n.length - 1);
		
		if (n.length <= 0) return "";
		return n;
	}
	
	public static function isNumber(t:String):Bool {
		if (Math.isNaN(Std.parseFloat(t))) {
			return false;
		}else{
			return true;
		}	
		return false;
	}
	
	public static function randomletter(uppercase:Bool = false):String {
		if (uppercase) return randomletter(false).toUpperCase();
		return letters[Std.int(Math.random() * 26)];
	}
	
	public static function encodebase64(t:String):String {
		return Base64.encode(haxe.io.Bytes.ofString(t));
	}
	
	public static function decodebase64(t:String):String {
		return Base64.decode(t).toString();
	}
	
	public static function bresenhamline(x0:Int, y0:Int, x1:Int, y1:Int):Void {
		var startx1:Int = x1;
		var starty1:Int = y1;
		bressize = 0;
		var swapXY = Math.abs(y1 - y0) > Math.abs(x1 - x0);
		var tmp:Int;
		
		if (swapXY) {
			// swap x and y
			tmp = x0; x0 = y0; y0 = tmp; // swap x0 and y0
			tmp = x1; x1 = y1; y1 = tmp; // swap x1 and y1
		}
		
		if(x0 > x1) {
			// make sure x0 < x1
			tmp = x0; x0 = x1; x1 = tmp; // swap x0 and x1
			tmp = y0; y0 = y1; y1 = tmp; // swap y0 and y1
		}
		
		var deltax = x1 - x0;
		var deltay = Std.int( Math.abs(y1 - y0));
		var error = Std.int( deltax / 2 );
		var y = y0;
		var ystep = if ( y0 < y1 ) 1 else -1;
		
		if (swapXY) {
			// Y / X
			for (x in x0 ... x1 + 1 ) {
				bresx[bressize] = y;
				bresy[bressize] = x;
				bressize++;
				error -= deltay;
				if ( error < 0 ) {
					y = y + ystep;
					error = error + deltax;
				}
			}
		}else {
			// X / Y
			for ( x in x0 ... x1 + 1 ) {
				bresx[bressize] = x;
				bresy[bressize] = y;
				bressize++;
				
				error -= deltay;
				if ( error < 0 ) {
					y = y + ystep;
					error = error + deltax;
				}
			}
		}
		
		if (startx1 == bresx[0] && starty1 == bresy[0]) {
			for (i in 0 ... bressize) {
				bresswap[i] = bresx[i];
			}
			
			for (i in 0 ... bressize) {
				bresx[i] = bresswap[bressize-i - 1];
			}
			
			for (i in 0 ... bressize) {
				bresswap[i] = bresy[i];
			}
			
			for (i in 0 ... bressize) {
				bresy[i] = bresswap[bressize-i - 1];
			}
		}
	}
	
	public static var letters:Array<String> = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"];
	
	public static var sine:Array<Float> = new Array<Float>();
	public static var cosine:Array<Float> = new Array<Float>();
	public static var longglow:Int;
	public static var longglowdir:Int;
	public static var glow:Int;
	public static var glowdir:Int;
	public static var fastglow:Int;
	public static var fastglowdir:Int;
	public static var slowsine:Int;
	public static var tenseconds:Int;
	public static var tempstring:String;
	
	public static var bresx:Array<Int> = new Array<Int>();
	public static var bresy:Array<Int> = new Array<Int>();
	public static var bresswap:Array<Int> = new Array<Int>();
	public static var bressize:Int;
}
