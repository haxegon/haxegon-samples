package gamecontrol;

import haxegon.*;
import gamecontrol.misc.*;
import terrylib.*;

class Openworld {
	public static inline var PIT:Int = 0;
	public static inline var RUIN1:Int = 1;
	public static inline var RUIN2:Int = 2;
	public static inline var RUIN3:Int = 3;
	public static inline var RUIN4:Int = 4;
	public static inline var RIVER:Int = 5;
	public static inline var BUILDING:Int = 6;
	public static inline var ROAD:Int = 7;
	public static inline var CAMP:Int = 8;
	
	public static function init():Void {
		for (i in 0 ... 100) worldblock.push(new Worldblockclass());
		
		worldblock[PIT].set(0, 0, Col.rgb(0, 0, 0), Col.rgb(0, 0, 32));
		worldblock[RUIN1].set(c("."), c("."), Col.rgb(64, 64, 64), Col.rgb(64, 64, 64), Col.rgb(32, 32, 32), Col.rgb(32, 32, 32));
		worldblock[RUIN2].set(c(" "), c(" "), Col.rgb(64, 64, 64), Col.rgb(64, 64, 64), Col.rgb(32, 32, 32), Col.rgb(32, 32, 32));
		worldblock[RUIN3].set(c(" "), c(" "), Col.rgb(64, 64, 64), Col.rgb(64, 64, 64), Col.rgb(32, 32, 32), Col.rgb(32, 32, 32));
		worldblock[RUIN4].set(c("#"), c("#"), Col.rgb(96, 96, 96), Col.rgb(96, 96, 96), Col.rgb(32, 32, 32), Col.rgb(32, 32, 32));
		worldblock[RIVER].set(177, 177, Col.rgb(160, 32, 32), Col.rgb(160, 16, 16));
		worldblock[BUILDING].set(8, 8, Col.rgb(220, 220, 220), Col.rgb(160, 160, 160));
		worldblock[ROAD].set(219, 219, Col.rgb(96, 96, 96), Col.rgb(96, 96, 96));
		worldblock[CAMP].set(c("+"), c("+"), Col.rgb(64, 220, 64), Col.rgb(32, 160, 32));
	}
	
	public static function checkforroomchange():Void {
		//If at the end of the turn, we're off the map, then we go to the next one!
		if (!inside) {
			var player:Int = Obj.getplayer();
			if (!Help.inboxw(Obj.entities[player].xp, Obj.entities[player].yp, 0, 0, World.mapwidth-1, World.mapheight-1)) {
				if (Obj.entities[player].xp < 0) {
					Obj.entities[player].xp += 32;
					worldx--;
				}else if (Obj.entities[player].xp >= 32) {
					Obj.entities[player].xp -= 32;
					worldx++;
				}else	if (Obj.entities[player].yp < 0) {
					Obj.entities[player].yp += 19;
					worldy--;
				}else if (Obj.entities[player].yp >= 19) {
					Obj.entities[player].yp -= 19;
					worldy++;
				}
				
				Game.changeroom("outside");
				//For fairness, the block you enter on cannot be on fire.
				if (Localworld.onfire) {
					Localworld.extingushfireblock(Obj.entities[player].xp, Obj.entities[player].yp);
				}
				Localworld.updatelighting();
			}
		}
	}
	
	public static function roomat(x:Int, y:Int):String {
		if (Help.inboxw(x, y, 0, 0, worldwidth - 1, worldheight - 1)) {
			temp = World.worldmap[x + (y * worldwidth)];
			switch(temp) {
				case Openworld.RUIN1, Openworld.RUIN2, Openworld.RUIN3, Openworld.RUIN4:
					if (x == 0 || y == 0 || x == worldwidth - 1 || y == worldheight - 1) {
						return "outside_boundary";
					}
					return "outside_ruin";
				case Openworld.CAMP:
					return "outside_camp";
				case Openworld.RIVER:
					return "outside_river";
				case Openworld.ROAD:
					if (x == 0 || y == 0 || x == worldwidth - 1 || y == worldheight - 1) {
						return "outside_boundary";
					}
					return "outside_ruin";
				case Openworld.BUILDING:
					if (x == 0 || y == 0 || x == worldwidth - 1 || y == worldheight - 1) {
						return "outside_boundary";
					}
					return "outside_building";
				case Openworld.PIT:
					return "outside_ruin";
			}
		}
		return "wasteland";
	}
	
	public static function c(t:String):Int {
		return t.charCodeAt(0);
	}
	
