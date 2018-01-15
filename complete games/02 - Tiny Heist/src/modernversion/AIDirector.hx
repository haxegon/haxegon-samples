package modernversion;

import haxegon.*;
import terrylib.*;
import gamecontrol.Game;
import gamecontrol.Generator;
import gamecontrol.Localworld;
/* 
 * The AI Director makes decisions to overrule the random generator. It looks at the state of the player
 * at various points, and tweaks things to be fairer and more fun. If it's doing it's job correctly,
 * it shouldn't be obvious that it's there at all.
 * */

 /*
	* Blueprint list:

"robot_firstfloor"
"robot_small"
"robot_large"
"robot_topfloor" (not implemented)
"intro_firstfloor"
"simpleempty" (testing only)
"intro_small"
"intro_small2"
"intro_small3"
"intro_topfloor"
"high_medium1"
"firstfloor"
"small"
"medium"
"big"
"cross"
"square"
	
	*/
class AIDirector {
	public static function restart() {
	  //reset internal variables
		itemsgiven_intro = 0;
		itemsgiven_high = 0;
		donethedoorjoke = false;
		placedfirstshopkeeper = false;
		placedsecondshopkeeper = false;
		placedthirdshopkeeper = false;
		//startingitems = ["Pistol", "Sword", "Gem", "Gem", "Gem", "Gem", "Gem", "Gem","Gem","Gem","Gem","Gem","Gem","Gem"];
		startingitems = [];
		Modern.keygemratelevel = 0;
		Modern.newrecord = false;
		
		outside = false;
		glitchmode = false;
		
		onthisrun_keys = 0;
		onthisrun_keysused = 0;
	  onthisrun_gems = 0;
	  onthisrun_items = 0;
	  onthisrun_treasurelist = [];
		
		givestartingitems();
		
		floor = 1;
	}
	
