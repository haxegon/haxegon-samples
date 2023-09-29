package visuals;

import haxegon.*;
import gamecontrol.Game;
import world.Localworld;
import world.World;
import entities.Obj;
import util.Glow;
import util.Lerp;
import util.Perlinarray;

class Draw {
	public static inline var tilewidth:Int = 12;
	public static inline var tileheight:Int = 12;
	public static var screentilewidth:Int;
	public static var screentileheight:Int;
	
	public static var tempx:Int;
	public static var tempy:Int;
	
	public static var perlinnoise:Int;
	
	public static var walldrawx:Int;
	public static var walldrawy:Int;
	
	public static var currentblock:Int;
	public static var currentblock_south:Int;
	public static var backcolour:Int;
	public static var frontcolour:Int;
	public static var frontcolour_wallshade:Int;
	public static var playerindex:Int;
	
	public static function init():Void {
		screentilewidth = Std.int(384 / 12);
		screentileheight = Std.int(240 / 12);
	}
	
	public static function getperlin(x:Int, y:Int):Int {
		return Perlinarray.perlinnoise[x % 384][y % 240];
	}
	
	public static function setboldtext():Void {
		Text.font = "fffhomepagebold";
		Text.size = 1;
	}
	
	public static function setnormaltext():Void {
		Text.font = "fffhomepage";
		Text.size = 1;
	}
	
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
	