	public static function charmap(t:Int, fog:Int):Int {
		//Return the ASCII character to use for each wall type
		if (fog == 1) {
			return worldblock[t].charcode_fog;
		}else{
			return 0;
		}
		return 0;
	}
	
	public static function colourmap(t:Int, fog:Int):Int {
		//Return the RGB value to use for each wall type
		if (fog == 1) {
			return worldblock[t].front_fog;
		}else{
			return 0;
		}
		return 0;
	}
	
	public static function backcolourmap(t:Int, fog:Int):Int {
		if (fog == 1) {
			return worldblock[t].back_fog;
		}
		return 0;
	}
	
	public static function changemapsize(w:Int, h:Int):Void {
		worldwidth = w;
		worldheight = h;
	}
	
	public static function xstep(t:Int, dif:Int = 1):Int {
		if (t == Help.LEFT) return -dif;
		if (t == Help.RIGHT) return dif;
		return 0;
	}
	
	public static function ystep(t:Int, dif:Int = 1):Int {
		if (t == Help.UP) return -dif;
		if (t == Help.DOWN) return dif;
		return 0;
	}
	
	public static function generateroomseed(x:Int, y:Int, t:Int):Void {
		if (Help.inboxw(x, y, 0, 0, worldwidth - 1, worldheight - 1)) {
			World.worldmapseed[x + (y * worldwidth)] = t;
		}
	}
	
	public static function getroomseed(x:Int, y:Int):Int {
		if (Help.inboxw(x, y, 0, 0, worldwidth - 1, worldheight - 1)) {
			return World.worldmapseed[x + (y * worldwidth)];
		}
		return worldseed + x + (worldwidth * y);
	}
	
	public static function placetile(x:Int, y:Int, t:Int):Void {
		if (Help.inboxw(x, y, 0, 0, worldwidth - 1, worldheight - 1)) {
			World.worldmap[x + (y * worldwidth)] = t;
		}
	}
	
	public static function at(x:Int, y:Int):Int {
		if (Help.inboxw(x, y, 0, 0, worldwidth - 1, worldheight - 1)) {
			return World.worldmap[x + (y * worldwidth)];
		}
		return PIT;
	}
	
	
	public static function ruinat(x:Int, y:Int):Bool {
		if (Help.inboxw(x, y, 0, 0, worldwidth - 1, worldheight - 1)) {
			var t:Int = World.worldmap[x + (y * worldwidth)];
			if (t == RUIN1 || t == RUIN2 || t == RUIN3 || t == RUIN4) {
				return true;
			}
		}
		return false;
	}
	
	
	
	public static function fogpoint(x:Int, y:Int):Void {
		if (Help.inboxw(x, y, 0, 0, worldwidth, worldheight)) {
			World.worldmapfog[x + (y * worldwidth)] = 1;
		}
	}
	
	public static function fogat(x:Int, y:Int):Int {
		return 1;
		if (x >= 0 && y >= 0 && x < worldwidth && y < worldheight) {
			return World.worldmapfog[x + (y * worldwidth)];
		}
		return 0;
	}
	
	public static function drawmap(x:Int, y:Int, tileset:String):Void {
		var t:Int;
			
		for (j in 0 ... 21) {
			for (i in 0 ... 49) {
				t = at(i, j);
				if (t > 0) {
					Gfx.fillbox((i + x) * Draw.tilewidth, (j + y) * Draw.tileheight, Draw.tilewidth, Draw.tileheight, backcolourmap(t, fogat(i, j)));
					Gfx.imagecolor(colourmap(t, fogat(i, j)));
					Gfx.drawtile((i + x) * Draw.tilewidth, (j + y) * Draw.tileheight, tileset, charmap(t, fogat(i, j)));
					Gfx.imagecolor();
				}
			}
		}
		
		if (viewmap <= 0) {
			Gfx.fillbox((worldx + x) * Draw.tilewidth, (worldy + y) * Draw.tileheight, Draw.tilewidth, Draw.tileheight, Col.BLACK);
			Gfx.drawtile((worldx + x) * Draw.tilewidth, (worldy + y) * Draw.tileheight, tileset, "@".charCodeAt(0));
		}else{
			if (Help.tenseconds % 20 >= 10) {
				Gfx.fillbox((worldx+x) * Draw.tilewidth, (worldy+y) * Draw.tileheight, Draw.tilewidth, Draw.tileheight, Col.BLACK);
				Gfx.drawtile((worldx+x) * Draw.tilewidth, (worldy+y) * Draw.tileheight, tileset, "@".charCodeAt(0));
			}
		}
	}
	
