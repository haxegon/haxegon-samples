package gamecontrol;

import haxegon.*;
import modernversion.*;
import terrylib.*;

class Use {
	/** Use the item numbered t in the list in the game. */
	public static function doitemaction(t:Int):Void {
		switch(Inventory.itemlist[t].name.toLowerCase()) {			
			case "first aid kit":
				//if (Game.health < 3) Game.health++;
				Game.health++;
				Obj.entities[Obj.getplayer()].health = Game.health;
				Obj.entities[Obj.getplayer()].setmessage("HEALTH RESTORED!", "good");
				
				Modern.hpflash = Modern.flashtime;
				Music.playsound("useitem");
			case "cardboard box":
				Obj.entities[Obj.getplayer()].setmessage("Wearing Box!", "player");
				Game.cloaked += 50;
				
				//Fog out the world!
				Localworld.setroomfog(0);
				
				Game.dealertall();
				Music.playsound("useitem");
			case "time stopper":
				Obj.entities[Obj.getplayer()].setmessage("Time stopped!", "player");
				Game.timestop += 20;
				Music.playsound("useitem");
			case "portable door":
				Draw.screenshake = 10;
				var player:Int = Obj.getplayer();
				World.placetile(Obj.entities[player].xp + Localworld.xstep(Obj.entities[player].dir), Obj.entities[player].yp + Localworld.ystep(Obj.entities[player].dir), Localworld.DOOR);
				
				Music.playsound("useitem");
			case "lockdown":
				Obj.entities[Obj.getplayer()].setmessage("Initiating Lockdown!", "player");
				Draw.screenshake = 10;
				for (j in 0 ... World.mapheight) {
					for (i in 0 ... World.mapwidth) {
						if (World.at(i, j) == Localworld.OPENDOOR) {
							World.placetile(i, j, Localworld.DOOR);
						}
					}
				}
				
				Music.playsound("useitem");
			case "ice cube":
				Obj.entities[Obj.getplayer()].setmessage("Swallowed Ice Cube!", "player");
				Game.icecube += 60;
				
				Music.playsound("useitem");
			case "signal jammer":
				for (i in 0 ... Obj.nentity) {
					if (Obj.entities[i].active) {
						if (Obj.entities[i].rule == "enemy") {
							if (Obj.entities[i].type == "camera" || Obj.entities[i].type == "sentinal" ||
								  Obj.entities[i].type == "lasercamera" || Obj.entities[i].type == "lasersentinal" ||
									Obj.entities[i].type == "drone_light" || Obj.entities[i].type == "drone_laser"||
									Obj.entities[i].type == Enemy.TRIPWIRE_UP || Obj.entities[i].type == Enemy.TRIPWIRE_DOWN ||
									Obj.entities[i].type == Enemy.TRIPWIRE_LEFT || Obj.entities[i].type == Enemy.TRIPWIRE_RIGHT ||
									Obj.entities[i].type == Enemy.LASERWIRE_UP || Obj.entities[i].type == Enemy.LASERWIRE_DOWN ||
									Obj.entities[i].type == Enemy.LASERWIRE_LEFT || Obj.entities[i].type == Enemy.LASERWIRE_RIGHT) {
								Game.stunenemy(i, Modern.LONGSTUNTIME);
							}
						}
					}
				}
				
				Draw.flashlight = 5;
				Draw.screenshake = 10;
				Obj.entities[Obj.getplayer()].setmessage("Jamming Camera Signals!", "player");
				Localworld.updatelighting();
				
				Music.playsound("useitem");
			case Item.LIGHTBULB:
				AIDirector.darkroom = false;
				Localworld.setroomfog(1);
				for (j in 0 ... World.mapheight) {
					for (i in 0 ... World.mapwidth) {
						Localworld.highlightpoint(i, j);
					}
				}
				Game.showmessage("LIGHT SWITCHED ON!", "good", 120);
				
				Music.playsound("useitem");
			case "drill":
				tdir = Obj.entities[Obj.getplayer()].dir;
				tx = Obj.entities[Obj.getplayer()].xp;
				ty = Obj.entities[Obj.getplayer()].yp;
			  Localworld.drill(tx + Localworld.xstep(tdir), ty + Localworld.ystep(tdir), tdir);
				
				Music.playsound("useitem");
			case Item.HELIXWING:
				Modern.playeronstairs = true;
				
				Modern.endlevelanimationstate = 1;
				Modern.endlevelanimationaction = "endgame";
				
				Music.playsound("nextfloor");
			case Item.BANANAPEEL:
				tdir = Help.oppositedirection(Obj.entities[Obj.getplayer()].dir);
				tx = Obj.entities[Obj.getplayer()].xp;
				ty = Obj.entities[Obj.getplayer()].yp;
			  
				//If there's an enemy right on your heels, just stun it
				var enemybehind:Int = -1;
				for (i in 0 ... Obj.nentity) {
					if (enemybehind == -1) {
						if (Obj.entities[i].active) {
							if (Obj.entities[i].state != Game.STUNNED) {
								if (Obj.entities[i].rule == "enemy") {
									if(Obj.entities[i].xp == tx && Obj.entities[i].yp == ty){
										Game.stunenemy(i, Modern.STANDARDSTUNTIME);
										enemybehind = i;
									}
								}
							}
						}
					}
				}
				if (enemybehind == -1) {
					if (World.at(tx + Localworld.xstep(tdir), ty + Localworld.ystep(tdir)) != Localworld.WALL) {
						World.placetile(tx + Localworld.xstep(tdir), ty + Localworld.ystep(tdir), Localworld.BANANAPEEL);
					}else {
						World.placetile(tx, ty, Localworld.BANANAPEEL);
					}
				}
				
				Music.playsound("useitem");
		}
	}
	
