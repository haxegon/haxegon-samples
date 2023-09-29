package world;

import haxegon.*;
import entities.EnemyType;
import gamecontrol.Game;
import visuals.Draw;
import modernversion.AIDirector;
import modernversion.Modern;
import world.World;
import entities.Obj;
import util.Rand;
import util.Glow;
import util.Lerp;
import util.Direction;
import util.BresenhamLine;
import visuals.ScreenEffects;
	
class Localworld {
	public static var BACKGROUND:Int = 0;
	public static var FLOOR:Int = 1;
	public static var BLOOD:Int = 2;
	public static var WALL:Int = 3;
	public static var DOOR:Int = 4;
	public static var KEY:Int = 5;
	public static var OPENDOOR:Int = 6;
	public static var STAIRS:Int = 7;
	public static var RUBBLE:Int = 8;
	public static var EMPTYBACKGROUND:Int = 9;
	public static var ENTRANCE:Int = 10;
	public static var OUTSIDE_GROUND:Int = 11;
	public static var OUTSIDE_EDGE:Int = 12;
	public static var OUTSIDE_ABYSS:Int = 13;
	public static var LOCKEDDOOR:Int = 14;
	public static var CONSIDERLOCKEDEXIT_A:Int = 15;
	public static var CONSIDERLOCKEDEXIT_B:Int = 16;
	public static var CONSIDERLOCKEDDOOR:Int = 17;
	public static var BANANAPEEL:Int = 18;
	public static var DEBRIS:Int = 19;
	public static var ROOFSIDE:Int = 20;
	public static var ROOFBACKGROUND:Int = 21;
	public static var ROOFSTARS:Int = 22;
	
	public static var numworldblocks:Int = 14;
	
	public static function init():Void {
		for (i in 0 ... 23) {
			worldblock.push(new Worldblockclass());
		}
		
		worldblock[BACKGROUND].set(0, 0, Col.BLACK, Game.backgroundcolour);
		worldblock[EMPTYBACKGROUND].set(0, 0, Col.BLACK, Game.backgroundcolour);
		worldblock[BLOOD].set(c("#"), c("#"), Col.rgb(164, 164, 164), Col.rgb(140, 140, 140));
		worldblock[DOOR].set(10, 10, 0xea7a30, 0xa04c14);
		worldblock[LOCKEDDOOR].set(11, 11, 0x53d61e, 0x3ca014);
		worldblock[KEY].set(12, 12, Col.rgb(128, 255, 128), Col.rgb(96, 255, 96));
		worldblock[OPENDOOR].set(9, 9, 0xea7a30, 0xa04c14);
		worldblock[STAIRS].set(44, 44, 0xe77af6, 0xe77af6);
		worldblock[DEBRIS].set(34, 34, Col.rgb(164, 164, 164), Col.rgb(140, 140, 140));
		worldblock[RUBBLE].set(c("#"), c("#"), Col.rgb(164, 164, 164), Col.rgb(140, 140, 140));
		worldblock[ROOFSIDE].set(201, 201, 0x5055be, 0x233a9f);
		worldblock[ROOFBACKGROUND].set(17, 17, 0x000022, 0x000022);
		worldblock[ROOFSTARS].set(23, 23, 0xf8ed8e, 0xf8ed8e);
		worldblock[BANANAPEEL].set(161, 161, 0xf8f5c2, 0xe9e573);
		worldblock[ENTRANCE].set(45, 45, 0xf6f27a, 0xf6f27a);
		
		worldblock[OUTSIDE_GROUND].set(228, 228, 0xad30ba, 0x6b6b6b);
		worldblock[OUTSIDE_EDGE].set(195, 195, 0xad30ba, 0x6b6b6b);
		worldblock[OUTSIDE_ABYSS].set(17, 17, Col.rgb(16, 0, 0), Col.rgb(16, 0, 0), 0x220000, Col.BLACK);
		
		worldblock[BACKGROUND].flamable = -1;
		worldblock[OUTSIDE_EDGE].flamable = -1;
		worldblock[OUTSIDE_ABYSS].flamable = -1;
		worldblock[ROOFBACKGROUND].flamable = -1;
		worldblock[ROOFSTARS].flamable = -1;
		worldblock[ROOFSIDE].flamable = -1;
		
		worldblock[OUTSIDE_GROUND].flamable = 15;
		worldblock[FLOOR].flamable = 15;
		worldblock[DEBRIS].flamable = 15;
		worldblock[BLOOD].flamable = 15;
		worldblock[RUBBLE].flamable = 15;
		worldblock[BANANAPEEL].flamable = 15;
		
		changepalette("blue", 0);
	}
	