	/** Flood out the river! */
	public static function flood():Void{
		for (j in 0 ... worldheight) {
			for (i in 0 ... worldwidth) {
				if (at(i, j) == RIVER) {
					for (j2 in -1 ... 2) {
						for (i2 in -1 ... 2) {
							if (at(i + i2, j + j2) != RIVER) {
								placetile(i + i2, j + j2, -1);	
							}
						}
					}
				}
			}
		}
		
		for (j in 0 ... worldheight) {
			for (i in 0 ... worldwidth) {
				if (at(i, j) == -1) {
					placetile(i, j, Rand.ppickint(RIVER, RIVER, Rand.ppickint(RUIN1, RUIN2, RUIN3, RUIN4)));
				}
			}
		}
	}
	
	/** Set tx and ty to border tiles */
	public static function getbordertile():Void {
		if (Rand.pbool()) {
			getborderhorizontal();
		}else {
			getbordervertical();
		}
	}
	
	public static function getborderhorizontal():Void {
		//Horizontal
		if (Rand.pbool()) {
			ty = 0;
			tdir = Help.DOWN;
		}else {
			ty = worldheight - 1;
			tdir = Help.UP;
		}
		
		tx = Rand.pint(Std.int(worldwidth/2)-10, Std.int(worldwidth/2)+10);
	}
	
	public static function getbordervertical():Void {
		//Vertical
		if (Rand.pbool()) {
			tx = 0;
			tdir = Help.RIGHT;
		}else {
			tx = worldwidth - 1;
			tdir = Help.LEFT;
		}
		
		ty = Rand.pint(Std.int(worldheight/2)-4, Std.int(worldheight/2)+4);
	}
	
	public static function riverflow(x:Int, y:Int, dir:Int):Void {
		tx = x; ty = y;
		tr = Rand.pint(0, 100);
		
		if (tr < 60) {
			placetile(tx, ty, RIVER); tx = tx + xstep(dir); ty = ty + ystep(dir);
			placetile(tx, ty, RIVER);	tx = tx + xstep(dir); ty = ty + ystep(dir);
			placetile(tx, ty, RIVER);	tx = tx + xstep(dir); ty = ty + ystep(dir);
			placetile(tx, ty, RIVER); tx = tx + xstep(dir); ty = ty + ystep(dir);
		}else if (tr < 80) {
			placetile(tx, ty, RIVER);	tx = tx + xstep(dir); ty = ty + ystep(dir);
			dir = Help.clockwise(dir);
			placetile(tx, ty, RIVER); tx = tx + xstep(dir); ty = ty + ystep(dir);
			placetile(tx, ty, RIVER); tx = tx + xstep(dir); ty = ty + ystep(dir);
			placetile(tx, ty, RIVER);	tx = tx + xstep(dir); ty = ty + ystep(dir);
			dir = Help.anticlockwise(dir);
			placetile(tx, ty, RIVER);	tx = tx + xstep(dir); ty = ty + ystep(dir);
		}else{
			placetile(tx, ty, RIVER);	tx = tx + xstep(dir); ty = ty + ystep(dir);
			dir = Help.anticlockwise(dir);
			placetile(tx, ty, RIVER); tx = tx + xstep(dir); ty = ty + ystep(dir);
			placetile(tx, ty, RIVER); tx = tx + xstep(dir); ty = ty + ystep(dir);
			placetile(tx, ty, RIVER);	tx = tx + xstep(dir); ty = ty + ystep(dir);
			dir = Help.clockwise(dir);
			placetile(tx, ty, RIVER);	tx = tx + xstep(dir); ty = ty + ystep(dir);
		}
		
		if (Help.inboxw(tx, ty, 0, 0, worldwidth, worldheight)) {
			riverflow(tx, ty, dir);
		}
	}
	
	public static function drive():Void {
		tx = tx + xstep(tdir); ty = ty + ystep(tdir);
	}
	
	public static function roadflow(x:Int, y:Int, dir:Int):Void {
		tx = x; ty = y; tdir = dir;
		tr = Rand.pint(0, 100);
		
		if(tr<90){
			placetile(tx, ty, ROAD); drive();
			placetile(tx, ty, ROAD); drive();
			placetile(tx, ty, ROAD); drive();
			placetile(tx, ty, ROAD); drive();
			placetile(tx, ty, ROAD); drive();
			placetile(tx, ty, ROAD); drive();
			placetile(tx, ty, ROAD); drive();
		}else {
			placetile(tx, ty, ROAD); drive();
			tdir = Rand.ppickint(Help.clockwise(tdir), Help.anticlockwise(tdir));
			placetile(tx, ty, ROAD); drive();
		}
		
		if (Help.inboxw(tx, ty, 0, 0, worldwidth, worldheight)) {
			roadflow(tx, ty, tdir);
		}
	}
	
