package gamecontrol;

import modernversion.AIDirector;
import modernversion.Modern;
import haxegon.*;
import states.EndingScreen;
import entities.Obj;
import entities.ItemType;
import entities.EnemyType;
import world.Placementclass;
import world.Generator;
import world.Localworld;
import world.World;
import util.Rand;
import util.Direction;
import util.Astar;
import visuals.Draw;
import visuals.ScreenEffects;

class Game {
	public static inline var TITLEMODE:Int = 0;
	public static inline var GAMEMODE:Int = 1;
	public static inline var ENDINGMODE:Int = 2;
	public static inline var FALLINGFROMTOWER:Int = 3;
	
	public static inline var NORMAL:Int = 0;
	public static inline var ALERTED:Int = 1;
	public static inline var STUNNED:Int = 2;
	public static inline var DOG_SEEKGUARD:Int = 3;
	public static inline var DOG_CHASEPLAYER:Int = 4;
	public static inline var CAMERA_SCANLEFT:Int = 3;
	public static inline var CAMERA_SCANRIGHT:Int = 4;
	
	public static var floor:Int = 1;
	
	public static var placement:Array<Placementclass> = new Array<Placementclass>();
	public static var placementindex:Map<String, Int> = new Map<String, Int>();
	public static var currentplacement:Int;
	
	public static var backgroundcolour:Int = 0x112945;
	public static var redwallshade:Float;
	public static var greenwallshade:Float;
	public static var bluewallshade:Float;
	
	public static var gamestate:Int;
	
	public static var turn:String;
	public static var signal:Int;
	public static var signalcheck:Bool;
	
	public static var tempstring:String;
	public static var tx:Int;
	public static var ty:Int;
	public static var tdir:Int;
	public static var tx1:Int; 
	public static var ty1:Int; 
	public static var tx2:Int; 
	public static var ty2:Int;
	public static var temp:Int;
	public static var attempts:Int;
	public static var playerdir:Int;
	
	public static var lastplayeraction:String;
	public static var possiblemove:Array<String> = new Array<String>();
	public static var possiblemovescore:Array<Int> = new Array<Int>();
	public static var numpossiblemoves:Int;
	
	public static var speedframe:Int = 0;
	
	public static var message:String = "";
	public static var messagedelay:Int = 0;
	public static var messagecol:String = "white";
	
	public static var health:Int = 3;
	public static var keys:Int = 3;
	public static var gems:Int = 0;
	
	public static var highlightcooldown:Int = 0;
	
	public static var alarm:Bool = false;
	public static var alarmsound:Int = 0;
	public static var alertlevel:Int = 0;
	public static var reinforcements:Array<String> = new Array<String>();
	public static var reinforcementspeed:Array<Int> = new Array<Int>();
	public static var reinforcestate:Int;
	
	public static var timestop:Int;
	public static var cloaked:Int;
	
	public static function init():Void {
		numpossiblemoves = 0;
		for (i in 0 ... 50){
			possiblemove.push("nothing");
			possiblemovescore.push(0);
		}
		
		reinforcements = [];
	  reinforcementspeed = [];
		reinforcestate = 0;
		
		createplacement("stairs");
		createplacement("collectable");
		createplacement("treasure");
	}
	
	public static function updatetimersandanimations() {
		if (messagedelay > 0) messagedelay--;
		
		if (Modern.endlevelanimationstate > 0) {	
			Modern.endlevelanimationdelay++;
			if(Modern.endlevelanimationdelay >= Modern.endlevelanimationspeed){
				Modern.endlevelanimationstate+=2;
				Modern.endlevelanimationdelay = 0;
				if (Modern.endlevelanimationstate > Draw.screentileheight) {
					if(Modern.endlevelanimationaction == "next"){
						Modern.usestairs_afteranimation();
					}else if (Modern.endlevelanimationaction == "endgame") {
					  startending();
					}else if (Modern.endlevelanimationaction == "leftmap") {
						leavetower();
					}else if(Modern.endlevelanimationaction == "restart"){
						Modern.restart();
					}else {
					  throw("Dunno what to do with " + Modern.endlevelanimationaction);	
					}
				}
			}
		}else if (Modern.endlevelanimationstate < 0) {
			Modern.endlevelanimationdelay++;
			if(Modern.endlevelanimationdelay >= Modern.endlevelanimationspeed){
				Modern.endlevelanimationstate-=2;
				Modern.endlevelanimationdelay = 0;
				if (Modern.endlevelanimationstate < -Draw.screentileheight) {
				  Modern.endlevelanimationstate = 0;
					Modern.endlevelanimationdelay = 0;
				}
			}
		}
		
		if (highlightcooldown > 0) {
			highlightcooldown--;
			if (highlightcooldown == 0) {
				Localworld.clearhighlight();
			}
		}
	}
	
	public static function startending() {
		Sound.play("helicopter");
		EndingScreen.init();
	  
		Modern.endlevelanimationstate = -1;
		
		for (i in 0 ... Inventory.inventoryslots) {
		  if (Inventory.inventory[i] == ItemType.HELIXWING) {
			  Game.gems += 10;
			}
		}
		
		Game.changestate(Game.ENDINGMODE);
	}
	
	public static function leavetower() {
		Sound.play("fall");
	  EndingScreen.endingstate	= "start";
		EndingScreen.endingstatepara = 0;
		EndingScreen.endingstatedelay = 0;
		
		Modern.endlevelanimationstate = -1;
		
		Game.changestate(Game.FALLINGFROMTOWER);
	}
	
	public static function createplacement(t:String):Void {
		placement.push(new Placementclass(t));
		placementindex.set(t, placement.length - 1);
	}
	
	/** Add a "thing" to the placement type. E.g. type = "enemy", thing = "guard" */
	public static function addplacement(type:String, thing:String, x:Int, y:Int, odds:Int):Void {
		placement[placementindex.get(type)].add(x, y, thing, odds);
	}
	
	public static function changeplacement(type:String):Void {
		currentplacement = placementindex.get(type);
	}
	
