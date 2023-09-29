package world;

import entities.Obj;
import gamecontrol.Game;
import modernversion.AIDirector;
import visuals.ScreenEffects;
import util.Rand;
import util.Direction;
import haxegon.Random;

//Glitch effects for the out of bounds tower
class Glitch{
	public static var glitchmode:Bool = false;
	static var tempx:Int;
	static var tempy:Int;
	static var tempx2:Int;
	static var tempy2:Int;
	static var t1:Int;
	static var t2:Int;
	static var t3:Int;
	
	public static function glitch() {
		//Distort the level in some unexpected way
		var temp:Int = Random.int(0, 100);
		if (temp < 50) {
		}else if(temp < 65){
			swaptwononplayerentities();
		}else if (temp < 68) {
			shiftcolumn(Random.int(0, World.mapwidth));
		}else {
			swaptwoblocks();
		}
	}
	
	public static function swaptwononplayerentities() {
		//Swap two non-player entities
		var t1:Int = Random.int(0, Obj.nentity);
		var t2:Int = Random.int(0, Obj.nentity);
		if (Obj.entities[t1].active && Obj.entities[t2].active) {
		  if (t1 != t2) {
			  if (Obj.entities[t1].rule != "player" && Obj.entities[t2].rule != "player") {
				  tempx = Obj.entities[t1].xp;
					tempy = Obj.entities[t1].yp;
					Obj.entities[t1].xp = Obj.entities[t2].xp;
					Obj.entities[t1].yp = Obj.entities[t2].yp;
					Obj.entities[t2].xp = tempx;
					Obj.entities[t2].yp = tempy;
				}
			}
		}	
	}
	
	public static function shiftcolumn(c:Int) {
		//Cancel it if the player is in it
		t1 = Obj.getplayer();
		if (t1 >-1) {
			if (Obj.entities[t1].xp != c) {
				//First the blocks
				t2 = World.at(c, 0);
				for (j in 0 ... World.mapheight - 2) {
				  World.placetile(c, j, World.at(c, j + 1));	
				}
				World.placetile(c,  World.mapheight - 1, t2);
				
				//Then the entities
				for (j in 0 ... Obj.nentity) {
				  if (Obj.entities[j].active) {
						if(Obj.entities[j].xp == c){
							Obj.entities[j].yp--;
							if (Obj.entities[j].yp < 0) {
								Obj.entities[j].yp += World.mapheight;
							}
						}
					}
				}
			}			
		}
	}
	
	public static function swaptwoblocks() {
		tempx = Random.int(0, World.mapwidth - 1);
		tempy = Random.int(0, World.mapheight - 1);
		tempx2 = Random.int(0, World.mapwidth - 1);
		tempy2 = Random.int(0, World.mapheight - 1);
		
		var player:Int = Obj.getplayer();
		if (player > -1) {
			if (Math.abs(Obj.entities[player].xp - tempx) > 3 || Math.abs(Obj.entities[player].yp - tempy) > 3) {
				if (Math.abs(Obj.entities[player].xp - tempx2) > 3 || Math.abs(Obj.entities[player].yp - tempy2) > 3) {
					t2 = World.at(tempx, tempy);
					World.placetile(tempx, tempy, World.at(tempx2, tempy2));
					World.placetile(tempx2, tempy2, t2);
				}
			}
		}	
	}
	
	public static function glitchoutside(level:Int) {
		if (level >= 5) {
			for (i in 0 ... (level - 5) * 4) {
				swaptwoblocks();	
			}
		}
	}
	
	public static function glitchexplode(x:Int, y:Int, rad:Int, hurtplayer:Bool = true):Void {
		//An explosion! Like explosion, but randomises stuff too
		var randomblocks:Array<Int> = [Localworld.FLOOR, Localworld.BLOOD, Localworld.WALL,
			                               Localworld.DOOR, Localworld.OPENDOOR, Localworld.RUBBLE, Localworld.EMPTYBACKGROUND,
																		 Localworld.OUTSIDE_GROUND, Localworld.DEBRIS,
																		 Localworld.ROOFSIDE, Localworld.ROOFBACKGROUND, Localworld.ROOFSTARS
																		 ];
    if (AIDirector.floor == 16) {
		  randomblocks.remove(Localworld.ROOFSIDE);	
			randomblocks.remove(Localworld.ROOFBACKGROUND);	
			randomblocks.remove(Localworld.ROOFSTARS);	
		}
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
					if (protectedsquares) {
						World.placetile(x + j, y + k, Rand.ppick(randomblocks));
						if (Rand.prare()) {
							//Low probablity of weird blocks	
							World.placetile(x + j, y + k, Rand.ppick([Localworld.BANANAPEEL, Localworld.OUTSIDE_EDGE, 
																								Localworld.ENTRANCE, Localworld.LOCKEDDOOR]));
							if (Rand.prare() && x + j > 5 && y + k > 5 && x + j < World.mapwidth - 5 && y + k < World.mapheight - 5) {
								World.placetile(x + j, y + k, Localworld.STAIRS);
							}
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
}