package modernversion;

import haxegon.*;
import entities.ItemType;
import entities.EnemyType;
import entities.Entclass;
import world.Localworld;
import world.Roomstyle;
import world.Levelgen;
import world.Glitch;
import world.World;
import entities.Obj;
import util.TinyRand;
import util.Glow;
import gamecontrol.Game;
import gamecontrol.Use;
import visuals.Draw;
import visuals.MessageBox;

//This project is a mess that I can barely interact with. So I'm creating this modern interface;
//from here, I can plug into the game without really touching anything.
class Modern {
	//Some balancing figures go here
	public static inline var STANDARDSTUNTIME:Int = 30;
	public static inline var LONGSTUNTIME:Int = 60;
	public static inline var TORCHRANGE:Int = 6;
	
	public static var hpflash:Int = 0;
	public static var keyflash:Int = 0;
	public static var gemflash:Int = 0;
	public static var waitflash:Int = 0;
	public static var flashtime:Int = 10;
	
	public static var worldx:Int = 50;
	public static var worldy:Int = 50;
	public static var currentrunseed:Int;
	public static var itemtopleft:String = "";
	public static var itemtopright:String = "";
	public static var itembottomright:String = "";
	public static var itembottomleft:String = "";
	
	public static var shopkeepcol:Int;
	public static var keygemrate:Int = 0;
	public static var keygemratelevel:Int = 0;
	public static var currentshopkeeper:Int = 0;
	public static var streakcount:Int = 0;
	
	public static var highestfloor:Int = 1;
	public static var newrecord:Bool = false;
	
	public static var endlevelanimationstate:Int = 0;
	public static var endlevelanimationdelay:Int = 0;
	public static var endlevelanimationspeed:Int = 1;
	public static var endlevelanimationx:Int = 0;
	public static var endlevelanimationy:Int = 0;
	public static var endlevelanimationaction:String = "next";

	public static function updatekeygemrate() {
		if (keygemratelevel == 0) { 
			keygemrate = 1;
		}else if (keygemratelevel == 1) { 
			keygemrate = 2;
		}else if (keygemratelevel == 2) { 
			keygemrate = 3;
		}else if (keygemratelevel == 3) { 
			keygemrate = 4;
		}else if (keygemratelevel == 4) { 
			keygemrate = 5;
		}else if (keygemratelevel == 5) { 
			keygemrate = 5;
		}
	}
	
	//Called from titlestate, this starts the game from the first floor.
  public static function start() {
		//100x150 is the upper limit on map sizes
		AIDirector.testmap = Data.create2darray(100, 100, 0);
		AIDirector.seed = "random";
		
		restart();
	}
	
	public static var lefttowerdir:String;
	public static function outsideworld() {
		Game.floor = 0;
		Obj.nentity = 0;
		
		hpflash = 0;
		gemflash = 0;
		keyflash = 0;
		waitflash = 0;
		
		Game.reinforcestate = 0;		
		AIDirector.reinforcements = [];
		AIDirector.reinforcementtime = [];
		
		Localworld.worldblock[Localworld.STAIRS].charcode_fog = 44;
		
		if (!AIDirector.outside) {
		  //Let's generate the outside world now
			worldx = 50;
			worldy = 50;
			var outsideitemlist:Array<String> = [ItemType.HELIXWING];
			outsideitemlist.push(Random.pick([ItemType.TIMESTOPPER, ItemType.CARDBOARDBOX, ItemType.MATCHSTICK, ItemType.TELEPORTER]));
			outsideitemlist.push("");
			outsideitemlist.push("");
			Random.shuffle(outsideitemlist);
			itemtopleft = outsideitemlist.pop();
			itemtopright = outsideitemlist.pop();
			itembottomleft = outsideitemlist.pop();
			itembottomright = outsideitemlist.pop();
		}
		
		Glitch.glitchmode = false;
		AIDirector.outside = true;
		AIDirector.style = Roomstyle.OUTSIDE;
		AIDirector.floor = Game.floor;
		
		Levelgen.outsidegen();
		
		if (lefttowerdir == "left") {
		  Obj.createentity(9, 9, "player");	
		}else if (lefttowerdir == "up") {
			Obj.createentity(16, 2, "player");	
		}else if (lefttowerdir == "down") {
			Obj.createentity(16, 15, "player");	
		}else {
			Obj.createentity(23, 9, "player");	
		}
		
		Localworld.setroomfog(1);
		Localworld.updatelighting();
		
		startfadein();
	}
	
	public static function restartfadeout() {
		endlevelanimationstate = 1;
		endlevelanimationaction = "restart";
	}
	
