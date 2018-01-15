package;

import haxegon.*;
import gamecontrol.*;
import config.*;
import terrylib.*;
import modernversion.*;

class GameInput {
	public static function splashscreeninput() {
		if (Input.justpressed(Key.SPACE)) {
			Game.changestate(Game.TITLEMODE);
			//Game.changestate(Game.GAMEMODE);
			Music.playsound("start");
			Modern.start();
			
			//Start the game
			Text.font = "fffhomepage";
			//Game.changestate(Game.ENDINGMODE);	
		}
	}
	
	public static function fallfromtowerinput() {
	}
	
	public static function endinginput() {
		if(Logic.endingstate == "pressspace"){
			if (Controls.justpressed("action")) {
				Modern.endlevelanimationstate = 1;
				Modern.endlevelanimationaction = "titlescreen";
				Music.playsong("silence");
				Music.playsound("start");
			}
		}
	}
	
	public static function titleinput() {
		if (Controls.justpressed("action")) {
			Modern.endlevelanimationstate = 1;
			Modern.endlevelanimationaction = "startgame";
		}
	}
	
	public static var lastpressed:String;
	public static var heldkeys:Array<Int> = [0, 0, 0, 0];
	public static var newestkey:Int;
	public static var newestkeyheld:Int;
	
	public static function getkeypriority() {
		heldkeys[0] = Std.int(Math.max(Input.pressheldtime(Key.UP), Input.pressheldtime(Key.W)));
		heldkeys[1] = Std.int(Math.max(Input.pressheldtime(Key.DOWN), Input.pressheldtime(Key.S)));
		heldkeys[2] = Std.int(Math.max(Input.pressheldtime(Key.LEFT), Input.pressheldtime(Key.A)));
		heldkeys[3] = Std.int(Math.max(Input.pressheldtime(Key.RIGHT), Input.pressheldtime(Key.D)));
		
		lastpressed = "";
		if (heldkeys[0] > 0 && (heldkeys[1] <= 0 && heldkeys[2] <= 0 && heldkeys[3] <= 0)) {
		  lastpressed = "up";	
		}else if (heldkeys[1] > 0 && (heldkeys[0] <= 0 && heldkeys[2] <= 0 && heldkeys[3] <= 0)) {
		  lastpressed = "down";	
		}else if (heldkeys[2] > 0 && (heldkeys[0] <= 0 && heldkeys[1] <= 0 && heldkeys[3] <= 0)) {
		  lastpressed = "left";	
		}else if (heldkeys[3] > 0 && (heldkeys[0] <= 0 && heldkeys[1] <= 0 && heldkeys[2] <= 0)) {
		  lastpressed = "right";	
		}else {
		  newestkey = -2; newestkeyheld = -2;
			for (i in 0 ... 4) {
			  if (heldkeys[i] > -1 && (heldkeys[i] < newestkeyheld || newestkeyheld == -2)) {
					newestkey = i;
				  newestkeyheld = heldkeys[i];
				}
			}
			if(newestkey == 0) lastpressed = "up";
			if(newestkey == 1) lastpressed = "down";
			if(newestkey == 2) lastpressed = "left";
			if(newestkey == 3) lastpressed = "right";
		}
		
		if (lastpressed == "") {
		  Use.doorknockcheck = false;	
		}
	}
	