	public static function drawmap():Void {
		Camera.update();
		
		for (j in Camera.y - (Camera.yoff > 0?1:0) ... Draw.screentileheight + 1 + Camera.y) {
			for (i in Camera.x - (Camera.xoff > 0?1:0) ... Draw.screentilewidth + 1 + Camera.x) {
				currentblock = World.at(i, j);// , Camera.x, Camera.y);
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
									Draw.filltile(Camera.xoff + (i * Draw.tilewidth) - (Camera.x * Draw.tilewidth), Camera.yoff + (j * Draw.tileheight) - (Camera.y * Draw.tileheight), backcolour);
								}
								
								if(Localworld.foregroundcolour_needschanging > 1){
									Gfx.imagecolor = frontcolour;
									Gfx.drawtile(Camera.xoff + (i * Draw.tilewidth) - (Camera.x * Draw.tilewidth), Camera.yoff + (j * Draw.tileheight) - (Camera.y * Draw.tileheight), "terminal", Localworld.charmap(i, j, currentblock));
									Gfx.resetcolor();
									//Also do a shade!
									Draw.filltile_half(Camera.xoff + (i * Draw.tilewidth) - (Camera.x * Draw.tilewidth), Camera.yoff + (j * Draw.tileheight) - (Camera.y * Draw.tileheight) + 4, backcolour);
									Gfx.imagecolor = frontcolour_wallshade;
									Gfx.drawtile(Camera.xoff + (i * Draw.tilewidth) - (Camera.x * Draw.tilewidth), Camera.yoff + (j * Draw.tileheight) - (Camera.y * Draw.tileheight), "terminal", Localworld.charmap(i, j, currentblock) + 1);
									Gfx.resetcolor();
								}else if (Localworld.foregroundcolour_needschanging == 1) {
									//Precached lit wall verge
									Draw.precoloured_drawtile(Camera.xoff + (i * Draw.tilewidth) - (Camera.x * Draw.tilewidth), Camera.yoff + (j * Draw.tileheight) - (Camera.y * Draw.tileheight), Localworld.charmap(i, j, currentblock) + 1 + 16);
								}else if (Localworld.foregroundcolour_needschanging == 0) {
									//Precached normal wall verge
									Draw.precoloured_drawtile(Camera.xoff + (i * Draw.tilewidth) - (Camera.x * Draw.tilewidth), Camera.yoff + (j * Draw.tileheight) - (Camera.y * Draw.tileheight), Localworld.charmap(i, j, currentblock) + 1);
								}
							}else {
								//We can just use the precached version
								Draw.precoloured_drawtile(Camera.xoff + (i * Draw.tilewidth) - (Camera.x * Draw.tilewidth), Camera.yoff + (j * Draw.tileheight) - (Camera.y * Draw.tileheight), Localworld.charmap(i, j, currentblock) + 1);
							}
						}else {
							//Draw a regular wall
							if (Localworld.backgroundcolour_needschanging && Localworld.foregroundcolour_needschanging > 1) {
								//Optimisation: Only change the background colour if it's actually lit	
								Draw.filltile(Camera.xoff + (i * Draw.tilewidth) - (Camera.x * Draw.tilewidth), Camera.yoff + (j * Draw.tileheight) - (Camera.y * Draw.tileheight),  backcolour);
							}
							if (Localworld.foregroundcolour_needschanging > 1) {
								Gfx.imagecolor = frontcolour;
								Gfx.drawtile(Camera.xoff + (i * Draw.tilewidth) - (Camera.x * Draw.tilewidth), Camera.yoff + (j * Draw.tileheight) - (Camera.y * Draw.tileheight), "terminal", Localworld.charmap(i, j, currentblock));
								Gfx.resetcolor();
							}else if (Localworld.foregroundcolour_needschanging == 1) {
								//Ok, we've cached a lit version of the wall, use that!
								Draw.precoloured_drawtile(Camera.xoff + (i * Draw.tilewidth) - (Camera.x * Draw.tilewidth), Camera.yoff + (j * Draw.tileheight) - (Camera.y * Draw.tileheight), Localworld.charmap(i, j, currentblock) + 16);
							}else {
								Draw.precoloured_drawtile(Camera.xoff + (i * Draw.tilewidth) - (Camera.x * Draw.tilewidth), Camera.yoff + (j * Draw.tileheight) - (Camera.y * Draw.tileheight), Localworld.charmap(i, j, currentblock));
							}
						}
						//drawwall(i, j, (i * Gfx.tiles[Gfx.currenttileset].width) - (World.camerax * Gfx.tiles[Gfx.currenttileset].width), (j * Gfx.tiles[Gfx.currenttileset].height) - (World.cameray * Gfx.tiles[Gfx.currenttileset].height));
					}
				}else	if (currentblock != Localworld.BACKGROUND) {
					if (Localworld.fogat(i, j) == 1) {
						if (Localworld.backgroundcolour_needschanging || Localworld.foregroundcolour_needschanging > 1) {
							//Optimisation: Only change the background colour if it's actually lit	
							Draw.filltile(Camera.xoff + (i * Draw.tilewidth) - (Camera.x * Draw.tilewidth), Camera.yoff + (j * Draw.tileheight) - (Camera.y * Draw.tileheight), backcolour);
						}
						if (currentblock == Localworld.FLOOR) {
							//All the floors are precaclulated!
							if (Localworld.foregroundcolour_needschanging > 1) {
								Gfx.imagecolor = frontcolour;
								Gfx.drawtile(Camera.xoff + (i * Draw.tilewidth) - (Camera.x * Draw.tilewidth), Camera.yoff + (j * Draw.tileheight) - (Camera.y * Draw.tileheight), "terminal", Localworld.charmap(i, j, currentblock));
								Gfx.resetcolor();
							}else if (Localworld.foregroundcolour_needschanging == 1) {
								Draw.precoloured_drawtile(Camera.xoff + (i * Draw.tilewidth) - (Camera.x * Draw.tilewidth), Camera.yoff + (j * Draw.tileheight) - (Camera.y * Draw.tileheight), Localworld.charmap(i, j, currentblock) + 16);
							}else {
								Draw.precoloured_drawtile(Camera.xoff + (i * Draw.tilewidth) - (Camera.x * Draw.tilewidth), Camera.yoff + (j * Draw.tileheight) - (Camera.y * Draw.tileheight), Localworld.charmap(i, j, currentblock));
							}
						}else if (currentblock == Localworld.ROOFSTARS) {
							//For drawing the stars, we hardcode a little animation, and force a background colour
							Starfield.updatetwinkle(i, j);
							Draw.precoloured_drawtile(Camera.xoff + (i * Draw.tilewidth) - (Camera.x * Draw.tilewidth), Camera.yoff + (j * Draw.tileheight) - (Camera.y * Draw.tileheight), Localworld.charmap(i, j, currentblock) + Starfield.twinkle);
						}else{
							Gfx.imagecolor = frontcolour;
							Gfx.drawtile(Camera.xoff + (i * Draw.tilewidth) - (Camera.x * Draw.tilewidth), Camera.yoff + (j * Draw.tileheight) - (Camera.y * Draw.tileheight), "terminal", Localworld.charmap(i, j, currentblock));
							Gfx.resetcolor();
						}
					}else {
						//Optimisation: We're drawing a fogged out area here, we don't need the fillrect
						//Draw.filltile(cameraxoff + (i * Draw.tilewidth) - (World.camerax * Draw.tilewidth), camerayoff + (j * Draw.tileheight) - (World.cameray * Draw.tileheight), Localworld.backcolourmap(i, j, currentblock));
						if (currentblock == Localworld.KEY) {
							Draw.precoloured_drawtile(Camera.xoff + (i * Draw.tilewidth) - (Camera.x * Draw.tilewidth), Camera.yoff + (j * Draw.tileheight) - (Camera.y * Draw.tileheight), "?".charCodeAt(0));
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
		Gfx.imagecolor = col;
		Gfx.drawtile(xp, yp, "terminal", 17);
		Gfx.resetcolor();
	}
	
	public static function filltile_half(xp:Int, yp:Int, col:Int) {
		Gfx.imagecolor = col;
		Gfx.drawtile(xp, yp, "terminal", 18);
		Gfx.resetcolor();
	}
	
	public static function roundfillrect(x:Int, y:Int, w:Float, h:Float, c:Int):Void {
		Gfx.fillbox(x+1, y, w-2, h, c);
		Gfx.fillbox(x, y+1, w, h-2, c);
	}
	
	public static function grayscale():Void {
		Gfx.fillbox(0, 0, Gfx.screenwidth, Gfx.screenheight, Col.WHITE, 0.25 - (Glow.glow / 1024));
	}
	
	public static function alarmtransform(amount:Int):Void {
		var v:Float = 0;
		if (amount >= 250) {
			v = (0.1 * (500- amount)) / 250;	
		}else {
		  v = (0.1 * amount) / 250;	
		}
		Gfx.fillbox(0, 0, Gfx.screenwidth, Gfx.screenheight, Col.WHITE, v);
	}
	
	public static function terminalprint(x:Int, y:Int, t:String, col:Int = 0xFFFFFF, drawbacking:Bool = false, xoffset:Int = 0, yoffset:Int = 0, backingcol:Int = 0x444444, bordercol:Int = 0x000000):Void {
		y = y * 12;
		if (x == Gfx.CENTER) {
			x = Gfx.screenwidthmid - Std.int(Text.width(t) / 2);
		}else {
			x = x * 12;
		}
		if (drawbacking) {
			roundfillrect(x - 4 + xoffset, y - 4 + yoffset+4, Text.width(t)+8, Text.height()+3+8 - 1, Col.BLACK);
			roundfillrect(x - 2 + xoffset, y - 2 + yoffset+4, Text.width(t)+4, Text.height()+3+4 - 1, bordercol);
			roundfillrect(x + xoffset, y + yoffset+4, Text.width(t), Text.height() + 3 - 1, backingcol);
		}
		
		Text.display(x + xoffset - 1, y + yoffset + 3 - 1, t, col);
	}
	
	public static function letterterminalprint(x:Int, y:Int, t:String, col:Int = 0xFFFFFF, drawbacking:Bool = false, xoffset:Int = 0, yoffset:Int = 0, backingcol:Int = 0x444444, bordercol:Int = 0x000000):Void {
		y = y * 12;
		if (x == Gfx.CENTER) {
			x = Gfx.screenwidthmid - Std.int(Text.width(t) / 2);
		}
		if (drawbacking) {
			roundfillrect(x - 4 + xoffset, y - 4 + yoffset+4, Text.width(t)+8, Text.height()+8 - 1, Col.BLACK);
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
	}
	
	public static function draw_default(i:Int):Void {
		Draw.filltile(Camera.xoff + Obj.entities[i].animx + Std.int(Obj.entities[i].xp - Camera.x) * Draw.tilewidth, 
		              Camera.yoff + Obj.entities[i].animy + Std.int(Obj.entities[i].yp - Camera.y) * Draw.tileheight, Game.backgroundcolour);
		if (Obj.entities[i].shakecount > 0) {
			Gfx.imagecolor = Obj.entities[i].col;
			Gfx.drawtile(Camera.xoff + Obj.entities[i].animx + Std.int(Obj.entities[i].xp - Camera.x) * Draw.tilewidth + Std.int(Obj.entities[i].shakex()), 
			             Camera.yoff + Obj.entities[i].animy + Std.int(Obj.entities[i].yp - Camera.y) * Draw.tileheight + Std.int(Obj.entities[i].shakey()), Obj.entities[i].tileset, Obj.entities[i].drawframe);
			Gfx.resetcolor();
		}else {
			Gfx.imagecolor = Obj.entities[i].col;
			Gfx.drawtile(Camera.xoff + Obj.entities[i].animx + Std.int(Obj.entities[i].xp - Camera.x) * Draw.tilewidth, 
			             Camera.yoff + Obj.entities[i].animy + Std.int(Obj.entities[i].yp - Camera.y) * Draw.tileheight, Obj.entities[i].tileset, Obj.entities[i].drawframe);
			Gfx.resetcolor();
		}
	}
	
	public static function draw_default_player(i:Int):Void {
		//Same as above, but the player draws the tile below correctly
		Draw.filltile(Camera.xoff + Obj.entities[i].animx + Std.int(Obj.entities[i].xp - Camera.x) * Draw.tilewidth, 
		              Camera.yoff + Obj.entities[i].animy + Std.int(Obj.entities[i].yp - Camera.y) * Draw.tileheight, Localworld.backcolourmap(Obj.entities[i].xp, Obj.entities[i].yp, World.at(Obj.entities[i].xp, Obj.entities[i].yp)));
		if (Obj.entities[i].shakecount > 0) {
			Gfx.imagecolor = Obj.entities[i].col;
			Gfx.drawtile(Camera.xoff + Obj.entities[i].animx + Std.int(Obj.entities[i].xp - Camera.x) * Draw.tilewidth + Std.int(Obj.entities[i].shakex()), 
			             Camera.yoff + Obj.entities[i].animy + Std.int(Obj.entities[i].yp - Camera.y) * Draw.tileheight + Std.int(Obj.entities[i].shakey()), Obj.entities[i].tileset, Obj.entities[i].drawframe);
			Gfx.resetcolor();
		}else {
			Gfx.imagecolor = Obj.entities[i].col;
			Gfx.drawtile(Camera.xoff + Obj.entities[i].animx + Std.int(Obj.entities[i].xp - Camera.x) * Draw.tilewidth, 
			             Camera.yoff + Obj.entities[i].animy + Std.int(Obj.entities[i].yp - Camera.y) * Draw.tileheight, Obj.entities[i].tileset, Obj.entities[i].drawframe);
			Gfx.resetcolor();
		}
	}
	
	public static function draw_default_items(i:Int):Void {
		//If we're drawing an item, we want to highlight the square below it if needs be.
		backcolour = Localworld.backcolourmap(Obj.entities[i].xp, Obj.entities[i].yp, World.at(Obj.entities[i].xp, Obj.entities[i].yp));
		if (Localworld.backgroundcolour_needschanging) {
			//Optimisation: Only change the background colour if it's actually lit	
			Draw.filltile(Camera.xoff + Obj.entities[i].animx + Std.int(Obj.entities[i].xp - Camera.x) * Draw.tilewidth, 
		              Camera.yoff + Obj.entities[i].animy + Std.int(Obj.entities[i].yp - Camera.y) * Draw.tileheight, backcolour);
		}
		if (Obj.entities[i].shakecount > 0) {
			Gfx.imagecolor = Obj.entities[i].col;
			Gfx.drawtile(Camera.xoff + Obj.entities[i].animx + Std.int(Obj.entities[i].xp - Camera.x) * Draw.tilewidth + Std.int(Obj.entities[i].shakex()), 
			             Camera.yoff + Obj.entities[i].animy + Std.int(Obj.entities[i].yp - Camera.y) * Draw.tileheight + Std.int(Obj.entities[i].shakey()), Obj.entities[i].tileset, Obj.entities[i].drawframe);
			Gfx.resetcolor();
		}else {
			Gfx.imagecolor = Obj.entities[i].col;
			Gfx.drawtile(Camera.xoff + Obj.entities[i].animx + Std.int(Obj.entities[i].xp - Camera.x) * Draw.tilewidth, 
			             Camera.yoff + Obj.entities[i].animy + Std.int(Obj.entities[i].yp - Camera.y) * Draw.tileheight, Obj.entities[i].tileset, Obj.entities[i].drawframe);
			Gfx.resetcolor();
		}
	}
	
	public static function draw_unknown(i:Int):Void {
		Draw.filltile(Camera.xoff + Std.int(Obj.entities[i].xp - Camera.x) * Draw.tilewidth, 
		              Camera.yoff + Std.int(Obj.entities[i].yp - Camera.y) * Draw.tileheight, Game.backgroundcolour);
		Draw.precoloured_drawtile(Camera.xoff + Obj.entities[i].animx + Std.int(Obj.entities[i].xp - Camera.x) * Draw.tilewidth, 
		                          Camera.yoff + Obj.entities[i].animy + Std.int(Obj.entities[i].yp - Camera.y) * Draw.tileheight, "?".charCodeAt(0));
	}
	
	public static function draw_unknown_dangerous(i:Int):Void {
		Draw.filltile(Camera.xoff + Std.int(Obj.entities[i].xp - Camera.x) * Draw.tilewidth, 
		              Camera.yoff + Std.int(Obj.entities[i].yp - Camera.y) * Draw.tileheight, Game.backgroundcolour);
		Gfx.imagecolor = 0xFF4444;
		Gfx.drawtile(Camera.xoff + Obj.entities[i].animx + Std.int(Obj.entities[i].xp - Camera.x) * Draw.tilewidth, 
		             Camera.yoff + Obj.entities[i].animy + Std.int(Obj.entities[i].yp - Camera.y) * Draw.tileheight, Obj.entities[i].tileset, "?".charCodeAt(0));
		Gfx.resetcolor();
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
	
	public static function drawbubble(x:Int, y:Int, w:Int, h:Int, backingcol:Int, bordercol:Int, innercol:Int) {
		roundfillrect(x, y, w, h, bordercol);
		roundfillrect(x + 1, y + 1, w - 2, h - 2, backingcol);
		roundfillrect(x + 2, y + 2, w - 4, h - 4, innercol);
	}
}