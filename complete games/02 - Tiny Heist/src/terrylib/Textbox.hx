package terrylib;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;
import openfl.text.*;
import haxegon.*;
import terrylib.util.*;

class Textbox{
	public static function init():Void {
		for (i in 0...30) {
			var t:Textboxclass = new Textboxclass();
			tb.push(t);
		}
		ntextbox = 0;
		
		txname = ""; activetb = -1;
		keepname = false; nameactive = false;
	}
	
	public static function createtextbox(t:String, xp:Int, yp:Int, c:Int):Void {
		if(ntextbox == 0) {
			//If there are no active textboxes, Z=0;
			m = 0; ntextbox++;
		}else {
			m = ntextbox; ntextbox++;
		}
		
		if (m < 20) {
			tb[m].clear();
			if (t == "") {
				tb[m].showname = false;
				tb[m].numlines = 0;
			}else {
				tb[m].showname = true;	
				tb[m].line[0] = t;			
				tb[m].numlines = 1;
			}
			tb[m].xp = xp;
			if (xp == -1) tb[m].xp = Std.int(Gfx.screenwidthmid - (((t.length / 2) + 1) * 8));
			tb[m].yp = yp;
			tb[m].col = c;
			tb[m].resize();
		}
	}
	
	public static function textboxcleanup():Void {
		var i:Int = ntextbox - 1; while (i >= 0 && !tb[i].active) { ntextbox--; i--; }
	}
	
	public static function textboxcenter():Void {
		tb[m].centerx(); tb[m].centery();
	}
	
	public static function textboxcenterx():Void {
		tb[m].centerx(); 
	}
	
	public static function textboxwidth():Int {
		return tb[m].width; 
	}
	
	public static function textboxmove(xo:Int, yo:Int):Void {
		tb[m].xp += xo; tb[m].yp += yo;
	}
	
	public static function textboxmoveto(xo:Int):Void {
		tb[m].xp = xo;
	}
	
	public static function textboxcentery():Void {
		tb[m].centery();
	}
	
	public static function textboxadjust():Void {
		tb[m].adjust();
	}
	
	public static function textboxposition(speaker:Int):Void {
		speakernum = speaker;
		if (speakernum > -1) {
			//Position textbox relative to speaker entity
			tb[m].resize();
			
			//Ok, we need a actual pixel position on screen first... Red dot is a debugging variable, sorta
			reddotx = Std.int(Obj.entities[speakernum].xp - World.camerax);
			reddoty = Std.int(Obj.entities[speakernum].yp - World.cameray - 4);
			reddotx -= Std.int(tb[m].width / 2);
			
			//If player is facing up, then the textbox is below them. In all other cases, it's above.
			if (Obj.entities[speakernum].dir == 1) {
				reddoty += 32 + 5;
			}else{
				reddoty -= tb[m].height + 5;
			}
			
			tb[m].xp = reddotx;
			tb[m].yp = reddoty;
		}
		
		tb[m].adjust();
	}
	
	public static function addline(t:String):Void {
		//tb[m].addline(t);
		stringbreak = ""; stringbreakcounter = 0; stringbreakline = 0;
		
		while (stringbreakcounter < Text.width(t)) {
			stringbreak += Help.Mid(t, stringbreakcounter);
			//if (len(stringbreak) >= 280) {
			if (Text.width(stringbreak) >= 240) {
				//Ok: stringbreak now contains a chunk of a sentance.
				//We need to work back and find the last space in this, then readjust everything.
				while (Help.Mid(stringbreak, stringbreak.length-1) != " ") {
					stringbreak = Help.Mid(stringbreak, 0, stringbreak.length - 1);
					stringbreakcounter--;
				}
				tb[m].addline(stringbreak);
				stringbreakline++;
				stringbreak = "";
			}
			stringbreakcounter++;
		}
		
		
		//Anything leftover?
		if (Text.width(stringbreak) > 0) {
			tb[m].addline(stringbreak);
			stringbreakline++;
			stringbreak = "";
		}
	}
	
