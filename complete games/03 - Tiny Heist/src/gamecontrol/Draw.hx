package gamecontrol;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;
import haxegon.*;
import terrylib.*;

class Draw {
	public static inline var tilewidth:Int = 12;
	public static inline var tileheight:Int = 12;
	
	public static var screentilewidth:Int;
	public static var screentileheight:Int;
	//Fade Transition (room changes, game state changes etc)
	public inline static var FADED_IN:Int = 0;
	public inline static var FADED_OUT:Int = 1;
	public inline static var FADE_OUT:Int = 2;
	public inline static var FADING_OUT:Int = 3;
	public inline static var FADE_IN:Int = 4;
	public inline static var FADING_IN:Int = 5;
	
	public static var fademode:Int;
	public static var fadeamount:Int;
	public static var fadeaction:String;
	
	public static var screenshake:Int;
	public static var flashlight:Int;
	//Fade functions
	public static function processfade():Void {
		if (fademode > FADED_OUT) {
			if (fademode == FADE_OUT) {
				//prepare fade out
				fadeamount = 0;
				fademode = FADING_OUT;
				Lerp.start("fadeout", 20);
			}else if (fademode == FADING_OUT) {
				fadeamount = Lerp.to(0, 100, "fadeout", "sine_out");
				if (Lerp.justfinished("fadeout")) {
					fademode = FADED_OUT; //faded
				}
			}else if (fademode == FADE_IN) {
				//prepare fade in
				fademode = FADING_IN;
				Lerp.start("fadein", 20);
			}else if (fademode == FADING_IN) {
				fadeamount = Lerp.to(100, 0, "fadein", "sine_in");
				if (Lerp.justfinished("fadein")) {
					fademode = FADED_IN; //normal
				}
			}
		}
	}
	
	public static function fadeout(t:String = "nothing"):Void {
		fademode = FADE_OUT;
		fadeaction = t;
	}
	
	public static function fadein():Void {
		fademode = FADE_IN;
	}
	
	public static function init():Void {
		screentilewidth = Std.int(384 / 12);
		screentileheight = Std.int(240 / 12);
	}
	
	public static function gfxflashlight():Void {
		//Disabling for now
		//Gfx.backbuffer.fillRect(Gfx.backbuffer.rect, 0xFFFFFF);
	}
	
	public static function gfxscreenshake():Void {
		//IMPLEMENT
		/*
		Gfx.screenbuffer.lock();
		Gfx.screenbuffer.copyPixels(Gfx.backbuffer, Gfx.backbuffer.rect, Gfx.tl, null, null, false);
		Gfx.settpoint(Std.int((Math.random() * 5) - 3), Std.int((Math.random() * 5) - 3));
		Gfx.screenbuffer.copyPixels(Gfx.backbuffer, Gfx.backbuffer.rect, Gfx.tpoint, null, null, false);
		Gfx.screenbuffer.unlock();
		
		Gfx.backbuffer.lock();
		Gfx.backbuffer.fillRect(Gfx.backbuffer.rect, 0x000000);
		Gfx.backbuffer.unlock();
		*/
	}
	
	public static function getperlin(x:Int, y:Int):Int {
		//IMPLEMENT
		/*
		x = x % Gfx.images[perlinnoise].width;
		y = y % Gfx.images[perlinnoise].height;
		return Col.getred(Gfx.images[perlinnoise].getPixel(x, y));
		*/
		//384, 240
		
		return Perlinarray.perlinnoise[x % 384][y % 240];
	}
	
	public static function setboldtext():Void {
		Text.font = "fffhomepagebold";
	}
	
	public static function setnormaltext():Void {
		Text.font = "fffhomepage";
	}
	
	public static function clicktostart():Void {
		Text.display(Text.CENTER, Text.CENTER, "[Click to start]", Col.rgb(Std.int(255 - (Help.glow / 2)), Std.int(255 - (Help.glow / 2)), Std.int(255 - (Help.glow / 2))));
	}

	public static function outoffocusrender():Void {
		//IMPLEMENT
		/*
		Gfx.cls();
		
		Text.display(Text.CENTER, Gfx.screenheightmid-28, "Game paused", Col.rgb(Std.int(255 - (Help.glow / 2)), Std.int(255 - (Help.glow / 2)), Std.int(255 - (Help.glow / 2))));
		
		Text.display(Text.CENTER, Gfx.screenheightmid, "[click to resume]", Col.rgb(Std.int(196 - (Help.glow / 2)), Std.int(196 - (Help.glow / 2)), Std.int(196 - (Help.glow / 2))));
		Text.display(Text.CENTER, Gfx.screenheight-28, "Press M to mute", Col.rgb(Std.int(255 - (Help.glow / 2)), Std.int(255 - (Help.glow / 2)), Std.int(255 - (Help.glow / 2))));
		
		Gfx.normalrender();
		*/
	}
	