	public static function gameinput() {
		getkeypriority();
		
		if (Modern.popupwindow) {
		  popupinput();
		}else	if (Script.running) {
			if (Script.pausescript) {
				//Advance text
				if (Controls.justpressed("action")) {
					Script.pausescript = false;
					Textbox.textboxremove();
				}
			}
		}else {
			if (Menu.textmode == 0 && Modern.endlevelanimationstate <= 0 && Game.health > 0) {
				if (Script.hascontrol) {
					var useitemnow:Bool = false;
					if (Input.justpressed(Key.ONE) && Modern.inventoryslots >= 1) {   			Modern.currentslot = 0;	useitemnow = true;
					}else if (Input.justpressed(Key.TWO) && Modern.inventoryslots >= 2) {   Modern.currentslot = 1;	useitemnow = true;	
					}else if (Input.justpressed(Key.THREE) && Modern.inventoryslots >= 3) { Modern.currentslot = 2;	useitemnow = true;
					}else if (Input.justpressed(Key.FOUR) && Modern.inventoryslots >= 4) {  Modern.currentslot = 3;	useitemnow = true;
					}else if (Input.justpressed(Key.FIVE) && Modern.inventoryslots >= 5) {	Modern.currentslot = 4;	useitemnow = true;
					}else if (Input.justpressed(Key.SIX) && Modern.inventoryslots >= 6) {	  Modern.currentslot = 5;	useitemnow = true;
					}else if (Input.justpressed(Key.SEVEN) && Modern.inventoryslots >= 7) { Modern.currentslot = 6;	useitemnow = true;
					}else if (Input.justpressed(Key.EIGHT) && Modern.inventoryslots >= 8) {	Modern.currentslot = 7;	useitemnow = true;
					}
					
					if (useitemnow) {
						var player:Int = Obj.getplayer();
						if(player > -1){
							if (Modern.inventory[Modern.currentslot] != "") {
								Modern.useitem(Obj.entities[player], Modern.inventory[Modern.currentslot]);
								Game.startmove("wait");
							}else {
								Game.showmessage("NO ITEM EQUIPPED IN SLOT " + (Modern.currentslot + 1) + "...", "flashing", 120);
							}
						}
					}
				}
				
				if (Game.turn == "playermove") {
					for (i in 0 ... Obj.nentity) {
						if (Obj.entities[i].rule == "player") {
							if (Obj.entities[i].active) {
								if (Script.hascontrol) {
									if(Controls.pressed("action")){
										Game.startmove("wait");
									}else if(lastpressed == "left"){
										Obj.entities[i].animated = 5;
										Obj.entities[i].dir = Help.LEFT;
										if(!Game.blockedfrommoving(i)) Game.startmove("move_left");
									}else if(lastpressed == "right"){
										Obj.entities[i].animated = 5;
										Obj.entities[i].dir = Help.RIGHT;
										if(!Game.blockedfrommoving(i)) Game.startmove("move_right");
									}else if(lastpressed == "up"){
										Obj.entities[i].animated = 5;
										Obj.entities[i].dir = Help.UP;
										if(!Game.blockedfrommoving(i)) Game.startmove("move_up");
									}else if(lastpressed == "down"){
										Obj.entities[i].animated = 5;
										Obj.entities[i].dir = Help.DOWN;
										if(!Game.blockedfrommoving(i)) Game.startmove("move_down");
									}
								}
							}
						}
					}
				}
			}else if (Menu.textmode == 1) {
				if (Controls.delaypressed("up", 7)) {
					Menu.currentmenu--;
				}else if (Controls.delaypressed("down", 7)) {
					Menu.currentmenu++;
				}
				
				if (Menu.currentmenu <= 0) Menu.currentmenu += Menu.menusize;
				if (Menu.currentmenu >= Menu.menusize) Menu.currentmenu -= Menu.menusize;
				
				if (Controls.pressed("action")) {
					if (Menu.showscript == "terryletter") {
						if(Game.lettertime <= 1350){
							Game.lettertime += 5;
						}
					}else if (Menu.showscript == "alpha_secret") {
						if(Game.lettertime <= 800){
							Game.lettertime += 5;
						}
					}else if (Menu.showscript == "alpha_startup") {
						if(Game.lettertime <= 800){
							Game.lettertime += 5;
						}
					}
				}
				if (Controls.justpressed("action")) {
					//do something, depending on menu/choice
					//e.g. link to new menu
					if (Menu.showscript == "terryletter") {
						//Menu.createmenu("destroyletter");
						if(Game.lettertime >= 1350){
							Menu.backtogame();
							Modern.usestairs_afteranimation();
						}
					}else if (Menu.showscript == "alpha_secret") {
						//Menu.createmenu("destroyletter");
						if(Game.lettertime >= 800){
							Menu.backtogame();
							Modern.usestairs_afteranimation();
						}
					}else if (Menu.showscript == "alpha_startup") {
						//Menu.createmenu("destroyletter");
						if(Game.lettertime >= 800){
							Menu.backtogame();
							Modern.usestairs_afteranimation();
						}
					}else if (Menu.showscript == "storeroomletter") {
						Menu.createmenu("destroyletter");
					}else if(Menu.showscript == "destroyletter"){
						if (Menu.currentmenu == 0) {
							Inventory.destroyinventoryletter(Inventory.currentletter);
							Menu.backtogame();
						}else {
							Menu.backtogame();
						}
					}else if(Menu.showscript == "readnow"){
						Menu.createmenu(Inventory.currentletter);
					}else if(Menu.showscript == "pawnshop"){
						Menu.createmenu("pawnshop2");
					}else if (Menu.showscript == "drink_yes1") {
						Menu.createmenu("drink_yes2");
					}else if(Menu.showscript == "drink_question"){
						if (Menu.currentmenu == 0) {
							Menu.createmenu("drink_yes1");
						}else {
							Menu.createmenu("drink_no");
						}
					}else if (Menu.showscript == "gameoptions") {
						//Main game menu!
						if (Menu.menuoptions[Menu.currentmenu] == "Use Tazer") {
							Menu.backtogame();
						}else if (Menu.menuoptions[Menu.currentmenu] == "Open inventory") {
							Menu.createmenu("inventory");
						}else	if (Menu.menuoptions[Menu.currentmenu] == "back") {
							Menu.backtogame();
						}
					}else if (Menu.showscript == "inventory") {
						var selection:Int = Inventory.getitemlistnum(Menu.menuoptions[Menu.currentmenu]);
						if (selection > -1) {
							if (Inventory.itemlist[selection].type == Inventory.WEAPON) {
								Inventory.setequippedweapon(Inventory.itemlist[selection].name);
								Inventory.reloadinventory();
							}else if (Inventory.itemlist[selection].type == Inventory.GADGET) {
								Inventory.setequippedgadget(Inventory.itemlist[selection].name);
								
								Inventory.reloadinventory();
							}else if (Inventory.itemlist[selection].type == Inventory.USEABLE) {
								Inventory.useitemcountdown = 15;
								Inventory.itemtouse = selection;
								Inventory.useinventoryitem(selection);
								
								Menu.backtogame();
							}else if (Inventory.itemlist[selection].type == Inventory.LETTER) {
								Inventory.currentletter = Inventory.itemlist[selection].letter;
							  Menu.createmenu(Inventory.currentletter);
							}else if (Inventory.itemlist[selection].type == Inventory.MAP) {
								Menu.textmode = 2;
								Openworld.viewmap = 90;
							}
						}else if (Menu.currentmenu == Menu.menusize-1) {
							//Game.createmenu("gameoptions");
							Menu.backtogame();
						}
					}else {
						Menu.backtogame();
					}
				}
			}else if (Menu.textmode == 2) {
				if (Controls.justpressed("action") || Controls.justpressed("menu")) {
					Menu.backtogame();
				}
			}
		}
		
		/*
		if (Input.justpressed(Key.P) && !Modern.popupwindow) {
			Modern.usestairs();
		}
		
		if (Input.justpressed(Key.O) && !Modern.popupwindow) {
			Use.doitemaction(Itemstats.get(Item.LIGHTBULB).index);
		}
		
		if (Input.justpressed(Key.I) && !Modern.popupwindow) {
			Use.doitemaction(Itemstats.get(Item.FIRSTAIDKIT).index);
		}
		*/
		
		if (Input.justpressed(Key.R) && !Modern.popupwindow) {
			Modern.restartfadeout();
			Music.playsound("restart");
		}
	}
	