	public static function place(rule:String, type:String = "", inorder:Bool = false):Void {
		if (type.toLowerCase() != "nothing") {
			//Do not place "nothing" - "nothing" is only there as a hack to make rare items rarer
			
			if (inorder) {
				if (placement[currentplacement].length > 0) {
				  placement[currentplacement].selection = 0;
					temp = 0;
				}
			}else {
				placement[currentplacement].pick();
				temp = placement[currentplacement].selection;
			}
			if(temp > -1){
				tx = placement[currentplacement].x(temp);
				ty = placement[currentplacement].y(temp);
				
				if (rule == "entrance") {
				  if (temp == 0) {
					  //Type A is entrance, change them to normal doors
						AIDirector.entrance = "A";
					}else if (temp == 1) {
						//Type B is the entrance, change them to normal doors
						AIDirector.entrance = "B";
					}
				}
				
				placement[currentplacement].remove();
			}else {
				tx = -1;
				while (tx == -1 || World.at(tx, ty) != Localworld.FLOOR) {
					tx = Rand.pint(0, World.mapwidth);	ty = Rand.pint(0, World.mapheight);
				}
			}
			switch(rule) {
				case "entrance":
					World.placetile(tx, ty, Localworld.ENTRANCE);
				case "exit", "stairs":
					World.placetile(tx, ty, Localworld.STAIRS);
				case "key":
					World.placetile(tx, ty, Localworld.KEY);
				default:
					Obj.createentity(tx, ty, rule, type);
			}
		}
	}
	
	public static function restartgame():Void {
		//Starts the entire game over.
		//Player
		Obj.nentity = 0;
		keys = 0;
		health = 3;
		gems = 0;
		floor = 0;
		
		cloaked = 0;
		timestop = 0;
		playerdir = Direction.RIGHT;
	}
	
	public static function clearroom():Void {
		//Reset variables for changing rooms (e.g. clears old entities).
		Obj.nentity = 0;
		
		messagedelay = 0;
		alarm = false;
		reinforcestate = 0;
	}
	
	/** True when there are no entities within 2 spaces of the entrance */
	public static function entranceclear():Bool {
		return true;
	}
	
