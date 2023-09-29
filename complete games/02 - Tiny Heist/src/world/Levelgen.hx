package world;

import haxegon.*;
import gamecontrol.*;
import entities.EnemyType;
import modernversion.AIDirector;
import modernversion.Modern;
import entities.ItemType;
import entities.Obj;
import world.World;
import util.Rand;
import util.Glow;
import openfl.geom.Point;

class Levelgen {
	public static function createroom() {
		Game.clearroom();
		Game.floor = AIDirector.floor;
		AIDirector.entrance = "X";
		
		Modern.updatepalette();
		
		//This is where all level generation decisions are made now!
		if (Game.floor == 16) {
			Game.showmessage("ROOFTOP", "white", 120);
		}else{
			Game.showmessage("FLOOR " + Std.string(Game.floor), "white", 120);
		}
		
		Generator.generate(Rand.ppick(AIDirector.blueprint));
		
		//Place the entrance and exit
		if (Generator.lastblueprint == "intro_topfloor") {
			Game.changeplacement("stairs");
			Game.place("entrance", "", true); //Force the top left room to be the entrance
			Game.placeatentrance("player");
		}else{
			Game.changeplacement("stairs");
			Game.place("entrance");
			Game.placeatentrance("player");
		}
		
		//Place treasure
		Game.changeplacement("collectable");
		for (i in 0 ... AIDirector.gems) {
			Game.place("treasure", "gem");
		}
		
		//Place keys
		for (i in 0 ... AIDirector.keys) {
			Game.place("key", "");
		}
		
		//Place enemies - not on topfloors
		//...
		for (i in 0 ... AIDirector.enemylist.length) Game.placeatrandom("enemy", AIDirector.enemylist[i]);
		
		//No top floors!
		Game.changeplacement("stairs");
		Game.place("exit");
		
		//Consider locked doors to exit room
		for (j in 0 ... World.mapheight) {
			for (i in 0 ... World.mapwidth) {
				if (World.at(i, j) == Localworld.CONSIDERLOCKEDDOOR) {
				  World.placetile(i, j, Localworld.DOOR);	
				}else if (World.at(i, j) == Localworld.CONSIDERLOCKEDEXIT_A ||
									World.at(i, j) == Localworld.CONSIDERLOCKEDEXIT_B) {
					if (AIDirector.lockedexit) {
						if (AIDirector.entrance == "A") {
							if (World.at(i, j) == Localworld.CONSIDERLOCKEDEXIT_B) {
								World.placetile(i, j, Localworld.LOCKEDDOOR);
							}else if (World.at(i, j) == Localworld.CONSIDERLOCKEDEXIT_A) {
								World.placetile(i, j, Localworld.DOOR);
							}
						}else if (AIDirector.entrance == "B") {
							if (World.at(i, j) == Localworld.CONSIDERLOCKEDEXIT_A) {
								World.placetile(i, j, Localworld.LOCKEDDOOR);
							}else if (World.at(i, j) == Localworld.CONSIDERLOCKEDEXIT_B) {
								World.placetile(i, j, Localworld.DOOR);
							}
						}else {
						  if(Buildconfig.showtraces) trace("Generator error: AIDirector can't find the exit");
							World.placetile(i, j, Localworld.DOOR);
						}
					}else{
						World.placetile(i, j, Localworld.DOOR);
					}
				}
			}
		}
		
		
		//Place items and gadgets
		Game.changeplacement("collectable");
		for (i in 0 ... AIDirector.weaponlist.length) {
			Game.place("item", AIDirector.weaponlist[i]);
		}
		for (i in 0 ... AIDirector.itemlist.length) {
			Game.place("item", AIDirector.itemlist[i]);
		}
		
		Localworld.setroomfog(AIDirector.roomlit?1:0);
		Localworld.updatelighting();
		
		Game.turn = "playermove";
	}
	
	public static function firebox(x:Int, y:Int, w:Int, h:Int) {
		for (j in y ... y + h) {
			for (i in x ... x + w) {
				if (Geom.inbox(i, j, 0, 0, World.mapwidth, World.mapheight)){
					if (i == x || i == x + w - 1 || j == y || j == y + h - 1) {
						if(Rand.pbool()) Localworld.startfire(i, j);
					}else{
						Localworld.startfire(i, j);
					}
				}
			}
		}
	}
	
