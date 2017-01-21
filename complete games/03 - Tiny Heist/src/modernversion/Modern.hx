package modernversion;

import haxegon.*;
import gamecontrol.*;
import obj.*;
import terrylib.*;
import config.Entclass;

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
	
	public static function popup(mode:String, item:Itemclass) {
		popupwindow = true;
		popupmode = mode;
		popuplerp = 0;
		popupstate = 0;
		popupitem = item;
		
		menuselection = 0;
	}
	
	public static var popupwindow:Bool = false;
	public static var popupmode:String = "";
	public static var popupstate:Int = 0;
	public static var popuplerp:Int = 0;
	public static var popupitem:Itemclass;
	public static var popupspeed:Int = 20;
	public static var popupanimationtype_appear:String = "back_out";
	public static var popupanimationtype_disappear:String = "back_out";
	public static var shopkeepcol:Int;
	public static var keygemrate:Int = 0;
	public static var keygemratelevel:Int = 0;
	public static var menuselection:Int = 0;
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
		//Starting items
		inventory = [];
		inventory_num = [];
		initslots = 3;
		for (i in 0 ... initslots + 1) {
		  inventory.push("");	
			inventory_num.push(0);
		}
		
		//100x150 is the upper limit on map sizes
		AIDirector.testmap = Data.blank2darray(100, 100);
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
			var outsideitemlist:Array<String> = [Item.HELIXWING];
			outsideitemlist.push(Random.pickstring(Item.TIMESTOPPER, Item.CARDBOARDBOX, Weapon.MATCHSTICK, Weapon.TELEPORTER));
			outsideitemlist.push("");
			outsideitemlist.push("");
			Random.shufflearray(outsideitemlist);
			itemtopleft = outsideitemlist.pop();
			itemtopright = outsideitemlist.pop();
			itembottomleft = outsideitemlist.pop();
			itembottomright = outsideitemlist.pop();
		}
		AIDirector.glitchmode = false;
		AIDirector.outside = true;
		AIDirector.style = Roomstyle.outside;
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
		inventoryslots = initslots;
		Game.reinforcestate = 0;
		currentslot = 0;
		
		for (i in 0 ... initslots + 1) {
		  inventory[i] = "";
			inventory_num[i] = 0;
		}
		
		hpflash = 0;
		gemflash = 0;
		keyflash = 0;
		waitflash = 0;
		
		Game.restartgame();
		
		streakcount = 0;
		
		AIDirector.restart();
		
		if (AIDirector.seed == "random") {
			currentrunseed = Std.int(Math.random() * 16807);
			Rand.setseed(currentrunseed);
		}else{	
			currentrunseed = Levelgen.stringseed(AIDirector.seed) + Game.floor;
			Rand.setseed(currentrunseed);
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
				case Roomstyle.intro:
					Localworld.changepalette("blue", 0);
				case Roomstyle.high:
					Localworld.changepalette("purple", 1);
				case Roomstyle.shopkeeper:
					Localworld.changepalette("green", 3);
				case Roomstyle.robot:
					Localworld.changepalette("gray", 2);
				case Roomstyle.executive:
					Localworld.changepalette("darkred", 0);
				case Roomstyle.outside:
					Localworld.changepalette("gray", 5);
				case Roomstyle.rooftop:
					Localworld.changepalette("blue", 4);
				case Roomstyle.error:
					Localworld.changepalette("darkred", 0);
				default:
					Localworld.changepalette("darkred", 0);
			}	
		}else {
			switch(AIDirector.style) {
				case Roomstyle.intro:
					Localworld.changepalette("blue", 0);
				case Roomstyle.high:
					Localworld.changepalette("purple", 1);
				case Roomstyle.shopkeeper:
					Localworld.changepalette("green", 3);
				case Roomstyle.robot:
					Localworld.changepalette("gray", 2);
				case Roomstyle.executive:
					Localworld.changepalette("darkred", 0);
				case Roomstyle.outside:
					Localworld.changepalette("gray", 5);
				case Roomstyle.rooftop:
					Localworld.changepalette("blue", 4);
				case Roomstyle.error:
					Localworld.changepalette("darkred", 0);
				default:
					Localworld.changepalette("darkred", 0);
			}	
		}
	}
	
	public static function updatepalettealarm() {
		switch(AIDirector.style) {
		  case Roomstyle.intro:
				Localworld.changepalette("red", 0);
			case Roomstyle.high:
				Localworld.changepalette("red", 1);
			case Roomstyle.shopkeeper:
				Localworld.changepalette("red", 3);
			case Roomstyle.robot:
				Localworld.changepalette("red", 2);
			case Roomstyle.executive:
				Localworld.changepalette("red", 0);
			case Roomstyle.error:
				Localworld.changepalette("red", 0);
			default:
				Localworld.changepalette("red", 0);
		}	
	}
	
	public static var playeronstairs:Bool = false;
	public static var playerjustteleported:Bool = false;
	public static function usestairs() {
		Music.playsound("nextfloor");
		playeronstairs = true;
		
		if (AIDirector.outside) {
			AIDirector.outside = false;
		  var zone:Int = Std.int(Math.max(Math.abs(Modern.worldx - 50), Math.abs(Modern.worldy - 50)));
			if (zone > 0) {
				//You used glitch stairs! Nice! Let's make a glitchy version of the tower
				AIDirector.glitchmode = true;
				Achievements.award("glitch", 1);
			}else {
			  streakcount++;
			}
		}
		
		//if (AIDirector.floor == 11) {
		//	endlevelanimationstate = 1;
		//	endlevelanimationaction = "alpha_level12";
		//}else{
		endlevelanimationstate = 1;
		if (AIDirector.floor >= 16) {
			endlevelanimationaction = "endgame";
		}else{
			endlevelanimationaction = "next";
		}
		//}
	}
	
	private static var temptile:Int;
	public static function checkfortowerexit() {
		if (AIDirector.outside) {
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
			if (!Help.inboxw(Obj.entities[player].xp, Obj.entities[player].yp, 0, 0, World.mapwidth-1, World.mapheight-1)) {
				endlevelanimationstate = 1;
				endlevelanimationaction = "leftmap";
				Achievements.award("exittower", 1);
				
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
					temptile = World.at(Obj.entities[player].xp, Obj.entities[player].yp);
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
		Achievements.award("floor", AIDirector.floor);
		
		if (AIDirector.seed == "random") {
			Rand.setseed(Std.int(Math.random() * 16807));
		}else{	
			Rand.setseed(Levelgen.stringseed(AIDirector.seed) + Game.floor);
		}
		if(Buildconfig.showtraces) trace("level seed is " + Levelgen.stringseed(AIDirector.seed) + Game.floor);
		
		AIDirector.designfloor();
		
		Levelgen.createroom();
		
		while (!AIDirector.assessroom()) Levelgen.createroom();
		
		if (AIDirector.glitchmode) {
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
			  Obj.createentity(Obj.entities[gempositions[i]].xp, Obj.entities[gempositions[i]].yp, "item", Item.ERRORBOMB);
			}
		}
		
		//Make streaks harder!
		if (streakcount > 0) {
		  if (streakcount >= 1) {
			  //Swap guards for laser guards and cameras for laser cameras
				var guardpositions:Array<Int> = [];
				for (i in 0 ... Obj.nentity) {
					if (Obj.entities[i].active) {
						if (Obj.entities[i].type == Enemy.GUARD) {
							guardpositions.push(i);
							Obj.entities[i].active = false;
						}
					}
				}
				
				for (i in 0 ... guardpositions.length) {
					Obj.createentity(Obj.entities[guardpositions[i]].xp, Obj.entities[guardpositions[i]].yp, "enemy", Enemy.LASERGUARD);
				}
				
				guardpositions = [];
				for (i in 0 ... Obj.nentity) {
					if (Obj.entities[i].active) {
						if (Obj.entities[i].type == Enemy.CAMERA) {
							guardpositions.push(i);
							Obj.entities[i].active = false;
						}
					}
				}
				
				for (i in 0 ... guardpositions.length) {
					Obj.createentity(Obj.entities[guardpositions[i]].xp, Obj.entities[guardpositions[i]].yp, "enemy", Enemy.LASERCAMERA);
				}
				
				guardpositions = [];
				for (i in 0 ... Obj.nentity) {
					if (Obj.entities[i].active) {
						if (Obj.entities[i].type == Enemy.SENTINAL) {
							guardpositions.push(i);
							Obj.entities[i].active = false;
						}
					}
				}
				
				for (i in 0 ... guardpositions.length) {
					Obj.createentity(Obj.entities[guardpositions[i]].xp, Obj.entities[guardpositions[i]].yp, "enemy", Enemy.LASERSENTINAL);
				}
			}
			if (streakcount >= 2) {
			  //All elite bots are now terminators
				var guardpositions:Array<Int> = [];
				for (i in 0 ... Obj.nentity) {
					if (Obj.entities[i].active) {
						if (Obj.entities[i].type == Enemy.ROBOT) {
							guardpositions.push(i);
							Obj.entities[i].active = false;
						}
					}
				}
				
				for (i in 0 ... guardpositions.length) {
					Obj.createentity(Obj.entities[guardpositions[i]].xp, Obj.entities[guardpositions[i]].yp, "enemy", Enemy.TERMINATOR);
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
	
	//New inventory stuff
	public static var currentslot:Int = 0;
	public static var oldcurrentslot:Int = 0;
	public static var initslots:Int;
	public static var inventory:Array<String>;
	public static var inventory_num:Array<Int>;
	public static var inventoryslots:Int;
	
	public static function drawbubble(x:Int, y:Int, w:Int, h:Int, backingcol:Int, bordercol:Int, innercol:Int) {
		Draw.roundfillrect(x, y, w, h, bordercol);
		Draw.roundfillrect(x + 1, y + 1, w - 2, h - 2, backingcol);
		Draw.roundfillrect(x + 2, y + 2, w - 4, h - 4, innercol);
	}
	
	public static var currentitem:Itemclass;
	
	public static function useitem(e:Entclass, itemname:String) {
		currentitem = Itemstats.get(itemname);
		if (currentitem.type == Inventory.USEABLE) {
			Use.doitemaction(currentitem.index);
			//Free up the item slot
			inventory[currentslot] = "";
		}else if (currentitem.type == Inventory.GADGET) {
			Use.usegadget(Obj.entities.indexOf(e), currentitem.index);
			inventory_num[currentslot]--;
			if (inventory_num[currentslot] <= 0) {
				inventory[currentslot] = "";
			  //Game.showmessage("OUT OF " + currentitem.multiname + "...", "flashing", 120);
			}
		}
		
		reorderinventory();
	}
	
	public static function swapinventory(a:Int, b:Int) {
		var temp:String = inventory[a];
		inventory[a] = inventory[b];
		inventory[b] = temp;
		
		var temp_amount:Int = inventory_num[a];
		inventory_num[a] = inventory_num[b];
		inventory_num[b] = temp_amount;
	}
	
	public static function reorderinventory() {
		//lazy bubble sort :3
	  if (inventory[2] != "" && inventory[1] == "") swapinventory(2, 1);
		if (inventory[1] != "" && inventory[0] == "") swapinventory(1, 0);
		if (inventory[2] != "" && inventory[1] == "") swapinventory(2, 1);
	}
	
	public static function slotsfree():Int {
	  var s:Int = 0;
		for (i in 0 ... inventoryslots) {
		  if (inventory[i] == "") s++;	
		}
		return s;
	}
	
	public static function pickupitembyitemclass(e:Itemclass) {
		//Duplicating all this is *probably* a bad idea, idk, but yolo, it's a jam game
		if (AIDirector.outside) {
		  if (Modern.worldx - 50 == -1 && Modern.worldy - 50 == -1) {
				Modern.itemtopleft = "";
			}else if (Modern.worldx - 50 == 1 && Modern.worldy - 50 == -1) {
				Modern.itemtopright = "";
			}else if (Modern.worldx - 50 == -1 && Modern.worldy - 50 == 1) {
				Modern.itembottomleft = "";
			}else if (Modern.worldx - 50 == 1 && Modern.worldy - 50 == 1) {
				Modern.itembottomright = "";
			}
		}
		
		//IF YOU UPDATE THIS FUNCTION, ALSO UPDATE THE ONE BELOW
		//We find a free inventory slot
		var freeslot:Int = -1;
		var emptyinventory:Bool = true;
		for (i in 0 ... inventoryslots) {
			if (inventory[i] != "") emptyinventory = false;
			if(freeslot == -1){
				if (inventory[i] == "")	{
					freeslot = i;
				}
			}
		}
		
		if (freeslot == -1) {
			//let's assume that bit just works for now
		  freeslot = inventoryslots;
			oldcurrentslot = currentslot;
		}
		
		currentitem = e;
		
		if (currentitem.type == Inventory.GADGET || currentitem.type == Inventory.USEABLE) {
		  Music.playsound("collectitem");	
		}else {
			
		}
		
		inventory[freeslot] = currentitem.name;
		//try out only getting 1 of everything
		if (currentitem.hasmultipleshots) {
			inventory_num[freeslot] = currentitem.typical;//e.para;
		}else{
			inventory_num[freeslot] = 1;//e.para;
		}
		
		//If we had an empty inventory, choose the thing we just collected
		if (emptyinventory) currentslot = freeslot;
	  //trace("picked up " + e.name + ", " + e.para);	
		
		//Deal with full inventory here
		if (freeslot == inventoryslots) {
			popup("newitem_drop", currentitem);
		}else {
			popup("newitem", currentitem);
		}
	}
	
	public static function pickupitem(e:Entclass) {
		//We find a free inventory slot
		
		//Check for outside world persistance
		if (AIDirector.outside) {
		  if (Modern.worldx - 50 == -1 && Modern.worldy - 50 == -1) {
				Modern.itemtopleft = "";
			}else if (Modern.worldx - 50 == 1 && Modern.worldy - 50 == -1) {
				Modern.itemtopright = "";
			}else if (Modern.worldx - 50 == -1 && Modern.worldy - 50 == 1) {
				Modern.itembottomleft = "";
			}else if (Modern.worldx - 50 == 1 && Modern.worldy - 50 == 1) {
				Modern.itembottomright = "";
			}
		}
		
		//IF YOU UPDATE THIS FUNCTION, ALSO UPDATE THE ONE ABOVE
		var freeslot:Int = -1;
		var emptyinventory:Bool = true;
		for (i in 0 ... inventoryslots) {
			if (inventory[i] != "") emptyinventory = false;
			if(freeslot == -1){
				if (inventory[i] == "")	{
					freeslot = i;
				}
			}
		}
		
		if (freeslot == -1) {
			//let's assume that bit just works for now
		  freeslot = inventoryslots;
			oldcurrentslot = currentslot;
		}
		
		currentitem = Itemstats.get(e.name);
		
		if (currentitem.type == Inventory.GADGET || currentitem.type == Inventory.USEABLE) {
		  Music.playsound("collectitem");	
		}else {
			
		}
		
		inventory[freeslot] = currentitem.name;
		//try out only getting 1 of everything
		if (currentitem.hasmultipleshots) {
			inventory_num[freeslot] = currentitem.typical;//e.para;
		}else{
			inventory_num[freeslot] = 1;//e.para;
		}
		
		//If we had an empty inventory, choose the thing we just collected
		if (emptyinventory) currentslot = freeslot;
	  //trace("picked up " + e.name + ", " + e.para);	
		
		//Deal with full inventory here
		if (freeslot == inventoryslots) {
			popup("newitem_drop", currentitem);
		}else {
			popup("newitem", currentitem);
		}
	}
	
	public static var guibackingcolour:Int;
	public static function showitems() {
		var tx:Int = Gfx.screenwidth - (inventoryslots * 28);
		var ty:Int = Gfx.screenheight - 25;
		
		guibackingcolour = Game.backgroundcolour;
		if (Game.messagedelay != 0) {
			guibackingcolour = Draw.messagecolback(Game.messagecol);
		}
		/*
		Gfx.fillbox(tx - 4, ty - 4, Gfx.screenwidth - (tx - 4), Gfx.screenheight - (ty - 4), guibackingcolour);
		for (j in 0 ... 20) {
		  Gfx.fillbox(tx - Std.int(j / 2) - 4, ty - 4 + j, Std.int(j / 2), 1, guibackingcolour);
		}*/
		
		for (i in 0 ... inventory.length) {
			if (inventory[i] != "") {
				//Use brighter colours and draw a border
				Draw.roundfillrect(tx + (i * 28) - 2, ty - 1, 24 + 2, 24, Localworld.worldblock[Localworld.WALL].front_fog);
			}
			currentitem = Itemstats.get(inventory[i]);
			//trying out only getting 1 of everything, so disabling ammo display
			if(currentitem.hasmultipleshots == true){
				drawbubble(tx + (i * 28), ty, 22, 22, Draw.shade(Col.rgb(currentitem.r, currentitem.g, currentitem.b), 0.8), 0x000000, 0x000000);
				Gfx.imagecolor(Col.rgb(currentitem.r, currentitem.g, currentitem.b));
				Gfx.drawtile(tx + (i * 28) + 5, ty + 5, "terminal", currentitem.character.charCodeAt(0));
				Gfx.imagecolor();
				
				Gfx.fillbox(tx + (i * 28) + 14 - 1, ty - 3 - 1, Text.width("x" + inventory_num[i]) + 4, 10 + 2, 0x000000);
				Gfx.fillbox(tx + (i * 28) + 14, ty - 3, Text.width("x" + inventory_num[i]) + 2, 10, Draw.shade(Col.rgb(currentitem.r, currentitem.g, currentitem.b), 0.8));
				Text.display(tx + (i * 28) + 15, ty - 5, "x" + inventory_num[i], 0x000000);
			}else if(currentitem.type == Inventory.USEABLE || currentitem.type == Inventory.GADGET){
				drawbubble(tx + (i * 28), ty, 22, 22, Draw.shade(Col.rgb(currentitem.r, currentitem.g, currentitem.b), 0.8), 0x000000, 0x000000);
				Gfx.imagecolor(Col.rgb(currentitem.r, currentitem.g, currentitem.b));
				Gfx.drawtile(tx + (i * 28) + 5, ty + 5, "terminal", currentitem.character.charCodeAt(0));
				Gfx.imagecolor();
			}else {
				drawbubble(tx + (i * 28), ty, 22, 22, 0x444444, 0x000000, 0x000000);
			}
			Text.display(tx + (i * 28) + 18, ty + 12, (i + 1) + "", 0xFFFFFF);
		}
		/*
		if (Game.messagedelay == 0) {
			var texty:Int = Gfx.screenheight - 14;
			Draw.setnormaltext();
			Text.align(Text.RIGHT);
			if (inventory[currentslot] != "") {
				currentitem = Itemstats.get(inventory[currentslot]);
				
				if (currentitem.type == Inventory.USEABLE || currentitem.type == Inventory.GADGET) {
					Text.display(Gfx.screenwidth - (inventoryslots * 26) - 12, texty, inventory[currentslot].toUpperCase(), currentitem.highlightcol);
				}else if(currentitem.type == Inventory.GADGET){
					Text.display(Gfx.screenwidth - (inventoryslots * 26) - 12, texty, inventory[currentslot].toUpperCase() + " [x" + inventory_num[currentslot] +"]", currentitem.highlightcol);
				}
			}else{
				Text.display(Gfx.screenwidth - (inventoryslots * 26) - 12, texty, "EMPTY", Col.rgb(164, 164, 164));
			}
			Text.align(Text.LEFT);
		}*/
		if (Game.messagedelay == 0) {
			Text.align(Text.RIGHT);
			var waitcol:Int = Col.rgb(220, 220, 220);
			if (waitflash > 0) {
				var waitflashamount:Int = Std.int(Math.min(220 + waitflash * 5, 255));
			  waitcol = Col.rgb(waitflashamount, waitflashamount, waitflashamount);
				waitflash--;
			}
			Text.display(Gfx.screenwidth - (inventoryslots * 26) - 18, Gfx.screenheight - 14, "Z - Wait", waitcol);
			Text.align(Text.LEFT);
		}
	}
}