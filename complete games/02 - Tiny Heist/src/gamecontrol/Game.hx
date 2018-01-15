package gamecontrol;

import modernversion.AIDirector;
import modernversion.Enemy;
import modernversion.Item;
import modernversion.Modern;
import modernversion.Weapon;
import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;
import gamecontrol.misc.*;
import haxegon.*;
import terrylib.*;
import config.*;

class Game {
	public static inline var TITLEMODE:Int = 0;
	public static inline var CLICKTOSTART:Int = 1;
	public static inline var FOCUSMODE:Int = 2;
	public static inline var GAMEMODE:Int = 3;
	public static inline var EDITORMODE:Int = 4;
	public static inline var EXPIREDMODE:Int = 5;
	public static inline var ENDINGMODE:Int = 6;
	public static inline var FALLINGFROMTOWER:Int = 7;
	public static inline var SPLASHSCREEN:Int = 8;
	
	public static inline var NORMAL:Int = 0;
	public static inline var ALERTED:Int = 1;
	public static inline var STUNNED:Int = 2;
	public static inline var DOG_SEEKGUARD:Int = 3;
	public static inline var DOG_CHASEPLAYER:Int = 4;
	public static inline var CAMERA_SCANLEFT:Int = 3;
	public static inline var CAMERA_SCANRIGHT:Int = 4;
	
	public static function init():Void {
		numpossiblemoves = 0;
		for (i in 0 ... 50){
			possiblemove.push("nothing");
			possiblemovescore.push(0);
			
			towergadgets.push("");
			towergadgets_rare.push("");
			toweritems.push("");
			toweritems_rare.push("");
			
			preshuffle.push(0);
		}
		
		for (i in 0 ... 30) {
			floorgadgets.push(new Numlist());
			flooritems.push(new Numlist());
			floortreasure.push(0);
		}
		
		numtowergadgets = 0;
		numtowergadgets_rare = 0;
		numtoweritems = 0;
		numtoweritems_rare = 0;
		
		reinforcements = [];
	  reinforcementspeed = [];
		reinforcestate = 0;
		
		createplacement("stairs");
		createplacement("collectable");
		createplacement("treasure");
		
		Inventory.setequippedweapon("none", false);
		
		Menu.init();
		Inventory.init();
	}
	
	public static function startending() {
		Sound.play("helicopter");
	  Logic.endingstate	= "start";
		Logic.endingstatepara = 0;
		Logic.endingstatedelay = 0;
		
		Modern.endlevelanimationstate = -1;
		
		for (i in 0 ... Modern.inventoryslots) {
		  if (Modern.inventory[i] == Item.HELIXWING) {
			  Game.cash += 10;
			}
		}
		
		Game.changestate(Game.ENDINGMODE);
	}
	