	public static function outsidegen() {
		Game.clearroom();
		Localworld.clearfire();
		Modern.updatepalette();
		
		//Totally redoing outside world generation from here:
		Generator.changemapsize(32, 19);
		
		Rand.setseed(Std.int(Math.abs((Modern.currentrunseed + (Modern.worldx * Modern.worldy)) % 2147483647)));
		
		var zone:Int = Std.int(Math.max(Math.abs(Modern.worldx - 50), Math.abs(Modern.worldy - 50)));
		
		//Standard terrain:
		for (j in 0 ... World.mapheight) {
			for (i in 0 ... World.mapwidth) {
				if (Rand.pint(0, 100) > 90) {
					World.placetile(i, j, Localworld.WALL);
				}else {
					if(Rand.pint(0,100) >= 66){	
						World.placetile(i, j, Localworld.DEBRIS);
					}else {
						World.placetile(i, j, Localworld.FLOOR);
					}
				}
			}
		}
		
		for (j in 17 ... 19) {
			for (i in 24 ... 32) {
				if(Rand.pint(0,100) >= 66){	
					World.placetile(i, j, Localworld.DEBRIS);
				}else {
					World.placetile(i, j, Localworld.FLOOR);
				}
			}
		}
		
		if(zone == 0){
			//The center room
			if (Modern.worldx == 50 && Modern.worldy == 50) {
				Generator.placeoutsideroom("heistytower");
			}
		}else if(zone == 1){
			//The treasure ring: the corner rooms have stuff
			if (Math.abs(Modern.worldx - 50) == Math.abs(Modern.worldy - 50)) {
				Generator.tx1 = Rand.pint(3, World.mapwidth - 1 - 14);
				Generator.ty1 = Rand.pint(3, World.mapheight - 1 - 13);
				Generator.tx2 = Rand.pint(7, 12); 
				Generator.ty2 = Rand.pint(7, 10);
				
				for (j in Generator.ty1 - 1 ... Generator.ty1 + Generator.ty2 + 2) {
					for (i in Generator.tx1 - 1 ... Generator.tx1 + Generator.tx2 + 2) {
						if(Rand.pint(0,100) >= 66){	
							World.placetile(i, j, Localworld.DEBRIS);
						}else {
							World.placetile(i, j, Localworld.FLOOR);
						}
					}
				}
				
				Generator.placeactualroom_nochecks(Generator.tx1, Generator.ty1, Generator.tx2, Generator.ty2);
				
				Generator.placedoorin(Generator.tx1, Generator.ty1, Generator.tx2, Generator.ty2);
				Generator.getrandompointin(Generator.tx1 + 1, Generator.ty1 + 1, Generator.tx2 - 2, Generator.ty2 - 2);
				if (Modern.worldx - 50 == -1 && Modern.worldy - 50 == -1) {
					if(Modern.itemtopleft != "")
					Obj.createentity(Generator.tx, Generator.ty, "item", Modern.itemtopleft);
				}else if (Modern.worldx - 50 == 1 && Modern.worldy - 50 == -1) {
					if(Modern.itemtopright != "")
					Obj.createentity(Generator.tx, Generator.ty, "item", Modern.itemtopright);
				}else if (Modern.worldx - 50 == -1 && Modern.worldy - 50 == 1) {
					if(Modern.itembottomleft != "")
					Obj.createentity(Generator.tx, Generator.ty, "item", Modern.itembottomleft);
				}else if (Modern.worldx - 50 == 1 && Modern.worldy - 50 == 1) {
					if(Modern.itembottomright != "")
					Obj.createentity(Generator.tx, Generator.ty, "item", Modern.itembottomright);
				}
			}
		}else if (zone == 2) {
			//The firepits
			var xoff:Int = Modern.worldx - 50;
			var yoff:Int = Modern.worldy - 50;
			
			if (yoff == -2 && xoff == -2) {
				firebox(3, 3, World.mapwidth + 4, World.mapheight - 6);
				firebox(3, 3, World.mapwidth - 6, World.mapheight + 4);
			}else if (yoff == -2 && xoff == 2) {
				firebox(-2, 3, World.mapwidth - 1, World.mapheight - 6);
				firebox(3, 3, World.mapwidth - 6, World.mapheight + 4);
			}else if (yoff == 2 && xoff == -2) {
				firebox(3, 3, World.mapwidth + 4, World.mapheight - 6);
				firebox(3, -2, World.mapwidth - 6, World.mapheight - 1);
			}else if (yoff == 2 && xoff == 2) {
				firebox(-2, 3, World.mapwidth - 1, World.mapheight - 6);
				firebox(3, -2, World.mapwidth - 6, World.mapheight - 1);
			}else if (yoff == -2 || yoff == 2) {
				firebox(-2, 3, World.mapwidth + 4, World.mapheight - 6);
			}else if (xoff == -2 || xoff == 2) {
				firebox(3, -2, World.mapwidth - 6, World.mapheight + 4);
			}
			
			var numfiremen:Int = Rand.pint(3, 5);
			for (i in 0 ... numfiremen) {
				Obj.createentity(Rand.pint(2, World.mapwidth - 3), Rand.pint(2, World.mapheight - 3), "enemy", EnemyType.FIREMAN);
			}
		}else if (zone == 3) {
			//The boundary
			//Place boundary!
			if (Modern.worldx - 50 == -3) {
				for (j in 0 ... World.mapheight) {
					Generator.tx = Rand.pint(3, 5);
					for(i in 0 ... Generator.tx){
						World.placetile(i, j, Localworld.WALL);
					}
				}
			}else if (Modern.worldx - 50 == 3) {
				for (j in 0 ... World.mapheight) {
					Generator.tx = Rand.pint(3, 5);
					for(i in 0 ... Generator.tx){
						World.placetile(World.mapwidth - 1 - i, j, Localworld.WALL);
					}
				}
			}
			
			if (Modern.worldy - 50 == -3) {
				for (i in 0 ... World.mapwidth) {
					Generator.ty = Rand.pint(3, 5);
					for(j in 0 ... Generator.ty){
						World.placetile(i, j, Localworld.WALL);
					}
				}
			}else if (Modern.worldy - 50 == 3) {
				for (i in 0 ... World.mapwidth) {
					Generator.ty = Rand.pint(3, 5);
					for(j in 0 ... Generator.ty){
						World.placetile(i, World.mapheight - 1 - j, Localworld.WALL);
					}
				}
			}
		}else{
			Modern.updatepalette(Rand.ppick([Roomstyle.ROBOT, Roomstyle.HIGH, Roomstyle.SHOPKEEPER, Roomstyle.INTRO, Roomstyle.ROOFTOP, Roomstyle.ERROR, Roomstyle.OUTSIDE]));
			//Glitch ring: everything beyond this is just noise
			var randomblocks:Array<Int> = [Localworld.FLOOR, Localworld.BLOOD, Localworld.WALL,
			                               Localworld.DOOR, Localworld.OPENDOOR, Localworld.RUBBLE, Localworld.EMPTYBACKGROUND,
																		 Localworld.OUTSIDE_GROUND, Localworld.DEBRIS,
																		 Localworld.ROOFSIDE, Localworld.ROOFBACKGROUND, Localworld.ROOFSTARS
																		 ];
			for (j in 0 ... World.mapheight) {
				for (i in 0 ... World.mapwidth) {
					World.placetile(i, j, Rand.ppick(randomblocks));
					if (Rand.prare()) {
					  //Low probablity of weird blocks	
						World.placetile(i, j, Rand.ppick([Localworld.BANANAPEEL, Localworld.OUTSIDE_EDGE, 
						                                  Localworld.ENTRANCE, Localworld.LOCKEDDOOR]));
						if (Rand.prare() && i > 5 && j > 5 && i < World.mapwidth - 5 && j < World.mapheight - 5) {
							World.placetile(i, j, Localworld.STAIRS);
						}
					}
				}
			}
		}
		
		Game.turn = "playermove";
	}
	