	public static function designfloor() {
		if(Buildconfig.showtraces) trace("AI Director is designing the floor");
		//Default values!
		roomlit = false;
		darkroom = false;
		//Modify blueprints in Generator.useblueprint()
		blueprint = [];
		enemylist = [];
		weaponlist = [];
		itemlist = [];
		
		//Reset the reinforcements
		Localworld.worldblock[Localworld.ENTRANCE].charcode_lit = "-".charCodeAt(0);
		Localworld.worldblock[Localworld.ENTRANCE].charcode_fog = "-".charCodeAt(0);
		Localworld.worldblock[Localworld.STAIRS].charcode_fog = 44;
		reinforcements = [Enemy.GUARD];
		reinforcementtime = [60];
		reinforcementdelay = 15;
		gems = 0;
		keys = 0;
		lockedexit = false;
		extralockeddoors = 0;
		
		if (floor > Modern.highestfloor) {
		  Modern.highestfloor = floor;
			Modern.newrecord = true;
		}
		
		switch(floor) {
			case 1:
				if(Buildconfig.showtraces) trace(" - designing floor 1");
				style = Roomstyle.intro;
				roomlit = true;
				
				gems = 1;
				keys = 1;
				lockedexit = true;
				
				blueprint = ["intro_firstfloor"]; //firstfloor
				
				reinforcements = [Enemy.GUARD];
				reinforcementtime = [60];
				enemylist = [Enemy.GUARD, Enemy.CAMERA];
				if (Rand.poccasional()) {
				  enemylist.push(Rand.ppickstring(Enemy.GUARD, Enemy.DOG, Enemy.CAMERA));
				}
				//Always give a slightly crappy item on floor one to prevent restart spamming
				itemlist.push(Rand.ppickstring(Item.LIGHTBULB, Item.SIGNALJAMMER, Item.BANANAPEEL));
			case 2, 3, 4:
				if(Buildconfig.showtraces) trace(" - designing floor " + floor);
				style = Roomstyle.intro;
				//Ok, let do more interesting stuff
				blueprint = ["intro_small", "intro_small2", "intro_small3"];
				
				gems = 1;
				if (Rand.pbool()) {
				  keys = 1;
					lockedexit = true;
				}else {
					keys = 0;
					lockedexit = false;
				}
				
				reinforcements = [Enemy.GUARD];
				reinforcementtime = [60];
				enemylist = [Enemy.GUARD, Enemy.GUARD, Enemy.CAMERA];
				if (Rand.poccasional()) {
				  enemylist.push(Rand.ppickstring(Enemy.GUARD, Enemy.DOG, Enemy.CAMERA));
				}
				if (Rand.poccasional()) {
				  enemylist.push(Rand.ppickstring(Enemy.GUARD, Enemy.DOG, Enemy.CAMERA));
				}else {
				  if (Rand.prare()) {
					  enemylist.push(Rand.ppickstring(Enemy.ROBOT, Enemy.CAMERA));	
					}
				}
				
				//What about items?
				if (floor == 4 && Game.health <= 1) {
					//You're not doing so well. Eh, it's the intro stage - have a health pack
					itemlist.push(Item.FIRSTAIDKIT);
				}
				
				if (itemsgiven_intro == 0 && floor == 4) {
				  //If I haven't given you anything by floor 4, let's make up for it now
					itemlist.push(Rand.ppickstring(
							Weapon.PISTOL, Weapon.LEAFBLOWER, Item.BANANAPEEL, Item.CARDBOARDBOX, Item.BOMB,
							Item.FIRSTAIDKIT, Item.SIGNALJAMMER, Item.LIGHTBULB, Item.DRILL, Weapon.SKATEBOARD
						));
					itemsgiven_intro++;
				}else	if (itemsgiven_intro < 2) {
				  //Consider giving you something!
					if (Rand.prare()) {
					  //1/20 chance of getting something weird
						itemlist.push(Rand.ppickstring(
						  Weapon.MATCHSTICK, 
							Weapon.SWORD,
							Item.TIMESTOPPER,
							Weapon.SKATEBOARD,
							Weapon.TELEPORTER
						));
						itemsgiven_intro++;
					}else {
						if (Rand.poccasional()) {
						  //1/5 chance of getting something standard
							itemlist.push(Rand.ppickstring(
							  Weapon.PISTOL, Weapon.LEAFBLOWER, Item.CARDBOARDBOX, Item.BANANAPEEL,
								Item.FIRSTAIDKIT, Item.SIGNALJAMMER, Item.LIGHTBULB, Item.DRILL, Item.DRILL,
								Item.BOMB
							));
							itemsgiven_intro++;
						}
					}
				}
				
				if (itemsgiven_intro == 0 && floor == 2) {
					if (Rand.poccasional()) {
						//Let's occasionally give you a pistol, but that's it
						if(Rand.pbool()){
							itemlist.push(Weapon.PISTOL);
							itemsgiven_intro += 2;
						}else {
							itemlist.push(Item.DRILL);
							itemsgiven_intro += 1;
						}
					}
				}
			case 5:
				//Floor five is the first "special" floor - let's bring out the special layout!
				blueprint = ["intro_topfloor"];
				style = Roomstyle.intro;
				
				reinforcements = [Enemy.GUARD, Enemy.GUARD, Enemy.ROBOT];
				reinforcementtime = [60, 60, 60];
			case 6, 7, 8, 9:
				if (floor == 6 || floor == 7) {
					//Floors six and seven use the "high_mediumX" blueprints	
					blueprint = ["high_medium1", "high_medium2", "high_medium3"];
				}else{
					//Floors eight and nine use the "high_bigX" blueprints
					//blueprint = ["high_big1", "high_big2", "high_big3"];
					blueprint = ["high_big3"];
				}
				
				style = Roomstyle.high;
				
				gems = 1;
				//They always do the locked exit thing
				keys = 1;
				lockedexit = true;
				
				//Enemy lists is similar to earlier floors, but with a chance of harder enemies
				reinforcements = [Enemy.GUARD, Enemy.LASERGUARD];
				reinforcementtime = [50, 60];
				
				enemylist = [Enemy.GUARD, Enemy.GUARD, Enemy.LASERCAMERA];
				if (Rand.poccasional()) {
				  enemylist.push(Rand.ppickstring(Enemy.GUARD, Enemy.DOG, Enemy.CAMERA));
				}
				if (Rand.poccasional()) {
				  enemylist.push(Rand.ppickstring(Enemy.LASERGUARD, Enemy.LASERCAMERA, Enemy.LASERGUARD));
				}else {
				  if (Rand.prare()) {
					  enemylist.push(Enemy.ROBOT);	
					}
				}
				
			  //What about items?
				if (itemsgiven_high < 2) {
				  //Consider giving you something!
					if (Rand.prare()) {
					  //1/20 chance of getting something weird
						itemlist.push(Rand.ppickstring(
						  Weapon.MATCHSTICK, 
							Weapon.SWORD,
							Item.TIMESTOPPER
						));
						itemsgiven_high++;
					}else {
						if (Rand.poccasional()) {
						  //1/5 chance of getting something standard
							if (floor == 9 && Game.health <= 1) {
								//You're not doing so well. Find a health pack!
								itemlist.push(Item.FIRSTAIDKIT);
							}else{				
								itemlist.push(Rand.ppickstring(
									Weapon.PISTOL, Weapon.LEAFBLOWER, Item.CARDBOARDBOX, Item.BANANAPEEL,
									Item.FIRSTAIDKIT, Item.SIGNALJAMMER, Item.LIGHTBULB, Item.DRILL, Item.DRILL, Item.BOMB
								));
							}
							itemsgiven_high++;
						}
					}
				}
				
				//Like on floors 2, you occasionally find a pistol on floor 6
				if (itemsgiven_high == 0 && floor == 6) {
					if (Rand.poccasional()) {
						//Let's occasionally give you a pistol, but that's it
						if(Rand.pbool()){
							itemlist.push(Weapon.PISTOL);
							itemsgiven_high += 2;
						}else {
							itemlist.push(Item.DRILL);
							itemsgiven_high += 1;
						}
					}
				}
			case 10:
				//Floor ten is the second "special" floor - let's bring out the special layout!
				blueprint = ["high_topfloor"];
				style = Roomstyle.high;
				
				//We only want robots here because of the crazy layout
				//And we want them to be significantly slower than on other floors
				reinforcements = [Enemy.ROBOT];
				reinforcementtime = [240];
			case 11:
				//Floor eleven is the shopkeeper! We're into the finish now!
				blueprint = ["floor11"];
				style = Roomstyle.shopkeeper;
				
				roomlit = true;
				//Turn off reinforcements obviously
				reinforcements = [];
				reinforcementtime = [];
				
				var shopitems:Array<String> = [Weapon.PISTOL, Weapon.LEAFBLOWER, Weapon.SKATEBOARD, Item.BANANAPEEL,
							Item.FIRSTAIDKIT, Item.FIRSTAIDKIT, Item.SIGNALJAMMER, Item.LIGHTBULB, Item.DRILL,
							Weapon.TELEPORTER];
				for (i in 0 ... 5) {
				  Rand.pshuffle(shopitems);	
					if (shopitems.length > 0) {
						itemlist.push(shopitems.pop());
					}
				}
			case 12:
				if(Buildconfig.showtraces) trace(" - designing floor 12");
				style = Roomstyle.robot;
				roomlit = false;
				
				gems = 1;
				keys = 0;
				lockedexit = false;
				
				blueprint = ["robot_firstfloor"]; //firstfloor
				reinforcements = [Enemy.ROOK, Enemy.ROBOT];
				reinforcementtime = [50, 50];
				
				enemylist = [Enemy.ROOK, Enemy.ROBOT];
				if (Rand.poccasional()) {
				  enemylist.push(Rand.ppickstring(Enemy.LASERCAMERA, Enemy.CAMERA, Enemy.GUARD));
				}
				if (Rand.pbool()) {
					itemlist.push(Rand.ppickstring(Weapon.SKATEBOARD, Weapon.PISTOL));
				}else{
					itemlist.push(Rand.ppickstring(Weapon.LEAFBLOWER, Weapon.SKATEBOARD, Item.DRILL, Weapon.PISTOL, Item.LIGHTBULB, Item.LIGHTBULB));
				}
				if (Rand.poccasional()) {
				  itemlist.push(Rand.ppickstring(Item.LIGHTBULB, Item.SIGNALJAMMER, Weapon.SWORD, Item.BANANAPEEL));
				}
			case 13:
				if(Buildconfig.showtraces) trace(" - designing floor " + floor);
				style = Roomstyle.robot;
				roomlit = false;
				
				gems = 1;
				keys = 0;
				lockedexit = false;
				
				blueprint = ["robot_small"];
				reinforcements = [Enemy.ROOK, Enemy.ROBOT];
				reinforcementtime = [50, 50];
				
				enemylist = [Enemy.ROOK, Enemy.ROBOT, Enemy.ROOK];
				
				if (Rand.poccasional()) {
				  enemylist.push(Rand.ppickstring(Enemy.LASERCAMERA, Enemy.CAMERA, Enemy.GUARD, Enemy.ROOK));
				}
				if (Rand.poccasional()) {
				  itemlist.push(Rand.ppickstring(Weapon.LEAFBLOWER, Weapon.SKATEBOARD, Item.DRILL, Weapon.SKATEBOARD, Item.LIGHTBULB, Item.LIGHTBULB));
				}
				if (Rand.poccasional()) {
				  itemlist.push(Rand.ppickstring(Item.LIGHTBULB, Item.SIGNALJAMMER, Weapon.SWORD));
				}
			case 14:
				if(Buildconfig.showtraces) trace(" - designing floor " + floor);
				style = Roomstyle.robot;
				roomlit = false;
				
				gems = 1;
				keys = 0;
				lockedexit = false;
				
				blueprint = ["robot_large"]; //the last robot floor!
				reinforcements = [Enemy.ROOK, Enemy.ROBOT];
				reinforcementtime = [50, 50];
				
				enemylist = [Enemy.ROOK, Enemy.ROBOT, Enemy.ROOK, Enemy.LASERGUARD, Enemy.LASERGUARD, Enemy.LASERCAMERA, Enemy.LASERCAMERA];
				
				if (Rand.poccasional()) {
				  enemylist.push(Rand.ppickstring(Enemy.LASERCAMERA, Enemy.CAMERA, Enemy.LASERCAMERA, Enemy.ROOK));
				}
				if (Rand.poccasional()) {
				  itemlist.push(Rand.ppickstring(Weapon.LEAFBLOWER, Weapon.SKATEBOARD, Item.DRILL, Weapon.SKATEBOARD, Item.LIGHTBULB, Item.LIGHTBULB));
				}
				if (Rand.poccasional()) {
				  itemlist.push(Rand.ppickstring(Item.LIGHTBULB, Item.SIGNALJAMMER, Weapon.SWORD));
				}
				if (Game.health <= 1 && Rand.poccasional()) {
					//You're not doing so well. Find a health pack!
					itemlist.push(Item.FIRSTAIDKIT);
				}
			case 15:
				//Floor 15 is the top floor for stage 3, just before the "roof" level
				blueprint = ["robot_topfloor"];
				style = Roomstyle.robot;
				
				gems = 2;
				keys = 1;
				lockedexit = false;
				
				reinforcements = [Enemy.TERMINATOR];
				reinforcementtime = [220];
			case 16:
				Localworld.worldblock[Localworld.STAIRS].charcode_fog = 43;
				roomlit = true;
				//The rooftop!
				blueprint = ["rooftop"];
				style = Roomstyle.rooftop;
				
				gems = 0;
				keys = 0;
				lockedexit = false;
				
				reinforcements = [Enemy.TERMINATOR];
				reinforcementtime = [200];
		  default:
				//If I haven't specifically designed it, just give me something totally Rand.
				if(Buildconfig.showtraces) trace(" - huh! giving up");
				style = Roomstyle.error;
		}
		
		if (glitchmode) {
			style = Random.pick([Roomstyle.robot, Roomstyle.high, Roomstyle.shopkeeper, Roomstyle.intro, Roomstyle.rooftop, Roomstyle.error, Roomstyle.outside]);
		}
	}
	