	public static function changepalette(pal:String, walltile:Int = 0):Void {
		switch(pal) {
			case "darkred":
				//untreated
				worldblock[WALL].set(192 + (walltile * 2), 192 + (walltile * 2), 0xfff7fd, 0xfd3d47);	
				worldblock[FLOOR].set(224 + (walltile * 2), 224 + (walltile * 2), 0xff4714, 0xc93600);
				worldblock[DEBRIS].setcol(0xff4714, 0xc93600);
				setbackcolours(0x7a1f00, 0x2c0100);
				setshadecolours(0.8, 0.4, 0.4);
			case "red":
				//untreated
				worldblock[WALL].set(192 + (walltile * 2), 192 + (walltile * 2), 0xedcad0, 0xc75881);	
				worldblock[FLOOR].set(224 + (walltile * 2), 224 + (walltile * 2), 0xd53746, 0xab2b31);
				worldblock[DEBRIS].setcol(0xd53746, 0xab2b31);
				setbackcolours(0x79112f, 0x451121);
				setshadecolours(0.8, 0.4, 0.4);
			case "green":
				//untreated
				worldblock[WALL].set(192 + (walltile * 2), 192 + (walltile * 2), 0xd0edca, 0x81c758);	
				worldblock[FLOOR].set(224 + (walltile * 2), 224 + (walltile * 2), 0x3dba30, 0x2a9525);
				worldblock[DEBRIS].setcol(0x3dba30, 0x2a9525);
				setbackcolours(0x3d7a22, 0x1c3c0e);
				setshadecolours(0.4, 0.8, 0.4);
				//wall unlit: 0x81c758
				//floor unlit: 0x2a9525
			case "blue":				
				//untreated
				worldblock[WALL].set(192 + (walltile * 2), 192 + (walltile * 2), 0xcad5ed, 0x5892c7);	
				worldblock[FLOOR].set(224 + (walltile * 2), 224 + (walltile * 2), 0x375ed5, 0x2b45ab);
				worldblock[DEBRIS].setcol(0x375ed5, 0x2b45ab);
				setbackcolours(0x113f79, 0x112945);
				setshadecolours(0.4, 0.4, 0.8);
				//treated check:
				//wall unlit: 0x5892c7
				//wall lit: 0xcad5ed
				//floor unlit: 0x2b45ab
				//floor lit: 0x375ed5
			case "yellow":
				//untreated
				worldblock[WALL].set(192 + (walltile * 2), 192 + (walltile * 2), 0xe7f4c5, 0xd5e13d);	
				worldblock[FLOOR].set(224 + (walltile * 2), 224 + (walltile * 2), 0xbcc53a, 0x90a428);
				worldblock[DEBRIS].setcol(0xbcc53a, 0x90a428);
				setbackcolours(0x6a601a, 0x413c10);
				setshadecolours(0.8, 0.8, 0.4);
			case "purple":
				//untreated
				worldblock[WALL].set(192 + (walltile * 2), 192 + (walltile * 2), 0xe7caed, 0x9e58c7);	
				worldblock[FLOOR].set(224 + (walltile * 2), 224 + (walltile * 2), 0xad30ba, 0x902595);
				worldblock[DEBRIS].setcol(0xad30ba, 0x902595);
				setbackcolours(0x5f227a, 0x2e0e3c);
				setshadecolours(Col.getred(0xba50bd) / Col.getred(0xe7caed), 
				                Col.getgreen(0xba50bd) / Col.getgreen(0xe7caed), 
												Col.getblue(0xba50bd) / Col.getblue(0xe7caed));
				//wall unlit: 0x9e58c7
				//wall lit: 0xe7caed
				//floor unlit: 0x902595
				//floor lit: 0xad30ba
			case "cyan":
				//untreated
				worldblock[WALL].set(192 + (walltile * 2), 192 + (walltile * 2), 0xc5def4, 0x3db7e2);	
				worldblock[FLOOR].set(224 + (walltile * 2), 224 + (walltile * 2), 0x1184fb, 0x0b5ccb);
				worldblock[DEBRIS].setcol(0x1184fb, 0x0b5ccb);
				setbackcolours(0x005e8b, 0x053a52);
				setshadecolours(0.4, 0.8, 0.8);
			case "gray", "grey":
				//untreated
				worldblock[WALL].set(192 + (walltile * 2), 192 + (walltile * 2), 0xdcdcdc, 0x909090);	
				worldblock[FLOOR].set(224 + (walltile * 2), 224 + (walltile * 2), 0x868686, 0x6b6b6b);
				worldblock[DEBRIS].setcol(0x868686, 0x6b6b6b);
				setbackcolours(0x454545, 0x2c2c2c);
				setshadecolours(0.6, 0.6, 0.6);
				//wall unlit: 0x909090
				//wall lit: 0xdcdcdc
				//floor unlit: 0x6b6b6b
				//floor lit: 0xad30ba
			default:
				//untreated
				worldblock[WALL].set(192 + (walltile * 2), 192 + (walltile * 2), 0xcad5ed, 0x5892c7);	
				worldblock[FLOOR].set(224 + (walltile * 2), 224 + (walltile * 2), 0x375ed5, 0x2b45ab);
				worldblock[DEBRIS].setcol(0x375ed5, 0x2b45ab);
				setbackcolours(0x113f79, 0x112945);
				setshadecolours(0.4, 0.4, 0.8);
		}
	}
	
	public static function setshadecolours(r:Float, g:Float, b:Float):Void {
	  //For wall shading only	
		Game.redwallshade = r;
		Game.greenwallshade = g;
		Game.bluewallshade = b;
	}
	
	public static function setbackcolours(lit:Int, shade:Int):Void {
		Game.backgroundcolour = shade;
		for (i in 0 ... numworldblocks) {
			worldblock[i].back_lit = lit;
			worldblock[i].back_fog = shade;
		}
	}
	
	public static function sc(t:Int):Void { //Set collision
	  World.sc(t);
	}
	
	public static function initcollisionarray():Void {
		//Set collision info for entire map
		sc(BACKGROUND);
		sc(WALL);
		sc(DOOR);
		sc(LOCKEDDOOR);
		
		sc(OUTSIDE_EDGE);
		sc(OUTSIDE_ABYSS);
	}
	
	public static function c(t:String):Int {
		return t.charCodeAt(0);
	}
	
	public static function charmap(x:Int, y:Int, t:Int):Int {
		light = lightat(x, y);
		fog = fogat(x, y);
		highlight = highlightat(x, y);
		laser = laserat(x, y);
		fire = fireat(x, y);
		//Return the ASCII character to use for each wall type
		if (fire >= 100) {
			if (Draw.getperlin(((x*16) + Std.int(Glow.longglow/2)), ((y*16) + Std.int(Glow.longglow))) > 150) {
		  	return 37 + Std.int((flash.Lib.getTimer() % 600) / 200);
			}
		}
		
		if (light == 1 && fog == 1) {
			return worldblock[t].charcode_lit;
		}else if (fog == 1) {
			return worldblock[t].charcode_fog;
		}else{
			return 0;
		}
		return 0;
	}
	
	public static function colourmap_shade(x:Int, y:Int, t:Int):Int {
		var c:Int = colourmap(x, y, t);
		
		tr = Col.getred(c);
		tg = Col.getgreen(c);
		tb = Col.getblue(c);
		
		tr = Std.int(tr * Game.redwallshade);
		tg = Std.int(tg * Game.greenwallshade);
		tb = Std.int(tb * Game.bluewallshade);
		
		return Col.rgb(tr, tg, tb);
	}
	