	public static function usegadget(ent:Int, gadget:Int):Void {
		tdir = Obj.entities[ent].dir;
		tx = Obj.entities[ent].xp;
		ty = Obj.entities[ent].yp;
		Game.cloaked = 0;
		
		//var ammo:Int = Inventory.getammo(gadget);
		
		//if (ammo > 0) {
			//Inventory.useinventoryitem(gadget);
			switch(Inventory.itemlist[gadget].name.toLowerCase()) {
				case "teleporter":
					Modern.playerjustteleported = true;
					var player:Int = Obj.getplayer();
					tx = Std.int(Obj.entities[player].xp);
					ty = Std.int(Obj.entities[player].yp);
					
					/*
					for (j in -2 ... 3) {
						for (i in -2 ... 3) {
							if(Math.abs(i) + Math.abs(j) < 4){
								Localworld.highlightpoint(tx + i, ty + j);
								if (Game.checkforenemy(tx + i, ty + j) > 0) {
									Game.stunenemy(Game.checkforenemy(tx + i, ty + j), Modern.STANDARDSTUNTIME);
								}
							}
						}
					}*/
					
					tx = Std.int(Obj.entities[player].xp);
					ty = Std.int(Obj.entities[player].yp);
					tx2 = -1;
					var attempts:Int = 1000;
					//Generally, pick a random point away from the player. For testing, pick a point
					//Beside the exit...
					while (attempts > 0 && (tx2 == -1 || World.at(tx2, ty2) != Localworld.FLOOR || Math.abs(tx - tx2) < 4 || Math.abs(ty - ty2) < 4)) {
						tx2 = Rand.pint(0, World.mapwidth);	ty2 = Rand.pint(0, World.mapheight);
						attempts--;
					}
					
					//Debug! Delete me
					/*
					for (j in 0 ... World.mapheight) {
						for (i in 0 ... World.mapwidth) {
							if (World.at(i, j) == Localworld.STAIRS) {
								tx2 = i; ty2 = j + 1;
							}
						}
					}*/
					
					if (attempts > 0) {
						for (j in -2 ... 3) {
							for (i in -2 ... 3) {		
								if(Math.abs(i) < 3 && Math.abs(j) < 3){
									if (Game.checkforenemy(tx2 + i, ty2 + j) > 0) {
										Game.stunenemy(Game.checkforenemy(tx2 + i, ty2 + j), Modern.STANDARDSTUNTIME);
									}
								}
							}
						}
						
						Obj.entities[player].xp = tx2;
						Obj.entities[player].yp = ty2;
					}else {
						Obj.randomwalk(player, 12);
					}
					tx = Std.int(Obj.entities[player].xp);
					ty = Std.int(Obj.entities[player].yp);
					
					for (j in -2 ... 3) {
						for (i in -2 ... 3) {			
							if(Math.abs(i) < 3 && Math.abs(j) < 3){
								Localworld.highlightpoint(tx + i, ty + j);
							}
						}
					}
					
					Localworld.updatelighting();
					
					Music.playsound("shoot");
				case "fire extinguisher":
					//Spreads out like a shotgun blast, putting out fires.
					Localworld.fireextinguisher(tx, ty, tdir, 1);
					Localworld.fireextinguisher(tx + Localworld.xstep(tdir), ty + Localworld.ystep(tdir), tdir, 4);
					Localworld.fireextinguisher(tx + Localworld.xstep(tdir) + Localworld.xstep(Help.clockwise(tdir)) , ty + Localworld.ystep(tdir) + Localworld.ystep(Help.clockwise(tdir)), tdir, 2);
					Localworld.fireextinguisher(tx + Localworld.xstep(tdir) + Localworld.xstep(Help.anticlockwise(tdir)) , ty + Localworld.ystep(tdir) + Localworld.ystep(Help.anticlockwise(tdir)), tdir, 2);
					Localworld.supressfire();
					if (!Localworld.checkforfire()) Localworld.clearfire();
					
					Music.playsound("shoot");
				case Weapon.MATCHSTICK:
					//Spreads out like a shotgun blast, putting out fires. 
					Draw.flashlight = 5;
					Draw.screenshake = 10;
					Localworld.flamethrower(tx + Localworld.xstep(tdir), ty + Localworld.ystep(tdir), tdir, 4);
					Localworld.flamethrower(tx + Localworld.xstep(tdir) + Localworld.xstep(Help.clockwise(tdir)) , ty + Localworld.ystep(tdir) + Localworld.ystep(Help.clockwise(tdir)), tdir, 2);
					Localworld.flamethrower(tx + Localworld.xstep(tdir) + Localworld.xstep(Help.anticlockwise(tdir)) , ty + Localworld.ystep(tdir) + Localworld.ystep(Help.anticlockwise(tdir)), tdir, 2);
					
					World.fire[tx + World.vmult[ty]] = 0;
					
					Music.playsound("shoot");
				case "tazer":
					//Knocks a nearby enemy out, or gives a message about being out of range
					var shotdistance:Int = 1;
					while (shotdistance < 6) {
						temp = Game.checkforenemy(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance));
						Localworld.highlightpoint(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance));
						if (temp == -2) shotdistance = 6;
						if (temp >= 0) {
							shotdistance = 10;
							Game.stunenemy(temp, Modern.STANDARDSTUNTIME);
							Draw.flashlight = 5;
							Draw.screenshake = 10;
						}
						shotdistance++;
					}
					