	public static var tempx:Int;
	public static var tempy:Int;
	public static var tempx2:Int;
	public static var tempy2:Int;
	public static var t1:Int;
	public static var t2:Int;
	public static var t3:Int;
	
	public static function swaptwononplayerentities() {
		//Swap two non-player entities
		t1 = Random.int(0, Obj.nentity);
		t2 = Random.int(0, Obj.nentity);
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
	
	public static function swaptwoblocks() {
		tempx = Random.int(0, World.mapwidth - 1);
		tempy = Random.int(0, World.mapheight - 1);
		tempx2 = Random.int(0, World.mapwidth - 1);
		tempy2 = Random.int(0, World.mapheight - 1);
		
		t1 = Obj.getplayer();
		if (t1 > -1) {
			if (Math.abs(Obj.entities[t1].xp - tempx) > 3 || Math.abs(Obj.entities[t1].yp - tempy) > 3) {
				if (Math.abs(Obj.entities[t1].xp - tempx2) > 3 || Math.abs(Obj.entities[t1].yp - tempy2) > 3) {
					t2 = World.at(tempx, tempy);
					World.placetile(tempx, tempy, World.at(tempx2, tempy2));
					World.placetile(tempx2, tempy2, t2);
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
	
	public static function glitch() {
		//Distort the level in some unexpected way
		t1 = Random.int(0, 100);
		if (t1 < 50) {
		}else if(t1 < 65){
			swaptwononplayerentities();
		}else if (t1 < 68) {
			shiftcolumn(Random.int(0, World.mapwidth));
		}else {
			swaptwoblocks();
		}
	}
	
	public static function glitchoutside(level:Int) {
		if (level >= 5) {
			for (i in 0 ... (level - 5) * 4) {
				swaptwoblocks();	
			}
		}
	}
	
	public static function countblocks(type:Int):Int {
	  var count:Int = 0;
		
		for (j in 0 ... World.mapheight) {
			for (i in 0 ... World.mapwidth) {
				if (World.at(i, j) == type) count++;
			}
		}
		
		return count;
	}
	
	public static function countgems():Int {
	  var count:Int = 0;
		
		for (i in 0 ... Obj.nentity) {
			if(Obj.entities[i].active){
				if (Obj.entities[i].type == "treasure") count++;
			}
		}
		
		return count;
	}
	
	public static function getitemsonthisfloor():Array<String> {
	  var itemlist:Array<String> = [];
		
		for (i in 0 ... Obj.nentity) {
			if(Obj.entities[i].active){
				if (Obj.entities[i].type == "item") itemlist.push(Obj.entities[i].name);
			}
		}
		
		return itemlist;
	}
	
	public static function copymaptotestbuffer(includeentities:Bool = false) {
		for (j in 0 ... World.mapheight) {
			for (i in 0 ... World.mapwidth) {
				testmap[i][j] = World.at(i, j);
			}
		}
		
		if (includeentities) {
		  for (i in 0 ... Obj.nentity) {
			  if (Obj.entities[i].active) {
				  testmap[Obj.entities[i].xp][Obj.entities[i].yp] = Localworld.WALL;
				}
			}
		}
	}
	
	public static function testbufferat(xp:Int, yp:Int):Int {
		if (xp >= 0 && yp >= 0 && xp < World.mapwidth && yp < World.mapheight) {
			return testmap[xp][yp];
		}
		return Localworld.WALL;
	}
	
	
	public static function floodtest_seekenemy_everythingblocks(x:Int, y:Int):Bool {
		if (testmap[x][y] == Localworld.BANANAPEEL) return true; //We found an enemy!
		//To stop this point getting retested, mark is as a "wall"
		testmap[x][y] = Localworld.WALL;
		
		if (y > 0) {
		  if (testmap[x][y - 1] != Localworld.WALL) {
			  if(floodtest_seekenemy_everythingblocks(x, y - 1)) return true;
			}
		}
		
		if (y < World.mapheight - 1) {
		  if (testmap[x][y + 1] != Localworld.WALL) {
			  if (floodtest_seekenemy_everythingblocks(x, y + 1)) return true;
			}
		}
		
		if (x > 0) {
		  if (testmap[x - 1][y] != Localworld.WALL) {
			  if(floodtest_seekenemy_everythingblocks(x - 1, y)) return true;
			}
		}
		
		if (x < World.mapwidth - 1) {
		  if (testmap[x + 1][y] != Localworld.WALL) {
			  if(floodtest_seekenemy_everythingblocks(x + 1, y)) return true;
			}
		}
		
		return false;
	}
	
	//Faster to do these as hardcoded functions because recursion, probably 
	public static function floodtest_seekexit_throughlocks(x:Int, y:Int):Bool {
		if (testmap[x][y] == Localworld.STAIRS) return true; //We made it!
		//To stop this point getting retested, mark is as a "wall"
		testmap[x][y] = Localworld.WALL;
		
		if (y > 0) {
		  if (testmap[x][y - 1] != Localworld.WALL) {
			  if(floodtest_seekexit_throughlocks(x, y - 1)) return true;
			}
		}
		
		if (y < World.mapheight - 1) {
		  if (testmap[x][y + 1] != Localworld.WALL) {
			  if (floodtest_seekexit_throughlocks(x, y + 1)) return true;
			}
		}
		
		if (x > 0) {
		  if (testmap[x - 1][y] != Localworld.WALL) {
			  if(floodtest_seekexit_throughlocks(x - 1, y)) return true;
			}
		}
		
		if (x < World.mapwidth - 1) {
		  if (testmap[x + 1][y] != Localworld.WALL) {
			  if(floodtest_seekexit_throughlocks(x + 1, y)) return true;
			}
		}
		
		return false;
	}
	
	//Faster to do these as hardcoded functions because recursion, probably 
	public static function floodtest_seekexit_blockedbylockeddoors(x:Int, y:Int):Bool {
		if (testmap[x][y] == Localworld.STAIRS) return true; //We made it!
		//To stop this point getting retested, mark is as a "wall"
		testmap[x][y] = Localworld.WALL;
		
		if (y > 0) {
		  if (testmap[x][y - 1] != Localworld.WALL && testmap[x][y - 1] != Localworld.LOCKEDDOOR) {
			  if(floodtest_seekexit_blockedbylockeddoors(x, y - 1)) return true;
			}
		}
		
		if (y < World.mapheight - 1) {
		  if (testmap[x][y + 1] != Localworld.WALL && testmap[x][y + 1] != Localworld.LOCKEDDOOR) {
			  if (floodtest_seekexit_blockedbylockeddoors(x, y + 1)) return true;
			}
		}
		
		if (x > 0) {
		  if (testmap[x - 1][y] != Localworld.WALL && testmap[x - 1][y] != Localworld.LOCKEDDOOR) {
			  if(floodtest_seekexit_blockedbylockeddoors(x - 1, y)) return true;
			}
		}
		
		if (x < World.mapwidth - 1) {
		  if (testmap[x + 1][y] != Localworld.WALL && testmap[x + 1][y] != Localworld.LOCKEDDOOR) {
			  if(floodtest_seekexit_blockedbylockeddoors(x + 1, y)) return true;
			}
		}
		
		return false;
	}
	
	//Faster to do these as hardcoded functions because recursion, probably 
	public static function floodtest_canreachkey(x:Int, y:Int):Bool {
		if (testmap[x][y] == Localworld.KEY) return true; //We made it!
		//if (testmap[x][y] == Localworld.FLOOR) World.placetile(x, y, Localworld.RUBBLE);
		//To stop this point getting retested, mark is as a "wall"
		testmap[x][y] = Localworld.WALL;
		
		if (y > 0) {
		  if (testmap[x][y - 1] != Localworld.WALL && testmap[x][y - 1] != Localworld.LOCKEDDOOR) {
			  if(floodtest_canreachkey(x, y - 1)) return true;
			}
		}
		
		if (y < World.mapheight - 1) {
		  if (testmap[x][y + 1] != Localworld.WALL && testmap[x][y + 1] != Localworld.LOCKEDDOOR) {
			  if (floodtest_canreachkey(x, y + 1)) return true;
			}
		}
		
		if (x > 0) {
		  if (testmap[x - 1][y] != Localworld.WALL && testmap[x - 1][y] != Localworld.LOCKEDDOOR) {
			  if(floodtest_canreachkey(x - 1, y)) return true;
			}
		}
		
		if (x < World.mapwidth - 1) {
		  if (testmap[x + 1][y] != Localworld.WALL && testmap[x + 1][y] != Localworld.LOCKEDDOOR) {
			  if(floodtest_canreachkey(x + 1, y)) return true;
			}
		}
		
		return false;
	}
	
	//Faster to do these as hardcoded functions because recursion, probably 
	public static function floodtest_guardspace(x:Int, y:Int, dist:Int) {
		if (dist > guardspace) guardspace = dist;
		if (dist > 5) return; //We don't care if we have more room than this
		if (testmap[x][y] != Localworld.FLOOR) return; //Stop checking this branch once we hit a wall
		
		//To stop this point getting retested, mark is as a "wall"
		testmap[x][y] = Localworld.WALL;
		
		if (y > 0) {
		  if (testmap[x][y - 1] == Localworld.FLOOR) {
			  floodtest_guardspace(x, y - 1, dist + 1);
			}
		}
		
		if (y < World.mapheight - 1) {
		  if (testmap[x][y + 1] == Localworld.FLOOR) {
			  floodtest_guardspace(x, y + 1, dist + 1);
			}
		}
		
		if (x > 0) {
		  if (testmap[x - 1][y] == Localworld.FLOOR) {
			  floodtest_guardspace(x - 1, y, dist + 1);
			}
		}
		
		if (x < World.mapwidth - 1) {
		  if (testmap[x + 1][y] == Localworld.FLOOR) {
			  floodtest_guardspace(x + 1, y, dist + 1);
			}
		}
		
		return;
	}
	
	public static var entrancex:Int;
	public static var entrancey:Int;
	public static function findentrance() {
		entrancex = -1; entrancey = -1;
		for (j in 0 ... World.mapheight) {
			for (i in 0 ... World.mapwidth) {
			  if (World.at(i, j) == Localworld.ENTRANCE) {
					entrancex = i; entrancey = j;
				}
			}
		}
	}
	
	public static var guardspace:Int;
	
	public static function assessroom():Bool {
	  //Now that the room's placed, let's have a look and see how we might improve it
		
		//Do we have any doors beside THREE walls? Turn them into walls.
		for (j in 0 ... World.mapheight) {
			for (i in 0 ... World.mapwidth) {
				if (World.at(i, j) == Localworld.LOCKEDDOOR || World.at(i, j) == Localworld.DOOR) {
					var wallcount:Int = 0;
					if (World.at(i - 1, j) == Localworld.WALL) wallcount++;
					if (World.at(i + 1, j) == Localworld.WALL) wallcount++;
					if (World.at(i, j - 1) == Localworld.WALL) wallcount++;
					if (World.at(i, j + 1) == Localworld.WALL) wallcount++;
					if (wallcount >= 3) {
						World.placetile(i, j, Localworld.WALL);	
					}
				}
			}
		}
		
		//Basic tests: Can the player actually reach the exit?
		//Outright reject a room if it's so bad that these basic checks fail
		
		//Do a flood fill test from the entrance, only checking collisions with walls
		//If we can't even do this, reject the map
		findentrance();
		
		copymaptotestbuffer();
		if (floodtest_seekexit_throughlocks(entrancex, entrancey)) {
		  if(Buildconfig.showtraces) trace("I can reach the exit!");
			copymaptotestbuffer();
			if (!floodtest_seekexit_blockedbylockeddoors(entrancex, entrancey)) {
				if(Buildconfig.showtraces) trace("... but not without a key.");
				copymaptotestbuffer();
				if (floodtest_canreachkey(entrancex, entrancey)) {
				  if(Buildconfig.showtraces) trace("thankfully, I can reach a key!");	
				}else {
				  if(Buildconfig.showtraces) trace("... and I can't find one. this level is impossible.");
					return false;
				}
			}else {
				if(Buildconfig.showtraces) trace("... and I don't even need a key to do it! yay!");
				if (floor == 1) {
					//Reject the first level if it's got a locked door and key but allows you to
					//stockpile an extra one
					return false;
				}
				if (keys > 0) {
					copymaptotestbuffer();
					if (!floodtest_canreachkey(entrancex, entrancey)) {	
						if(Buildconfig.showtraces) trace("... but there is a key on this floor I can't reach. which means it's behind a locked door.");
						return false;
					}
				}
			}
		}else {
			if(Buildconfig.showtraces) trace("This level is impossible - there are walls between me and the exit.");
			return false;
		}
		
		if(floor >= 1 && floor < 15 && floor !=5 && floor !=11 && floor !=10){
			copymaptotestbuffer();
			//Let's simplify the map so that all doors are also walls:
			for (j in 0 ... World.mapheight) {
				for (i in 0 ... World.mapwidth) {
					if (testmap[i][j] == Localworld.DOOR || testmap[i][j] == Localworld.OPENDOOR ||
							testmap[i][j] == Localworld.LOCKEDDOOR){
						testmap[i][j] = Localworld.WALL;
					}
				}
			}
			//We want to "tag" enemies for this one:
			for (i in 0 ... Obj.nentity) {
				if (Obj.entities[i].active) {
					if (Obj.entities[i].rule == "enemy") {
						testmap[Obj.entities[i].xp][Obj.entities[i].yp] = Localworld.BANANAPEEL;
					}
				}
			}
			
			if (floodtest_seekenemy_everythingblocks(entrancex, entrancey)) {
				if (Buildconfig.showtraces) trace("Map rejected: there's an enemy in the entrance room");
				return false;
			}
		}
		
		if (floor == 1) {
		  if (countblocks(Localworld.LOCKEDDOOR) > 1) {
				if(Buildconfig.showtraces) trace("rejecting this level: it's best not to give the player more than one locked door on floor 1");
			  return false;	
			}
		}
		
		//If the generator has double placed something, then just reject the room and try again
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active) {
				for (j in 0 ... Obj.nentity) {
					if (Obj.entities[j].active) {
						if (i != j) {
							if (Obj.entities[i].xp == Obj.entities[j].xp) {
								if (Obj.entities[i].yp == Obj.entities[j].yp) {
									if(Buildconfig.showtraces) trace("rejecting this level: we've double placed an entity");
									if(Buildconfig.showtraces) trace("(" + Obj.entities[i].type + " and a " + Obj.entities[j].type + " on the same square)");
									return false;	
								}
							}
						}
					}
				}
			}
		}
		
		//Reject the room if a dog is sleeping on a key!
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active) {
				if (Obj.entities[i].type != Enemy.GUARD && Obj.entities[i].type != Enemy.LASERGUARD) {
					if (World.at(Obj.entities[i].xp, Obj.entities[i].yp) == Localworld.KEY) {
						if(Buildconfig.showtraces) trace("rejecting this level: we placed an entity (" + Obj.entities[i].type + ") on a key");
						return false;	
					}
				}
			}
		}
		
		//Remove guards that are in unfair positions.
		//First we need to make a collision map that includes other entities
		copymaptotestbuffer(true);
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active) {
			  if (Obj.entities[i].type == Enemy.GUARD || Obj.entities[i].type == Enemy.LASERGUARD) {
					//ok: is this guard in a corridor?
					if ((testbufferat(Obj.entities[i].xp, Obj.entities[i].yp - 1) != Localworld.FLOOR &&
					    testbufferat(Obj.entities[i].xp, Obj.entities[i].yp + 1) != Localworld.FLOOR) ||
							(testbufferat(Obj.entities[i].xp - 1, Obj.entities[i].yp) != Localworld.FLOOR &&
					    testbufferat(Obj.entities[i].xp + 1, Obj.entities[i].yp) != Localworld.FLOOR)) {
						if(Buildconfig.showtraces) trace("Ai Director: I'm going to consider cutting the guard at (" + Obj.entities[i].xp + ", " + Obj.entities[i].yp + ")");
						testmap[Obj.entities[i].xp][Obj.entities[i].yp] = Localworld.FLOOR;
						guardspace = 0;
						floodtest_guardspace(Obj.entities[i].xp, Obj.entities[i].yp, 0);
						if(Buildconfig.showtraces) trace("This guard has at least " + guardspace + " spaces around it.");
						//Set up the next one
						if (guardspace <= 2) {
							if(Buildconfig.showtraces) trace("Well, that's not enough space! Let's cut it.");
							World.placetile(Obj.entities[i].xp, Obj.entities[i].yp, Localworld.FLOOR);
							Obj.entities[i].active = false;
						}
						copymaptotestbuffer(true);
					}
				}
			}
		}
		