	/** Place block at random, rejecting blocks beside another of the same type, or rivers */
	public static function placeatrandom_avoiding(block:Int, avoid1:Int = 0, avoid2:Int = 0, avoid3:Int = 0):Void {
		tx = -1;
		attempts = 250;
		while (attempts > 0 && (tx == -1 || !ruinat(tx, ty))) {
			tx = Rand.pint(2, worldwidth-3);	ty = Rand.pint(2, worldheight-3);
		}
		
		if (attempts > 0) {
			//OMG just place it already
			placetile(tx, ty, block);
		}else{
			var checknearby:Int=0;
			for (j in -2 ... 3) {
				for (i in -2 ... 3) {
					if (at(tx + i, ty + j) == block || at(tx + i, ty + j) == avoid1  || at(tx + i, ty + j) == avoid2  || at(tx + i, ty + j) == avoid3) {
						checknearby = 1;
					}
				}
			}
			
			if (checknearby == 1) {
				placeatrandom_avoiding(block, avoid1, avoid2, avoid3);
			}else{
				placetile(tx, ty, block);
			}
		}
	}
	
	/** Place block at random, rejecting blocks beside another of the same type, or rivers */
	public static function placeatcenter_avoiding(block:Int, avoid1:Int = 0, avoid2:Int = 0, avoid3:Int = 0):Void {
		tx = -1;
		attempts = 250;
		while (attempts > 0 && (tx == -1 || !ruinat(tx, ty))) {
			tx = Rand.pint(Std.int(worldwidth / 2) - 8, Std.int(worldwidth / 2) + 8);	ty = Rand.pint(Std.int(worldheight / 2) - 5, Std.int(worldheight / 2) + 5);
			attempts--;
		}
		
		if (attempts > 0) {
			//OMG just place it already
			placetile(tx, ty, block);
		}else{
			var checknearby:Int=0;
			for (j in -2 ... 3) {
				for (i in -2 ... 3) {
					if (at(tx + i, ty + j) == block || at(tx + i, ty + j) == avoid1  || at(tx + i, ty + j) == avoid2  || at(tx + i, ty + j) == avoid3) {
						checknearby = 1;
					}
				}
			}
			
			if (checknearby == 1) {
				placeatrandom_avoiding(block, avoid1, avoid2, avoid3);
			}else{
				placetile(tx, ty, block);
			}
		}
	}
	
	
	public static function gotocamp():Void {
		for (j in 0 ... worldheight) {
			for (i in 0 ... worldwidth) {
				if (at(i, j) == CAMP) {
					worldx = i;
					worldy = j;
				}
			}
		}
	}
	
	public static function generate(t:String):Void {
		//Turn the string t into a world seed!
		worldseed = 0;
		for (i in 0 ... t.length) {
			worldseed += (Help.Mid(t, i).charCodeAt(0) * Help.Mid(t, i).charCodeAt(0)) % 233280;
		}
		
		Rand.setseed(worldseed);
		
		changemapsize(40, 18);
		
		for (j in 0 ... worldheight) {
			for (i in 0 ... worldwidth) {
			  placetile(i, j, Rand.ppickint(RUIN1, RUIN2, RUIN3, RUIN4));	
				generateroomseed(i, j, (Rand.pint(0, 233280) * Rand.pint(0, 233280)) % 233280);
			}
		}
		
		getborderhorizontal(); roadflow(tx, ty, tdir);
		getbordervertical(); roadflow(tx, ty, tdir);
		getbordervertical(); roadflow(tx, ty, tdir);
		if (Rand.pint(0, 100) > 95) {
			getborderhorizontal(); roadflow(tx, ty, tdir);
		}
		
		if (Rand.pint(0, 100) > 95) {
			getbordertile();
			riverflow(tx, ty, tdir);			
		}
		getbordertile();
		riverflow(tx, ty, tdir);
		flood();
		flood();
		
		for (i in 0 ... 10) {
			placeatrandom_avoiding(BUILDING, RIVER);
		}
		placeatcenter_avoiding(CAMP, RIVER, BUILDING);
		
		gotocamp();
	}
	
	public static var worldwidth:Int;
	public static var worldheight:Int;
	public static var worldblock:Array<Worldblockclass> = new Array<Worldblockclass>();
	
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
	public static var temp:Int;
	public static var attempts:Int;
	
	//Store world seeds here
	public static var worldseed:Int;
	public static var worldx:Int;
	public static var worldy:Int;
	public static var inside:Bool = true;
	
	public static var viewmap:Int;
}