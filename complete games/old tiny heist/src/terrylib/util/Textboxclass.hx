package terrylib.util;
	
import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;
import terrylib.*;
import haxegon.*;

class Textboxclass{
	public function new() {
		firstcreate();
	}
	
	public function firstcreate():Void {
		//Like clear, only it creates the actual arrays, etc
		for (iter in 0...10) {
			var t:String = ""; 
			line.push(t);
		}
		xp = 0; yp = 0; width = 0; height = 0; 
		numlines = 0; linewidth = 0; lerp = 0; active = false;
		showname = true;
		tbcursor = 0; tbline = 1;
		textboxstate = Textbox.STATE_READY;
		col = 0;
	}
	
	public function clear():Void {
		//Set all values to a default, required for creating a new entity
		for (iter in 0...12) {
			line[iter]="";
		}
		textrect = new Rectangle();
		xp = 0; yp = 0; width = 0; height = 0; 
		numlines = 1; linewidth = 0; lerp = 0; active = true;
		showname = true;
		tbcursor = 0; tbline = 1; //Start at 1 until no-named textboxes are introduced
		textboxstate = Textbox.STATE_READY;
	}
	
	public function centerx():Void { resize();	xp = Std.int((Gfx.screenwidth / 2) - (width / 2));	resize(); }
	public function centery():Void { resize();	yp = Std.int((Gfx.screenheight / 2) - (height / 2)); resize(); }
	
	public function adjust():Void {
		resize();
		if (xp < 3) xp = 3;
		if (yp < 3) yp = 3;
		if (xp + width > Gfx.screenwidth - 3) xp = (Gfx.screenwidth - 3) - width;
		if (yp + height > Gfx.screenheight - 3) yp = (Gfx.screenheight - 3) - height;	
		resize();
	}
	
	public function update():Void {
		if (textboxstate == Textbox.STATE_BOXAPPEARING) {
			lerp = Lerp.to_float(0.0, 1.0, lerptimer, "back_out");
			if (Lerp.justfinished(lerptimer)){
				lerp = 1;
				textboxstate = Textbox.STATE_TEXTAPPEARING;
				tbcursor = 0; tbline = 0;
			}
		}else if (textboxstate == Textbox.STATE_TEXTAPPEARING) {
			tbcursor += 3;
				
			if (tbcursor > line[tbline].length) {
				tbline++; tbcursor = 0;
				if (tbline >= numlines) {
					textboxstate = Textbox.STATE_VISABLE;
				}
			}
		}else if (textboxstate == Textbox.STATE_DISAPPEARING) {
			lerp -= .2; if (lerp <= 0) { lerp = 0; }
			
			if (lerp <= 0) {
				lerp = 0;
				textboxstate = Textbox.STATE_DELETING;
				tbcursor = 0; tbline = 0;
			}
		}
	}
	
	public function remove():Void {
		textboxstate = Textbox.STATE_DISAPPEARING; lerp = 1; //Remove mode
	}
	
	public function removefast():Void {
		textboxstate = Textbox.STATE_DISAPPEARING; lerp = 0.4; //Remove mode
	}
	
	public function resize():Void {
		//Set the width and height to the correct sizes
		//old resize function
		max = 0;
		for (iter in 0...numlines) if (Text.width(line[iter]) > max) max = Std.int(Text.width(line[iter]));
		
		linewidth = max;
		if (showname) {
			width = max + 44;
		}else {
			width = max + 32;
		}
		height = (numlines * 12) + 16;
	}
	
	public function addline(t:String):Void {
		line[numlines] = t;
		numlines++;
		resize();
		if (numlines >= 12) numlines = 0;
	}
	
	//Fundamentals
	public var line:Array<String> = new Array<String>();
	public var xp:Int;
	public var yp:Int;
	public var linewidth:Int;
	public var width:Int;
	public var height:Int;
	public var numlines:Int;
	public var textrect:Rectangle;
	public var active:Bool;
	public var showname:Bool;
	public var tbcursor:Int;
	public var tbline:Int;
	public var textboxstate:Int;
	public var col:Int;
	
	public var lerp:Float; //Alpha values
	public var lerptimer:String;
	
	public var iter:Int;
	public var max:Int;
}
