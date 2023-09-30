package gamecontrol;

import haxegon.*;
import modernversion.*;
import entities.ItemType;
import entities.EnemyType;
import world.Glitch;
import world.Localworld;
import world.World;
import entities.Obj;
import util.TinyRand;
import util.Glow;
import util.Direction;
import visuals.Draw;
import visuals.ScreenEffects;
import PopUp.PopUpType;

class Use {
	public static var doorknockcheck:Bool = false;
	
	static var tx:Int;
	static var ty:Int;
	static var tx2:Int;
	static var ty2:Int;
	static var tdir:Int;
	static var temp:Int;
	
	public static function useitem(ent:Int, itemname:String):Void {
		Game.cloaked = 0;
		
		switch(itemname.toLowerCase()) {
			case ItemType.TELEPORTER:
				Modern.playerjustteleported = true;
				var player:Int = Obj.getplayer();
				tx = Std.int(Obj.entities[player].xp);
				ty = Std.int(Obj.entities[player].yp);
				tx2 = -1;
				
				var attempts:Int = 1000;
				//Pick a random point away from the player.
				while (attempts > 0 && (tx2 == -1 || World.at(tx2, ty2) != Localworld.FLOOR || Math.abs(tx - tx2) < 4 || Math.abs(ty - ty2) < 4)) {
					tx2 = TinyRand.pint(0, World.mapwidth);	ty2 = TinyRand.pint(0, World.mapheight);
					attempts--;
				}
				
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
				
				Sound.play("shoot");
			case ItemType.FIREEXTINGUISHER:
				tdir = Obj.entities[ent].dir;
				tx = Obj.entities[ent].xp;
				ty = Obj.entities[ent].yp;
				
				//Spreads out like a shotgun blast, putting out fires.
				Localworld.fireextinguisher(tx, ty, tdir, 1);
				Localworld.fireextinguisher(tx + Localworld.xstep(tdir), ty + Localworld.ystep(tdir), tdir, 4);
				Localworld.fireextinguisher(tx + Localworld.xstep(tdir) + Localworld.xstep(Direction.clockwise(tdir)) , ty + Localworld.ystep(tdir) + Localworld.ystep(Direction.clockwise(tdir)), tdir, 2);
				Localworld.fireextinguisher(tx + Localworld.xstep(tdir) + Localworld.xstep(Direction.anticlockwise(tdir)) , ty + Localworld.ystep(tdir) + Localworld.ystep(Direction.anticlockwise(tdir)), tdir, 2);
				Localworld.supressfire();
				if (!Localworld.checkforfire()) Localworld.clearfire();
				
				Sound.play("shoot");
			case ItemType.MATCHSTICK:
				tdir = Obj.entities[ent].dir;
				tx = Obj.entities[ent].xp;
				ty = Obj.entities[ent].yp;
				
				//Spreads out like a shotgun blast, putting out fires. 
				ScreenEffects.screenshake = 10;
				Localworld.flamethrower(tx + Localworld.xstep(tdir), ty + Localworld.ystep(tdir), tdir, 4);
				Localworld.flamethrower(tx + Localworld.xstep(tdir) + Localworld.xstep(Direction.clockwise(tdir)) , ty + Localworld.ystep(tdir) + Localworld.ystep(Direction.clockwise(tdir)), tdir, 2);
				Localworld.flamethrower(tx + Localworld.xstep(tdir) + Localworld.xstep(Direction.anticlockwise(tdir)) , ty + Localworld.ystep(tdir) + Localworld.ystep(Direction.anticlockwise(tdir)), tdir, 2);
				
				World.fire[tx + (ty * World.mapwidth)] = 0;
				
				Sound.play("shoot");
			case ItemType.SKATEBOARD:
				tdir = Obj.entities[ent].dir;
				tx = Obj.entities[ent].xp;
				ty = Obj.entities[ent].yp;
				
				//Dash forward until you hit something, then stop.
				var shotdistance:Int = 1;
				var hitwall = false;
				while (!hitwall) {
					temp = Game.checkforentity(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance));
					if (!Geom.inbox(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance), 0, 0, World.mapwidth, World.mapheight)) {
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
				
				Sound.play("shoot");
			case ItemType.SWORD:
				tdir = Obj.entities[ent].dir;
				tx = Obj.entities[ent].xp;
				ty = Obj.entities[ent].yp;
				
				//Dash forward, kill everything in your path
				var shotdistance:Int = 1;
				var hitwall = false;
				while (shotdistance < 100 && !hitwall) {
					temp = Game.checkforenemy(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance));
					if (!Geom.inbox(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance), 0, 0, World.mapwidth, World.mapheight)) {
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
						ScreenEffects.screenshake = 10;
					}
					shotdistance++;
				}
				shotdistance-= 2;
				if (shotdistance > 0) {
					var player:Int = Obj.getplayer();
					Obj.entities[player].xp = Obj.entities[player].xp + Localworld.xstep(tdir, shotdistance);
					Obj.entities[player].yp = Obj.entities[player].yp + Localworld.ystep(tdir, shotdistance);
				}
				