	public static function starttextbox():Void {
		tb[m].textboxstate = STATE_BOXAPPEARING;
		tb[m].lerptimer = "textboxin_" + Help.randomletter() + Help.randomletter();
		Lerp.start(tb[m].lerptimer, 10);
		activetb = m;
	}
	
	public static function textboxremove():Void {
		//Remove all textboxes
		for (i in 0...ntextbox) {
			tb[i].remove();
		}
	}
	
	public static function textboxremovefast():Void {
		//Remove all textboxes
		for (i in 0...ntextbox) {
			tb[i].removefast();
		}
	}
	
	public static function textboxactive():Void {
		//Remove all but the most recent textbox
		for (i in 0...ntextbox) {
			if (m != i) tb[i].remove();
		}
	}
	
	public static function tbprint(cline:Int, tbline:Int, tbcursor:Int, x:Int, y:Int, t:String, r:Int, g:Int=-1, b:Int=-1):Void {
		//Special version of print which automatically handles line positions, tickers, etc
		if (x == -1) x = Std.int(Gfx.screenwidthmid - (Text.width(t) / 2));
		//if (y == -1) y = 56 - ((tbsize - 1) * 4);
		
		if (cline < tbline) {
			//Always draw
			//if (cline == tbsize) t += " _";
			if (g == -1 && b == -1) {
				Text.display(x, y + (cline * 12), t, r);
			}else{
				Text.display(x, y + (cline * 12), t, Col.rgb(r, g, b));
			}
		}else if (cline == tbline) {
			//In the process of drawing
			tempstring = "";
			for (j in 0...t.length) if (tbcursor > j) tempstring += t.charAt(j);
			//tempstring += " _";
			if (g == -1 && b == -1) {
				Text.display(x, y + (cline * 12), tempstring, Col.rgb(Std.int(Col.getred(r) * 0.75), Std.int(Col.getgreen(r) * 0.75), Std.int(Col.getblue(r) * 0.75)));
			}else{
				Text.display(x, y + (cline * 12), tempstring, Col.rgb(Std.int(r * 0.75), Std.int(g * 0.75), Std.int(b * 0.75)));
			}
		}
	}
	
	public static function updatetextboxes():Void {
		//Textbox animations
		for (i in 0...ntextbox) {
			tb[i].update();
			
			//Sound effects/Fast text progression here
			if (tb[i].textboxstate == STATE_TEXTAPPEARING) {
				//if(Key.gamekeyheld) tb[i].tbcursor+=4;
				talktimer--;
				if(talktimer<=0){
					//if(Music.usingtickertext) Music.playef("tickertext");
					talktimer = 4;
				}
			}else if (tb[i].textboxstate == STATE_DELETING) {
				activetb = -1;
				tb[i].textboxstate = STATE_READY;
				tb[i].active = false;
			}
		}
	}
	
	public static var m:Int;
	public static var activetb:Int;
	public static var ntextbox:Int;
	public static var tb:Array<Textboxclass> = new Array<Textboxclass>();
	public static var txname:String;
	public static var tempstring:String;
	public static var keepname:Bool;
	public static var nameactive:Bool;
	public static var stringbreak:String;
	public static var stringbreakcounter:Int;
	public static var stringbreakline:Int;
	public static var speaker:String;
	public static var speakernum:Int;
	public static var activenpc:Int;
	public static var activenpcscript:String;
	public static var reddotx:Int = 0;
	public static var reddoty:Int = 0;
	public static var talktimer:Int = 0;
	public static var col:Int = 0;
	
	public static var STATE_READY:Int = 0;
	public static var STATE_BOXAPPEARING:Int = 1;
	public static var STATE_TEXTAPPEARING:Int = 2;
	public static var STATE_VISABLE:Int = 3;
	public static var STATE_DISAPPEARING:Int = 4;
	public static var STATE_DELETING:Int = 5;
	
	public static var TEXTBORDER:Int = 0;
	public static var TEXTBACKING:Int = 1;
	public static var TEXTHIGHLIGHT:Int = 2;
}