		if (Generator.lastblueprint == "intro_topfloor") {
			//How can we make this better? Well, let's count the locked doors
			//If there are excess, make them gems instead
			var lockeddoorcount:Int = Levelgen.countlockeddoors();
			var keycount:Int = Levelgen.countkeys();
			if (keycount > lockeddoorcount) {
				//Only ever do one, otherwise it breaks the occasional interesting challenge
				Levelgen.swapkeysforgems(1);	
			}
		}
		
		if (Generator.lastblueprint == "high_topfloor") {
			//How can we make this better? Well, let's count the locked doors
			//If there are excess, make them gems instead
			var lockeddoorcount:Int = Levelgen.countlockeddoors();
			var keycount:Int = Levelgen.countkeys();
			if (keycount > lockeddoorcount) {
				//Only ever do one, otherwise it breaks the occasional interesting challenge
				Levelgen.swapkeysforgems(1);	
			}
		}
		
		//Consider placing a shopkeeper:
		if ((floor == 3 || floor == 4) && !placedfirstshopkeeper && Game.cash >= 2) {
			//Consider placing a shopkeeper on this floor
			if ((Rand.pbool() && floor == 3) || floor == 4) {
				if (Game.health < 3) {
					Levelgen.placeshopkeeper(Rand.ppickstring(Item.FIRSTAIDKIT, Weapon.PISTOL, Item.BANANAPEEL));
				}else{
					Levelgen.placeshopkeeper(Rand.ppickstring(Item.LIGHTBULB, Item.SIGNALJAMMER, Item.DRILL, Item.BOMB));
				}
			placedfirstshopkeeper = true;
			}
		}
		