	public static function stringseed(s:String):Int {
		var newseed:Int = 0;
		for (i in 0 ... s.length) {
		  newseed += s.charCodeAt(i);
		}
		return newseed;
	}
	
	public static function swaprealdoorforfakedoor(t:Int) {
		//ok, make a list of doors
		var doorlocations:Array<Point> = [];
		for (j in 0 ... World.mapheight) {
			for (i in 0 ... World.mapwidth) {
				if (World.at(i, j) == Localworld.DOOR) {
				  doorlocations.push(new Point(i, j));
				}
			}
		}
		
		//Randomlly 
		Rand.pshuffle(doorlocations);
		for (i in 0 ... t) {
			if(i < doorlocations.length){
				World.placetile(Std.int(doorlocations[i].x), Std.int(doorlocations[i].y), Localworld.FLOOR);
				Obj.createentity(Std.int(doorlocations[i].x), Std.int(doorlocations[i].y), "item", ItemType.PORTABLEDOOR);
			}
		}
	}
	
	public static function countlockeddoors():Int {
		var lockeddoorcounter:Int = 0;
		for (j in 0 ... World.mapheight) {
			for (i in 0 ... World.mapwidth) {
				if (World.at(i, j) == Localworld.LOCKEDDOOR) lockeddoorcounter++;
			}
		}
		
		return lockeddoorcounter;
	}
	
	public static function countkeys():Int {
		var keycounter:Int = 0;
		for (j in 0 ... World.mapheight) {
			for (i in 0 ... World.mapwidth) {
				if (World.at(i, j) == Localworld.KEY) keycounter++;
			}
		}
		
		return keycounter;
	}
	