	//0 - regular, 1 - lit, 2 or more - highlight/fire something else
	public static var foregroundcolour_needschanging:Int;
	public static function colourmap(x:Int, y:Int, t:Int):Int {
		foregroundcolour_needschanging = 2;
		
		light = lightat(x, y);
		fog = fogat(x, y);
		highlight = highlightat(x, y);
		laser = laserat(x, y);
		fire = fireat(x, y);
		//Return the RGB value to use for each wall type
		if (fire >= 100 && fog == 1) {
			fire = Std.int(Math.random() * 64) + 64;
			fire2 = 0;
			fire3 = 0;
			//firecol = Rand.int(1, 10);
			firecol = Std.int(Draw.getperlin((x * 16) + Std.int(Glow.longglow / 2), (y * 16) + Std.int(Glow.longglow)) / 20);
			if (firecol == 10) {
				fire = 255;
				fire2 = fire;
				fire3 = fire;
			}else if (firecol == 9 || firecol == 8) {
				fire = 255;
				fire2 = fire;
			}else if (firecol == 7 || firecol == 6) {
				fire = 255;
			}
			if (highlight == 1) {
				tr = Std.int(Math.min(Col.getred(worldblock[t].front_lit) * (1 + (Lerp.from_value(0.8, 0.0, Game.highlightcooldown, 20, "sine_in"))), 255));
				tg = Std.int(Math.min(Col.getgreen(worldblock[t].front_lit) * (1 + (Lerp.from_value(0.8, 0.0, Game.highlightcooldown, 20, "sine_in"))), 255));
				tb = Std.int(Math.min(Col.getblue(worldblock[t].front_lit) * (1 + (Lerp.from_value(0.8, 0.0, Game.highlightcooldown, 20, "sine_in"))), 255));
				return Draw.addcolours(Col.rgb(tr, tg, tb), Col.rgb(fire, fire2, fire3));
		  }else if (laser == 1) {
				tg = Std.int(Math.min(Col.getgreen(worldblock[t].front_lit)*0.2, 255));
				tb = Std.int(Math.min(Col.getblue(worldblock[t].front_lit)*0.2, 255));
				return Draw.addcolours(Col.rgb(255, tg, tb), Col.rgb(fire, fire2, fire3));
			}else if (light == 1) {
				return Draw.addcolours(worldblock[t].front_lit, Col.rgb(fire, fire2, fire3));
			}else{
				return Col.rgb(fire, fire2, fire3);
			}
		}else if (highlight == 1 && fog == 1) {
			tr = Std.int(Math.min(Col.getred(worldblock[t].front_lit) * (1 + (Lerp.from_value(0.8, 0.0, Game.highlightcooldown, 20, "sine_in"))), 255));
			tg = Std.int(Math.min(Col.getgreen(worldblock[t].front_lit) * (1 + (Lerp.from_value(0.8, 0.0, Game.highlightcooldown, 20, "sine_in"))), 255));
			tb = Std.int(Math.min(Col.getblue(worldblock[t].front_lit) * (1 + (Lerp.from_value(0.8, 0.0, Game.highlightcooldown, 20, "sine_in"))), 255));
			return Col.rgb(tr, tg, tb);
		}else if (laser == 1 && fog == 1) {
			tg = Std.int(Math.min(Col.getgreen(worldblock[t].front_lit)*0.2, 255));
			tb = Std.int(Math.min(Col.getblue(worldblock[t].front_lit)*0.2, 255));
			return Col.rgb(255, tg, tb);
		}else if (light == 1 && fog == 1) {
			foregroundcolour_needschanging = 1;
			return worldblock[t].front_lit;
		}else if (fog == 1) {
			foregroundcolour_needschanging = 0;
			return worldblock[t].front_fog;
		}else{
			return 0;
		}
		
		foregroundcolour_needschanging = 0;
		return 0;
	}
	
	public static var backgroundcolour_needschanging:Bool;
	public static function backcolourmap(x:Int, y:Int, t:Int):Int {
		backgroundcolour_needschanging = true;
		
		light = lightat(x, y);
		fog = fogat(x, y);
		highlight = highlightat(x, y);
		laser = laserat(x, y);
		fire = fireat(x, y);
		//Return the RGB value to use for each BACKGROUND wall type
		if (fire >= 100 && fog == 1) {
			fire = Std.int(Math.random() * 16) + 32;
			if (highlight == 1) {
				return Col.rgb(Std.int(Math.min(fire * (1 + (Lerp.from_value(0.8, 0.0, Game.highlightcooldown, 20, "sine_in"))), 255)), 0, 0);
		  }else if (laser == 1) {
				tg = Std.int(Math.min(Col.getgreen(worldblock[t].front_lit)*0.2, 255));
				tb = Std.int(Math.min(Col.getblue(worldblock[t].front_lit)*0.2, 255));
				return Draw.addcolours(Col.rgb(64, tg, tb), Col.rgb(fire, 0, 0));
			}else if (light == 1) {
				return Draw.addcolours(worldblock[t].back_lit, Col.rgb(fire, 0, 0));
			}else{
				return Col.rgb(fire, 0, 0);
			}
		}else if (highlight == 1 && fog == 1) {
			tr = Std.int(Math.min(Col.getred(worldblock[t].back_lit) * (1 + (Lerp.from_value(0.8, 0.0, Game.highlightcooldown, 20, "sine_in"))), 255));
			tg = Std.int(Math.min(Col.getgreen(worldblock[t].back_lit) * (1 + (Lerp.from_value(0.8, 0.0, Game.highlightcooldown, 20, "sine_in"))), 255));
			tb = Std.int(Math.min(Col.getblue(worldblock[t].back_lit) * (1 + (Lerp.from_value(0.8, 0.0, Game.highlightcooldown, 20, "sine_in"))), 255));
			return Col.rgb(tr, tg, tb);
		}else if (laser == 1 && fog == 1) {
			tg = Std.int(Math.min(Col.getgreen(worldblock[t].front_lit)*0.2, 255));
			tb = Std.int(Math.min(Col.getblue(worldblock[t].front_lit)*0.2, 255));
			return Col.rgb(64, tg, tb);
		}else if (light == 1 && fog == 1) {
			return worldblock[t].back_lit;
		}else if (fog == 1) {
			/*
			//Show heatmap for testing
			var redthing:Int = 255 - (heatmapat(x, y) * 6);
			if (redthing < 0) redthing = 0;
			return Col.rgb(redthing,  Std.int(redthing/2), 0);
			*/
			backgroundcolour_needschanging = false;
			return worldblock[t].back_fog;
		}
		
		backgroundcolour_needschanging = false;
		return Game.backgroundcolour;
	}
	