	public static function restart() {
		AIDirector.outside = true;
		Game.reinforcestate = 0;
		Inventory.restart();
		
		hpflash = 0;
		gemflash = 0;
		keyflash = 0;
		waitflash = 0;
		
		Game.restartgame();
		
		streakcount = 0;
		
		AIDirector.restart();
		
		if (AIDirector.seed == "random") {
			currentrunseed = Std.int(Math.random() * 16807);
			TinyRand.setseed(currentrunseed);
		}else{	
			currentrunseed = Levelgen.stringseed(AIDirector.seed) + Game.floor;
			TinyRand.setseed(currentrunseed);
		}
		if(Buildconfig.showtraces) trace("level seed is " + AIDirector.seed + ":(" + Levelgen.stringseed(AIDirector.seed) + Game.floor + ")");
		
		AIDirector.designfloor();
		Levelgen.createroom();
		
		while (!AIDirector.assessroom()) Levelgen.createroom();
		startfadein();
	}
	
	public static function updatepalette(?forcechange:Roomstyle) {
		if (forcechange != null) {
			switch(forcechange) {
				case Roomstyle.INTRO:
					Localworld.changepalette("blue", 0);
				case Roomstyle.HIGH:
					Localworld.changepalette("purple", 1);
				case Roomstyle.SHOPKEEPER:
					Localworld.changepalette("green", 3);
				case Roomstyle.ROBOT:
					Localworld.changepalette("gray", 2);
				case Roomstyle.OUTSIDE:
					Localworld.changepalette("gray", 5);
				case Roomstyle.ROOFTOP:
					Localworld.changepalette("blue", 4);
				case Roomstyle.ERROR:
					Localworld.changepalette("darkred", 0);
				default:
					Localworld.changepalette("darkred", 0);
			}	
		}else {
			switch(AIDirector.style) {
				case Roomstyle.INTRO:
					Localworld.changepalette("blue", 0);
				case Roomstyle.HIGH:
					Localworld.changepalette("purple", 1);
				case Roomstyle.SHOPKEEPER:
					Localworld.changepalette("green", 3);
				case Roomstyle.ROBOT:
					Localworld.changepalette("gray", 2);
				case Roomstyle.OUTSIDE:
					Localworld.changepalette("gray", 5);
				case Roomstyle.ROOFTOP:
					Localworld.changepalette("blue", 4);
				case Roomstyle.ERROR:
					Localworld.changepalette("darkred", 0);
				default:
					Localworld.changepalette("darkred", 0);
			}	
		}
	}
	
	public static var playeronstairs:Bool = false;
	public static var playerjustteleported:Bool = false;
	public static function usestairs() {
		Sound.play("nextfloor");
		playeronstairs = true;
		
		if (AIDirector.outside) {
			AIDirector.outside = false;
		  var zone:Int = Std.int(Math.max(Math.abs(Modern.worldx - 50), Math.abs(Modern.worldy - 50)));
			if (zone > 0) {
				//You used glitch stairs! Nice! Let's make a glitchy version of the tower
				Glitch.glitchmode = true;
			}else {
			  streakcount++;
			}
		}
		
		endlevelanimationstate = 1;
		if (AIDirector.floor >= 16) {
			endlevelanimationaction = "endgame";
		}else{
			endlevelanimationaction = "next";
		}
	}
	
	public static function checkfortowerexit() {
		if (AIDirector.outside) {
			var player:Int = Obj.getplayer();
			if (!Geom.inbox(Obj.entities[player].xp, Obj.entities[player].yp, 0, 0, World.mapwidth, World.mapheight)) {
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
				
				var px:Int = Obj.entities[player].xp;
				var py:Int = Obj.entities[player].yp;
				Levelgen.outsidegen();
				
				Obj.createentity(px, py, "player");
				//For fairness, the block you enter on cannot be on fire.
				if (Localworld.onfire) {
					Localworld.extingushfireblock(px, py);
				}
				Localworld.updatelighting();
			}
		}else{
			var player:Int = Obj.getplayer();
			if (!Geom.inbox(Obj.entities[player].xp, Obj.entities[player].yp, 0, 0, World.mapwidth, World.mapheight)) {
				endlevelanimationstate = 1;
				endlevelanimationaction = "leftmap";
				
				if (Obj.entities[player].xp < 0) {
					lefttowerdir = "left";
				}else if (Obj.entities[player].yp < 0) {
					lefttowerdir = "up";
				}else if (Obj.entities[player].yp > World.mapheight - 1) {
					lefttowerdir = "down";
				}else {
					lefttowerdir = "right";	
				}
			}else {
				if (Game.floor == 16) {
					var temptile:Int = World.at(Obj.entities[player].xp, Obj.entities[player].yp);
					if (temptile == Localworld.ROOFBACKGROUND || temptile == Localworld.ROOFSIDE || temptile == Localworld.ROOFSTARS) {
						endlevelanimationstate = 1;
						endlevelanimationaction = "leftmap";
						
						if (temptile == Localworld.ROOFSIDE) {
							lefttowerdir = "down";
						}else if (Obj.entities[player].xp < 7) {
							lefttowerdir = "left";
						}else if (Obj.entities[player].yp < 7) {
							lefttowerdir = "up";
						}else {
							lefttowerdir = "right";
						}
					}
				}	
			}
		}
	}
		