	public static function drawfade():Void {
		if (Draw.fademode == Draw.FADED_OUT) {
			Gfx.clearscreen(Col.BLACK);
		}else if (Draw.fademode == Draw.FADING_OUT) {
			Gfx.fillbox(0, 0, Std.int((Draw.fadeamount * (Gfx.screenwidth / 20)) / 10), Gfx.screenheight, Col.BLACK);
			Gfx.fillbox(Std.int(Gfx.screenwidth - ((Draw.fadeamount * (Gfx.screenwidth / 20)) / 10)), 0, Gfx.screenwidthmid, Gfx.screenheight, Col.BLACK);
			Gfx.fillbox(0, 0, Gfx.screenwidth, Std.int((Draw.fadeamount * (Gfx.screenheight / 20)) / 10), Col.BLACK);
			Gfx.fillbox(0, Std.int(Gfx.screenheight - ((Draw.fadeamount * (Gfx.screenheight / 20)) / 10)), Gfx.screenwidth,  Gfx.screenheightmid, Col.BLACK);
		}else if (Draw.fademode == Draw.FADING_IN) {
			Gfx.fillbox(0, 0, Std.int((Draw.fadeamount * (Gfx.screenwidth / 20)) / 10), Gfx.screenheight, Col.BLACK);
			Gfx.fillbox(Std.int(Gfx.screenwidth - ((Draw.fadeamount * (Gfx.screenwidth / 20)) / 10)), 0, Gfx.screenwidthmid, Gfx.screenheight, Col.BLACK);
			Gfx.fillbox(0, 0, Gfx.screenwidth, Std.int((Draw.fadeamount * (Gfx.screenheight / 20)) / 10), Col.BLACK);
			Gfx.fillbox(0, Std.int(Gfx.screenheight - ((Draw.fadeamount * (Gfx.screenheight / 20)) / 10)), Gfx.screenwidth, Gfx.screenheightmid, Col.BLACK);
		}
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
	
	public static function drawtextbox(xp:Int, yp:Int, w:Int, h:Int, col:Int, lerp:Float, state:Int):Void {
		//Draw a textbox at given position and size
		if (state == Textbox.STATE_BOXAPPEARING || state == Textbox.STATE_DISAPPEARING) {
			tempx = Std.int(((w - 8) / 2) * lerp);
			tempy = Std.int(((h - 8) / 2) * lerp);
			Gfx.fillbox(Std.int((xp + 4 + ((w - 8) / 2)) - tempx), Std.int((yp + 4 + ((h - 8) / 2)) - tempy), tempx * 2, tempy * 2, Draw.shade(textboxcol(col, Textbox.TEXTBACKING), lerp * 2));
		}else if (state >= Textbox.STATE_TEXTAPPEARING && state <= Textbox.STATE_VISABLE) {
			//Non-Backing parts
			//IMPLEMENT
			/*
			Gfx.settrect(xp + 16, yp, w - 32, h);	        Gfx.backbuffer.fillRect(Gfx.trect, textboxcol(col, Textbox.TEXTBORDER));
			Gfx.settrect(xp + 16, yp + 2, w - 32, h - 4);	Gfx.backbuffer.fillRect(Gfx.trect, textboxcol(col, Textbox.TEXTHIGHLIGHT));
			Gfx.settrect(xp + 16, yp + 4, w - 32, h - 8);	Gfx.backbuffer.fillRect(Gfx.trect, textboxcol(col, Textbox.TEXTBACKING));
			
			Gfx.settrect(xp, yp + 16, w, h - 32);	        Gfx.backbuffer.fillRect(Gfx.trect, textboxcol(col, Textbox.TEXTBORDER));
			Gfx.settrect(xp + 2, yp + 16, w - 4, h - 32);	Gfx.backbuffer.fillRect(Gfx.trect, textboxcol(col, Textbox.TEXTHIGHLIGHT));
			Gfx.settrect(xp + 4, yp + 16, w - 8, h - 32);	Gfx.backbuffer.fillRect(Gfx.trect, textboxcol(col, Textbox.TEXTBACKING));
			
			//Corners!
			Gfx.changetileset();
			Gfx.drawtile(xp, yp, (col * 4) + 0);
			Gfx.drawtile(xp + w - 16, yp, (col * 4) + 1);
			Gfx.drawtile(xp, yp + h - 16, (col * 4) + 2);
			Gfx.drawtile(xp + w - 16, yp + h - 16, (col * 4) + 3);
			*/
		}
	}
	
	public static function drawparticles():Void {		
		//IMPLEMENT
		/*
		for (i in 0...Obj.nparticles) {
			if (Obj.particles[i].active) {
				if (Obj.particles[i].type == "pixel") {
					Gfx.settrect(Std.int(Obj.particles[i].xp - World.camerax), Std.int(Obj.particles[i].yp - World.cameray), 5, 5);
					Gfx.backbuffer.fillRect(Gfx.trect, Col.rgb(255, 255, 255));
				}else if (Obj.particles[i].type == "rpgtext") {
					//White text
					Text.display(Std.int(Obj.particles[i].xp - World.camerax), Std.int(Obj.particles[i].yp - World.cameray), 
										 Std.string(Obj.particles[i].colour), Col.rgb(255, 255, 255));
				}else {
					Gfx.changetileset(Obj.particles[i].type);
					Gfx.drawtile(Std.int(Obj.particles[i].xp - World.camerax), Std.int(Obj.particles[i].yp - World.cameray), Obj.particles[i].tile);
				}
			}
		}
		*/
		
	}
	
	public static var walldrawx:Int;
	public static var walldrawy:Int;
	
	public static function draw_horizontal(x1:Int, y1:Int, x2:Int, y2:Int):Void {
		Gfx.fillbox(walldrawx + x1, walldrawy + y1, x2, y2, Game.backgroundcolour);
		Gfx.fillbox(walldrawx + x1, walldrawy + y1 + 2, x2, 2, 0x5380d1);
	}
	
	
	public static function draw_vertical(x1:Int, y1:Int, x2:Int, y2:Int):Void {
		Gfx.fillbox(walldrawx + x1, walldrawy + y1, x2, y2, Game.backgroundcolour);
		Gfx.fillbox(walldrawx + x1 + 2, walldrawy + y1, 2, y2, 0x5380d1);
	}
	
	public static function drawwall(x:Int, y:Int, drawx:Int, drawy:Int):Void {
		//Draw wall at a given position!
		var w:Int, h:Int;
		var check:Bool = false;
		
		walldrawx = drawx;
		walldrawy = drawy;
		
		w = Draw.tilewidth;
		h = Draw.tileheight;
		
		check = World.collide(x, y + 1);
		if (!check) draw_horizontal(2, h - 6, w - 4, 6);
		
		check = World.collide(x, y - 1);
		if (!check) draw_horizontal(0, 0, w, 6);
		
		check = World.collide(x + 1, y);
		if (!check) draw_vertical(w - 6, 0, 6, h);
		
		check = World.collide(x - 1, y);
		if (!check) draw_vertical(0, 0, 6, h);
	}
	
	public static var currentblock:Int;
	public static var currentblock_south:Int;
	public static var backcolour:Int;
	public static var frontcolour:Int;
	public static var frontcolour_wallshade:Int;
	public static var cameraxoff:Int;
	public static var camerayoff:Int;
	public static var playerindex:Int;
	public static var twinkle:Int;
	public static function drawmap(tileset:String):Void {
		if (World.disablecamera) {
			World.camerax = 0; World.cameray = 0;
		}else{
			if (World.noxcam) World.camerax = 0; if (World.noycam) World.cameray = 0;
		}
		
		cameraxoff = 0;
		camerayoff = 0;
		playerindex = Obj.getplayer(); 
		if (playerindex > -1) {
			World.camerax = Obj.entities[playerindex].xp - 16;
			if (World.camerax < 0) World.camerax = 0;
			if (World.camerax + 32 > World.mapwidth) World.camerax = World.mapwidth - 32;
			if (World.camerax != 0) cameraxoff = -Obj.entities[playerindex].animx;
			
			if (World.camerax >= -1 && 
			    World.camerax + 31 < World.mapwidth) cameraxoff = -Obj.entities[playerindex].animx;
			if (Obj.entities[playerindex].xp - 15 <= 0 && cameraxoff < 0) cameraxoff = 0;
			if (Obj.entities[playerindex].xp - 16 <= 0 && cameraxoff > 0) cameraxoff = 0;
			if (Obj.entities[playerindex].xp + 15 >= World.mapwidth && cameraxoff > 0) cameraxoff = 0;
			if (Obj.entities[playerindex].xp + 16 >= World.mapwidth && cameraxoff < 0) cameraxoff = 0;
			
			World.cameray = Obj.entities[playerindex].yp - 10;
			if (World.cameray < 0) World.cameray = 0;
			if (World.cameray + 19 >= World.mapheight) World.cameray = World.mapheight - 19;
			
			if (World.cameray >= -1 && 
			    World.cameray + 18 < World.mapheight) camerayoff = -Obj.entities[playerindex].animy;
			if (Obj.entities[playerindex].yp - 9 <= 0 && camerayoff < 0) camerayoff = 0;
			if (Obj.entities[playerindex].yp - 10 <= 0 && camerayoff > 0) camerayoff = 0;
			if (Obj.entities[playerindex].yp + 8 >= World.mapheight && camerayoff > 0) camerayoff = 0;
			if (Obj.entities[playerindex].yp + 9 >= World.mapheight && camerayoff < 0) camerayoff = 0;
		}
		
		for (j in World.cameray - (camerayoff > 0?1:0) ... Draw.screentileheight + 1 + World.cameray) {
			for (i in World.camerax - (cameraxoff > 0?1:0) ... Draw.screentilewidth + 1 + World.camerax) {
				currentblock = World.at(i, j);// , World.camerax, World.cameray);
				backcolour = Localworld.backcolourmap(i, j, currentblock);
				frontcolour = Localworld.colourmap(i, j, currentblock);
				frontcolour_wallshade = Localworld.colourmap_shade(i, j, currentblock);
				
				if (currentblock == Localworld.WALL) {
					if (Localworld.fogat(i, j) == 1) {
						currentblock_south = World.at(i, j + 1);
						if (currentblock_south != Localworld.WALL && currentblock_south != Localworld.BACKGROUND) {
							//If we're doing a shaded wall and there are no optimisations, we need to do the whole thing
							if (Localworld.backgroundcolour_needschanging || Localworld.foregroundcolour_needschanging > 0) {
								if (Localworld.backgroundcolour_needschanging && Localworld.foregroundcolour_needschanging > 1){
									Draw.filltile(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight), backcolour);
								}
								
								if(Localworld.foregroundcolour_needschanging > 1){
									Gfx.imagecolor(frontcolour);
									Gfx.drawtile(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight), tileset, Localworld.charmap(i, j, currentblock));
									Gfx.imagecolor();
									//Also do a shade!
									Draw.filltile_half(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight) + 4, backcolour);
									Gfx.imagecolor(frontcolour_wallshade);
									Gfx.drawtile(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight), tileset, Localworld.charmap(i, j, currentblock) + 1);
									Gfx.imagecolor();
								}else if (Localworld.foregroundcolour_needschanging == 1) {
									//Precached lit wall verge
									Draw.precoloured_drawtile(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight), Localworld.charmap(i, j, currentblock) + 1 + 16);
								}else if (Localworld.foregroundcolour_needschanging == 0) {
									//Precached normal wall verge
									Draw.precoloured_drawtile(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight), Localworld.charmap(i, j, currentblock) + 1);
								}
							}else {
								//We can just use the precached version
								Draw.precoloured_drawtile(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight), Localworld.charmap(i, j, currentblock) + 1);
							}
						}else {
							//Draw a regular wall
							if (Localworld.backgroundcolour_needschanging && Localworld.foregroundcolour_needschanging > 1) {
								//Optimisation: Only change the background colour if it's actually lit	
								Draw.filltile(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight),  backcolour);
							}
							if (Localworld.foregroundcolour_needschanging > 1) {
								Gfx.imagecolor(frontcolour);
								Gfx.drawtile(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight), tileset, Localworld.charmap(i, j, currentblock));
								Gfx.imagecolor();
							}else if (Localworld.foregroundcolour_needschanging == 1) {
								//Ok, we've cached a lit version of the wall, use that!
								Draw.precoloured_drawtile(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight), Localworld.charmap(i, j, currentblock) + 16);
							}else {
								Draw.precoloured_drawtile(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight), Localworld.charmap(i, j, currentblock));
							}
						}
						//drawwall(i, j, (i * Gfx.tiles[Gfx.currenttileset].width) - (World.camerax * Gfx.tiles[Gfx.currenttileset].width), (j * Gfx.tiles[Gfx.currenttileset].height) - (World.cameray * Gfx.tiles[Gfx.currenttileset].height));
					}
				}else	if (currentblock != Localworld.BACKGROUND) {
					if (Localworld.fogat(i, j) == 1) {
						if (Localworld.backgroundcolour_needschanging || Localworld.foregroundcolour_needschanging > 1) {
							//Optimisation: Only change the background colour if it's actually lit	
							Draw.filltile(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight), backcolour);
						}
						if (currentblock == Localworld.FLOOR) {
							//All the floors are precaclulated!
							if (Localworld.foregroundcolour_needschanging > 1) {
								Gfx.imagecolor(frontcolour);
								Gfx.drawtile(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight), tileset, Localworld.charmap(i, j, currentblock));
								Gfx.imagecolor();
							}else if (Localworld.foregroundcolour_needschanging == 1) {
								Draw.precoloured_drawtile(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight), Localworld.charmap(i, j, currentblock) + 16);
							}else {
								Draw.precoloured_drawtile(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight), Localworld.charmap(i, j, currentblock));
							}
						}else if (currentblock == Localworld.ROOFSTARS) {
							//For drawing the stars, we hardcode a little animation, and force a background colour
							//Draw.filltile(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight), 0x000022);
							twinkle = (flash.Lib.getTimer() + ((j + i) * 100)) % 1000;
							if (twinkle >= 800) {
								twinkle = twinkle - 800;
								if (twinkle >= 100) {
									twinkle = 2;
								}else {
								  twinkle = 1;	
								}
							}else {
							  twinkle = 0;	
							}
							Draw.precoloured_drawtile(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight), Localworld.charmap(i, j, currentblock) + twinkle);
						}else{
							Gfx.imagecolor(frontcolour);
							Gfx.drawtile(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight), tileset, Localworld.charmap(i, j, currentblock));
							Gfx.imagecolor();
						}
					}else {
						//Optimisation: We're drawing a fogged out area here, we don't need the fillrect
						//Draw.filltile(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight), Localworld.backcolourmap(i, j, currentblock));
						if (currentblock == Localworld.KEY) {
							Draw.precoloured_drawtile(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight), "?".charCodeAt(0));
						}
					}
				}//else {
				//Optimisation: We never actually need to draw the background colour on fogged out areas
				//	if (Localworld.fogat(i, j) == 0) {
				//		Draw.filltile(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight), Game.backgroundcolour);
				//	}
				//}
			}
		}
	}
	
	public static function precoloured_drawtile(xp:Float, yp:Float, tilenum:Int) {
	  Gfx.drawtile(xp, yp, "colorterminal", tilenum);	
	}
	
	public static function filltile(xp:Int, yp:Int, col:Int) {
		Gfx.imagecolor(col);
		Gfx.drawtile(xp, yp, "terminal", 17);
		Gfx.imagecolor();
	}
	
	public static function filltile_half(xp:Int, yp:Int, col:Int) {
	  Gfx.imagecolor(col);
		Gfx.drawtile(xp, yp, "terminal", 18);
		Gfx.imagecolor();
	}
	
	public static function drawmapfade(px:Int, py:Int, tileset:String, fadelevel:Int):Void {
		if (World.disablecamera) {
			World.camerax = 0; World.cameray = 0;
		}else{
			if (World.noxcam) World.camerax = 0; if (World.noycam) World.cameray = 0;
		}
		
		if (Obj.getplayer() > -1) {
			World.camerax = Obj.entities[Obj.getplayer()].xp - 16;
			if (World.camerax < 0) World.camerax = 0;
			if (World.camerax + 32 > World.mapwidth) World.camerax = World.mapwidth - 32;
			
			World.cameray = Obj.entities[Obj.getplayer()].yp - 10;
			if (World.cameray < 0) World.cameray = 0;
			if (World.cameray + 19 > World.mapheight) World.cameray = World.mapheight - 19;
		}
		
		var t:Int, t2:Int;
		
		for (j in World.cameray ... Draw.screentileheight + 1 + World.cameray) {
			for (i in World.camerax ... Draw.screentilewidth + 1 + World.camerax) {
				if (Math.abs(px - i) / 2 >= fadelevel || Math.abs(py - j) >= fadelevel) {
					//Gfx.fillbox((i * Gfx.tiles[Gfx.currenttileset].width) - (World.camerax * Gfx.tiles[Gfx.currenttileset].width), (j * Gfx.tiles[Gfx.currenttileset].height) - (World.cameray * Gfx.tiles[Gfx.currenttileset].height), Gfx.tiles[Gfx.currenttileset].width, Gfx.tiles[Gfx.currenttileset].height, Game.backgroundcolour);
					Draw.filltile((i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), (j * Draw.tileheight) - (World.cameray * Draw.tileheight), 0x000000);
				}
			}
		}
	}
	
	public static function drawfade_withoutmap(px:Int, py:Int, tileset:String, fadelevel:Int):Void {
		for (j in 0 ... Draw.screentileheight + 1) {
			for (i in 0 ... Draw.screentilewidth + 1) {
				if (Math.abs(px - i) / 2 >= fadelevel || Math.abs(py - j) >= fadelevel) {
					//Gfx.fillbox((i * Gfx.tiles[Gfx.currenttileset].width) - (World.camerax * Gfx.tiles[Gfx.currenttileset].width), (j * Gfx.tiles[Gfx.currenttileset].height) - (World.cameray * Gfx.tiles[Gfx.currenttileset].height), Gfx.tiles[Gfx.currenttileset].width, Gfx.tiles[Gfx.currenttileset].height, Game.backgroundcolour);
					Draw.filltile((i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), (j * Draw.tileheight) - (World.cameray * Draw.tileheight), 0x000000);
				}
			}
		}
	}
	
	public static function roundfillrect(x:Int, y:Int, w:Float, h:Float, r:Int, g:Int = -1, b:Int = -1):Void {
		if (g != -1 || b != -1) {
			r = Col.rgb(r, g, b);
		}
		
		Gfx.fillbox(x+1, y, w-2, h, r);
		Gfx.fillbox(x, y+1, w, h-2, r);
	}
	
	public static function grayscale():Void {
		Gfx.fillbox(0, 0, Gfx.screenwidth, Gfx.screenheight, Col.WHITE, 0.25 - (Help.glow / 1024));
	}
	
	public static function alarmtransform(amount:Int):Void {
		var v:Float = 0;
		if (amount >= 250) {
			v = (0.1 * (500- amount)) / 250;	
		}else {
		  v = (0.1 * amount) / 250;	
		}
		Gfx.fillbox(0, 0, Gfx.screenwidth, Gfx.screenheight, Col.WHITE, v);
		//IMPLEMENT
		/*
		var v:Float = 0;
		if (amount >= 250) {
			v = (0.1 * (500- amount)) / 250;	
		}else {
		  v = (0.1 * amount) / 250;	
		}
		var newct:ColorTransform = new ColorTransform(1.0, 0.5, 0.5, v);
		newct.color = 0xFFFFFF;
		Gfx.shapematrix.identity();
		Gfx.backbuffer.draw(Gfx.backbuffer, Gfx.shapematrix, newct);
		*/
	}
	
	public static function terminalprint(x:Int, y:Int, t:String, col:Int = 0xFFFFFF, drawbacking:Bool = false, xoffset:Int = 0, yoffset:Int = 0, backingcol:Int = 0x444444, bordercol:Int = 0x000000):Void {
		y = y * 12;
		if (x == Gfx.CENTER) {
			x = Gfx.screenwidthmid - Std.int(Text.width(t) / 2);
			//x= Std.int(((Gfx.screenwidth - (t.length * Gfx.tiles[Gfx.currenttileset].width)) / 2) / Gfx.tiles[Gfx.currenttileset].width);
		}else {
			x = x * 12;
		}
		if (drawbacking) {
			roundfillrect(x - 4 + xoffset, y - 4 + yoffset+4, Text.width(t)+8, Text.height()+8 - 1, 0, 0, 0);
			roundfillrect(x - 2 + xoffset, y - 2 + yoffset+4, Text.width(t)+4, Text.height()+4 - 1, bordercol);
			roundfillrect(x + xoffset, y + yoffset+4, Text.width(t), Text.height() - 1, backingcol);
		}
		
		Text.display(x + xoffset - 1, y + yoffset + 3 - 1, t, col);
	}
	
	public static function letterterminalprint(x:Int, y:Int, t:String, col:Int = 0xFFFFFF, drawbacking:Bool = false, xoffset:Int = 0, yoffset:Int = 0, backingcol:Int = 0x444444, bordercol:Int = 0x000000):Void {
		y = y * 12;
		if (x == Gfx.CENTER) {
			x = Gfx.screenwidthmid - Std.int(Text.width(t) / 2);
			//x= Std.int(((Gfx.screenwidth - (t.length * Gfx.tiles[Gfx.currenttileset].width)) / 2) / Gfx.tiles[Gfx.currenttileset].width);
		}else {
		}
		if (drawbacking) {
			roundfillrect(x - 4 + xoffset, y - 4 + yoffset+4, Text.width(t)+8, Text.height()+8 - 1, 0, 0, 0);
			roundfillrect(x - 2 + xoffset, y - 2 + yoffset+4, Text.width(t)+4, Text.height()+4 - 1, bordercol);
			roundfillrect(x + xoffset, y + yoffset+4, Text.width(t), Text.height() - 1, backingcol);
		}
		
		Text.display(x + xoffset, y + yoffset + 3, t, col);
	}
	
	public static function rterminalprint(x:Int, y:Int, t:String, col:Int = 0xFFFFFF, drawbacking:Bool = false, backingcol:Int = 0x444444):Void {
		y = y * 12;
		x = Std.int((x * 12) - Text.width(t));
		if (drawbacking) {
			Gfx.fillbox(x + 2, y + 4, Text.width(t), Text.height(), Col.BLACK);
			Gfx.fillbox(x, y + 2, Text.width(t), Text.height(), backingcol);
		}
		
		Text.display(x, y + 3, t, col);
	}
	
	public static function drawbackground():Void {
		Gfx.fillbox(0, 0, Gfx.screenwidth, Gfx.screenheight, Game.backgroundcolour);
		/*
		for (j in 0 ... Gfx.screentileheight + 1) {
			for (i in 0 ... Gfx.screentilewidth + 1) {
				Gfx.fillbox((i * Gfx.tiles[Gfx.currenttileset].width) - (World.camerax * Gfx.tiles[Gfx.currenttileset].width), (j * Gfx.tiles[Gfx.currenttileset].height) - (World.cameray * Gfx.tiles[Gfx.currenttileset].height), Gfx.tiles[Gfx.currenttileset].width, Gfx.tiles[Gfx.currenttileset].height, Game.backgroundcolour);
				Gfx.drawtile_col((i * Gfx.tiles[Gfx.currenttileset].width) - (World.camerax * Gfx.tiles[Gfx.currenttileset].width), (j * Gfx.tiles[Gfx.currenttileset].height) - (World.cameray * Gfx.tiles[Gfx.currenttileset].height), 219, 0x254071);
			}
		}
		*/
	}
	
	public static function messagecol(t:String):Int {
		switch(t) {
			case "kludge":
				if (Help.slowsine % 32 >= 16) {
					return Col.rgb(255, 255, 255);
				}else {
					return Col.rgb(224, 224, 224);
				}
			case "white":
				return Col.rgb(255, 255, 255);
			case "shout":
			  if (Help.slowsine % 32 >= 16) {
					return Col.rgb(255, 255, 255);
				}else {
					return Col.rgb(196, 196, 196);
				}
			case "whisper":
				if (Help.slowsine % 32 >= 16) {
					return Col.rgb(164, 164, 164);
				}else {
					return Col.rgb(128, 128, 128);
				}
			case "player":
				if (Help.slowsine % 32 >= 16) {
					return 0xe1fffe;
				}else {
					return 0xFFFFFF;
				}
			case "cash": 
				return Col.rgb(255 - Std.int(Help.glow / 2), 255 - Std.int(Help.glow / 2), 64);
			case "key": 
				return Col.rgb(64, 255 - Std.int(Help.glow / 2), 64);
			case "red": 
				return Col.rgb(255 - Help.glow, Help.glow, Help.glow);
			case "flashing":
			  if (Help.slowsine % 32 >= 16) {
					return Col.rgb(255 - Help.glow, 164, 164);
				}else {
					return Col.rgb(255 - Help.glow, 255, 164);
				}
			case "good":
				if (Help.slowsine % 32 >= 16) {
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
	
	public static function drawmenu():Void {
		//Automatically adjust menuoffset based on cursor position
		if (Menu.menusize < 8) {
			Menu.menuoffset = 0;
		}else {
			if(Menu.currentmenu - Menu.menuoffset < 1){
				Menu.menuoffset = Menu.currentmenu - 1;
			}
			if (Menu.currentmenu - Menu.menuoffset> 6) {
				Menu.menuoffset = Menu.currentmenu - 6;
			}
			if (Menu.menuoffset < 0) Menu.menuoffset = 0;
		}
		
		for (j in 0 ... Menu.menusize) {
			var i:Int = j + Menu.menuoffset;
			if (i < Menu.menusize){
				if (Menu.menuoptions[i] == "back") {
					if (Menu.currentmenu == i) {
						Gfx.fillbox(0, (11 * 12) + (j * 12)+4, Gfx.screenwidth, 12, Col.rgb(64, 64, 64));
						Draw.rterminalprint(22, 11 + j, "[ " + Menu.menuoptions[i] + " ]", Col.rgb(196, 196, 255), false);
					}else {
						Draw.rterminalprint(22, 11 + j, Menu.menuoptions[i] + "  ", Col.rgb(164, 164, 164));
					}
				}else {
					if (Menu.menucol[i] == 0) {
						if (Menu.currentmenu == i) {
							Gfx.fillbox(0, (10 * 12) + (j * 12)+4, Gfx.screenwidth, 12, Col.rgb(64, 64, 64));
							Draw.terminalprint(Gfx.CENTER, 10+j, "[ " + Menu.menuoptions[i] + " ]", Col.rgb(164, 164, 164), false);
						}else {
							Draw.terminalprint(Gfx.CENTER, 10 + j, Menu.menuoptions[i], Col.rgb(164, 164, 164));
						}
					}else if (Menu.menucol[i] == 1) {
						if (Menu.currentmenu == i) {
							Gfx.fillbox(0, (10 * 12) + (j * 12)+4, Gfx.screenwidth, 12, Col.rgb(64, 64, 64));
							Draw.terminalprint(Gfx.CENTER, 10+j, "[ " + Menu.menuoptions[i] + " ]", Col.rgb(164, 164, 255), false);
						}else {
							Draw.terminalprint(Gfx.CENTER, 10 + j, Menu.menuoptions[i], Col.rgb(164, 164, 255));
						}
					}else if (Menu.menucol[i] == 2) {
						if (Menu.currentmenu == i) {
							Gfx.fillbox(0, (10 * 12) + (j * 12)+4, Gfx.screenwidth, 12, Col.rgb(64, 64, 64));
							Draw.terminalprint(Gfx.CENTER, 10+j, "[ " + Menu.menuoptions[i] + " ]", Col.rgb(164, 255, 164), false);
						}else {
							Draw.terminalprint(Gfx.CENTER, 10 + j, Menu.menuoptions[i], Col.rgb(164, 255, 164));
						}
					}
				}
			}
		}
	}
	
	public static function draw_default(i:Int):Void {
		Draw.filltile(cameraxoff + Obj.entities[i].animx + Std.int(Obj.entities[i].xp - World.camerax) * Draw.tilewidth, 
		              camerayoff + Obj.entities[i].animy + Std.int(Obj.entities[i].yp - World.cameray) * Draw.tileheight, Game.backgroundcolour);
		if (Obj.entities[i].shakecount > 0) {
			Gfx.imagecolor(Obj.entities[i].col);
			Gfx.drawtile(cameraxoff + Obj.entities[i].animx + Std.int(Obj.entities[i].xp - World.camerax) * Draw.tilewidth + Std.int(Obj.entities[i].shakex()), 
			             camerayoff + Obj.entities[i].animy + Std.int(Obj.entities[i].yp - World.cameray) * Draw.tileheight + Std.int(Obj.entities[i].shakey()), Obj.entities[i].tileset, Obj.entities[i].drawframe);
			Gfx.imagecolor();
		}else {
			Gfx.imagecolor(Obj.entities[i].col);
			Gfx.drawtile(cameraxoff + Obj.entities[i].animx + Std.int(Obj.entities[i].xp - World.camerax) * Draw.tilewidth, 
			             camerayoff + Obj.entities[i].animy + Std.int(Obj.entities[i].yp - World.cameray) * Draw.tileheight, Obj.entities[i].tileset, Obj.entities[i].drawframe);
			Gfx.imagecolor();
		}
	}
	
	public static function draw_default_player(i:Int):Void {
		//Same as above, but the player draws the tile below correctly
		Draw.filltile(cameraxoff + Obj.entities[i].animx + Std.int(Obj.entities[i].xp - World.camerax) * Draw.tilewidth, 
		              camerayoff + Obj.entities[i].animy + Std.int(Obj.entities[i].yp - World.cameray) * Draw.tileheight, Localworld.backcolourmap(Obj.entities[i].xp, Obj.entities[i].yp, World.at(Obj.entities[i].xp, Obj.entities[i].yp)));
		if (Obj.entities[i].shakecount > 0) {
			Gfx.imagecolor(Obj.entities[i].col);
			Gfx.drawtile(cameraxoff + Obj.entities[i].animx + Std.int(Obj.entities[i].xp - World.camerax) * Draw.tilewidth + Std.int(Obj.entities[i].shakex()), 
			             camerayoff + Obj.entities[i].animy + Std.int(Obj.entities[i].yp - World.cameray) * Draw.tileheight + Std.int(Obj.entities[i].shakey()), Obj.entities[i].tileset, Obj.entities[i].drawframe);
			Gfx.imagecolor();
		}else {
			Gfx.imagecolor(Obj.entities[i].col);
			Gfx.drawtile(cameraxoff + Obj.entities[i].animx + Std.int(Obj.entities[i].xp - World.camerax) * Draw.tilewidth, 
			             camerayoff + Obj.entities[i].animy + Std.int(Obj.entities[i].yp - World.cameray) * Draw.tileheight, Obj.entities[i].tileset, Obj.entities[i].drawframe);
			Gfx.imagecolor();
		}
	}
	
	public static function draw_default_items(i:Int):Void {
		//If we're drawing an item, we want to highlight the square below it if needs be.
		backcolour = Localworld.backcolourmap(Obj.entities[i].xp, Obj.entities[i].yp, World.at(Obj.entities[i].xp, Obj.entities[i].yp));
		if (Localworld.backgroundcolour_needschanging) {
			//Optimisation: Only change the background colour if it's actually lit	
			Draw.filltile(cameraxoff + Obj.entities[i].animx + Std.int(Obj.entities[i].xp - World.camerax) * Draw.tilewidth, 
		              camerayoff + Obj.entities[i].animy + Std.int(Obj.entities[i].yp - World.cameray) * Draw.tileheight, backcolour);
		}
		if (Obj.entities[i].shakecount > 0) {
			Gfx.imagecolor(Obj.entities[i].col);
			Gfx.drawtile(cameraxoff + Obj.entities[i].animx + Std.int(Obj.entities[i].xp - World.camerax) * Draw.tilewidth + Std.int(Obj.entities[i].shakex()), 
			             camerayoff + Obj.entities[i].animy + Std.int(Obj.entities[i].yp - World.cameray) * Draw.tileheight + Std.int(Obj.entities[i].shakey()), Obj.entities[i].tileset, Obj.entities[i].drawframe);
			Gfx.imagecolor();
		}else {
			Gfx.imagecolor(Obj.entities[i].col);
			Gfx.drawtile(cameraxoff + Obj.entities[i].animx + Std.int(Obj.entities[i].xp - World.camerax) * Draw.tilewidth, 
			             camerayoff + Obj.entities[i].animy + Std.int(Obj.entities[i].yp - World.cameray) * Draw.tileheight, Obj.entities[i].tileset, Obj.entities[i].drawframe);
			Gfx.imagecolor();
		}
	}
	
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
		var x:Int = Obj.entities[i].xp - World.camerax;
		var y:Int = Obj.entities[i].yp - World.cameray - 1;
		
		var playerx:Int;
		var playery:Int;
		if (Obj.getplayer() == -1) {
			playerx = 0;
			playery = 0;
		}else{
			playerx = Obj.entities[Obj.getplayer()].xp - World.camerax;
			playery = Obj.entities[Obj.getplayer()].yp - World.cameray;
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
		
		Draw.terminalprint(x, y, Obj.entities[i].message, Draw.messagecol(Obj.entities[i].messagecol), true, Obj.entities[i].animx + cameraxoff, Obj.entities[i].animy - 10 + camerayoff, Draw.messagecolback(Obj.entities[i].messagecol), Draw.messagecolborder(Obj.entities[i].messagecol));
	}
	
	public static function draw_unknown(i:Int):Void {
		Draw.filltile(cameraxoff + Std.int(Obj.entities[i].xp - World.camerax) * Draw.tilewidth, 
		              camerayoff + Std.int(Obj.entities[i].yp - World.cameray) * Draw.tileheight, Game.backgroundcolour);
		Draw.precoloured_drawtile(cameraxoff + Obj.entities[i].animx + Std.int(Obj.entities[i].xp - World.camerax) * Draw.tilewidth, 
		                          camerayoff + Obj.entities[i].animy + Std.int(Obj.entities[i].yp - World.cameray) * Draw.tileheight, "?".charCodeAt(0));
	}
	
	public static function draw_unknown_dangerous(i:Int):Void {
		Draw.filltile(cameraxoff + Std.int(Obj.entities[i].xp - World.camerax) * Draw.tilewidth, 
		              camerayoff + Std.int(Obj.entities[i].yp - World.cameray) * Draw.tileheight, Game.backgroundcolour);
		Gfx.imagecolor(0xFF4444);
		Gfx.drawtile(cameraxoff + Obj.entities[i].animx + Std.int(Obj.entities[i].xp - World.camerax) * Draw.tilewidth, 
		             camerayoff + Obj.entities[i].animy + Std.int(Obj.entities[i].yp - World.cameray) * Draw.tileheight, Obj.entities[i].tileset, "?".charCodeAt(0));
		Gfx.imagecolor();
	}
	
	public static function draw_defaultinit(i:Int, xoff:Int, yoff:Int, t:Int):Void {
		//IMPLEMENT
		//Gfx.drawtile(Std.int(Obj.initentities[i].xp - xoff), Std.int(Obj.initentities[i].yp - yoff), t);
	}
	
	public static function drawentities():Void {
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active) {
				if (!Obj.entities[i].invis) {
					if (Obj.entities[i].collidable) {
						Obj.templates[Obj.entindex.get(Obj.entities[i].rule)].drawentity(i);
						//Gfx.drawbox(Obj.entities[i].xp * 12, Obj.entities[i].yp * 12, 12, 12, 255, 255, 255);
					}else {
						//Ok, to be akward, check that there's not also something else here
						var doubledrawcheck:Bool = false;
						for (j in 0 ... i) {
							if (Obj.entities[i].xp == Obj.entities[j].xp) {
								if (Obj.entities[i].yp == Obj.entities[j].yp) {
									doubledrawcheck = true;
								}
							}
						}
						if (!doubledrawcheck) {
							if (Obj.entities[i].active) {
								if (!Obj.entities[i].invis) {
									Obj.templates[Obj.entindex.get(Obj.entities[i].rule)].drawentity(i);	
									//Gfx.drawbox(Obj.entities[i].xp * 12, Obj.entities[i].yp * 12, 12, 12, 255, 255, 255);
								}
							}
						}
					}
				}else {
					//Gfx.drawbox(Obj.entities[i].xp * 12, Obj.entities[i].yp * 12, 12, 12, 255, 255, 255);
				}
			}
		}
	}
	
	public static function addcolours(one:Int, two:Int):Int {
		var r:Int = Col.getred(one) + Col.getred(two);
		var g:Int = Col.getgreen(one) + Col.getgreen(two);
		var b:Int = Col.getblue(one) + Col.getblue(two);
		
		if (r > 255) r = 255;
		if (g > 255) g = 255;
		if (b > 255) b = 255;
		
		return Col.rgb(r, g, b);
	}
	
	
	public static function shade(currentcol:Int, a:Float):Int {
		if (a > 1.0) a = 1.0;	if (a < 0.0) a = 0.0;
		return Col.rgb(Std.int((Col.getred(currentcol) * a)), Std.int((Col.getgreen(currentcol) * a)), Std.int((Col.getblue(currentcol) * a)));
	}
	
	public static function drawgui():Void {
		Textbox.textboxcleanup();
		//Draw all the textboxes to the screen
		for (i in 0...Textbox.ntextbox) {
			if (Textbox.tb[i].active) {
				Draw.drawtextbox(Std.int(Textbox.tb[i].xp), Std.int(Textbox.tb[i].yp), Std.int(Textbox.tb[i].width), Std.int(Textbox.tb[i].height), Textbox.tb[i].col, Textbox.tb[i].lerp, Textbox.tb[i].textboxstate);
				if (Textbox.tb[i].textboxstate >= Textbox.STATE_TEXTAPPEARING && 
					  Textbox.tb[i].textboxstate < Textbox.STATE_DISAPPEARING) {
					var j:Int;
					if (Textbox.tb[i].showname) {
						for (j in 0...Textbox.tb[i].numlines) {
							if (j == 0) {
								Text.display(Textbox.tb[i].xp + 14, 
													 Textbox.tb[i].yp + 6, 
													 Textbox.tb[i].line[j], Col.rgb(255, 255, 0));
							}else {
								Textbox.tbprint(j, Textbox.tb[i].tbline, Textbox.tb[i].tbcursor, 
																Textbox.tb[i].xp + 22, 
																Textbox.tb[i].yp + 6, 
																Textbox.tb[i].line[j], Col.rgb(255, 255, 255));					
							}
						}
					}else {
						for (j in 0...Textbox.tb[i].numlines) {
							Textbox.tbprint(j, Textbox.tb[i].tbline, Textbox.tb[i].tbcursor, 
															Textbox.tb[i].xp + 14, 
															Textbox.tb[i].yp + 6, 
															Textbox.tb[i].line[j], 255, 255, 255);					
						}
					}
				}
			}
		}
	}
	
	
	public static var tempx:Int;
	public static var tempy:Int;
	
	public static var perlinnoise:Int;
}