		if ((floor == 6 || floor == 7) && !placedsecondshopkeeper && Game.cash >= 2) {
			//Consider placing a shopkeeper on this floor
			if ((Rand.pbool() && floor == 6) || floor == 7) {
				if (Game.health < 3) {
					Levelgen.placeshopkeeper(Rand.ppickstring(Item.FIRSTAIDKIT, Weapon.PISTOL, Weapon.TELEPORTER, Item.BOMB));
				}else{
					Levelgen.placeshopkeeper(Rand.ppickstring(Weapon.PISTOL, Item.LIGHTBULB, Item.SIGNALJAMMER, Item.DRILL, Weapon.TELEPORTER, Item.BOMB));
				}
			placedsecondshopkeeper = true;
			}
		}
		
		if ((floor == 13 || floor == 14) && !placedthirdshopkeeper && Game.cash >= 2) {
			//Consider placing a shopkeeper on this floor
			if (Game.health < 3) {
				Levelgen.placeshopkeeper(Item.FIRSTAIDKIT);
			}else{
				Levelgen.placeshopkeeper(Rand.ppickstring(Weapon.PISTOL, Item.LIGHTBULB, Weapon.SWORD, Item.DRILL));
			}
			placedthirdshopkeeper = true;
		}
		
		if (floor >= 6 && floor < 10) {
		  //On the 6th - 10th floor, very rarely randomly swap a door for a fake portable door sometimes	
			if (Rand.prare()) {
			  if (!donethedoorjoke) {	
					Levelgen.swaprealdoorforfakedoor(1);
					donethedoorjoke = true;
				}
			}
			//Make sure there's never more than one robot
			
			//If the map has long vertical corridors, make sure there's a wiggle in em somewhere (otherwise
			//robots can shoot you from behind and it's very unfair)
		}
		