	public static function setroomfog(t:Int):Void {
		for (j in 0 ... World.mapheight) {
			for (i in 0 ... World.mapwidth) {
				World.fog[i + (j * World.mapwidth)] = t;
			}
		}
	}
	
	public static function clearlighting():Void {
		for (j in 0 ... World.mapheight) {
			for (i in 0 ... World.mapwidth) {
				World.lighting[i + (j * World.mapwidth)] = 0;
			}
		}
	}
	
	public static function clearhighlight():Void {
		for (j in 0 ... World.mapheight) {
			for (i in 0 ... World.mapwidth) {
				World.highlight[i + (j * World.mapwidth)] = 0;
			}
		}
	}
	
	public static function clearlaser():Void {
		for (j in 0 ... World.mapheight) {
			for (i in 0 ... World.mapwidth) {
				World.laser[i + (j * World.mapwidth)] = 0;
			}
		}
	}
	
	public static function lightpoint(x:Int, y:Int, ent:Int):Void {
		if (Geom.inbox(x, y, 0, 0, World.mapwidth, World.mapheight)) {
			World.lighting[x + (y * World.mapwidth)] = 1;
			if (x == playerx && y == playery) {
				if (ent > -1) {
					alertedtoplayer(ent);
					hasplayerinsight(ent);
				}
			}
		}
	}
	
	/** True if any tile on the map is outright on fire. Things heating up don't count. */
	public static function checkforfire():Bool {
		for (j in 0 ... World.mapheight) {
			for (i in 0 ... World.mapwidth) {
				if (fireat(i, j) >= 100) {
					return true;
				}
			}
		}
		return false;
	}
	
	/** Put everyone out */
	public static function clearfire():Void {
		for (j in 0 ... World.mapheight) {
			for (i in 0 ... World.mapwidth) {
				World.fire[i + (j * World.mapwidth)] = 0;
			}
		}
		onfire = false;
	}
	