	/** How many enemies are currently on the map? */
	public static function numberofenemies():Int {
		var temp:Int = 0;
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active) {
				if (Obj.entities[i].rule == "enemy") {
					temp++;
				}
			}
		}
		return temp;
	}
	
	public static function createentrance(rule:String = "player", type:String = ""):Void {
		//Place the player somewhere random on the map.
		tx = -1;
		while (tx == -1 || World.at(tx, ty) != Localworld.FLOOR) {
			tx = Rand.pint(0, World.mapwidth);	ty = Rand.pint(0, World.mapheight);
		}
		World.placetile(tx, ty, Localworld.ENTRANCE);
	}
	
	public static function placeatentrance(rule:String, type:String = ""):Void {
		//Place the player somewhere random on the map.
		tx = -1; ty = -1;
		for (j in 0 ... World.mapheight) {
			for (i in 0 ... World.mapwidth) {
			  if (World.at(i, j) == Localworld.ENTRANCE) {
					tx = i; ty = j;
				}
			}
		}
		if (tx == -1) {
			//createentrance(rule, type);
			if(Buildconfig.showtraces) trace("ERROR! Can't find entrance...");
		}else {
			attempts = 5;
			while (attempts >= 0 && World.collide(tx + Localworld.xstep(playerdir), ty + Localworld.ystep(playerdir))) {
				//Need to change direction to something safe!
				playerdir = Direction.clockwise(playerdir);
				attempts--;
			}
		  Obj.createentity(tx, ty, rule, type);
		}
	}
	
	public static function placeatrandom_outside(rule:String, type:String = ""):Void {
		//Like above, but looking for different blocks
		tx = -1;
		while (tx == -1 || World.at(tx, ty) != Localworld.OUTSIDE_GROUND) {
			tx = Rand.pint(0, World.mapwidth);	ty = Rand.pint(0, World.mapheight);
		}
		Obj.createentity(tx, ty, rule, type);
	}
	
	public static function pplaceatrandom_outside(rule:String, type:String = ""):Void {
		//Like above, but looking for different blocks
		tx = -1;
		while (tx == -1 || World.at(tx, ty) != Localworld.OUTSIDE_GROUND) {
			tx = Rand.pint(0, World.mapwidth);	ty = Rand.pint(0, World.mapheight);
		}
		Obj.createentity(tx, ty, rule, type);
	}
	
	public static function placeatrandom(rule:String, type:String = ""):Void {
		tx = Rand.pint(0, Astar.oln - 1);
		tx1 = Astar.fcost[tx];
		ty1 = Astar.gcost[tx];
		
		Obj.createentity(tx1, ty1, rule, type);
	}
	
	public static function item_placeatrandom(item:Int):Void {
		//Find an empty floor tile for the player in the stupiest way possible
		tx = -1;
		while (tx == -1 || World.at(tx, ty) != Localworld.FLOOR) {
			tx = Rand.pint(0, World.mapwidth);	ty = Rand.pint(0, World.mapheight);
		}
		World.placetile(tx, ty, item);
	}
	
	public static function item_placeatrandom_awayfromplayer(item:Int):Void {
		tx1 = Std.int(Obj.entities[Obj.getplayer()].xp);
		ty1 = Std.int(Obj.entities[Obj.getplayer()].yp);
		tx = -1;
		attempts = 100;
		while (attempts > 0 && (tx == -1 || World.at(tx, ty) != Localworld.FLOOR || Math.abs(tx1 - tx) < 6 || Math.abs(ty1 - ty) < 6)) {
			tx = Rand.pint(0, World.mapwidth);	ty = Rand.pint(0, World.mapheight);
			attempts--;
		}
		
		if (attempts > 0) World.placetile(tx, ty, item);
	}
	
	public static function changestate(state:Int):Void {
		gamestate = state;
	}
	
	public static function sortpossiblemoves():Void {
		//Sort possible moves by highest scoring to lowest
		var tempint:Int;
		var tempstring:String;
		
		for (j in 0 ... numpossiblemoves) {
			for (i in j ... numpossiblemoves) {
				if (possiblemovescore[i] < possiblemovescore[j]) {
					tempint = possiblemovescore[i];
					possiblemovescore[i] = possiblemovescore[j];
					possiblemovescore[j] = tempint;
					
					tempstring = possiblemove[i];
					possiblemove[i] = possiblemove[j];
					possiblemove[j] = tempstring;
				}
			}
		}
	}
	
	public static function removemovesbelownothing():Void {
		//Remove moves below "nothing". Depends on one of the moves actually being "nothing".
		if (numpossiblemoves > 0) {
			if (possiblemove[numpossiblemoves - 1] != "nothing") {
				numpossiblemoves--;
				removemovesbelownothing();
			}
		}
	}
	
	/** Convert Help.DIR to Game's format "move_dir" */
	public static function movestring(t:Int):String {
		if (t == Direction.UP) return "move_up";
		if (t == Direction.DOWN) return "move_down";
		if (t == Direction.LEFT) return "move_left";
		if (t == Direction.RIGHT) return "move_right";
		return "nothing";
	}
	
	
	public static function reversemovestring(t:String):Int {
		if (t == "move_up") return Direction.UP;
		if (t == "move_down") return Direction.DOWN;
		if (t == "move_left") return Direction.LEFT;
		if (t == "move_right") return Direction.RIGHT;
		return Direction.NONE;
	}
	
	public static function resetplayermove(i:Int, t:String):Void{
		Obj.entities[i].resetactions();
		lastplayeraction = t;
		Obj.entities[i].addaction(lastplayeraction);
		
		for (i in 0 ... Obj.nentity) {
			Obj.entities[i].alerted_thisframe = false;
			Obj.entities[i].insights_thisframe = false;
		}
	}

	public static function startmove(t:String):Void {
		if (t == "wait") Modern.waitflash = Modern.flashtime;
		resetplayermove(Obj.getplayer(), t);
		interactwithdir(Obj.getplayer(), t);
		turn = "figureoutmove";
		resetenemymoves();
	}
	
	public static function blockedfrommoving(e:Int):Bool {
	  //Returns true if a step forward blocks this entity from moving. Used to cancel
		//out of player turn before doing any logic.
		tdir = Obj.entities[e].dir;
		tx = Std.int(Obj.entities[e].xp + Localworld.xstep(tdir));
		ty = Std.int(Obj.entities[e].yp + Localworld.ystep(tdir));
		
		if (World.at(tx, ty) == Localworld.WALL) {
		  return true;	
		}else if (World.at(tx, ty) == Localworld.LOCKEDDOOR && Game.keys <= 0) {
			if (!Use.doorknockcheck) {
				e = Obj.getplayer();	
				if (e > -1) {
					Obj.entities[e].setmessage("It's locked...", "player");	
					
					Sound.play("lockeddoor");
				}
				Use.doorknockcheck = true;
			}
		  return true;
		}
		
		return false;
	}
	
	public static function interactwithdir(ent:Int, movestring:String):Void {
		//Check if there's a thing to interact with in direction t. If so, figure it out here!
		tdir = reversemovestring(movestring);
		tx = Std.int(Obj.entities[ent].xp + Localworld.xstep(tdir));
		ty = Std.int(Obj.entities[ent].yp + Localworld.ystep(tdir));
		
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active) {
				if (Obj.entities[i].collidable) {
					if (Std.int(Obj.entities[i].xp) == tx && Std.int(Obj.entities[i].yp) == ty) {
						Use.interactwith(i, ent);
					}
				}
			}
		}
		
		Use.interactwithblock(World.at(tx, ty), tx, ty, ent);
	}
	
	public static function getinteractblock(t:Int):Int {
		//Check if there's a thing to interact with in t's direction. Return that block!
		tdir = Obj.entities[t].dir;
		tx = Std.int(Obj.entities[t].xp + Localworld.xstep(tdir));
		ty = Std.int(Obj.entities[t].yp + Localworld.ystep(tdir));
		
		return World.at(tx, ty);
	}
	
	public static function killenemy(target:Int):Void {
		Sound.play("destroy");
		Obj.templates[Obj.entindex.get(Obj.entities[target].rule)].kill(target);
	}
	
	public static function stunenemy(target:Int, time:Int):Void {
		Sound.play("stun");
		Obj.templates[Obj.entindex.get(Obj.entities[target].rule)].stun(target, time);
	}
	
	public static function allenemiesdead():Bool {
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active) {
				if (Obj.entities[i].rule == "enemy") {
					return false;
				}
			}
		}
		return true;
	}
	
	public static function hurtplayer(fromdirection:Int):Void {
		if (!Modern.playeronstairs && !Modern.playerjustteleported) {
			Sound.play("damaged");
			
			var player:Int = Obj.getplayer();
			if (player > -1) {
				if(fromdirection != Direction.NONE){
					Obj.entities[player].startshake(Localworld.xstep(Obj.entities[player].dir), Localworld.ystep(Obj.entities[player].dir));
				}
				
				health--;
				Obj.entities[player].health--;
				ScreenEffects.screenshake = 10;
				
				Modern.hpflash = Modern.flashtime;
			}
		}
	}
	
	public static function checkifplayerdead():Void {
		if (Obj.getplayer() > -1) {
			if (Obj.entities[Obj.getplayer()].health <= 0) {
				//Obj.entities[Obj.getplayer()].active = false;
				showmessage("GAME OVER - PRESS R TO RESTART", "red", -1);
			}
		}
	}
	
	public static function doenemyattack():Void {
		//If the player's ended a turn beside an enemy, take damage...
		tx = Std.int(Obj.entities[Obj.getplayer()].xp);
		ty = Std.int(Obj.entities[Obj.getplayer()].yp);
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active) {
				if (Obj.entities[i].rule == "enemy") {
					if (Obj.entities[i].state == 1) {
						if (Obj.entities[i].canattack) {
							if (adjacent(tx, ty, Std.int(Obj.entities[i].xp), Std.int(Obj.entities[i].yp))) {
								hurtplayer(Obj.entities[i].dir);
							}
						}
					}
				}
			}
		}
		
		checkifplayerdead();
	}
	
	public static function clearchain():Void {
		for (i in 0 ... Obj.nentity) {
			Obj.entities[i].inchain = false;
		}
	}
	
	public static function resetenemymove(i:Int):Void {
		if (Obj.entities[i].rule == "enemy") {
			Obj.entities[i].action = "nothing";
			Obj.entities[i].actionset = false;
			Obj.entities[i].userevertdir = false;
			
			doenemyai(i);
		}
	}
	
	public static function resetenemymoves():Void {
		Game.speedframe = Game.speedframe + 1;
		if (Game.speedframe == 12) Game.speedframe = 0;
		
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active) {
				resetenemymove(i);
			}
		}
	}
	
	public static function updatestatuseffects():Void {
		if (Game.timestop > 0) {
			Game.timestop--;
			if (Game.timestop == 8) {
				if (Obj.getplayer() > -1) {
					Obj.entities[Obj.getplayer()].setmessage("TIME STOP WEARING OFF...", "player");
				}
			}else if (Game.timestop == 0) {
				Obj.entities[Obj.getplayer()].messagedelay = 0;
			}
		}
		
		
		if (Game.cloaked > 0) {
			Game.cloaked--;
			if (Game.cloaked == 8) {
				if (Obj.getplayer() > -1) {
					Obj.entities[Obj.getplayer()].setmessage("BOX FALLING APART...", "player");
				}
			}else if (Game.cloaked == 0) {
				Obj.entities[Obj.getplayer()].messagedelay = 0;
			}
		}
	}
	
	public static function updatereinforcements():Void {
		//No reinforecements on this floor
		if (AIDirector.reinforcements.length == 0) return;
		
		var player:Int = Obj.getplayer();
		
		Game.reinforcestate++;
		if (Game.alarm) Game.reinforcestate++;
		
		if (player > -1) {
			//Supress reinforcements if you stand on the stairs
			if (World.at(Obj.entities[player].xp, Obj.entities[player].yp) == Localworld.ENTRANCE) {
				Game.reinforcestate--;
				if (Game.alarm) Game.reinforcestate--;
			}
		}
		if (AIDirector.reinforcementdelay > 0) {
			//Have an initial delay before reinforements start
			if (Game.reinforcestate >= AIDirector.reinforcementdelay || Game.alarm) {
				AIDirector.reinforcementdelay = 0; //When we regen the floor, this gets "repaired"
				Game.reinforcestate = 0;
				Game.nextreinforcement();
			}
		}else{
			if (Game.reinforcestate >= Game.reinforcementspeed[0]) {
				Localworld.worldblock[Localworld.ENTRANCE].charcode_lit = "-".charCodeAt(0);
				Localworld.worldblock[Localworld.ENTRANCE].charcode_fog = "-".charCodeAt(0);
				if (Game.entranceclear()) {
					if (Game.reinforcements[0] == EnemyType.GUARD) {
						Game.showmessage("PATROL BOT HAS ENTERED THE ROOM", "white", 120);
					}else if (Game.reinforcements[0] == EnemyType.LASERGUARD) {
						Game.showmessage("LASER PATROL BOT HAS ENTERED THE ROOM", "white", 120);
					}else if (Game.reinforcements[0] == EnemyType.ROBOT) {
						Game.showmessage("ELITE BOT HAS ENTERED THE ROOM", "white", 120);
					}else{
						Game.showmessage(Game.reinforcements[0].toUpperCase() + " HAS ENTERED THE ROOM", "white", 120);
					}
					Game.placeatentrance("enemy", Game.reinforcements[0]);
					Game.nextreinforcement();
					Game.reinforcestate = 0;
				}
			}else {
				if (Game.reinforcementspeed[0] - Game.reinforcestate < 10) {
					Localworld.worldblock[Localworld.ENTRANCE].charcode_lit = Std.string(Game.reinforcementspeed[0] - Game.reinforcestate).charCodeAt(0);
					Localworld.worldblock[Localworld.ENTRANCE].charcode_fog = Std.string(Game.reinforcementspeed[0] - Game.reinforcestate).charCodeAt(0);
				}else {
					Localworld.worldblock[Localworld.ENTRANCE].charcode_lit = "-".charCodeAt(0);
					Localworld.worldblock[Localworld.ENTRANCE].charcode_fog = "-".charCodeAt(0);
				}
			}
		}
	}
	
	public static function findpathtopoint(t:Int, xoff:Int, yoff:Int, x:Int, y:Int):Void {
		Astar.setmapcollision();
		
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active) {
				if (i != t) {
					Astar.setcollidepoint(getintendedx(i), getintendedy(i));
				}
			}
		}
		
		Astar.pathfind(x, y, getcurrentx(t) + xoff, getcurrenty(t) + yoff);
	}
	
	public static function findpathbetween(a:Int, b:Int):Void {
		var starttime:Int = flash.Lib.getTimer();
		Astar.setmapcollision();
		
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active && Obj.entities[i].collidable) {
				if (i != a && i != b) {
					Astar.setcollidepoint(getintendedx(i), getintendedy(i));	
				}
			}
		}
		
		Astar.pathfind(getcurrentx(b), getcurrenty(b), getcurrentx(a), getcurrenty(a));
		//trace("A* pathfind: took " + (flash.Lib.getTimer() - starttime) + "ms");
	}
	
	public static function adjacenttowall(i:Int):Bool {
		if (World.collide(Obj.entities[i].xp - 1, Obj.entities[i].yp)) return true;
		if (World.collide(Obj.entities[i].xp + 1, Obj.entities[i].yp)) return true;
		if (World.collide(Obj.entities[i].xp, Obj.entities[i].yp - 1)) return true;
		if (World.collide(Obj.entities[i].xp, Obj.entities[i].yp + 1)) return true;
		return false;
	}
	
	public static function surroundedbywalls(i:Int):Bool {
		var numwalls:Int = 0;
		if (World.collide(Obj.entities[i].xp - 1, Obj.entities[i].yp)) numwalls++;
		if (World.collide(Obj.entities[i].xp + 1, Obj.entities[i].yp)) numwalls++;
		if (World.collide(Obj.entities[i].xp, Obj.entities[i].yp - 1)) numwalls++;
		if (World.collide(Obj.entities[i].xp, Obj.entities[i].yp + 1)) numwalls++;
		if (numwalls == 3) return true;
		return false;
	}
	
	public static function adjacenttocorner(i:Int):Bool {
		var numwalls:Int = 0;
		if (World.collide(Obj.entities[i].xp - 1, Obj.entities[i].yp)) numwalls++;
		if (World.collide(Obj.entities[i].xp + 1, Obj.entities[i].yp)) numwalls++;
		if (World.collide(Obj.entities[i].xp, Obj.entities[i].yp - 1)) numwalls++;
		if (World.collide(Obj.entities[i].xp, Obj.entities[i].yp + 1)) numwalls++;
		if (numwalls >= 2) return true;
		return false;
	}
	
	public static function attachtowall(i:Int):Void {
		if(!adjacenttowall(i)){
			Obj.entities[i].dir = Direction.random();
			while (!World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) {
				Obj.entities[i].xp += Localworld.xstep(Obj.entities[i].dir);
				Obj.entities[i].yp += Localworld.ystep(Obj.entities[i].dir);
			}
			Obj.entities[i].dir = Direction.opposite(Obj.entities[i].dir);
		}
	}
	
	public static function faceawayfromwall(i:Int):Void {
		if (surroundedbywalls(i)) {
			Obj.entities[i].dir = Direction.random();
			if (World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Direction.clockwise(Obj.entities[i].dir);
			if (World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Direction.clockwise(Obj.entities[i].dir);
			if (World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Direction.clockwise(Obj.entities[i].dir);
			if (World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Direction.clockwise(Obj.entities[i].dir);
		}else {
			Obj.entities[i].dir = Direction.random();
			if (!World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Direction.clockwise(Obj.entities[i].dir);
			if (!World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Direction.clockwise(Obj.entities[i].dir);
			if (!World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Direction.clockwise(Obj.entities[i].dir);
			if (!World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Direction.clockwise(Obj.entities[i].dir);
			Obj.entities[i].dir = Direction.opposite(Obj.entities[i].dir);
		}		
	}
	
	public static function attachtocorner(i:Int, attempts:Int = 4):Void {
		if(!adjacenttocorner(i)){
			attachtowall(i);
			
			if (!World.collide(Obj.entities[i].xp + Localworld.xstep(Direction.clockwise(Obj.entities[i].dir)), Obj.entities[i].yp + Localworld.ystep(Direction.clockwise(Obj.entities[i].dir))) &&
					!World.collide(Obj.entities[i].xp + Localworld.xstep(Direction.anticlockwise(Obj.entities[i].dir)), Obj.entities[i].yp + Localworld.ystep(Direction.anticlockwise(Obj.entities[i].dir)))) {
				//Out in the open!
				if (Rand.pbool()) {
					//Clockwise move
					Obj.entities[i].dir = Direction.clockwise(Obj.entities[i].dir);
					while (!World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) {
						Obj.entities[i].xp += Localworld.xstep(Obj.entities[i].dir);
						Obj.entities[i].yp += Localworld.ystep(Obj.entities[i].dir);
					}
					Obj.entities[i].dir = Direction.anticlockwise(Obj.entities[i].dir);
				}else {
					//AntiClockwise move
					Obj.entities[i].dir = Direction.anticlockwise(Obj.entities[i].dir);
					while (!World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) {
						Obj.entities[i].xp += Localworld.xstep(Obj.entities[i].dir);
						Obj.entities[i].yp += Localworld.ystep(Obj.entities[i].dir);
					}
					Obj.entities[i].dir = Direction.clockwise(Obj.entities[i].dir);
				}
			}
		}else {
			attempts = 0;
		}
		
		if (attempts > 0) attachtocorner(i, attempts - 1);
	}
	
	public static function adjacent(x1:Int, y1:Int, x2:Int, y2:Int):Bool {
		if (x1 == x2 && y1 == y2) return true;
		if (x1 == x2-1 && y1 == y2) return true;
		if (x1 == x2+1 && y1 == y2) return true;
		if (x1 == x2 && y1 == y2+1) return true;
		if (x1 == x2 && y1 == y2-1) return true;
		return false;
	}
	
	/** Can an entity of speed t move this turn? */
	public static function turnspeed(t):Bool {
		if (t == 0) return true;
		if (t == 1) if (speedframe % 2 == 0) return true;
		if (t == 2) if (speedframe % 3 == 0) return true;
		if (t == 3) if (speedframe % 4 == 0) return true;
		return false;
	}
	
	/** Setup Game's tx, ty and tdir variables for entity t */
	public static function settempobjvariables(t:Int):Void {
		tx = Obj.entities[t].xp;
		ty = Obj.entities[t].yp;
		tdir = Obj.entities[t].dir;
	}
	
	/** In this function, enemies decide what they're going to do this turn. */
	public static function doenemyai(i:Int):Void {
		var player:Int;
		var nextmove:Int;
		player = Obj.getplayer();
		
		Obj.entities[i].resetactions();
		if (Obj.entities[i].rule == "enemy") {
			//So, AI works like this: there is a big picture thing that the entity is
			//trying to do, which breaks down to smaller picture next move stuff.
			//For example, an entity might want to get in line with the player and shoot.
			if (turnspeed(Obj.entities[i].speed)) {
				switch(Obj.entities[i].ai) {
					case "random":
						var randdir:Int = Direction.random();
						Obj.entities[i].addaction(movestring(randdir));
						Obj.entities[i].addaction(movestring(Direction.clockwise(randdir)));
						Obj.entities[i].addaction(movestring(Direction.clockwise(randdir, 2)));
						Obj.entities[i].addaction(movestring(Direction.clockwise(randdir, 3)));
					case "clockwisefollowwall":
						settempobjvariables(i);
						Obj.entities[i].userevertdir = true; Obj.entities[i].revertdir = Obj.entities[i].dir;
						Obj.entities[i].dir = Direction.opposite(Obj.entities[i].dir);
						if (World.collide(tx + Localworld.xstep(Obj.entities[i].dir), ty + Localworld.ystep(Obj.entities[i].dir))) {
							//Cool, continue hugging wall!
						  Obj.entities[i].dir = Direction.opposite(Obj.entities[i].dir);
							Obj.entities[i].dir = Direction.anticlockwise(Obj.entities[i].dir);
							if (World.collide(tx + Localworld.xstep(Obj.entities[i].dir), ty + Localworld.ystep(Obj.entities[i].dir))) {
								Obj.entities[i].dir = Direction.anticlockwise(Obj.entities[i].dir);
								Obj.entities[i].addaction(movestring(Obj.entities[i].dir));
								Obj.entities[i].addaction("wait");
								Obj.entities[i].dir = Direction.anticlockwise(Obj.entities[i].dir);
							}else {
								Obj.entities[i].addaction(movestring(Obj.entities[i].dir));
								Obj.entities[i].dir = Direction.clockwise(Obj.entities[i].dir);
							}
						}else {
							//Shit, no longer hugging the wall. Move towards where the wall was and rotate!
							Obj.entities[i].addaction(movestring(Obj.entities[i].dir));
							Obj.entities[i].addaction("wait");
							Obj.entities[i].dir = Direction.clockwise(Obj.entities[i].dir);
						}
						
						Obj.entities[i].addaction("reverse_ai");
					case "anticlockwisefollowwall":
						settempobjvariables(i);
						Obj.entities[i].userevertdir = true; Obj.entities[i].revertdir = Obj.entities[i].dir;
						Obj.entities[i].dir = Direction.opposite(Obj.entities[i].dir);
						if (World.collide(tx + Localworld.xstep(Obj.entities[i].dir), ty + Localworld.ystep(Obj.entities[i].dir))) {
							//Cool, continue hugging wall!
						  Obj.entities[i].dir = Direction.opposite(Obj.entities[i].dir);
							Obj.entities[i].dir = Direction.clockwise(Obj.entities[i].dir);
							if (World.collide(tx + Localworld.xstep(Obj.entities[i].dir), ty + Localworld.ystep(Obj.entities[i].dir))) {
								Obj.entities[i].dir = Direction.clockwise(Obj.entities[i].dir);
								Obj.entities[i].addaction(movestring(Obj.entities[i].dir));
							  Obj.entities[i].addaction("wait");
								Obj.entities[i].dir = Direction.clockwise(Obj.entities[i].dir);
							}else {
								Obj.entities[i].addaction(movestring(Obj.entities[i].dir));
								Obj.entities[i].dir = Direction.anticlockwise(Obj.entities[i].dir);
							}
						}else {
							//Shit, no longer hugging the wall. Move towards where the wall was and rotate!
							Obj.entities[i].addaction(movestring(Obj.entities[i].dir));
							Obj.entities[i].addaction("wait");
							Obj.entities[i].dir = Direction.anticlockwise(Obj.entities[i].dir);
						}
						
						Obj.entities[i].addaction("reverse_ai");
					case "clockwiserandommarch":
						//Keep moving in the same direction: if there's a wall ahead, 
						//change direction at random
						settempobjvariables(i);
						if (World.collide(tx + Localworld.xstep(Obj.entities[i].dir), ty + Localworld.ystep(Obj.entities[i].dir))) {
							Obj.entities[i].dir = Direction.clockwise(Obj.entities[i].dir);
							if (World.collide(tx + Localworld.xstep(Obj.entities[i].dir), ty + Localworld.ystep(Obj.entities[i].dir))) {
								Obj.entities[i].dir = Direction.anticlockwise(Obj.entities[i].dir);
								Obj.entities[i].dir = Direction.anticlockwise(Obj.entities[i].dir);
								if (World.collide(tx + Localworld.xstep(Obj.entities[i].dir), ty + Localworld.ystep(Obj.entities[i].dir))) {
									Obj.entities[i].dir = Direction.anticlockwise(Obj.entities[i].dir);
								}
							}
						}
						
						Obj.entities[i].addaction(movestring(Obj.entities[i].dir));
						Obj.entities[i].addaction(movestring(Direction.clockwise(Obj.entities[i].dir)));
						Obj.entities[i].addaction(movestring(Direction.anticlockwise(Obj.entities[i].dir)));
						Obj.entities[i].addaction(movestring(Direction.opposite(Obj.entities[i].dir)));
					case "anticlockwiserandommarch":
						//Keep moving in the same direction: if there's a wall ahead, 
						//change direction at random
						settempobjvariables(i);
						if (World.collide(tx + Localworld.xstep(Obj.entities[i].dir), ty + Localworld.ystep(Obj.entities[i].dir))) {
							Obj.entities[i].dir = Direction.anticlockwise(Obj.entities[i].dir);
							if (World.collide(tx + Localworld.xstep(Obj.entities[i].dir), ty + Localworld.ystep(Obj.entities[i].dir))) {
								Obj.entities[i].dir = Direction.clockwise(Obj.entities[i].dir);
								Obj.entities[i].dir = Direction.clockwise(Obj.entities[i].dir);
								if (World.collide(tx + Localworld.xstep(Obj.entities[i].dir), ty + Localworld.ystep(Obj.entities[i].dir))) {
									Obj.entities[i].dir = Direction.clockwise(Obj.entities[i].dir);
								}
							}
						}
						
						Obj.entities[i].addaction(movestring(Obj.entities[i].dir));
						Obj.entities[i].addaction(movestring(Direction.anticlockwise(Obj.entities[i].dir)));
						Obj.entities[i].addaction(movestring(Direction.clockwise(Obj.entities[i].dir)));
						Obj.entities[i].addaction(movestring(Direction.opposite(Obj.entities[i].dir)));
					case "pathfind":
						//Pathfind to enemy - only accept useful paths
						//If the enemy is going to be adjacent to where the player is headed, DON'T MOVE
						if (adjacent(getdestinationx(player, Obj.entities[player].possibleactions[0]), getdestinationy(player, Obj.entities[player].possibleactions[0]), getcurrentx(i), getcurrenty(i))) {
							Obj.entities[i].addaction("wait");
						}else{
							findpathbetween(i, player);
							nextmove = Astar.getnextmove();
							
							//nextmove = Localworld.heatmapmove(Obj.entities[i].xp, Obj.entities[i].yp);
							if (nextmove != Direction.NONE) {
								Obj.entities[i].addaction(movestring(nextmove));
								//Check for doors!
								tx = Obj.entities[i].xp + Localworld.xstep(nextmove);
								ty = Obj.entities[i].yp + Localworld.ystep(nextmove);
								Use.interactwithblock(World.at(tx, ty), tx, ty, i);
							}
						}
					case "pathfind_rush":
						//Pathfind to enemy - only accept useful paths
						//If the enemy is going to be adjacent to where the player is headed, DON'T MOVE
						
						findpathbetween(i, player);
							
						nextmove = Astar.getnextmove();
						
						//nextmove = Localworld.heatmapmove(Obj.entities[i].xp, Obj.entities[i].yp);
						if (nextmove != Direction.NONE) {
							Obj.entities[i].addaction(movestring(nextmove));
							//Check for doors!
							tx = Obj.entities[i].xp + Localworld.xstep(nextmove);
							ty = Obj.entities[i].yp + Localworld.ystep(nextmove);
							Use.interactwithblock(World.at(tx, ty), tx, ty, i);
							Obj.entities[i].ai = "pathfind_rush2";
						}
					case "pathfind_rush2":
						//Wait a turn
						nextmove = Direction.NONE;
						Obj.entities[i].ai = "pathfind_rush3";
					case "pathfind_rush3":
						//Continue going the same way until the next step is a wall
						settempobjvariables(i);
						if (World.collide(tx + Localworld.xstep(tdir), ty + Localworld.ystep(tdir))) {
							Obj.entities[i].addaction("wait");
							Obj.entities[i].ai = "pathfind_rush";
						}else {
							Obj.entities[i].addaction(movestring(Obj.entities[i].dir));
							Obj.entities[i].addaction(movestring(Direction.clockwise(Obj.entities[i].dir)));
							Obj.entities[i].addaction(movestring(Direction.opposite(Obj.entities[i].dir)));
							Obj.entities[i].addaction(movestring(Direction.anticlockwise(Obj.entities[i].dir)));
							
							//Check for doors!
							tx = Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir);
							ty = Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir);
							Use.interactwithblock(World.at(tx, ty), tx, ty, i);
						}
					case "pathfind_totarget":
						//This is a special dog thing
						//Pathfind to given target entity - only accept useful paths
						//If the enemy is going to be adjacent to where the player is headed, DON'T MOVE
						findpathbetween(i, Obj.entities[i].target);
							
						nextmove = Astar.getnextmove();
						if (nextmove != Direction.NONE) {
							Obj.entities[i].addaction(movestring(nextmove));
							
							tx = Obj.entities[i].xp + Localworld.xstep(nextmove);
							ty = Obj.entities[i].yp + Localworld.ystep(nextmove);
							Use.interactwithblock(World.at(tx, ty), tx, ty, i);
						}else {
							//Huh - if we can't get to the next guard, then let's just go for the player!
							Obj.entities[i].state = Game.DOG_CHASEPLAYER;
							Obj.entities[i].ai = "pathfind";
						}
				}
			}else {
				Obj.entities[i].addaction("wait");
			}
		}
	}
	
	public static function getintendedx(i:Int):Int {
		//Return context sensitive x position: depending on 
		//where in the movement decision process they are
		if (Obj.entities[i].actionset) {
			return getdestinationx(i);
		}
		return getcurrentx(i);
	}
	
	public static function getintendedy(i:Int):Int {
		//Return context sensitive y position: depending on 
		//where in the movement decision process they are
		if (Obj.entities[i].actionset) {
			return getdestinationy(i);
		}
		return getcurrenty(i);
	}
	
	public static function getcurrentx(i:Int):Int {
		return Std.int(Obj.entities[i].xp);
	}
	
	public static function getcurrenty(i:Int):Int {
		return Std.int(Obj.entities[i].yp);
	}
	
	public static function getdestinationx(i:Int, movestring:String=""):Int {
		tx = Std.int(Obj.entities[i].xp);
		
		if (movestring != "") {
			if (movestring == "move_left") tx--;
			if (movestring == "move_right") tx++;
		}else{			
			if (Obj.entities[i].action == "move_left") tx--;
			if (Obj.entities[i].action == "move_right") tx++;
		}
		
		return tx;
	}
	
	public static function getdestinationy(i:Int, movestring:String=""):Int {
		ty = Std.int(Obj.entities[i].yp);
		
		if (movestring != "") {
			if (movestring == "move_up") ty--;
			if (movestring == "move_down") ty++;
		}else{			
			if (Obj.entities[i].action == "move_up") ty--;
			if (Obj.entities[i].action == "move_down") ty++;
		}
		
		return ty;
	}
	
	/** Return true if a and b are opposite direction strings */
	public static function oppositedirstring(a:String, b:String):Bool {
		if (a == "up" && b == "down") return true;
		if (a == "down" && b == "up") return true;
		if (a == "left" && b == "right") return true;
		if (a == "right" && b == "left") return true;
		return false;
	}
	
	/** Return the opposite direction move string */
	public static function oppositedirmovestring(a:String):String {
		if (a == "move_up") return "move_down";
		if (a == "move_down") return "move_up";
		if (a == "move_left") return "move_right";
		if (a == "move_right") return "move_left";
		return "nothing";
	}
	
	public static function couldtry(xoff:Int, yoff:Int, i:Int):Bool {
		if (!World.collide(xoff, yoff)) {
			for (j in 0 ... Obj.nentity) {
				if (i != j) {
					if (Obj.entities[j].active) {
						tx2 = getdestinationx(j); ty2 = getdestinationy(j);
						if (xoff == tx2 && yoff == ty2) return true;
					}
				}
			}
		}else {
			return true;
		}
		
		return false;
	}
	
	public static function couldtryagain(i:Int):Bool {
		//An entity can try to move again if they've got an empty square adjacent.
		var mleft:Int = 0, mright:Int = 0, mup:Int = 0, mdown:Int = 0;
		tx1 = getcurrentx(i); ty1 = getcurrenty(i);
		
		mup = couldtry(tx1, ty1 - 1, i)?1:0;
		mdown = couldtry(tx1, ty1 + 1, i)?1:0;
		mleft = couldtry(tx1 - 1, ty1, i)?1:0;
		mright = couldtry(tx1 + 1, ty1, i)?1:0;
		
		if (mleft + mright + mup + mdown == 4) return false;
		return true;
	}
	
	public static function figureoutmove(i:Int):Void {
		//Pick a move at random from this entities available list
		//trace("Figuring out entity ", Std.string(i), ", " + Obj.entities[i].type);
		if (Obj.entities[i].possibleactions.length == 0) {
			Obj.entities[i].action = "nothing";
			Obj.entities[i].actionset = true;
			//trace("  Out of moves, do nothing.");
		}else {
			if (!Obj.entities[i].actionset) {
				//tx = Std.int(Math.random() * Obj.entities[i].numpossibleactions);
				tx = 0;
				tempstring = Obj.entities[i].possibleactions[tx];
				if (S.getroot(tempstring, "_") == "move") {
					Obj.entities[i].action = tempstring;
					//trace("  Attempting ", Obj.entities[i].action);
				}else if (tempstring == "wait") {
					Obj.entities[i].action = "wait";
					Obj.entities[i].actionset = true;
				}else if (tempstring == "reverse_ai") {
					if (Obj.entities[i].ai == "anticlockwisefollowwall") {
						Obj.entities[i].ai = "clockwisefollowwall";
					}else if (Obj.entities[i].ai == "clockwisefollowwall") {
						Obj.entities[i].ai = "anticlockwisefollowwall";
					}
					Obj.entities[i].stringpara = Obj.entities[i].ai;
					Obj.entities[i].action = "nothing";
					Obj.entities[i].actionset = true;
				}else {
					//Do something other that move: for the moment, just do nothing
					Obj.entities[i].action = "nothing";
					Obj.entities[i].actionset = true;
					//trace("  Doing nothing.");
				}
			}
		}
		
		//Ok, now try to do that move
		if (S.getroot(Obj.entities[i].action, "_") == "move") {
			tx1= getdestinationx(i); ty1 = getdestinationy(i);
			//First check for simple wall collisions
			if (World.collide(tx1, ty1)) {
				//Collision: remove this option from this entity
				Obj.entities[i].removeaction(Obj.entities[i].action);
				Obj.entities[i].action = "nothing";
				//trace("  Collided with wall, try again.");
				return;
			}else {
				//Ok, next check for complex enemy collisions: either
				//A set enemy or a chain enemy collides on it's destination square, and is a solid block
				//An unset enemy collides on it's current sqaure, but is not solid yet
				for (j in 0 ... Obj.nentity) {
					if(Obj.entities[j].active && Obj.entities[j].collidable){
						if (i != j) {
							if (Obj.entities[j].actionset || Obj.entities[j].inchain) {
								tx2 = getdestinationx(j); ty2 = getdestinationy(j);	
								if (tx1 == tx2 && ty1 == ty2) {
									Obj.entities[i].removeaction(Obj.entities[i].action);
									Obj.entities[i].action = "nothing";
									//trace("  Collided with set entity or entity in chain, try again. (entity " + Std.string(j) + ")");
									return;
								}
								if (Obj.entities[j].inchain) {
									//Special check: If an entity is in a chain and moving
									//the opposite direction from you, then ALSO check thier current square
									if (oppositedirstring(S.getbranch(Obj.entities[i].action, "_"),
																				S.getbranch(Obj.entities[j].action, "_"))) {
										tx2 = getcurrentx(j); ty2 = getcurrenty(j);
										if (tx1 == tx2 && ty1 == ty2) {
											Obj.entities[i].removeaction(Obj.entities[i].action);
											Obj.entities[i].action = "nothing";
											//trace("  Collided with entity in chain going back the same way, try again. (entity " + Std.string(j) + ")");
											return;
										}
									}
								}
							}else {
								tx2 = getcurrentx(j); ty2 = getcurrenty(j);									
								if (tx1 == tx2 && ty1 == ty2) {
									//Ok, we've collided with an entity that's still deciding.
									Obj.entities[i].inchain = true;
									//trace("  Collided with unset entity " + Std.string(j) + ", passing signal:");
									while (!Obj.entities[j].actionset) figureoutmove(j);
									return;
								}
							}
						}
					}
				}
				
				//We're still here! Then then move is ok
				Obj.entities[i].actionset = true;
				//trace("  Move is ok!");
			}
		}
	}
	
	public static function allactionsset():Bool {
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active) {
				if (!Obj.entities[i].actionset) return false;
			}
		}
		return true;
	}
	
	/** Return index of an enemy at this square, -2 for a wall, -1 for empty space */
	public static function checkforenemy(x:Int, y:Int):Int {
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active && Obj.entities[i].collidable) {
				if (Obj.entities[i].xp == x && Obj.entities[i].yp == y) {
					if (Obj.entities[i].rule == "enemy") {
						return i;
					}
				}
			}
		}
		
		if (World.collide(x, y)) return -2;
		return -1;
	}
	
	/** Return index of any entity at this square, -2 for a wall, -1 for empty space */
	public static function checkforentity(x:Int, y:Int):Int {
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active && Obj.entities[i].collidable) {
				if (Obj.entities[i].xp == x && Obj.entities[i].yp == y) {
					return i;
				}
			}
		}
		
		if (World.collide(x, y)) return -2;
		return -1;
	}
	
	
	/** Alert all the enemies! */
	public static function alertallenemies():Void {
		Sound.play("spotted");
		
		//Trying out no alarms - alerts only affect enemys in the room right now
		alarm = true;
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active) {
				if (Obj.entities[i].rule == "enemy") {
					if (Obj.entities[i].state != STUNNED) {
						if (Obj.entities[i].alertbysound) {
							Localworld.alertedtoplayer(i);
						}
					}
				}
			}
		}
	}
	
	/** Dealert all the enemies! */
	public static function dealertall():Void {
		alarm = false;
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active) {
				if (Obj.entities[i].rule == "enemy") {
					if (Obj.entities[i].state == ALERTED) {
						Obj.templates[Obj.entindex.get(Obj.entities[i].rule)].dealert(i);
					}
				}
			}
		}
	}
	
	public static function showmessage(_message:String, col:String, time:Int):Void {
		message = _message;
		messagedelay = time;
		messagecol = col; 
	}
	
	public static function setupreinforcements(enemy:String, time:Int):Void {
		reinforcements.push(enemy);
		reinforcementspeed.push(time);
	}
	
	public static function nextreinforcement():Void {
		if(reinforcements.length > 0){
			reinforcements.splice(0, 1);
			reinforcementspeed.splice(0, 1);
		}
		
		if(reinforcements.length == 0){
			//Stock up on reinforcements!
			for (i in 0 ... AIDirector.reinforcements.length) {
				if (S.isinstring(AIDirector.reinforcements[i], "_")) {
					var options:Array<String> = AIDirector.reinforcements[i].split("_");
					Rand.pshuffle(options);
					setupreinforcements(options[0], AIDirector.reinforcementtime[i]);
				}else{
					setupreinforcements(AIDirector.reinforcements[i], AIDirector.reinforcementtime[i]);
				}
			}
		}
	}
	
	public static function cameraframe(t:Int):Int {
		//Given angle t, return 0 - 4, for up down left right.
		//For doing camera animations.
		t = Std.int((t + 360) % 360);
		
		if (t > 22 && t <= 67) return 1;
		if (t > 67 && t <= 112) return 2;
		if (t > 112 && t <= 157) return 3;
		if (t > 157 && t <= 202) return 16;
		if (t > 202 && t <= 247) return 17;
		if (t > 247 && t <= 292) return 18;
		if (t > 292 && t <= 337) return 19;
		return 0;
	}
}