		//*** At this point all entity removals are final! ***
		
		//We should update the lighting now to deal with ghost guards.
		Localworld.updatelighting();
		
		//Do some statistics, might use this to shape levels better
		onthisfloor_lockeddoors = countblocks(Localworld.LOCKEDDOOR);
		onthisfloor_keys = countblocks(Localworld.KEY);
		onthisfloor_gems = countgems();
		
		var itemlist:Array<String> = getitemsonthisfloor();
		onthisfloor_items = itemlist.length;
		
		//Consider fairness of locked doors!
		//is there a locked door on this floor that we can't open?
		/*
		if(floor != 10){
			if (onthisfloor_lockeddoors > onthisfloor_keys + Game.keys) {
				trace("there are more locked doors on this level than there are keys on this floor");
				//Ok: did we have a chance to pick up a key that we missed?
				trace("We've seen " + onthisrun_keys + " keys on this run, and opened " + onthisrun_keysused + " locked doors.");
				if ((onthisrun_keys - onthisfloor_keys) - onthisrun_keysused < onthisfloor_lockeddoors - (onthisfloor_keys + Game.keys)) {
					//Ok, we didn't. Do we have an item or did we have the opertunity to get an item that would
					//have allowed us to get through anyway?
					trace("maybe we should scrap this level: the player didn't encounter enough keys on this run to open it.");
				}
			}
		}
		*/
		