	/** Bwahahaha! */
	public static function incinerate():Void {
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active) {
				if (Obj.entities[i].rule == "player") {
					if (fireat(Obj.entities[i].xp, Obj.entities[i].yp) >= 100) {
						if (!Obj.entities[i].fireproof) {
							Game.hurtplayer(Direction.NONE);
							Game.checkifplayerdead();
							updatelighting();
						}
					}
				}else if (Obj.entities[i].rule == "item") {
					if (fireat(Obj.entities[i].xp, Obj.entities[i].yp) >= 100) {
						Obj.entities[i].active = false;
					}
				}else if (Obj.entities[i].rule == "enemy") {
					if (fireat(Obj.entities[i].xp, Obj.entities[i].yp) >= 100) {
						if (!Obj.entities[i].fireproof) {
							Game.killenemy(i);
						}
					}
				}else if (Obj.entities[i].rule == "shopkeeper") {
					if (fireat(Obj.entities[i].xp, Obj.entities[i].yp) >= 100) {					
						ScreenEffects.screenshake = 10;
						Obj.entities[i].active = false;
					}
				}
			}
		}
	}
	
	public static function startfire(x:Int, y:Int):Void {
		if (Geom.inbox(x, y, 0, 0, World.mapwidth, World.mapheight)) {
			World.fire[x + (y * World.mapwidth)] = 100;
			firepoint(x - 1, y - 1); 	firepoint(x, y - 1); firepoint(x + 1, y - 1);
			firepoint(x - 1, y); 	firepoint(x, y); firepoint(x + 1, y);
			firepoint(x - 1, y + 1); 	firepoint(x, y + 1); firepoint(x + 1, y + 1);
		}
		onfire = true;
	}
	
	public static function extingushfire(x:Int, y:Int):Void {
		if (Geom.inbox(x, y, 0, 0, World.mapwidth, World.mapheight)) {
			World.fire[x + (y * World.mapwidth)] = 0;
		}
		if (!checkforfire()) {
			clearfire();
		}
	}
	
	public static function extingushfireblock(x:Int, y:Int):Void {
		for (j in -2 ... 3) {
			for (i in -2 ... 3) {
				if (Geom.inbox(x + i, y + j, 0, 0, World.mapwidth, World.mapheight)) {
					World.fire[x + i + ((y + j) * World.mapwidth)] = 0;
				}
			}
		}
		
		if (!checkforfire()) {
			clearfire();
		}
	}
	
	public static function supressfire():Void {
		for (j in 0 ... World.mapheight) {
			for (i in 0 ... World.mapwidth) {
				if (World.fire[i + (j * World.mapwidth)] < 100) {
					World.fire[i + (j * World.mapwidth)] = 0;
				}
			}
		}
		
		for (j in 0 ... World.mapheight) {
			for (i in 0 ... World.mapwidth) {
				if (World.fire[i + (j * World.mapwidth)] >= 100) {
					firepoint(i - 1, j - 1); 	firepoint(i, j - 1); firepoint(i + 1, j - 1);
					firepoint(i - 1, j); 	    firepoint(i, j);     firepoint(i + 1, j);
					firepoint(i - 1, j + 1); 	firepoint(i, j + 1); firepoint(i + 1, j + 1);
				}
			}
		}
	}
	
	public static function fireextinguisher_checkforenemy(x:Int, y:Int):Void {
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active) {
				if (Obj.entities[i].rule == "enemy") {
					if (Obj.entities[i].type == EnemyType.FIREMAN) {
						if(Obj.entities[i].xp == x && Obj.entities[i].yp == y){
							Obj.entities[i].setmessage(Rand.ppickstring("Stop!", "No!!!", "Hiss!!!"), "flashing"); 
							Game.stunenemy(i, 20);
						}
					}
				}
			}
		}
	}
	
	public static function fireextinguisher_explode(x:Int, y:Int, rad:Int):Void {
		//An explosion! If anyone is in it, they're destroyed.
		for (k in -rad ... rad + 1) {
			for (j in -rad ... rad + 1) {
				if (Math.sqrt(Math.pow(j, 2) + Math.pow(k, 2)) <= rad) {
					if (World.fire[x + j + ((y + k) * World.mapwidth)] > 0){
						Localworld.highlightpoint(x + j, y + k);
					}
				}
				if (Math.sqrt(Math.pow(j, 2) + Math.pow(k, 2)) <= rad) {
					World.fire[x + j + ((y + k) * World.mapwidth)] = 0;
					if (World.at(x + j, y + k) == Localworld.DEBRIS) {
						World.placetile(x + j, y + k, Localworld.FLOOR);	
					}
				}
			}
		}
	}
	
	public static function fireextinguisher(x:Int, y:Int, dir:Int, power:Int):Void {
		if (power > 0) {
			if (Geom.inbox(x, y, 0, 0, World.mapwidth, World.mapheight)) {
				World.fire[x + (y * World.mapwidth)] = 0;
				if (World.at(x, y) == Localworld.DEBRIS) {
				  World.placetile(x, y, Localworld.FLOOR);	
				}
				var temp:Int = Game.checkforenemy(x, y);
				if (temp >= 0) {
					Game.stunenemy(temp, Modern.STANDARDSTUNTIME);
					ScreenEffects.screenshake = 10;
				}
				highlightpoint(x, y);
				fireextinguisher_checkforenemy(x, y);
			}
			fireextinguisher(x + xstep(dir), y + ystep(dir), dir, power - 1);
			fireextinguisher(x + xstep(dir,2) + xstep(Direction.clockwise(dir)), y + ystep(dir,2) + ystep(Direction.clockwise(dir)), dir, power - 1);
			fireextinguisher(x + xstep(dir,2) + xstep(Direction.anticlockwise(dir)), y + ystep(dir,2) + ystep(Direction.anticlockwise(dir)), dir, power - 1);
		}
	}
	
	public static function flamethrower(x:Int, y:Int, dir:Int, power:Int):Void {
		if (power > 0) {
			if (Geom.inbox(x, y, 0, 0, World.mapwidth, World.mapheight)) {
				startfire(x, y);
				highlightpoint(x, y);
			}
			flamethrower(x + xstep(dir), y + ystep(dir), dir, power - 1);
			flamethrower(x + xstep(dir,2) + xstep(Direction.clockwise(dir)), y + ystep(dir,2) + ystep(Direction.clockwise(dir)), dir, power - 1);
			flamethrower(x + xstep(dir,2) + xstep(Direction.anticlockwise(dir)), y + ystep(dir,2) + ystep(Direction.anticlockwise(dir)), dir, power - 1);
		}
	}
	
	public static function firepoint(x:Int, y:Int):Void {
		if (Geom.inbox(x, y, 0, 0, World.mapwidth, World.mapheight)) {
			if (World.fire[x + (y * World.mapwidth)] < 100) {
				World.fire[x + (y * World.mapwidth)]++;
				if (worldblock[World.at(x, y)].flamable > -1) {
					if (World.fire[x + (y * World.mapwidth)] >= worldblock[World.at(x, y)].flamable) {
						if (Rand.pint(1, 5) == 5) {
							//Try a little randomness
							World.fire[x + (y * World.mapwidth)] = 0;
						}else{
							//Spread!
							World.fire[x + (y * World.mapwidth)] = 100;
							firepoint(x - 1, y - 1); 	firepoint(x, y - 1); firepoint(x + 1, y - 1);
							firepoint(x - 1, y); 	firepoint(x, y); firepoint(x + 1, y);
							firepoint(x - 1, y + 1); 	firepoint(x, y + 1); firepoint(x + 1, y + 1);
						}
					}
				}
			}
		}
	}
	
	public static function updatefire():Void {
		if (onfire) {
			for (j in 0 ... World.mapheight) {
				for (i in 0 ... World.mapwidth) {
					if (fireat(i, j) > 0) firepoint(i, j);
				}
			}
		}
	}
	
	
	public static function fireat(x:Int, y:Int):Int {
		if (x >= 0 && y >= 0 && x < World.mapwidth && y < World.mapheight) {
			return World.fire[x + (y * World.mapwidth)];
		}
		return 0;
	}
	
	
	
	public static function highlightpoint(x:Int, y:Int):Void {
		if (Geom.inbox(x, y, 0, 0, World.mapwidth, World.mapheight)) {
			World.highlight[x + (y * World.mapwidth)] = 1;
		}
		
		Game.highlightcooldown = 20;
	}
	
	
	public static function laserpoint(x:Int, y:Int, ent:Int):Void {
		if (Geom.inbox(x, y, 0, 0, World.mapwidth, World.mapheight)) {
			World.laser[x + (y * World.mapwidth)] = 1;
			if (x == playerx && y == playery) {
				if (ent > -1) {
					alertedtoplayer(ent);
					hasplayerinsight(ent);
				}
			}
		}
	}

	public static function laserat(x:Int, y:Int):Int {
		if (x >= 0 && y >= 0 && x < World.mapwidth && y < World.mapheight) {
			return World.laser[x + (y * World.mapwidth)];
		}
		return 0;
	}
	
	public static function lightat(x:Int, y:Int):Int {
		if (x >= 0 && y >= 0 && x < World.mapwidth && y < World.mapheight) {
			return World.lighting[x + (y * World.mapwidth)];
		}
		return 0;
	}
	
	public static function fogpoint(x:Int, y:Int):Void {
		if (Geom.inbox(x, y, 0, 0, World.mapwidth, World.mapheight)) {
			World.fog[x + (y * World.mapwidth)] = 1;
		}
	}
	
	public static function fogat(x:Int, y:Int):Int {
		if (x >= 0 && y >= 0 && x < World.mapwidth && y < World.mapheight) {
			return World.fog[x + (y * World.mapwidth)];
		}
		return 0;
	}
	
	
	public static function highlightat(x:Int, y:Int):Int {
		if (x >= 0 && y >= 0 && x < World.mapwidth && y < World.mapheight) {
			return World.highlight[x + (y * World.mapwidth)];
		}
		return 0;
	}

	public static function xstep(t:Int, dif:Int = 1):Int {
		if (t == Direction.LEFT) return -dif;
		if (t == Direction.RIGHT) return dif;
		return 0;
	}
	
	public static function ystep(t:Int, dif:Int = 1):Int {
		if (t == Direction.UP) return -dif;
		if (t == Direction.DOWN) return dif;
		return 0;
	}
	
	public static function explode(x:Int, y:Int, rad:Int, hurtplayer:Bool = true):Void {
		//An explosion! If anyone is in it, they're destroyed.
		for (k in -rad ... rad + 1) {
			for (j in -rad ... rad + 1) {
				if (Math.sqrt(Math.pow(j, 2) + Math.pow(k, 2)) <= rad) {
					Localworld.highlightpoint(x + j, y + k);
				}
				if (Math.sqrt(Math.pow(j, 2) + Math.pow(k, 2)) <= rad) {
					var protectedsquares:Bool = true;
					if (World.at(x + j, y + k) == Localworld.ENTRANCE) protectedsquares = false;
					if (World.at(x + j, y + k) == Localworld.STAIRS) protectedsquares = false;
					if (World.at(x + j, y + k) == Localworld.KEY) protectedsquares = false;
					if (World.at(x + j, y + k) == Localworld.ROOFBACKGROUND) protectedsquares = false;
					if (World.at(x + j, y + k) == Localworld.ROOFSIDE) protectedsquares = false;
					if (World.at(x + j, y + k) == Localworld.ROOFSTARS) protectedsquares = false;
					if(protectedsquares){
						World.placetile(x + j, y + k, Rand.ppickint(Localworld.RUBBLE, Localworld.EMPTYBACKGROUND, Localworld.EMPTYBACKGROUND));
						if (Math.sqrt(Math.pow(j, 2) + Math.pow(k, 2)) <= Std.int((rad * 2) / 3)) {
							World.placetile(x + j, y + k, Localworld.EMPTYBACKGROUND);
						}
					}
				}
			}
		}
		
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active) {
				if (Generator.closestroom_getdist_straight(x, y, Obj.entities[i].xp, Obj.entities[i].yp) <= rad) {
					if (Obj.entities[i].rule == "enemy") {
					  Game.killenemy(i);
					}else if (Obj.entities[i].rule == "player" && hurtplayer) {
						Game.hurtplayer(Direction.NONE);
						Game.checkifplayerdead();
					}
				}
			}
		}
		
		ScreenEffects.screenshake = 10;
	}
	
	public static function drill(x:Int, y:Int, dir:Int):Void {
		//Drill a hole in the wall!
		var drillcomplete:Bool = false;
		while(Geom.inbox(x, y, 0, 0, World.mapwidth, World.mapheight) && !drillcomplete) {
			if (World.at(x, y) == WALL || World.at(x, y) == BACKGROUND) {
				World.placetile(x, y, Random.pick([DEBRIS, DEBRIS, FLOOR]));
				if (World.at(x + xstep(Direction.clockwise(dir)), y + ystep(Direction.clockwise(dir))) == BACKGROUND) {
					World.placetile(x + xstep(Direction.clockwise(dir)), y + ystep(Direction.clockwise(dir)), WALL);
				}
				if (World.at(x + xstep(Direction.anticlockwise(dir)), y + ystep(Direction.anticlockwise(dir))) == BACKGROUND) {
					World.placetile(x + xstep(Direction.anticlockwise(dir)), y + ystep(Direction.anticlockwise(dir)), WALL);
				}
				x += xstep(dir);
				y += ystep(dir);
			}else{
				drillcomplete = true;
			}
		}
	}
	
	public static function tinydirectionallaser(x:Int, y:Int, dir:Int, ent:Int, range:Int):Void {
		if (Geom.inbox(x, y, 0, 0, World.mapwidth, World.mapheight) && range != 0) {
			if (!World.collide(x, y)) {
				laserpoint(x, y, ent);
				tinydirectionallaser(x + xstep(dir), y + ystep(dir), dir, ent, range - 1);
			}else {
				laserpoint(x, y, ent);
			}
		}
	}
	
	public static function tinydirectionallight(x:Int, y:Int, dir:Int, ent:Int, range:Int):Void {
		//Light a point recusively
		if (Geom.inbox(x, y, 0, 0, World.mapwidth, World.mapheight) && range != 0) {
			if (!World.collide(x, y)) {
				lightpoint(x, y, ent);
				tinydirectionallight(x + xstep(dir), y + ystep(dir), dir, ent, range - 1);
			}else {
				lightpoint(x, y, ent);
			}
		}
	}
	
	public static function raytrace(x:Int, y:Int, dir:Float, power:Int, ent:Int):Void {
	  BresenhamLine.traceline(x, y, Std.int(x + Math.cos(BresenhamLine.torad(dir)) * power * 2),  Std.int(y + Math.sin(BresenhamLine.torad(dir)) * power * 2));
		
		for (i in 0 ... Std.int(BresenhamLine.size/2)) {
			if (World.collide(BresenhamLine.x[i], BresenhamLine.y[i])) {
				lightpoint(BresenhamLine.x[i], BresenhamLine.y[i], ent);
				return;
			}else{
				lightpoint(BresenhamLine.x[i], BresenhamLine.y[i], ent);
			}
		}
	}
	
	public static function laserraytrace(x:Int, y:Int, dir:Float, power:Int, ent:Int):Void {
	  BresenhamLine.traceline(x, y, Std.int(x + Math.cos(BresenhamLine.torad(dir)) * power * 2),  Std.int(y + Math.sin(BresenhamLine.torad(dir)) * power * 2));
		
		for (i in 0 ... Std.int(BresenhamLine.size/2)) {
			if (World.collide(BresenhamLine.x[i], BresenhamLine.y[i])) {
				laserpoint(BresenhamLine.x[i], BresenhamLine.y[i], ent);
				return;
			}else{
				laserpoint(BresenhamLine.x[i], BresenhamLine.y[i], ent);
			}
		}
	}
	
	public static function directionallight(x:Int, y:Int, dir:Int, ent:Int, range:Int, lighttype:Int, shootleft:Bool, shootright:Bool):Void {
		//Light a point recusively
		if (Geom.inbox(x, y, 0, 0, World.mapwidth, World.mapheight) && range != 0) {
			if (!World.collide(x, y)) {
				lightpoint(x, y, ent);
				if(shootright){
					lightpoint(x + xstep(Direction.clockwise(dir)), y + ystep(Direction.clockwise(dir)), ent);
				}
				if(shootleft){
				  lightpoint(x + xstep(Direction.anticlockwise(dir)), y + ystep(Direction.anticlockwise(dir)), ent);
				}
				if (lighttype != 0) {
					//Don't shoot clockwise or anticlockwise if there's a collision
					if (World.collide(x + xstep(Direction.clockwise(dir)), y + ystep(Direction.clockwise(dir)))) {
						shootright = false;
					}
					if (World.collide(x + xstep(Direction.anticlockwise(dir)), y + ystep(Direction.anticlockwise(dir)))) {
						shootleft = false;
					}
				}
				directionallight(x + xstep(dir), y + ystep(dir), dir, ent, range - 1, lighttype, shootleft, shootright);
			}else {
				lightpoint(x, y, ent);
				//lightpoint(x + xstep(Direction.clockwise(dir)), y + ystep(Direction.clockwise(dir)), ent);
				//lightpoint(x + xstep(Direction.anticlockwise(dir)), y + ystep(Direction.anticlockwise(dir)), ent);
			}
		}
	}
	
	public static function directionallaser(x:Int, y:Int, dir:Int, ent:Int, range:Int, lighttype:Int, shootleft:Bool, shootright:Bool):Void {
		//Laser a point recusively
		if (Geom.inbox(x, y, 0, 0, World.mapwidth, World.mapheight) && range != 0) {
			if (!World.collide(x, y)) {
				laserpoint(x, y, ent);
				if(shootright){
				  laserpoint(x + xstep(Direction.clockwise(dir)), y + ystep(Direction.clockwise(dir)), ent);
				}
				if(shootleft){
					laserpoint(x + xstep(Direction.anticlockwise(dir)), y + ystep(Direction.anticlockwise(dir)), ent);
				}
				if (lighttype != 0) {
					//Don't shoot clockwise or anticlockwise if there's a collision
					if (World.collide(x + xstep(Direction.clockwise(dir)), y + ystep(Direction.clockwise(dir)))) {
						shootright = false;
					}
					if (World.collide(x + xstep(Direction.anticlockwise(dir)), y + ystep(Direction.anticlockwise(dir)))) {
						shootleft = false;
					}
				}
				directionallaser(x + xstep(dir), y + ystep(dir), dir, ent, range - 1, lighttype, shootleft, shootright);
			}else {
				laserpoint(x, y, ent);
				//laserpoint(x + xstep(Direction.clockwise(dir)), y + ystep(Direction.clockwise(dir)), ent);
				//laserpoint(x + xstep(Direction.anticlockwise(dir)), y + ystep(Direction.anticlockwise(dir)), ent);
			}
		}
	}
	
	public static function alertedtoplayer(ent:Int):Void {
		//This is slightly confusing, so I'm breaking it down:
		//ent contains the index number of the in game entity that's been alerted.
		//tr is then set to the rule number the enemy template
		//I do it this way because I want to have a nice "alert" function in the entity class.
		tr = Obj.entindex.get(Obj.entities[ent].rule);
		tempbool = Obj.templates[tr].getalerted_thisframe(ent);
		if (Game.cloaked <= 0 && Game.timestop <= 0 && !tempbool) {
			Obj.templates[tr].alert(ent);
			Obj.templates[tr].setalerted_thisframe(ent);
		}
	}
	
	public static function hasplayerinsight(ent:Int):Void {
		tr = Obj.entindex.get(Obj.entities[ent].rule);
		tempbool = Obj.templates[tr].getinsights_thisframe(ent);
		if (Game.cloaked <= 0 && Game.timestop <= 0 && !tempbool) {
			Obj.templates[tr].insight(ent);
			Obj.templates[tr].setinsights_thisframe(ent);
		}
	}
	
	public static function updatelighting():Void {
		//Let's just light up a box around the player for now
		clearlighting();
		clearlaser();
		
		playerx = Std.int(Obj.entities[Obj.getplayer()].xp);
		playery = Std.int(Obj.entities[Obj.getplayer()].yp);
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active) {
				tx = Std.int(Obj.entities[i].xp); ty = Std.int(Obj.entities[i].yp); tdir = Obj.entities[i].dir;
				if (Obj.entities[i].lightsource == "bombbot") {
					for (k in -3 ... 3 + 1) {
						for (j in -3 ... 3 + 1) {
							if (Math.sqrt(Math.pow(j, 2) + Math.pow(k, 2)) <= 3) {
								World.lighting[tx + j + ((ty + k) * World.mapwidth)] = 1;
							}
						}
					}
				}else	if (Obj.entities[i].lightsource == "directional") {
					directionallight(tx + xstep(tdir), ty + ystep(tdir), tdir, i, Modern.TORCHRANGE, 0, true, true);
					if (!World.collide(tx + xstep(tdir), ty + ystep(tdir))) {
						if (!World.collide(tx + xstep(tdir) + xstep(Direction.clockwise(tdir)), ty + ystep(tdir) + ystep(Direction.clockwise(tdir)))) {
							directionallight(tx + xstep(tdir, 2) + xstep(Direction.clockwise(tdir)), ty + ystep(tdir, 2) + ystep(Direction.clockwise(tdir)), tdir, i, Modern.TORCHRANGE, 1, true, true);
						}
						if(!World.collide(tx + xstep(tdir) + xstep(Direction.anticlockwise(tdir)), ty + ystep(tdir) + ystep(Direction.anticlockwise(tdir)))){
							directionallight(tx + xstep(tdir, 2) + xstep(Direction.anticlockwise(tdir)), ty + ystep(tdir, 2) + ystep(Direction.anticlockwise(tdir)), tdir, i, Modern.TORCHRANGE, -1, true, true);
						}
					}
				}else if (Obj.entities[i].lightsource == "laserdirectional") {
					directionallaser(tx + xstep(tdir), ty + ystep(tdir), tdir, i, Modern.TORCHRANGE, 0, true, true);
					if (!World.collide(tx + xstep(tdir), ty + ystep(tdir))) {
						if (!World.collide(tx + xstep(tdir) + xstep(Direction.clockwise(tdir)), ty + ystep(tdir) + ystep(Direction.clockwise(tdir)))) {
							directionallaser(tx + xstep(tdir, 2) + xstep(Direction.clockwise(tdir)), ty + ystep(tdir, 2) + ystep(Direction.clockwise(tdir)), tdir, i, Modern.TORCHRANGE, 1, true, true);
						}
						if(!World.collide(tx + xstep(tdir) + xstep(Direction.anticlockwise(tdir)), ty + ystep(tdir) + ystep(Direction.anticlockwise(tdir)))){
							directionallaser(tx + xstep(tdir, 2) + xstep(Direction.anticlockwise(tdir)), ty + ystep(tdir, 2) + ystep(Direction.anticlockwise(tdir)), tdir, i, Modern.TORCHRANGE, -1, true, true);
						}
					}
				}else if (Obj.entities[i].lightsource == "directional_narrow") {
					tinydirectionallight(tx + xstep(tdir), ty + ystep(tdir), tdir, i, Modern.TORCHRANGE);
				}else if (Obj.entities[i].lightsource == "camera") {
					//Cameras are most mathematically exact lights: they trace a line out a given
					//distance from their origin
					for(angle in Std.int(Obj.entities[i].cameradir - 18) ... Std.int(Obj.entities[i].cameradir + 18)){
						raytrace(tx, ty, angle, Obj.entities[i].camerapower, i);
					}
				}else if (Obj.entities[i].lightsource == "lasercamera") {
					for(angle in Std.int(Obj.entities[i].cameradir - 18) ... Std.int(Obj.entities[i].cameradir + 18)){
						laserraytrace(tx, ty, angle, Obj.entities[i].camerapower, i);
					}
				}else if (Obj.entities[i].lightsource == "sentinal") {
					//Sentinals are cameras that face in four directions and have a protective layer
					for (k in -1 ... 1 + 1) {
						for (j in -1 ... 1 + 1) {
							lightpoint(Obj.entities[i].xp + j, Obj.entities[i].yp + k, i);
						}
					}
					raytrace(tx, ty, (Obj.entities[i].cameradir * 7.5), Obj.entities[i].camerapower, i);
					raytrace(tx, ty, (Obj.entities[i].cameradir * 7.5) + 90, Obj.entities[i].camerapower, i);
					raytrace(tx, ty, (Obj.entities[i].cameradir * 7.5) + 180, Obj.entities[i].camerapower, i);
					raytrace(tx, ty, (Obj.entities[i].cameradir * 7.5) + 270, Obj.entities[i].camerapower, i);
				}else if (Obj.entities[i].lightsource == "lasersentinal") {
					for (k in -1 ... 1 + 1) {
						for (j in -1 ... 1 + 1) {
							laserpoint(Obj.entities[i].xp + j, Obj.entities[i].yp + k, i);
						}
					}
					laserraytrace(tx, ty, (Obj.entities[i].cameradir * 7.5), Obj.entities[i].camerapower, i);
					laserraytrace(tx, ty, (Obj.entities[i].cameradir * 7.5) + 90, Obj.entities[i].camerapower, i);
					laserraytrace(tx, ty, (Obj.entities[i].cameradir * 7.5) + 180, Obj.entities[i].camerapower, i);
					laserraytrace(tx, ty, (Obj.entities[i].cameradir * 7.5) + 270, Obj.entities[i].camerapower, i);
				}else if (Obj.entities[i].lightsource == "laser_narrow") {
					tinydirectionallaser(tx + xstep(tdir), ty + ystep(tdir), tdir, i, Modern.TORCHRANGE);
				}else if (Obj.entities[i].lightsource == "laser_bubble") {
					tinydirectionallaser(tx + xstep(tdir), ty + ystep(tdir), tdir, i, Modern.TORCHRANGE);
					//Creates a bubble of radius para
					for (k in -Obj.entities[i].mysteryvalue ... Obj.entities[i].mysteryvalue + 1) {
						for (j in -Obj.entities[i].mysteryvalue ... Obj.entities[i].mysteryvalue + 1) {
							laserpoint(Obj.entities[i].xp + j, Obj.entities[i].yp + k, i);
						}
					}
				}else if (Obj.entities[i].lightsource == "bubble") {
					//Creates a bubble of radius para
					for (k in -Obj.entities[i].mysteryvalue ... Obj.entities[i].mysteryvalue + 1) {
						for (j in -Obj.entities[i].mysteryvalue ... Obj.entities[i].mysteryvalue + 1) {
							//if (Math.sqrt(Math.pow(j, 2) + Math.pow(k, 2)) <= Obj.entities[i].para) {
							if (Math.abs(k) + Math.abs(j) < (Obj.entities[i].mysteryvalue * 2) - 1) {
								lightpoint(Obj.entities[i].xp + j, Obj.entities[i].yp + k, i);	
							}
						}
					}
				}else if (Obj.entities[i].lightsource == "dogbubble") {
					//Creates a bubble of radius para
					for (k in -Obj.entities[i].mysteryvalue ... Obj.entities[i].mysteryvalue + 1) {
						for (j in -Obj.entities[i].mysteryvalue ... Obj.entities[i].mysteryvalue + 1) {
							lightpoint(Obj.entities[i].xp + j, Obj.entities[i].yp + k, i);	
						}
					}
				}else if (Obj.entities[i].lightsource == "laserbeside") {
					for (k in -1 ... 2) {
						for (j in -1 ... 2) {
							laserpoint(Obj.entities[i].xp + j, Obj.entities[i].yp + k, i);	
						}
					}
				}else if (Obj.entities[i].lightsource == "close") {
					//For the player, basically
					for (k in -5 ... 6) {
						for (j in -5 ... 6) {
							if (Math.abs(k) + Math.abs(j) < 9) {
								fogpoint(Std.int(Obj.entities[i].xp + j), Std.int(Obj.entities[i].yp + k));
							}
						}
					}
				}
			}
		}
	}
	
	public static var playerx:Int;
	public static var playery:Int;
	public static var spottedplayer:Bool;
	public static var tx:Int;
	public static var ty:Int;
	public static var tdir:Int;
	public static var tx1:Int;
	public static var ty1:Int;
	public static var tx2:Int;
	public static var ty2:Int;
	public static var tr:Int;
	public static var tg:Int;
	public static var tb:Int;
	public static var connecta:Int;
	public static var connectb:Int;
	public static var attempts:Int;
	
	public static var light:Int;
	public static var fog:Int;
	public static var highlight:Int;
	public static var laser:Int;
	public static var fire:Int;
	public static var fire2:Int;
	public static var fire3:Int;
	public static var firecol:Int;
	
	public static var onfire:Bool;
	public static var tempbool:Bool;
	
	public static var worldblock:Array<Worldblockclass> = new Array<Worldblockclass>();
}