	public static function popupinput() {
		if (Modern.popupmode == "itemshopkeeper") {
			if (Modern.popupstate == 1) {
				if (Controls.justpressed("left") || Controls.justpressed("up")) {
					Modern.menuselection = 0;
				}
				if (Controls.justpressed("down") || Controls.justpressed("right")) {
					Modern.menuselection = 1;
				}
				
				if (Controls.justpressed("action")) {
					if (Modern.popupitem.cost > Game.cash || Modern.slotsfree() == 0) {
						Modern.popupstate = 3;
						Music.playsound("lockeddoor");
					}else	if(Modern.menuselection == 1){
						Modern.popupstate = 2;	
						Music.playsound("lockeddoor");
					}else {
						if (Game.cash >= Modern.popupitem.cost) {
							Game.cash -= Modern.popupitem.cost;
							Modern.gemflash = Modern.flashtime;
							
							Modern.pickupitembyitemclass(Modern.popupitem);
							Game.keys++;
							Modern.keyflash = Modern.flashtime;
							
							Obj.entities[Obj.getplayer()].setmessage("Bought " + Modern.popupitem.name.toUpperCase(), "player", 90);
							Music.playsound("collectitem");
							Modern.popupstate = 2;
							
							Obj.entities[Modern.currentshopkeeper].name = "sold out";
						}else {
							Music.playsound("lockeddoor");
						}
					}
				}
			}
		}else if (Modern.popupmode == "shopkeeper") {
			if (Modern.popupstate == 1) {
				if (Controls.justpressed("left") || Controls.justpressed("up")) {
					Modern.menuselection = 0;
				}
				if (Controls.justpressed("down") || Controls.justpressed("right")) {
					Modern.menuselection = 1;
				}
				
				if (Controls.justpressed("action")) {
					if ( Modern.keygemrate > Game.cash) {
						Modern.popupstate = 3;
						Music.playsound("lockeddoor");
					}else	if(Modern.menuselection == 1){
						Modern.popupstate = 2;	
						Music.playsound("lockeddoor");
					}else {
						if (Game.cash >= Modern.keygemrate) {
							Game.cash -= Modern.keygemrate;
							Modern.gemflash = Modern.flashtime;
							Modern.keygemratelevel++;
							
							Game.keys++;
							Modern.keyflash = Modern.flashtime;
							
							Obj.entities[Obj.getplayer()].setmessage("Bought a KEY", "key", 90);
							Music.playsound("collectkey");
							Modern.popupstate = 2;
						}else {
							Music.playsound("lockeddoor");
						}
					}
				}
			}
		}else if (Modern.popupmode == "soldoutshopkeeper") {
			if (Modern.popupstate == 1) {
				if (Controls.justpressed("action")) {
					Modern.popupstate = 2;	
				}
			}
		}else if (Modern.popupmode == "newitem") {
			if (Modern.popupstate == 1) {
				if (Controls.justpressed("action")) {
					Modern.popupstate = 2;	
				}
			}
		}else if (Modern.popupmode == "newitem_drop") {
			if (Modern.popupstate < 2) {
				if (Controls.delaypressed("left", 8)) {
					Modern.currentslot = (Modern.currentslot + (Modern.inventory.length - 1)) % Modern.inventory.length;
				}
				if (Controls.delaypressed("right", 8)) {
					Modern.currentslot = (Modern.currentslot + 1) % Modern.inventory.length;
				}
			}
			if (Modern.popupstate == 1) {
				if (Controls.justpressed("action")) {
					Modern.popupstate = 2;
				}
			}
		}	
	}
}