	public static function swapkeysforgems(t:Int) {
	  //ok, make a list of keys
		var keylocations:Array<Point> = [];
		for (j in 0 ... World.mapheight) {
			for (i in 0 ... World.mapwidth) {
				if (World.at(i, j) == Localworld.KEY) {
				  keylocations.push(new Point(i, j));
				}
			}
		}
		
		//Randomlly 
		Rand.pshuffle(keylocations);
		for (i in 0 ... t) {
			if(i < keylocations.length){
				World.placetile(Std.int(keylocations[i].x), Std.int(keylocations[i].y), Localworld.FLOOR);
				Obj.createentity(Std.int(keylocations[i].x), Std.int(keylocations[i].y), "treasure", "gem");
			}
		}
	}
	
	public static function placeshopkeeper(sellingitem:String) {
	  //Find a spot near the entrance to place the shopkeeper
		//The spot should be:
		// - within 5 squares of the stairs
		// - surrounded on all 8 sides by floor
		var possiblelocations:Array<Point> = [];
		
		var player:Int = Obj.getplayer();
		var px:Int = Obj.entities[player].xp;
		var py:Int = Obj.entities[player].yp;
		for (j in -4 ... 5) {
			for (i in -4 ... 5) {
				if (World.at(px + i, py + j) == Localworld.FLOOR) {
					var pointok:Bool = true;
					//Disallow adjacent to stairs
					if (i == -1 && j == 0) pointok = false;
					if (i == 1 && j == 0) pointok = false;
					if (i == 0 && j == -1) pointok = false;
					if (i == 0 && j == 1) pointok = false;
					//Disallow adjacent to doors
					if (World.anydoor(World.at(px + i - 1, py + j))) pointok = false;
					//Disallow placement if you're touching more than 
					//one wall, including diagionally
					if (pointok) {
						var wallcount:Int = 0;
						if (World.at(px + i - 1, py + j - 1) != Localworld.FLOOR) wallcount++;
						if (World.at(px + i, py + j - 1) != Localworld.FLOOR) wallcount++;
						if (World.at(px + i + 1, py + j - 1) != Localworld.FLOOR) wallcount++;
						if (World.at(px + i - 1, py + j) != Localworld.FLOOR) wallcount++;
						if (World.at(px + i + 1, py + j) != Localworld.FLOOR) wallcount++;
						if (World.at(px + i - 1, py + j + 1) != Localworld.FLOOR) wallcount++;
						if (World.at(px + i, py + j + 1) != Localworld.FLOOR) wallcount++;
						if (World.at(px + i + 1, py + j + 1) != Localworld.FLOOR) wallcount++;
						if (wallcount > 1) {
							pointok = false;
							//Ok! Do consider corners, though
							if (World.at(px + i, py + j - 1) == Localworld.WALL 
							 && World.at(px + i - 1, py + j) == Localworld.WALL) {
								//Top left: this is ok if right, down and down right are clear
								if (World.at(px + i + 1, py + j + 1) == Localworld.FLOOR &&
										World.at(px + i + 1, py + j) == Localworld.FLOOR &&
										World.at(px + i, py + j + 1) == Localworld.FLOOR) {
									pointok = true;
								}
							}
							if (World.at(px + i, py + j - 1) == Localworld.WALL 
							 && World.at(px + i + 1, py + j) == Localworld.WALL) {
								//Top right: this is ok if left, down and down left are clear
								if (World.at(px + i - 1, py + j + 1) == Localworld.FLOOR &&
										World.at(px + i - 1, py + j) == Localworld.FLOOR &&
										World.at(px + i, py + j + 1) == Localworld.FLOOR) {
									pointok = true;
								}
							}
							if (World.at(px + i, py + j + 1) == Localworld.WALL 
							 && World.at(px + i + 1, py + j) == Localworld.WALL) {
								//bottom right: this is ok if left, up and up left are clear
								if (World.at(px + i - 1, py + j - 1) == Localworld.FLOOR &&
										World.at(px + i - 1, py + j) == Localworld.FLOOR &&
										World.at(px + i, py + j - 1) == Localworld.FLOOR) {
									pointok = true;
								}
							}
							if (World.at(px + i, py + j + 1) == Localworld.WALL 
							 && World.at(px + i - 1, py + j) == Localworld.WALL) {
								//bottom left: this is ok if right, up and up right are clear
								if (World.at(px + i + 1, py + j - 1) == Localworld.FLOOR &&
										World.at(px + i + 1, py + j) == Localworld.FLOOR &&
										World.at(px + i, py + j - 1) == Localworld.FLOOR) {
									pointok = true;
								}
							}
						}
					}
					
					if (pointok) possiblelocations.push(new Point(px + i, py + j));
				}
			}
		}
		
		//Pick randomlly 
		if(possiblelocations.length > 0){
			Rand.pshuffle(possiblelocations);
			Obj.createentity(Std.int(possiblelocations[0].x), Std.int(possiblelocations[0].y), "shopkeeper", sellingitem);
		}
	}
}	