package visuals;

import entities.Obj;
import haxegon.Gfx;
import haxegon.Text;
import haxegon.Col;
import util.Glow;

class MessageBox{
	public static function drawentitymessages():Void {
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active) {
				if (!Obj.entities[i].invis) {
					if (Obj.entities[i].messagedelay > 0) {
						drawentitymessage(i); 
					}
				}
			}
		}
	}
	
	public static function drawentitymessage(i:Int):Void {
		var x:Int = Obj.entities[i].xp - Camera.x;
		var y:Int = Obj.entities[i].yp - Camera.y - 1;
		
		var playerx:Int;
		var playery:Int;
		if (Obj.getplayer() == -1) {
			playerx = 0;
			playery = 0;
		}else{
			playerx = Obj.entities[Obj.getplayer()].xp - Camera.x;
			playery = Obj.entities[Obj.getplayer()].yp - Camera.y;
		}
			
		x = x - Std.int((Text.width(Obj.entities[i].message) / 12) / 2);
		if (x < 0) x = 0;
		if ((x * 12) + Text.width(Obj.entities[i].message) >= Gfx.screenwidth) x = Std.int((Gfx.screenwidth - Text.width(Obj.entities[i].message)) / 12);
		if (y == -1) y = 1;
		if (y == playery) {
			if (playerx >= x && playerx < x + Obj.entities[i].message.length) {
				y += 2;
				if (y >= 18) y = 18;
			}
		}
		
		Draw.terminalprint(x, y, Obj.entities[i].message, messagecol(Obj.entities[i].messagecol), true, Obj.entities[i].animx + Camera.xoff, Obj.entities[i].animy - 10 + Camera.yoff, messagecolback(Obj.entities[i].messagecol), messagecolborder(Obj.entities[i].messagecol));
	}
	
  public static function textboxcol(type:Int, shade:Int):Int {
		//Color lookup function for textboxes
		switch(type) {
			case 0: //White textbox
				switch(shade) {
					case 0: return Col.rgb(0, 0, 0);
					case 1: return Col.rgb(64, 64, 64);
					case 2: return Col.rgb(192, 192, 192);
				}
			case 1: //Red textbox
				switch(shade) {
					case 0: return Col.rgb(0, 0, 0);
					case 1: return Col.rgb(65, 3, 19);
					case 2: return Col.rgb(255, 31, 41);
				}
			case 2: //Green textbox
				switch(shade) {
					case 0: return Col.rgb(0, 0, 0);
					case 1: return Col.rgb(3, 65, 5);
					case 2: return Col.rgb(31, 255, 84);
				}
			case 3: //Blue textbox
				switch(shade) {
					case 0: return Col.rgb(0, 0, 0);
					case 1: return Col.rgb(3, 37, 65);
					case 2: return Col.rgb(31, 105, 255);
				}
		}
		return Col.rgb(0, 0, 0);
	}
	
	public static function messagecol(t:String):Int {
		switch(t) {
			case "kludge":
				if (Glow.slowsine % 32 >= 16) {
					return Col.rgb(255, 255, 255);
				}else {
					return Col.rgb(224, 224, 224);
				}
			case "white":
				return Col.rgb(255, 255, 255);
			case "shout":
			  if (Glow.slowsine % 32 >= 16) {
					return Col.rgb(255, 255, 255);
				}else {
					return Col.rgb(196, 196, 196);
				}
			case "whisper":
				if (Glow.slowsine % 32 >= 16) {
					return Col.rgb(164, 164, 164);
				}else {
					return Col.rgb(128, 128, 128);
				}
			case "player":
				if (Glow.slowsine % 32 >= 16) {
					return 0xe1fffe;
				}else {
					return 0xFFFFFF;
				}
			case "cash": 
				return Col.rgb(255 - Std.int(Glow.glow / 2), 255 - Std.int(Glow.glow / 2), 64);
			case "key": 
				return Col.rgb(64, 255 - Std.int(Glow.glow / 2), 64);
			case "red": 
				return Col.rgb(255 - Glow.glow, Glow.glow, Glow.glow);
			case "flashing":
			  if (Glow.slowsine % 32 >= 16) {
					return Col.rgb(255 - Glow.glow, 164, 164);
				}else {
					return Col.rgb(255 - Glow.glow, 255, 164);
				}
			case "good":
				if (Glow.slowsine % 32 >= 16) {
					return Col.rgb(164, 255, 164);
				}else{
					return Col.rgb(64, 255, 64);
				}
			case "grayedout":
				return Col.rgb(128, 128, 128);
		}
		return Col.rgb(255, 255, 255);
	}
	
	public static function messagecolback(t:String):Int {
		switch(t) {
			case "white":
				return Col.rgb(32, 32, 32);
			case "red": 
				return Col.rgb(64, 0, 0);
			case "player":
				return 0x697c86;
			case "good":
				return Col.rgb(32, 128, 32);
		}
		return Col.rgb(0, 0, 0);
	}
	
	public static function messagecolborder(t:String):Int {
		switch(t) {
			case "white":
				return Col.rgb(32, 32, 32);
			case "red": 
				return Col.rgb(64, 0, 0);
			case "player":
				return 0xade6fa;
			case "good":
				return Col.rgb(64, 255, 64);
		}
		return Col.rgb(96, 96, 96);
	}
}