		//After this point, we're adding stuff to the cumulative findings. Be careful!
		onthisrun_keys += onthisfloor_keys;
		onthisrun_gems += onthisfloor_gems;
		for (i in 0 ... itemlist.length) {
			onthisrun_treasurelist.push(itemlist[i]);
		}
		
		if(Buildconfig.showtraces) trace("=-=-=-=-=-=-=-=-=-=-=-");
		/*
		trace("statistics:");
		trace("Keys on this floor: " + onthisfloor_keys);
		trace("Keys on this run so far: " + onthisrun_keys);
		trace("Gems on this floor: " + onthisfloor_gems);
		trace("Gems on this run so far: " + onthisrun_gems);
		
		trace("Number of items on this floor: " + onthisfloor_items, itemlist);
		trace("Complete list of items seen: ", onthisrun_treasurelist);
		*/
		return true;
	}
	
	//These are the level parameters for each floor
	public static var seed:String = "random";
	public static var floor:Int = 1;
	public static var roomlit:Bool = false;
	public static var darkroom:Bool = false;
	public static var gems:Int = 1;
	public static var keys:Int = 1;
	public static var lockedexit:Bool = true;
	public static var extralockeddoors:Int = 1;
	public static var style:Roomstyle = Roomstyle.intro;
	public static var blueprint:Array<String> = [];
	public static var enemylist:Array<String> = [];
	public static var weaponlist:Array<String> = [];
	public static var itemlist:Array<String> = [];
	public static var startingitems:Array<String> = [];
	public static var reinforcements:Array<String> = [];
	public static var reinforcementtime:Array<Int> = [];
	public static var reinforcementdelay:Int;
	
	public static var glitchmode:Bool = false;
	public static var outside:Bool = false;
	
	//Internal variables
	public static var entrance:String = "";
	public static var itemsgiven_intro:Int;
	public static var itemsgiven_high:Int;
	public static var donethedoorjoke:Bool;
	public static var placedfirstshopkeeper:Bool;
	public static var placedsecondshopkeeper:Bool;
	public static var placedthirdshopkeeper:Bool;
	
	public static var onthisfloor_lockeddoors:Int;
	public static var onthisfloor_keys:Int;
	public static var onthisfloor_gems:Int;
	public static var onthisfloor_items:Int;
	
	public static var onthisrun_keys:Int;
	public static var onthisrun_keysused:Int;
	public static var onthisrun_gems:Int;
	public static var onthisrun_items:Int;
	public static var onthisrun_treasurelist:Array<String>;
	
	public static function givestartingitems() {
		var j:Int = 0;
		for (i in 0 ... startingitems.length) {
			if (startingitems[i].toLowerCase() == "key") {
				Game.keys++;
			}else if (startingitems[i].toLowerCase() == "gem") {
				Game.cash++;
			}else if (Itemstats.get(startingitems[i]).hasmultipleshots) {
				Modern.inventory[j] = startingitems[i];
				Modern.inventory_num[j] = Itemstats.get(startingitems[i]).typical;
				j++;
			}else{
				Modern.inventory[j] = startingitems[i];
				j++;
			}
		}	
	}
	
	public static var testmap:Array<Array<Int>>;
}	