					Music.playsound("shoot");
				case Weapon.SKATEBOARD:
					//Dash forward until you hit something, then stop.
					var shotdistance:Int = 1;
					var hitwall = false;
					while (!hitwall) {
						temp = Game.checkforentity(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance));
						if (!Help.inboxw(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance), 0, 0, World.mapwidth - 1, World.mapheight - 1)) {
							temp = -2;
						}
						if (temp != -1) {
							//We've hit a wall, we're done
							hitwall = true;
						}else {
							Localworld.highlightpoint(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance));
							if (World.at(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance)) == Localworld.DEBRIS) {
								World.placetile(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance), Localworld.FLOOR);
							}
						}
						shotdistance++;
					}
					shotdistance-= 2;
					if (shotdistance > 0) {
						var player:Int = Obj.getplayer();
						Obj.entities[player].xp = Obj.entities[player].xp + Localworld.xstep(tdir, shotdistance);
						Obj.entities[player].yp = Obj.entities[player].yp + Localworld.ystep(tdir, shotdistance);
					}
					
					Music.playsound("shoot");
				case Weapon.SWORD:
					//Dash forward, kill everything in your path
					var shotdistance:Int = 1;
					var hitwall = false;
					while (shotdistance < 100 && !hitwall) {
						temp = Game.checkforenemy(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance));
						if (!Help.inboxw(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance), 0, 0, World.mapwidth - 1, World.mapheight - 1)) {
							temp = -2;
						}
						Localworld.highlightpoint(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance));
						if (World.at(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance)) == Localworld.DEBRIS) {
							World.placetile(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance), Localworld.FLOOR);
						}
						if (temp == -2) {
							//We've hit a wall, we're done
							hitwall = true;
						}
						if (temp >= 0) {
							Game.killenemy(temp);
							Draw.flashlight = 5;
							Draw.screenshake = 10;
						}
						shotdistance++;
					}
					shotdistance-= 2;
					if (shotdistance > 0) {
						var player:Int = Obj.getplayer();
						Obj.entities[player].xp = Obj.entities[player].xp + Localworld.xstep(tdir, shotdistance);
						Obj.entities[player].yp = Obj.entities[player].yp + Localworld.ystep(tdir, shotdistance);
					}
					
					Music.playsound("shoot");
				case "leaf blower":
					//Knocks back anything it comes into contact with!
					var shotdistance:Int = 1;
					var hitwall = false;
					while (shotdistance < Math.max(World.mapheight+1, World.mapwidth+1) && !hitwall) {
						temp = Game.checkforenemy(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance));
						Localworld.highlightpoint(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance));
						if (temp == -2) {
							hitwall = true;
						}
						if (temp >= 0) {
							Game.stunenemy(temp, Modern.STANDARDSTUNTIME);
							hitwall = true;
							Draw.flashlight = 5;
							Draw.screenshake = 10;
						}
						shotdistance++;
					}
					
					//Ok, we have our entity!
					if (temp >= 0) {
						while (Game.checkforentity(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance)) == -1 && Help.inboxw(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance), 0, 0, World.mapwidth, World.mapheight)) {
							Localworld.highlightpoint(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance));
						  Obj.entities[temp].xp = tx + Localworld.xstep(tdir, shotdistance);
							Obj.entities[temp].yp = ty + Localworld.ystep(tdir, shotdistance);
							shotdistance++;
						}
					}
					
					Music.playsound("shoot");
				case "pistol":
					//Kills a thing dead. Alerts all other guards in a room.
					var shotdistance:Int = 1;
					while (shotdistance < Math.max(World.mapheight+1, World.mapwidth+1)) {
						temp = Game.checkforenemy(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance));
						Localworld.highlightpoint(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance));
						if (temp == -2) shotdistance = Std.int(Math.max(World.mapheight+1, World.mapwidth+1));
						if (temp >= 0) {
							shotdistance = 10000;
							Game.killenemy(temp);
							Draw.flashlight = 5;
							Draw.screenshake = 10;
						}
						shotdistance++;
					}
					Game.alertallenemies();
					
					Music.playsound("shoot");
				case "sniper rifle":
					//Like pistol, but doesn't alert
					var shotdistance:Int = 1;
					while (shotdistance < Math.max(World.mapheight+1, World.mapwidth+1)) {
						temp = Game.checkforenemy(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance));
						Localworld.highlightpoint(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance));
						if (temp == -2) shotdistance = Std.int(Math.max(World.mapheight+1, World.mapwidth+1));
						if (temp >= 0) {
							shotdistance = 10000;
							Game.killenemy(temp);
							Draw.flashlight = 5;
							Draw.screenshake = 10;
						}
						shotdistance++;
					}
					
					Music.playsound("shoot");
				case "tranquilizer":
					//Knocks human enemies out from a distance
					var shotdistance:Int = 1;
					while (shotdistance < Math.max(World.mapheight+1, World.mapwidth+1)) {
						temp = Game.checkforenemy(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance));
						Localworld.highlightpoint(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance));
						if (temp == -2) shotdistance = Std.int(Math.max(World.mapheight+1, World.mapwidth+1));
						if (temp >= 0) {
							shotdistance = 10000;
							if(!Obj.entities[temp].isarobot){
								Game.stunenemy(temp, Modern.STANDARDSTUNTIME);
								Draw.flashlight = 5;
								Draw.screenshake = 10;
							}
						}
						shotdistance++;
					}
					
					Music.playsound("shoot");
				case Item.ERRORBOMB:
					Localworld.glitchexplode(tx, ty, 6, false);
					Game.alertallenemies();
					
					Music.playsound("shoot");
				case "bomb":
					Localworld.explode(tx, ty, 3, false);
					Game.alertallenemies();
					
					Music.playsound("shoot");
				case "emp blaster":
					//Drop to stun all robot enemies nearby.
					for (j in -3 ... 4) {
						for (i in -3 ... 4) {
							if(Math.abs(i) + Math.abs(j) < 5){
								temp = Game.checkforenemy(tx + i, ty + j);
								Localworld.highlightpoint(tx + i, ty + j);
								if (temp >= 0) {
									if(Obj.entities[temp].isarobot){
										Game.stunenemy(temp, Modern.STANDARDSTUNTIME);
										Draw.flashlight = 5;
										Draw.screenshake = 10;
									}
								}
							}
						}
					}
					
					Music.playsound("shoot");
				case "knockout gas":
					//Drop to stun all human enemies nearby.
					for (j in -3 ... 4) {
						for (i in -3 ... 4) {
							if(Math.abs(i) + Math.abs(j) < 5){
								temp = Game.checkforenemy(tx + i, ty + j);
								Localworld.highlightpoint(tx + i, ty + j);
								if (temp >= 0) {
									if(!Obj.entities[i].isarobot){
										Game.stunenemy(temp, Modern.STANDARDSTUNTIME);
										Draw.flashlight = 5;
										Draw.screenshake = 10;
									}
								}
							}
						}
					}
					
					Music.playsound("shoot");
			}
			
			//if (ammo <= 1) {
			//	Inventory.setequippedgadget("none", false);
			//}
		//}else {
		  //Game.showmessage("OUT OF " +Inventory.itemlist[gadget].multiname + "...", "flashing", 120);
		//}
	}
	
	public static function interactwith(target:Int, source:Int):Void {
		//Source is interacting with the target! For example:
		if(Obj.entities[source].rule == "player"){
			if (Obj.entities[target].rule == "enemy") {
				//Attacking an enemy with your weapon!
				/*
				switch(Inventory.itemlist[Inventory.equippedweapon].name.toLowerCase()) {
					case "dagger":
						Game.killenemy(target);
					case "stick":
						if (Obj.entities[target].state < 2) {
							Game.stunenemy(target, Modern.STANDARDSTUNTIME);	
						}
					case "club":
						if (Obj.entities[target].state < 2) {
							Game.stunenemy(target, Modern.STANDARDSTUNTIME);	
						}
					case "nightstick":
						if (Obj.entities[target].state < 2) {
							Game.stunenemy(target, Modern.LONGSTUNTIME);	
						}
				}
				*/				
				//No longer having equippable items as a concept.
				if (Obj.entities[target].state != Game.STUNNED) {
					Game.stunenemy(target, Modern.STANDARDSTUNTIME);
					Game.cloaked = 0;
					Game.timestop = 0;
				}
			}else if (Obj.entities[target].rule == "npc") {
				//It's an NPC - talk to them!
				//Menu.createmenu(Obj.entities[target].name);
				Modern.shopkeepcol = Obj.entities[target].col;
				Music.playsound("talk");
				if(Obj.entities[target].name.toLowerCase() == "key"){
					Modern.popup("shopkeeper", Modern.currentitem);
				}else if(Obj.entities[target].name.toLowerCase() == "sold out"){
					Modern.popup("soldoutshopkeeper", Modern.currentitem);
				}else{
					Modern.currentitem = Itemstats.get(Obj.entities[target].name);
					Modern.popup("itemshopkeeper", Modern.currentitem);
					Modern.currentshopkeeper = target;
				}
				Modern.updatekeygemrate();
				//Menu.textmode = 1;
			}else if (Obj.entities[target].rule == "treasure") {
				//It's treasure! Pick it up!
				Music.playsound("collectgem");
				Obj.entities[Obj.getplayer()].setmessage("Found GEM", "cash", 40);
				Game.cash += Obj.entities[target].life;
				Modern.gemflash = Modern.flashtime;
				Obj.entities[target].active = false;
			}else if (Obj.entities[target].rule == "item") {
				//It's an item! Cool! Pick it up!
				Modern.pickupitem(Obj.entities[target]);
				Obj.entities[target].active = false;
				/*
				if (Inventory.giveitem(Obj.entities[target].name, Obj.entities[target].para)) {
					var t:Int = Inventory.getitemlistnum(Obj.entities[target].name);
					if (Inventory.itemlist[t].type == Inventory.GADGET) {
						Obj.entities[Obj.getplayer()].setmessage("Found "+Inventory.itemlist[t].multiname+" x" + Std.string(Inventory.itemlist[t].typical) + " for " + Obj.entities[target].name.toUpperCase(), "player");
					}else {
						Obj.entities[Obj.getplayer()].setmessage("Found " + Obj.entities[target].name.toUpperCase(), "player");	
					}
				}else {
					var t:Int = Inventory.getitemlistnum(Obj.entities[target].name);
					if (Inventory.itemlist[t].type == Inventory.LETTER) {
						Inventory.currentletter = Inventory.itemlist[t].letter;
						Menu.createmenu("readnow");
						Menu.textmode = 1;
					}else{
						if (Inventory.itemlist[t].type == Inventory.GADGET) {
							Obj.entities[Obj.getplayer()].setmessage("Found " + Obj.entities[target].name.toUpperCase() + " + "+Inventory.itemlist[t].multiname+" x" + Std.string(Inventory.itemlist[t].typical), "player");	
						}else{
							Obj.entities[Obj.getplayer()].setmessage("Found " + Obj.entities[target].name.toUpperCase(), "player");	
						}
					}
				}
				Obj.entities[target].active = false;
				*/
			}
		}
	}
	
	public static var doorknockcheck:Bool = false;
	public static function interactwithblock(target:Int, x:Int, y:Int, source:Int):Void {
		//Source in interacting with a block type of TARGET. Eg. Doors, stairs.
		if (Obj.entities[source].rule == "enemy") {
			if (target == Localworld.DOOR) {
				World.placetile(x, y, Localworld.OPENDOOR);
				Music.playsound("opendoor");
			}
		}
		
		if (Obj.entities[source].rule == "player") {
			if (target == Localworld.DOOR) {
				World.placetile(x, y, Localworld.OPENDOOR);
				Music.playsound("opendoor");
			}else if (target == Localworld.LOCKEDDOOR) {
				if (Game.keys > 0) {
					World.placetile(x, y, Localworld.OPENDOOR);
					Game.keys--;
					Modern.keyflash = Modern.flashtime;
					AIDirector.onthisrun_keysused++;
					
					Music.playsound("unlock");
				}else {
					if(!doorknockcheck){
						Obj.entities[Obj.getplayer()].setmessage("It's locked...", "player");	
						Obj.entities[Obj.getplayer()].actionset = true;
						Obj.entities[Obj.getplayer()].action = "nothing";
						
						Music.playsound("lockeddoor");
						doorknockcheck = true;
					}
				}
			}else if (target == Localworld.KEY) {
				World.placetile(x, y, Localworld.FLOOR);
				Game.keys++;
				Modern.keyflash = Modern.flashtime;
				
				Obj.entities[Obj.getplayer()].setmessage("Found KEY", "key", 40);
				Music.playsound("collectkey");
			}else if (target == Localworld.STAIRS) {
				if (Openworld.inside) {
					Modern.usestairs();
					//Game.floor++;
					//Game.changeroom("inside");
				}else {
					//Entering a building from outside!
					Rand.setseed(Openworld.getroomseed(Openworld.worldx, Openworld.worldy));
					Game.generatetowerblock("intro");
					
					Game.floor = 1;
					Game.changeroom("inside");
				}
			}
		}
	}
	
	public static var tx:Int;
	public static var ty:Int;
	public static var tx2:Int;
	public static var ty2:Int;
	public static var tdir:Int;
	public static var temp:Int;
}