	public static function leavetower() {
		Sound.play("fall");
	  Logic.endingstate	= "start";
		Logic.endingstatepara = 0;
		Logic.endingstatedelay = 0;
		
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
	
	public static function teststart():Void {
		//For testing: use this function to start in a particular place.
		clearroom();
		Openworld.inside = true;
		floor = 1;
		//generatetowerblock("intro");
		changeroom("outside");
		/*
		 * pretty solid first five rooms
		generatetowerblock("intro");
		changeroom("inside");
		*/
		/*
		 * seems to be incomplete version of old tower
		generatetowerblock("normal");
		changeroom("inside");
		*/
		/*
		 * start of some good ideas
		generatetowerblock("robot");
		changeroom("inside");
		*/
		
		useteststart = true;
	}
	public static var useteststart:Bool = false;
	
	public static function restartgame():Void {
		//Starts the entire game over.
		//Player
		Obj.nentity = 0;
		keys = 0;
		health = 3;
		cash = 0;
		floor = 0;
		
		icecube = 0;
		cloaked = 0;
		timestop = 0;
		playerdir = Help.RIGHT;
		
		//Inventory
		Inventory.numitems = 0;
		//Inventory.giveitem("world map");
		//Inventory.giveitem("tazer", 4);
		//Inventory.giveitem("pistol", 25);
		//Inventory.giveitem("tranquilizer", 25);
		//Inventory.giveitem("teleporter", 500);
		//Inventory.giveitem("gps scanner", 50);
		//Inventory.giveitem("lockdown", 50);
		//Inventory.giveitem("portable door", 50);
		//Inventory.giveitem("time stopper", 50);
		//Inventory.giveitem(Weapon.SWORD, 10);
		//Inventory.giveitem("leaf blower", 10);
		//Inventory.giveitem("skateboard", 12);
		//Inventory.giveitem("signal jammer");
		//Inventory.giveitem("cardboard box", 50);
		//Inventory.setequippedgadget("teleporter", false);
		Inventory.setequippedgadget("none", false);
		
		//World
		//Openworld.generate(Rand.string(10));
		//Openworld.gotocamp();
		//changeroom("outside");		
		//Localworld.updatelighting();
		
		//if (useteststart) teststart();
	}
	
	public static function clearroom():Void {
		//Reset variables for changing rooms (e.g. clears old entities).
		World.mapchanged = true;
		Obj.nentity = 0;
		
		messagedelay = 0;
		alarm = false;
		reinforcestate = 0;
	}
	
	public static function changeroom(t:String):Void {
		switch(t) {
			case "outside":
				updateoutsideplayerposition();
				
			  Openworld.inside = false;
				Rand.setseed(Openworld.getroomseed(Openworld.worldx, Openworld.worldy));
				Generator.generate(Openworld.roomat(Openworld.worldx, Openworld.worldy));
				Localworld.setroomfog(1);
				
				switch(Openworld.roomat(Openworld.worldx, Openworld.worldy)) {
					case "outside_river":
						var numfiremen:Int = Rand.pint(3, 5);
						for (i in 0 ... numfiremen) {
							Generator.getrandompoint_awayfromedge();
							Obj.createentity(Localworld.tx, Localworld.ty, "enemy", "fireman");
						}
					case "outside_camp":
						Obj.createentity(24, 7, "npc", "terry");
						Obj.createentity(11, 6, "npc", "pawnshop");
				}
				
				Localworld.updatelighting();
				turn = "playermove";
				
			case "inside":
				//This is where all level generation decisions are made now!
				Rand.setseed(Openworld.getroomseed(Openworld.worldx, Openworld.worldy) + floor);
				Openworld.inside = true;
				clearroom();
				
				if (Game.floor == Game.towerheight) {
					Game.showmessage("BASEMENT", "flashing", 120);
				}else{
					Game.showmessage("FLOOR " + Std.string(Game.floor) + " OF " +Std.string(Game.towerheight), "white", 120);
				}
				
				if (floor == 1) {
					currentblueprint = firstfloor;
				}else if (floor == towerheight) {
					currentblueprint = lastfloor;
				}else {
					currentblueprint = blueprint[floor - 1];
				}
				Generator.generate("indoors"); 
				
				//Place the entrance and exit
				changeplacement("stairs");
				place("entrance");
				placeatentrance("player");
				
				//Place items and gadgets
				changeplacement("collectable");
				for (i in 0 ... floorgadgets[floor - 1].length) {
					place("item", floorgadgets[floor - 1].list[i]);
				}
				for (i in 0 ... flooritems[floor - 1].length) {
					place("item", flooritems[floor - 1].list[i]);
				}
				//Place treasure
				//TO DO: divvy up floortreasure[floor-1];
				placetreasure();
				
				//Place enemies - not on topfloors
				if (floor != towerheight) {
					enemylevel = towerstartlevel + Std.int(floor / ((towerheight / (towerendlevel - towerstartlevel + 1)) + 1));
					getenemywave(enemylevel, towertype);
					createwave(floorenemies.list[Rand.pint(0, floorenemies.length - 1)]);
				}
					
				if(floor != towerheight){
					changeplacement("stairs");
					place("exit");
				}
				
				Localworld.setroomfog(AIDirector.roomlit?1:0);
				Localworld.updatelighting();
		}
		
		
		Localworld.updatelighting();
		turn = "playermove";
	}
	
	public static function createwave(t:String):Void {
		switch(t) {
			case "2guards":
				for (i in 0 ... 2) placeatrandom("enemy", "guard");
			case "2guards1camera":
				for (i in 0 ... 2) placeatrandom("enemy", "guard");
				for (i in 0 ... 1) placeatrandom("enemy", "camera");
			case "2guardscameras":
				for (i in 0 ... 2) placeatrandom("enemy", "guard");
				for (i in 0 ... 2) placeatrandom("enemy", "camera");
			case "3guards":
				for(i in 0 ... 3) placeatrandom("enemy", "guard");
			case "3guardsdogs":
				for(i in 0 ... 3) placeatrandom("enemy", "guard");
				for(i in 0 ... 2) placeatrandom("enemy", "dog");
			case "3guardscameras":
				for (i in 0 ... 3) placeatrandom("enemy", "guard");
				for (i in 0 ... 3) placeatrandom("enemy", "camera");
			case "4guards":
				for(i in 0 ... 4) placeatrandom("enemy", "guard");
			case "4guardsdogs":
				for(i in 0 ... 4) placeatrandom("enemy", "guard");
				for(i in 0 ... 2) placeatrandom("enemy", "dog");
			case "4guardscameras":
				for (i in 0 ... 4) placeatrandom("enemy", "guard");
				for (i in 0 ... 3) placeatrandom("enemy", "camera");
			case "5guards":
				for(i in 0 ... 5) placeatrandom("enemy", "guard");
			case "6guards":
				for(i in 0 ... 6) placeatrandom("enemy", "guard");
			case "7guards":
				for(i in 0 ... 7) placeatrandom("enemy", "guard");
			case "8guards":
				for (i in 0 ... 8) placeatrandom("enemy", "guard");
			case "1rook":
				placeatrandom("enemy", "rook");
			case "2rooks":
				for (i in 0 ... 2) placeatrandom("enemy", "rook");
			case "3rooks":
				for (i in 0 ... 3) placeatrandom("enemy", "rook");
			case "1rookcameras":
				placeatrandom("enemy", "rook");
				for (i in 0 ... 2) placeatrandom("enemy", "lasercamera");
			case "2rookscameras":
				for (i in 0 ... 2) placeatrandom("enemy", "rook");
				for (i in 0 ... 3) placeatrandom("enemy", "lasercamera");
			case "3rookscameras":
				for (i in 0 ... 3) placeatrandom("enemy", "rook");
				for (i in 0 ... 3) placeatrandom("enemy", "lasercamera");
				
		}
	}
	
	public static function addwave(t:String):Void {
		floorenemies.add(t);
	}
	
	public static function getenemywave(lvl:Int, leveltype:String = "normal"):Void {
		//Make a list of possible enemy waves for this part of the game
		//Depends on both enemy level and roomtype
		if (lvl < 1) lvl = 1;
		if (lvl > 5) lvl = 5;
		
		floorenemies.clear();
		
		switch(leveltype) {
			case "robot":
				switch(lvl) {
					case 1:
						addwave("1rook");
						addwave("2rooks");
					case 2:
						addwave("1rookcameras");
						addwave("2rooks");
					case 3:
						addwave("1rookcameras");
						addwave("2rooks");
						addwave("2rookscameras");
					case 4:
						addwave("2rooks");
						addwave("2rookscameras");
						addwave("3rooks");
					case 5:
						addwave("2rookscameras");
						addwave("3rooks");
						addwave("3rookscameras");
					default:
						addwave("3rooks");
				}
			case "intro":
				//Because all levels here fit into one screen, number of enemies is very important.
				switch(lvl) {
					case 1:
						addwave("2guards");
						addwave("2guards1camera");
					case 2:
						addwave("2guards");
						addwave("3guards");
						addwave("2guardscameras");
					case 3:
						addwave("3guards");
						addwave("4guards");
						addwave("2guardscameras");
					case 4:
						addwave("4guards");
						addwave("5guards");
						addwave("3guardscameras");
						addwave("3guardsdogs");
					case 5:
						addwave("3guardscameras");
						addwave("4guardscameras");
						addwave("4guardsdogs");
						addwave("5guards");
						addwave("6guards");
						addwave("7guards");
				}
			default:
				switch(lvl) {
					case 1:
						addwave("2guards");
						addwave("3guards");
						addwave("4guards");
						addwave("5guards");
					case 2:
						addwave("3guards");
						addwave("4guards");
						addwave("5guards");
					case 3:
						addwave("4guards");
						addwave("5guards");
					case 4:
						addwave("4guards");
						addwave("5guards");
						addwave("6guards");
					case 5:
						addwave("5guards");
						addwave("6guards");
						addwave("7guards");
				}
		}
		
		
	}
	
	public static function placetreasure():Void {
		temp = 0;
		for (i in 0 ... Generator.treasuredrops) {
			preshuffle[i] = 0;
		}
		while (floortreasure[floor - 1] > 0) {
			tx = Rand.pint(0, 3) * 25;
			if (floortreasure[floor - 1] > tx) {
				preshuffle[temp] += tx;
				floortreasure[floor - 1] -= tx;
			}else {
				preshuffle[temp] += floortreasure[floor - 1];
				floortreasure[floor - 1] = 0;
			}
			temp = (temp + 1) % Generator.treasuredrops;
		}
		
		changeplacement("collectable");
		for (i in 0 ... Generator.treasuredrops) {
			if (preshuffle[i] > 0) place("treasure", Std.string(preshuffle[i]));
		}
	}
	
	/** Keep track of player position outside. Mostly cleaning up generation function. */
	public static function updateoutsideplayerposition():Void {
		temp = Obj.getplayer();
		if (temp == -1) {
			Obj.createentity(24, 9, "player");
			
			temp = Obj.getplayer();
			tx = Obj.entities[temp].xp;
			ty = Obj.entities[temp].yp;
			playerdir = Obj.entities[temp].dir;
		}else {
			tx = Obj.entities[temp].xp;
			ty = Obj.entities[temp].yp;
			playerdir = Obj.entities[temp].dir;
			
			Obj.nentity = 0;
			Obj.createentity(tx, ty, "player");
		}
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
				playerdir = Help.clockwise(playerdir);
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
	
	public static function fadelogic():Void {
		if (Draw.fademode == Draw.FADED_IN && Obj.activedoor != "null") {
			Draw.fademode = Draw.FADE_OUT; Draw.fadeaction = "changeroom";
			Obj.activedoordest = Obj.activedoor;
		}
		
		if (Draw.fademode == Draw.FADED_OUT && !Script.running) {
			if (Draw.fadeaction == "changeroom") {
				World.change(Obj.activedoordest);
				Draw.fademode = Draw.FADE_IN; Draw.fadeaction = "nothing";
			}else if (Draw.fadeaction == "title") {
				changestate(TITLEMODE);
				Draw.fademode = Draw.FADE_IN; Draw.fadeaction = "nothing";
			}else{
				Script.load(Draw.fadeaction);
				Draw.fademode = Draw.FADE_IN; Draw.fadeaction = "nothing";
			}
		}
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
		if (t == Help.UP) return "move_up";
		if (t == Help.DOWN) return "move_down";
		if (t == Help.LEFT) return "move_left";
		if (t == Help.RIGHT) return "move_right";
		return "nothing";
	}
	
	
	public static function reversemovestring(t:String):Int {
		if (t == "move_up") return Help.UP;
		if (t == "move_down") return Help.DOWN;
		if (t == "move_left") return Help.LEFT;
		if (t == "move_right") return Help.RIGHT;
		return Help.NODIRECTION;
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
				if(fromdirection != Help.NODIRECTION){
					Obj.entities[player].startshake(Localworld.xstep(Obj.entities[player].dir), Localworld.ystep(Obj.entities[player].dir));
				}
				
				health--;
				Obj.entities[player].health--;
				Draw.screenshake = 10;
				Draw.flashlight = 5;
				
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
		if (Game.icecube > 0) {
			Game.icecube--;
			if (Game.icecube == 8) {
				if (Obj.getplayer() > -1) {
					Obj.entities[Obj.getplayer()].setmessage("ICECUBE WEARING OFF...", "player");
				}
			}else if (Game.icecube == 0) {
				Obj.entities[Obj.getplayer()].messagedelay = 0;
			}
		}
		
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
		/*
		if (Game.allenemiesdead() && Game.floor > 1) {
			if (Game.reinforcementspeed[Game.numreinforcements - 1] != 25) {
				//CHANGE THIS LATER TO DEPEND ON FLOOR DIFFICULTY
				for (i in 0 ... 10) {
					Game.reinforce("guard", 10);
				}
				Game.reinforce("guard", 25);
			}
		}*/
		//No reinforecements on this floor
		if (AIDirector.reinforcements.length == 0) return;
		
		var player:Int = Obj.getplayer();
		
		if (Openworld.inside) {
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
						if (Game.reinforcements[0] == Enemy.GUARD) {
							Game.showmessage("PATROL BOT HAS ENTERED THE ROOM", "white", 120);
						}else if (Game.reinforcements[0] == Enemy.LASERGUARD) {
							Game.showmessage("LASER PATROL BOT HAS ENTERED THE ROOM", "white", 120);
						}else if (Game.reinforcements[0] == Enemy.ROBOT) {
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
			Obj.entities[i].dir = Help.randomdirection();
			while (!World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) {
				Obj.entities[i].xp += Localworld.xstep(Obj.entities[i].dir);
				Obj.entities[i].yp += Localworld.ystep(Obj.entities[i].dir);
			}
			Obj.entities[i].dir = Help.oppositedirection(Obj.entities[i].dir);
		}
	}
	
	public static function faceawayfromwall(i:Int):Void {
		if (surroundedbywalls(i)) {
			Obj.entities[i].dir = Help.randomdirection(); 
			if (World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Help.clockwise(Obj.entities[i].dir);
			if (World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Help.clockwise(Obj.entities[i].dir);
			if (World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Help.clockwise(Obj.entities[i].dir);
			if (World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Help.clockwise(Obj.entities[i].dir);
		}else {
			Obj.entities[i].dir = Help.randomdirection();
			if (!World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Help.clockwise(Obj.entities[i].dir);
			if (!World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Help.clockwise(Obj.entities[i].dir);
			if (!World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Help.clockwise(Obj.entities[i].dir);
			if (!World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Help.clockwise(Obj.entities[i].dir);
			Obj.entities[i].dir = Help.oppositedirection(Obj.entities[i].dir);
		}		
	}
	
	public static function attachtocorner(i:Int, attempts:Int = 4):Void {
		if(!adjacenttocorner(i)){
			attachtowall(i);
			
			if (!World.collide(Obj.entities[i].xp + Localworld.xstep(Help.clockwise(Obj.entities[i].dir)), Obj.entities[i].yp + Localworld.ystep(Help.clockwise(Obj.entities[i].dir))) &&
					!World.collide(Obj.entities[i].xp + Localworld.xstep(Help.anticlockwise(Obj.entities[i].dir)), Obj.entities[i].yp + Localworld.ystep(Help.anticlockwise(Obj.entities[i].dir)))) {
				//Out in the open!
				if (Rand.pbool()) {
					//Clockwise move
					Obj.entities[i].dir = Help.clockwise(Obj.entities[i].dir);
					while (!World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) {
						Obj.entities[i].xp += Localworld.xstep(Obj.entities[i].dir);
						Obj.entities[i].yp += Localworld.ystep(Obj.entities[i].dir);
					}
					Obj.entities[i].dir = Help.anticlockwise(Obj.entities[i].dir);
				}else {
					//AntiClockwise move
					Obj.entities[i].dir = Help.anticlockwise(Obj.entities[i].dir);
					while (!World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) {
						Obj.entities[i].xp += Localworld.xstep(Obj.entities[i].dir);
						Obj.entities[i].yp += Localworld.ystep(Obj.entities[i].dir);
					}
					Obj.entities[i].dir = Help.clockwise(Obj.entities[i].dir);
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
						var randdir:Int = Help.randomdirection();
						Obj.entities[i].addaction(movestring(randdir));
						Obj.entities[i].addaction(movestring(Help.clockwise(randdir)));
						Obj.entities[i].addaction(movestring(Help.clockwise(randdir, 2)));
						Obj.entities[i].addaction(movestring(Help.clockwise(randdir, 3)));
					case "clockwisefollowwall":
						settempobjvariables(i);
						Obj.entities[i].userevertdir = true; Obj.entities[i].revertdir = Obj.entities[i].dir;
						Obj.entities[i].dir = Help.oppositedirection(Obj.entities[i].dir);
						if (World.collide(tx + Localworld.xstep(Obj.entities[i].dir), ty + Localworld.ystep(Obj.entities[i].dir))) {
							//Cool, continue hugging wall!
						  Obj.entities[i].dir = Help.oppositedirection(Obj.entities[i].dir);
							Obj.entities[i].dir = Help.anticlockwise(Obj.entities[i].dir);
							if (World.collide(tx + Localworld.xstep(Obj.entities[i].dir), ty + Localworld.ystep(Obj.entities[i].dir))) {
								Obj.entities[i].dir = Help.anticlockwise(Obj.entities[i].dir);
								Obj.entities[i].addaction(movestring(Obj.entities[i].dir));
								Obj.entities[i].addaction("wait");
								Obj.entities[i].dir = Help.anticlockwise(Obj.entities[i].dir);
							}else {
								Obj.entities[i].addaction(movestring(Obj.entities[i].dir));
								Obj.entities[i].dir = Help.clockwise(Obj.entities[i].dir);
							}
						}else {
							//Shit, no longer hugging the wall. Move towards where the wall was and rotate!
							Obj.entities[i].addaction(movestring(Obj.entities[i].dir));
							Obj.entities[i].addaction("wait");
							Obj.entities[i].dir = Help.clockwise(Obj.entities[i].dir);
						}
						
						Obj.entities[i].addaction("reverse_ai");
					case "anticlockwisefollowwall":
						settempobjvariables(i);
						Obj.entities[i].userevertdir = true; Obj.entities[i].revertdir = Obj.entities[i].dir;
						Obj.entities[i].dir = Help.oppositedirection(Obj.entities[i].dir);
						if (World.collide(tx + Localworld.xstep(Obj.entities[i].dir), ty + Localworld.ystep(Obj.entities[i].dir))) {
							//Cool, continue hugging wall!
						  Obj.entities[i].dir = Help.oppositedirection(Obj.entities[i].dir);
							Obj.entities[i].dir = Help.clockwise(Obj.entities[i].dir);
							if (World.collide(tx + Localworld.xstep(Obj.entities[i].dir), ty + Localworld.ystep(Obj.entities[i].dir))) {
								Obj.entities[i].dir = Help.clockwise(Obj.entities[i].dir);
								Obj.entities[i].addaction(movestring(Obj.entities[i].dir));
							  Obj.entities[i].addaction("wait");
								Obj.entities[i].dir = Help.clockwise(Obj.entities[i].dir);
							}else {
								Obj.entities[i].addaction(movestring(Obj.entities[i].dir));
								Obj.entities[i].dir = Help.anticlockwise(Obj.entities[i].dir);
							}
						}else {
							//Shit, no longer hugging the wall. Move towards where the wall was and rotate!
							Obj.entities[i].addaction(movestring(Obj.entities[i].dir));
							Obj.entities[i].addaction("wait");
							Obj.entities[i].dir = Help.anticlockwise(Obj.entities[i].dir);
						}
						
						Obj.entities[i].addaction("reverse_ai");
					case "clockwiserandommarch":
						//Keep moving in the same direction: if there's a wall ahead, 
						//change direction at random
						settempobjvariables(i);
						if (World.collide(tx + Localworld.xstep(Obj.entities[i].dir), ty + Localworld.ystep(Obj.entities[i].dir))) {
							Obj.entities[i].dir = Help.clockwise(Obj.entities[i].dir);
							if (World.collide(tx + Localworld.xstep(Obj.entities[i].dir), ty + Localworld.ystep(Obj.entities[i].dir))) {
								Obj.entities[i].dir = Help.anticlockwise(Obj.entities[i].dir);
								Obj.entities[i].dir = Help.anticlockwise(Obj.entities[i].dir);
								if (World.collide(tx + Localworld.xstep(Obj.entities[i].dir), ty + Localworld.ystep(Obj.entities[i].dir))) {
									Obj.entities[i].dir = Help.anticlockwise(Obj.entities[i].dir);
								}
							}
						}
						
						Obj.entities[i].addaction(movestring(Obj.entities[i].dir));
						Obj.entities[i].addaction(movestring(Help.clockwise(Obj.entities[i].dir)));
						Obj.entities[i].addaction(movestring(Help.anticlockwise(Obj.entities[i].dir)));
						Obj.entities[i].addaction(movestring(Help.oppositedirection(Obj.entities[i].dir)));
					case "anticlockwiserandommarch":
						//Keep moving in the same direction: if there's a wall ahead, 
						//change direction at random
						settempobjvariables(i);
						if (World.collide(tx + Localworld.xstep(Obj.entities[i].dir), ty + Localworld.ystep(Obj.entities[i].dir))) {
							Obj.entities[i].dir = Help.anticlockwise(Obj.entities[i].dir);
							if (World.collide(tx + Localworld.xstep(Obj.entities[i].dir), ty + Localworld.ystep(Obj.entities[i].dir))) {
								Obj.entities[i].dir = Help.clockwise(Obj.entities[i].dir);
								Obj.entities[i].dir = Help.clockwise(Obj.entities[i].dir);
								if (World.collide(tx + Localworld.xstep(Obj.entities[i].dir), ty + Localworld.ystep(Obj.entities[i].dir))) {
									Obj.entities[i].dir = Help.clockwise(Obj.entities[i].dir);
								}
							}
						}
						
						Obj.entities[i].addaction(movestring(Obj.entities[i].dir));
						Obj.entities[i].addaction(movestring(Help.anticlockwise(Obj.entities[i].dir)));
						Obj.entities[i].addaction(movestring(Help.clockwise(Obj.entities[i].dir)));
						Obj.entities[i].addaction(movestring(Help.oppositedirection(Obj.entities[i].dir)));
					case "pathfind":
						//Pathfind to enemy - only accept useful paths
						//If the enemy is going to be adjacent to where the player is headed, DON'T MOVE
						if (adjacent(getdestinationx(player, Obj.entities[player].possibleactions[0]), getdestinationy(player, Obj.entities[player].possibleactions[0]), getcurrentx(i), getcurrenty(i))) {
							Obj.entities[i].addaction("wait");
						}else{
							findpathbetween(i, player);
							nextmove = Astar.getnextmove();
							
							//nextmove = Localworld.heatmapmove(Obj.entities[i].xp, Obj.entities[i].yp);
							if (nextmove != Help.NODIRECTION) {
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
						if (nextmove != Help.NODIRECTION) {
							Obj.entities[i].addaction(movestring(nextmove));
							//Check for doors!
							tx = Obj.entities[i].xp + Localworld.xstep(nextmove);
							ty = Obj.entities[i].yp + Localworld.ystep(nextmove);
							Use.interactwithblock(World.at(tx, ty), tx, ty, i);
							Obj.entities[i].ai = "pathfind_rush2";
						}
					case "pathfind_rush2":
						//Wait a turn
						nextmove = Help.NODIRECTION;
						Obj.entities[i].ai = "pathfind_rush3";
					case "pathfind_rush3":
						//Continue going the same way until the next step is a wall
						settempobjvariables(i);
						if (World.collide(tx + Localworld.xstep(tdir), ty + Localworld.ystep(tdir))) {
							Obj.entities[i].addaction("wait");
							Obj.entities[i].ai = "pathfind_rush";
						}else {
							Obj.entities[i].addaction(movestring(Obj.entities[i].dir));
							Obj.entities[i].addaction(movestring(Help.clockwise(Obj.entities[i].dir)));
							Obj.entities[i].addaction(movestring(Help.oppositedirection(Obj.entities[i].dir)));
							Obj.entities[i].addaction(movestring(Help.anticlockwise(Obj.entities[i].dir)));
							
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
						if (nextmove != Help.NODIRECTION) {
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
		//return Obj.getgridpoint(Obj.entities[i].xp, Gfx.tiles[Gfx.currenttileset].height);
		return Std.int(Obj.entities[i].xp);
	}
	
	public static function getcurrenty(i:Int):Int {
		//return Obj.getgridpoint(Obj.entities[i].yp, Gfx.tiles[Gfx.currenttileset].height);
		return Std.int(Obj.entities[i].yp);
	}
	
	public static function getdestinationx(i:Int, movestring:String=""):Int {
		//tx = Obj.getgridpoint(Obj.entities[i].xp, Gfx.tiles[Gfx.currenttileset].width);
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
		//ty = Obj.getgridpoint(Obj.entities[i].yp, Gfx.tiles[Gfx.currenttileset].height);
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
		if (Obj.entities[i].numpossibleactions == 0) {
			Obj.entities[i].action = "nothing";
			Obj.entities[i].actionset = true;
			//trace("  Out of moves, do nothing.");
		}else {
			if (!Obj.entities[i].actionset) {
				//tx = Std.int(Math.random() * Obj.entities[i].numpossibleactions);
				tx = 0;
				tempstring = Obj.entities[i].possibleactions[tx];
				if (Help.getroot(tempstring, "_") == "move") {
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
		if (Help.getroot(Obj.entities[i].action, "_") == "move") {
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
									if (oppositedirstring(Help.getbranch(Obj.entities[i].action, "_"),
																				Help.getbranch(Obj.entities[j].action, "_"))) {
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
	
	public static function showmessage(_message:String, col:String, time:Int):Void {
		message = _message;
		messagedelay = time;
		messagecol = col; 
	}
	
	public static var message:String = "";
	public static var messagedelay:Int = 0;
	public static var messagecol:String = "white";
	
	public static var health:Int = 3;
	public static var keys:Int = 3;
	public static var cash:Int = 0;
	
	public static var highlightcooldown:Int = 0;
	
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
	
	public static var alarm:Bool = false;
	public static var alarmsound:Int = 0;
	public static var alertlevel:Int = 0;
	public static var reinforcements:Array<String> = new Array<String>();
	public static var reinforcementspeed:Array<Int> = new Array<Int>();
	public static var reinforcestate:Int;
	
	public static var icecube:Int;
	public static var timestop:Int;
	public static var cloaked:Int;
	
	/** Add a room type that can come up in the tower */
	public static function addblueprint(t:String):Void {
		towerblueprints[numtowerblueprints] = t;
		numtowerblueprints++;
	}
	
	/** Add a gadget to the tower. Every item will appear somewhere in the tower. */
	public static function addgadget(t:String):Void {
		towergadgets[numtowergadgets] = t;
		numtowergadgets++;
	}
	
	/** Add a rare gadget to the tower. One item in this list can appear somewhere. */
	public static function addraregadget(t:String):Void {
		towergadgets_rare[numtowergadgets_rare] = t;
		numtowergadgets_rare++;
	}
	
	/** Shuffle the tower gadgets array */
	public static function shufflegadgets():Void {
		for (i in 0 ... numtowergadgets) {
			var j:Int = Rand.pint(0, numtowergadgets - 1);
			var a:String = towergadgets[i];
			var b:String = towergadgets[j];
			towergadgets[i] = b;
			towergadgets[j] = a;
		}
	}
	
	/** Add an item to the tower. Every item will appear somewhere in the tower. */
	public static function additem(t:String):Void {
		toweritems[numtoweritems] = t;
		numtoweritems++;
	}
		
	/** Add a rare gadget to the tower. One item in this list can appear somewhere. */
	public static function addrareitem(t:String):Void {
		toweritems_rare[numtoweritems_rare] = t;
		numtoweritems_rare++;
	}
	
	
	/** Shuffle the tower gadgets array */
	public static function shuffleitems():Void {
		for (i in 0 ... numtoweritems) {
			var j:Int = Rand.pint(0, numtoweritems - 1);
			var a:String = toweritems[i];
			var b:String = toweritems[j];
			toweritems[i] = b;
			toweritems[j] = a;
		}
	}
	
	public static function cleartower():Void {
		numtowergadgets = 0;
		numtowergadgets_rare = 0;
		numtoweritems = 0;
		numtoweritems_rare = 0;
		numtowerblueprints = 0;
	}
	
	/** Make a int to int map for shuffling */
	public static function initpreshuffle(start:Int, end:Int):Void {
		for (i in start ... end) {
			preshuffle[i] = i;
		}
		
		for (i in start ... end) {
			var j:Int = Rand.pint(start, end - 1);
			var a:Int = preshuffle[i];
			var b:Int = preshuffle[j];
			preshuffle[i] = b;
			preshuffle[j] = a;
		}
	}
	
	public static function distributefloors():Void {
		//Given a list of possible blueprints, distribute them for all the floors
		if (blueprintorder == "random") {
			//Just pick randomly
			for (i in 1 ... towerheight-1) {
				blueprint[i] = towerblueprints[Rand.pint(0, numtowerblueprints - 1)];
			}
		}else if (blueprintorder == "ordered") {
			//Put them in order!
			var div:Int = Std.int((towerheight - 2) / numtowerblueprints);
			var currentdiv:Int = 0;
			var diviter:Int = 0;
			
			for (i in 1 ... towerheight-1) {
				blueprint[i] = towerblueprints[currentdiv];
				diviter++;
				if (diviter >= div) {
					diviter = 0;
					currentdiv = currentdiv + 1;
					if (currentdiv == numtowerblueprints) {
						currentdiv = numtowerblueprints - 1;
					}
				}
			}
		}
	}
	
	public static function distributeitems(start:Int, end:Int):Void {
		for(i in 0 ... towerheight){
			flooritems[i].clear();
			floorgadgets[i].clear();
			floortreasure[i] = 0;
		}
		
		//Pick floors BETWEEN the top and bottom to place items on
		//Shuffle the floors to have a random distribution!
		var i:Int;
		var j:Int;
		
		//Gadgets
		i = start; j = 0;
		initpreshuffle(start, end);
		while (j < numtowergadgets) {
			floorgadgets[preshuffle[i]].add(towergadgets[j]);
			i++; j++;
			if (i >= end) i = start;
		}
		
		if (numtowergadgets_rare > 0) {
			floorgadgets[preshuffle[i]].add(towergadgets_rare[Rand.pint(0, numtowergadgets_rare-1)]);
		}
		
		//Items
		i = start; j = 0;
		initpreshuffle(start, end);
		while (j < numtoweritems) {
			flooritems[preshuffle[i]].add(toweritems[j]);
			i++; j++;
			if (i >= end) i = start;
		}
		
		if (numtoweritems_rare > 0) {
			flooritems[preshuffle[i]].add(toweritems_rare[Rand.pint(0, numtoweritems_rare-1)]);
		}
		
		//Treasure
		//We just want this divided more or less evenly
		for (i in start ... end) {
			floortreasure[i] = Std.int(towertreasure / (towerheight - 2));
		}
		
		initpreshuffle(start, end);
		for (i in start ... end) {
			for (j in start ... end) {
				if (floortreasure[preshuffle[i]] > 50) {
					floortreasure[preshuffle[i]] -= 50;
					floortreasure[j] += 50;
				}
			}
		}
		
		//Debug!
		
		if(Buildconfig.showtraces) trace("Items distributed in tower:");
		if(Buildconfig.showtraces) trace(Std.string(towerheight) + " FLOORS HIGH");
		if(Buildconfig.showtraces) trace("----");
		for(i in 0 ... towerheight){
			if(Buildconfig.showtraces) trace("FLOOR " + Std.string(i + 1) + ": " + floorgadgets[i].printout() +", " + flooritems[i].printout() + ", and $" + Std.string(floortreasure[i]) + " worth of treasure");
		}
	}
	
	public static function initblueprints(type:String, first:String, last:String):Void {
		towertype = type;
		
		firstfloor = first;
		lastfloor = last;
		
		switch(towertype) {
			case "intro":
				blueprintorder = "ordered";
				addblueprint("intro_small");
				addblueprint("intro_small2");
				addblueprint("intro_small3");
			case "robot":
				blueprintorder = "ordered";
				addblueprint("robot_small");
				addblueprint("robot_large");
			case "somethingelse":
				blueprintorder = "random";
				addblueprint("cross");
				addblueprint("square");
			case "normal":
				blueprintorder = "ordered";
				addblueprint("small");
				addblueprint("medium");
				addblueprint("big");
		}
	}
	
	public static function generatetowerblock(type:String):Void {
		//Generate all tower block info! For now just hardcode some stuff
		cleartower();
		
		switch(type) {
			case "intro":
				Localworld.changepalette("blue", 0);
				towerheight = 5;
				initblueprints("intro", "intro_firstfloor", "intro_topfloor");
				
				towerstartlevel = 1; towerendlevel = 4;
				itemlevel = 1;
				
				towertreasure = 420 + (Rand.ppickint(0, 6) * 30);
				
				//Add things to find in the tower
				if (Rand.poccasional()) {
					addgadget(Rand.ppickstring("teleporter", "knockout gas"));
				}else{
					addgadget(Rand.ppickstring("tazer", "leaf blower", "skateboard"));
				}
				if (Rand.prare()) {
					addgadget(Weapon.MATCHSTICK);
				}else {
					addgadget("pistol");
				}
				shufflegadgets();
				
				additem("Lightbulb");
				additem("Signal Jammer");
				var tmp:Int = Rand.ppickint(1, 4);
				if (tmp == 1) {
					additem("First Aid Kit");
					additem("Signal Jammer");
				}else if (tmp == 2) {
					additem("First Aid Kit");
					additem("Cardboard Box");
				}else if (tmp == 3) {
					additem("Signal Jammer");
					additem("Cardboard Box");
				}else if (tmp == 4) {
					additem("Lightbulb");
					additem("First Aid Kit");
				}
				shuffleitems();
			case "robot":
				Localworld.changepalette("gray", 2);
				towerheight = 5;
				initblueprints("robot", "robot_firstfloor", "robot_topfloor");
				
				towerstartlevel = 1; towerendlevel = 4;
				itemlevel = 1;
				
				towertreasure = 420 + (Rand.ppickint(0, 6) * 30);
				
				//Add things to find in the tower
				if (Rand.poccasional()) {
					addgadget(Rand.ppickstring("teleporter", "knockout gas"));
				}else{
					addgadget(Rand.ppickstring("tazer", "leaf blower", "skateboard"));
				}
				if (Rand.prare()) {
					addgadget(Weapon.MATCHSTICK);
				}else {
					addgadget("pistol");
				}
				shufflegadgets();
				
				additem("Lightbulb");
				additem("Signal Jammer");
				var tmp:Int = Rand.ppickint(1, 4);
				if (tmp == 1) {
					additem("First Aid Kit");
					additem("Signal Jammer");
				}else if (tmp == 2) {
					additem("First Aid Kit");
					additem("Cardboard Box");
				}else if (tmp == 3) {
					additem("Signal Jammer");
					additem("Cardboard Box");
				}else if (tmp == 4) {
					additem("Lightbulb");
					additem("First Aid Kit");
				}
				shuffleitems();
			case "normal":
				towerheight = 5;
				initblueprints("intro", "intro_firstfloor", "intro_topfloor");
				
				towerstartlevel = 1; towerendlevel = 4;
				itemlevel = 1;
			case "fire":
				//Found in firelevels only! Terrifying fire tower with fireproof suit as reward
				//initblueprints("fire", "fire_firstfloor", "fire_topfloor");
			default:
				if(Buildconfig.showtraces) trace("ERROR! No tower type " + type + ". Generating normal instead.");
				generatetowerblock("normal");
				type = "error";
		}
		
		if (type != "error") {
			//Set tower levels. Between 1 and ???
			enemylevel = towerstartlevel;
			
			distributefloors();
			distributeitems(1, towerheight - 1);
		}
	}
	
	public static function cameraframe(t:Int):Int {
		//Given angle t, return 0 - 4, for up down left right.
		//For doing camera animations.
		t = Std.int(Help.fixangle(t));
		if (t > 22 && t <= 67) return 1;
		if (t > 67 && t <= 112) return 2;
		if (t > 112 && t <= 157) return 3;
		if (t > 157 && t <= 202) return 16;
		if (t > 202 && t <= 247) return 17;
		if (t > 247 && t <= 292) return 18;
		if (t > 292 && t <= 337) return 19;
		return 0;
	}
	
	public static var floor:Int = 1;
	public static var enemylevel:Int;
	public static var itemlevel:Int;
	public static var towerheight:Int;
	public static var towertype:String;
	public static var currentblueprint:String;
	public static var blueprint:Array<String> = new Array<String>();
	public static var towerblueprints:Array<String> = new Array<String>();
	public static var numtowerblueprints:Int;
	public static var blueprintorder:String;
	public static var firstfloor:String;
	public static var lastfloor:String;
	
	public static var towerstartlevel:Int;
	public static var towerendlevel:Int;
	
	public static var towergadgets:Array<String> = new Array<String>();
	public static var towergadgets_rare:Array<String> = new Array<String>();
	public static var numtowergadgets:Int;
	public static var numtowergadgets_rare:Int;
	
	public static var toweritems:Array<String> = new Array<String>();
	public static var toweritems_rare:Array<String> = new Array<String>();
	public static var numtoweritems:Int;
	public static var numtoweritems_rare:Int;
	
	public static var flooritems:Array<Numlist> = new Array<Numlist>();
	public static var floorgadgets:Array<Numlist> = new Array<Numlist>();
	public static var floorenemies:Numlist = new Numlist();
	public static var floortreasure:Array<Int> = new Array<Int>();
	
	public static var preshuffle:Array<Int> = new Array<Int>();
	
	public static var towertreasure:Int;
	
	public static var placement:Array<Placementclass> = new Array<Placementclass>();
	public static var placementindex:Map<String, Int> = new Map<String, Int>();
	public static var currentplacement:Int;
	
	public static var backgroundcolour:Int = 0x112945;
	public static var redwallshade:Float;
	public static var greenwallshade:Float;
	public static var bluewallshade:Float;
	
	public static var lettertime:Int;
	public static var letterreadspeed:Int = 3;
}