				Sound.play("shoot");
			case ItemType.LEAFBLOWER:
				tdir = Obj.entities[ent].dir;
				tx = Obj.entities[ent].xp;
				ty = Obj.entities[ent].yp;
				
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
						ScreenEffects.screenshake = 10;
					}
					shotdistance++;
				}
				
				//Ok, we have our entity!
				if (temp >= 0) {
					while (Game.checkforentity(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance)) == -1 && Geom.inbox(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance), 0, 0, World.mapwidth, World.mapheight)) {
						Localworld.highlightpoint(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance));
						Obj.entities[temp].xp = tx + Localworld.xstep(tdir, shotdistance);
						Obj.entities[temp].yp = ty + Localworld.ystep(tdir, shotdistance);
						shotdistance++;
					}
				}
				
				Sound.play("shoot");
			case ItemType.PISTOL:
				tdir = Obj.entities[ent].dir;
				tx = Obj.entities[ent].xp;
				ty = Obj.entities[ent].yp;
				
				//Kills a thing dead. Alerts all other guards in a room.
				var shotdistance:Int = 1;
				while (shotdistance < Math.max(World.mapheight+1, World.mapwidth+1)) {
					temp = Game.checkforenemy(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance));
					Localworld.highlightpoint(tx + Localworld.xstep(tdir, shotdistance), ty + Localworld.ystep(tdir, shotdistance));
					if (temp == -2) shotdistance = Std.int(Math.max(World.mapheight+1, World.mapwidth+1));
					if (temp >= 0) {
						shotdistance = 10000;
						Game.killenemy(temp);
						ScreenEffects.screenshake = 10;
					}
					shotdistance++;
				}
				Game.alertallenemies();
				
				Sound.play("shoot");
			case ItemType.ERRORBOMB:
				tx = Obj.entities[ent].xp;
				ty = Obj.entities[ent].yp;
				
				Glitch.glitchexplode(tx, ty, 6, false);
				Game.alertallenemies();
				
				Sound.play("shoot");
			case ItemType.BOMB:
				tx = Obj.entities[ent].xp;
				ty = Obj.entities[ent].yp;
				
				Localworld.explode(tx, ty, 3, false);
				Game.alertallenemies();
				
				Sound.play("shoot");
			case ItemType.FIRSTAIDKIT:
				Game.health++;
				Obj.entities[Obj.getplayer()].health = Game.health;
				Obj.entities[Obj.getplayer()].setmessage("HEALTH RESTORED!", "good");
				
				Modern.hpflash = Modern.flashtime;
				Sound.play("useitem");
			case ItemType.CARDBOARDBOX:
				Obj.entities[Obj.getplayer()].setmessage("Wearing Box!", "player");
				Game.cloaked += 50;
				
				//Fog out the world!
				Localworld.setroomfog(0);
				
				Game.dealertall();
				Sound.play("useitem");
			case ItemType.TIMESTOPPER:
				Obj.entities[Obj.getplayer()].setmessage("Time stopped!", "player");
				Game.timestop += 20;
				Sound.play("useitem");
			case ItemType.PORTABLEDOOR:
				ScreenEffects.screenshake = 10;
				var player:Int = Obj.getplayer();
				World.placetile(Obj.entities[player].xp + Localworld.xstep(Obj.entities[player].dir), Obj.entities[player].yp + Localworld.ystep(Obj.entities[player].dir), Localworld.DOOR);
				
				Sound.play("useitem");
			case ItemType.SIGNALJAMMER:
				for (i in 0 ... Obj.nentity) {
					if (Obj.entities[i].active) {
						if (Obj.entities[i].rule == "enemy") {
							if (Obj.entities[i].type == EnemyType.CAMERA || Obj.entities[i].type == EnemyType.SENTINAL ||
								  Obj.entities[i].type == EnemyType.LASERCAMERA || Obj.entities[i].type == EnemyType.LASERSENTINAL) {
								Game.stunenemy(i, Modern.LONGSTUNTIME);
							}
						}
					}
				}
				
				ScreenEffects.screenshake = 10;
				Obj.entities[Obj.getplayer()].setmessage("Jamming Camera Signals!", "player");
				Localworld.updatelighting();
				
				Sound.play("useitem");
			case ItemType.LIGHTBULB:
				AIDirector.darkroom = false;
				Localworld.setroomfog(1);
				for (j in 0 ... World.mapheight) {
					for (i in 0 ... World.mapwidth) {
						Localworld.highlightpoint(i, j);
					}
				}
				Game.showmessage("LIGHT SWITCHED ON!", "good", 120);
				
				Sound.play("useitem");
			case ItemType.DRILL:
				tdir = Obj.entities[Obj.getplayer()].dir;
				tx = Obj.entities[Obj.getplayer()].xp;
				ty = Obj.entities[Obj.getplayer()].yp;
			  Localworld.drill(tx + Localworld.xstep(tdir), ty + Localworld.ystep(tdir), tdir);
				
				Sound.play("useitem");
			case ItemType.HELIXWING:
				Modern.playeronstairs = true;
				
				Modern.endlevelanimationstate = 1;
				Modern.endlevelanimationaction = "endgame";
				
				Sound.play("nextfloor");
			case ItemType.BANANAPEEL:
				tdir = Direction.opposite(Obj.entities[Obj.getplayer()].dir);
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
				
				Sound.play("useitem");
		}
	}
	
	public static function interactwith(target:Int, source:Int):Void {
		//Source is interacting with the target! For example:
		if(Obj.entities[source].rule == "player"){
			if (Obj.entities[target].rule == "enemy") {	
				if (Obj.entities[target].state != Game.STUNNED) {
					Game.stunenemy(target, Modern.STANDARDSTUNTIME);
					Game.cloaked = 0;
					Game.timestop = 0;
				}
			}else if (Obj.entities[target].rule == "shopkeeper") {
				//It's a Shopkeeper - talk to them!
				//Menu.createmenu(Obj.entities[target].name);
				Modern.shopkeepcol = Obj.entities[target].col;
				Sound.play("talk");
				if(Obj.entities[target].name.toLowerCase() == "key"){
					PopUp.create(PopUpType.SHOPKEEPER_KEYS);
				}else if(Obj.entities[target].name.toLowerCase() == "sold out"){
					PopUp.create(PopUpType.SHOPKEEPER_SOLDOUT);
				}else{
					PopUp.create(PopUpType.SHOPKEEPER_ITEM, GameData.getitem(Obj.entities[target].name));
					Modern.currentshopkeeper = target;
				}
				Modern.updatekeygemrate();
				//Menu.textmode = 1;
			}else if (Obj.entities[target].rule == "treasure") {
				//It's treasure! Pick it up!
				Sound.play("collectgem");
				Obj.entities[Obj.getplayer()].setmessage("Found GEM", "cash", 40);
				Game.gems += Obj.entities[target].life;
				Modern.gemflash = Modern.flashtime;
				Obj.entities[target].active = false;
			}else if (Obj.entities[target].rule == "item") {
				//It's an item! Cool! Pick it up!
				Inventory.giveitem(Obj.entities[target].name);
				Obj.entities[target].active = false;
			}
		}
	}
	
	public static function interactwithblock(target:Int, x:Int, y:Int, source:Int):Void {
		//Source in interacting with a block type of TARGET. Eg. Doors, stairs.
		if (Obj.entities[source].rule == "enemy") {
			if (target == Localworld.DOOR) {
				World.placetile(x, y, Localworld.OPENDOOR);
				Sound.play("opendoor");
			}
		}
		
		if (Obj.entities[source].rule == "player") {
			if (target == Localworld.DOOR) {
				World.placetile(x, y, Localworld.OPENDOOR);
				Sound.play("opendoor");
			}else if (target == Localworld.LOCKEDDOOR) {
				if (Game.keys > 0) {
					World.placetile(x, y, Localworld.OPENDOOR);
					Game.keys--;
					Modern.keyflash = Modern.flashtime;
					AIDirector.onthisrun_keysused++;
					
					Sound.play("unlock");
				}else {
					if(!doorknockcheck){
						Obj.entities[Obj.getplayer()].setmessage("It's locked...", "player");	
						Obj.entities[Obj.getplayer()].actionset = true;
						Obj.entities[Obj.getplayer()].action = "nothing";
						
						Sound.play("lockeddoor");
						doorknockcheck = true;
					}
				}
			}else if (target == Localworld.KEY) {
				World.placetile(x, y, Localworld.FLOOR);
				Game.keys++;
				Modern.keyflash = Modern.flashtime;
				
				Obj.entities[Obj.getplayer()].setmessage("Found KEY", "key", 40);
				Sound.play("collectkey");
			}else if (target == Localworld.STAIRS) {
				Modern.usestairs();
			}
		}
	}
}