	public static function usestairs_afteranimation() {
		playeronstairs = false;
		playerjustteleported = false;
		
		AIDirector.floor++;	
		
		if (AIDirector.seed == "random") {
			TinyRand.setseed(Std.int(Math.random() * 16807));
		}else{	
			TinyRand.setseed(Levelgen.stringseed(AIDirector.seed) + Game.floor);
		}
		if(Buildconfig.showtraces) trace("level seed is " + Levelgen.stringseed(AIDirector.seed) + Game.floor);
		
		AIDirector.designfloor();
		
		Levelgen.createroom();
		
		while (!AIDirector.assessroom()) Levelgen.createroom();
		
		if (Glitch.glitchmode) {
		  //Swap all the gems for glitch bombs
			var gempositions:Array<Int> = [];
			for (i in 0 ... Obj.nentity) {
				if (Obj.entities[i].active) {
				  if (Obj.entities[i].rule == "treasure") {
						gempositions.push(i);
						Obj.entities[i].active = false;
					}
				}
			}
			
			for (i in 0 ... gempositions.length) {
			  Obj.createentity(Obj.entities[gempositions[i]].xp, Obj.entities[gempositions[i]].yp, "item", ItemType.ERRORBOMB);
			}
		}
		
		//Make streaks harder!
		if (streakcount > 0) {
		  if (streakcount >= 1) {
			  //Swap guards for laser guards and cameras for laser cameras
				var guardpositions:Array<Int> = [];
				for (i in 0 ... Obj.nentity) {
					if (Obj.entities[i].active) {
						if (Obj.entities[i].type == EnemyType.GUARD) {
							guardpositions.push(i);
							Obj.entities[i].active = false;
						}
					}
				}
				
				for (i in 0 ... guardpositions.length) {
					Obj.createentity(Obj.entities[guardpositions[i]].xp, Obj.entities[guardpositions[i]].yp, "enemy", EnemyType.LASERGUARD);
				}
				
				guardpositions = [];
				for (i in 0 ... Obj.nentity) {
					if (Obj.entities[i].active) {
						if (Obj.entities[i].type == EnemyType.CAMERA) {
							guardpositions.push(i);
							Obj.entities[i].active = false;
						}
					}
				}
				
				for (i in 0 ... guardpositions.length) {
					Obj.createentity(Obj.entities[guardpositions[i]].xp, Obj.entities[guardpositions[i]].yp, "enemy", EnemyType.LASERCAMERA);
				}
				
				guardpositions = [];
				for (i in 0 ... Obj.nentity) {
					if (Obj.entities[i].active) {
						if (Obj.entities[i].type == EnemyType.SENTINAL) {
							guardpositions.push(i);
							Obj.entities[i].active = false;
						}
					}
				}
				
				for (i in 0 ... guardpositions.length) {
					Obj.createentity(Obj.entities[guardpositions[i]].xp, Obj.entities[guardpositions[i]].yp, "enemy", EnemyType.LASERSENTINAL);
				}
			}
			if (streakcount >= 2) {
			  //All elite bots are now terminators
				var guardpositions:Array<Int> = [];
				for (i in 0 ... Obj.nentity) {
					if (Obj.entities[i].active) {
						if (Obj.entities[i].type == EnemyType.ROBOT) {
							guardpositions.push(i);
							Obj.entities[i].active = false;
						}
					}
				}
				
				for (i in 0 ... guardpositions.length) {
					Obj.createentity(Obj.entities[guardpositions[i]].xp, Obj.entities[guardpositions[i]].yp, "enemy", EnemyType.TERMINATOR);
				}
			}
		}
		
		startfadein();
	}
	
	public static function startfadein() {
		endlevelanimationstate = -1;
	  var player:Int = Obj.getplayer();
		
		endlevelanimationx = Obj.entities[player].xp;
		endlevelanimationy = Obj.entities[player].yp;
	}
}