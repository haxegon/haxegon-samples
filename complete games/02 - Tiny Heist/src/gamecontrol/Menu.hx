package gamecontrol;

import terrylib.*;
import haxegon.*;

class Menu {
	public static function showtextbox():Void {
		var liney:Int = 7;
		switch(showscript) {
			case "terry":
				liney = 7;
				Draw.terminalprint(Gfx.CENTER, liney, "Hey, I'm Terry. Welcome to my world!");
				Draw.terminalprint(Gfx.CENTER, liney + 2, "There's not much out there right now.");
				Draw.terminalprint(Gfx.CENTER, liney + 3, "You should probably just stick exploring");
				Draw.terminalprint(Gfx.CENTER, liney + 4, "the tower here.");
			case "pawnshop":
				liney = 7;
				Draw.terminalprint(Gfx.CENTER, liney, "Welcome to my shop!");
				Draw.terminalprint(Gfx.CENTER, liney+2, "If you come across anything useful out");
				Draw.terminalprint(Gfx.CENTER, liney+3, "there, let me take a look at it. I might be");
				Draw.terminalprint(Gfx.CENTER, liney+4, "able to give you a few quid for it.");
			case "pawnshop2":
				liney = 9;
				Draw.terminalprint(Gfx.CENTER, liney, "Well, not really... Once you go up those");
				Draw.terminalprint(Gfx.CENTER, liney+1, "steps, there's no way back down. Hah!");
			case "storeroomletter":
				liney = 9;
				Draw.terminalprint(Gfx.CENTER, liney, "Wow, did you really just rob the storeroom?");
				Draw.terminalprint(Gfx.CENTER, liney + 2, "Tut tut!");
			case "drink_question":
				Draw.terminalprint(Gfx.CENTER, liney, "Would you like to drink the");
				Draw.terminalprint(Gfx.CENTER, liney+1, "water from the fountain?");
			case "drink_yes1":
				liney = 8;
				Draw.terminalprint(Gfx.CENTER, liney, "You drink from the fountain.");
				Draw.terminalprint(Gfx.CENTER, liney+1, "Suddenly, every muscle in your");
				Draw.terminalprint(Gfx.CENTER, liney+2, "body tightens. You feel like");
				Draw.terminalprint(Gfx.CENTER, liney+3, "a teenager again.");
			case "drink_yes2":
				liney = 8;
				Draw.terminalprint(Gfx.CENTER, liney, "Each time you drink from the");
				Draw.terminalprint(Gfx.CENTER, liney+1, "fountain, the effects diminish.");
				Draw.terminalprint(Gfx.CENTER, liney+3, "Death is inevitable.");
			case "drink_no":
				liney = 9;
				Draw.terminalprint(Gfx.CENTER, liney, "You step away from the fountain.");
			case "npctest":
				liney = 8;
				Draw.terminalprint(Gfx.CENTER, liney, "I wish I'd never drank from");
				Draw.terminalprint(Gfx.CENTER, liney + 1, "that damn fountain. I'm ready.");
				Draw.terminalprint(Gfx.CENTER, liney + 2, "Let me die in peace. ");
			case "terryletter":
				liney = 4;
				var lettercontents:Array<String> = [ 
					"Hey! Thanks for playing the alpha!",
					"              ",
					"That's it for now. I'm aiming for 16 floors with a",
					"boss level in the final version, but right now I",
					"just have these 12 floors.",
					"              ",
					"(You can keep playing, but the 12th floor layout will",
					"just keep repeating. See how far you can get!)",
					"              ",
					"Please let me know what you think on my blog - I'm",
					"gonna release a final version just before the new year!",
					"                                          - Terry",
				];
				
				var typedlettercontents:Array<String> = [];
				var cursor:Int = 0;
				var currentline:Int = 0;
				
				while (currentline < lettercontents.length && cursor < Std.int(Game.lettertime / Game.letterreadspeed)) {
					if (lettercontents[currentline].length > Std.int(Game.lettertime / Game.letterreadspeed) - cursor) {
						typedlettercontents.push(lettercontents[currentline].substr(0, Std.int(Game.lettertime / Game.letterreadspeed) - cursor));
						cursor = Std.int(Game.lettertime / Game.letterreadspeed) + 1;
					}else {
						typedlettercontents.push(lettercontents[currentline]);
						cursor += lettercontents[currentline].length;
					}
					currentline++;
				}
				
				for (i in 0 ... typedlettercontents.length) {
					if(i == 6 || i == 7){
						Draw.letterterminalprint(Gfx.screenwidthmid - Std.int(Text.width(lettercontents[i]) / 2), liney + i, typedlettercontents[i], 0x888888);
					}else {
					  Draw.letterterminalprint(Gfx.screenwidthmid - Std.int(Text.width(lettercontents[i]) / 2), liney + i, typedlettercontents[i]);		
					}
				}
			case "alpha_secret":
				liney = 7;
				var lettercontents:Array<String> = [ 
					"Hah! You left the map. Nice.",
					"              ",
					"If you do that in the final version, something",
					"cool will happen. It's a secret. Don't tell anyone!",
					"              ",
					"(for now, let's just take you to the next floor...)"
				];
				
				var typedlettercontents:Array<String> = [];
				var cursor:Int = 0;
				var currentline:Int = 0;
				
				while (currentline < lettercontents.length && cursor < Std.int(Game.lettertime / Game.letterreadspeed)) {
					if (lettercontents[currentline].length > Std.int(Game.lettertime / Game.letterreadspeed) - cursor) {
						typedlettercontents.push(lettercontents[currentline].substr(0, Std.int(Game.lettertime / Game.letterreadspeed) - cursor));
						cursor = Std.int(Game.lettertime / Game.letterreadspeed) + 1;
					}else {
						typedlettercontents.push(lettercontents[currentline]);
						cursor += lettercontents[currentline].length;
					}
					currentline++;
				}
				
				for (i in 0 ... typedlettercontents.length) {
					if(i == 5 || i == 6){
						Draw.letterterminalprint(Gfx.screenwidthmid - Std.int(Text.width(lettercontents[i]) / 2), liney + i, typedlettercontents[i], 0x888888);
					}else {
					  Draw.letterterminalprint(Gfx.screenwidthmid - Std.int(Text.width(lettercontents[i]) / 2), liney + i, typedlettercontents[i]);		
					}
				}
			case "alpha_startup":
				liney = 7;
				var lettercontents:Array<String> = [ 
					"Hello! Thanks for playing the alpha of my new game!",
					"                     ",
					"This is a tiny little thing that I'm hoping to finish",
					"before the end of the year. If you run into any",
					"problems or have any suggestions, let me know!",
					"",
					"I'm @terrycavanagh on twitter, or my blog is at",
					"http://www.distractionware.com"
				];
				
				var typedlettercontents:Array<String> = [];
				var cursor:Int = 0;
				var currentline:Int = 0;
				
				while (currentline < lettercontents.length && cursor < Std.int(Game.lettertime / Game.letterreadspeed)) {
					if (lettercontents[currentline].length > Std.int(Game.lettertime / Game.letterreadspeed) - cursor) {
						typedlettercontents.push(lettercontents[currentline].substr(0, Std.int(Game.lettertime / Game.letterreadspeed) - cursor));
						cursor = Std.int(Game.lettertime / Game.letterreadspeed) + 1;
					}else {
						typedlettercontents.push(lettercontents[currentline]);
						cursor += lettercontents[currentline].length;
					}
					currentline++;
				}
				
				for (i in 0 ... typedlettercontents.length) {
					if(i == 5 || i == 6){
						Draw.letterterminalprint(Gfx.screenwidthmid - Std.int(Text.width(lettercontents[i]) / 2), liney + i, typedlettercontents[i], 0x888888);
					}else {
					  Draw.letterterminalprint(Gfx.screenwidthmid - Std.int(Text.width(lettercontents[i]) / 2), liney + i, typedlettercontents[i]);		
					}
				}
			case "destroyletter":
				Draw.terminalprint(Gfx.CENTER, liney, "Destroy the letter?");			
			case "readnow":
				var cl:Int = Inventory.getitemlistnumfromletter(Inventory.currentletter);
				liney = 13 - Inventory.itemlist[cl].descriptionsize;
				Draw.terminalprint(Gfx.CENTER, liney - 3, "It's a letter.");
				for (i in 0 ... Inventory.itemlist[cl].descriptionsize) {
					Draw.terminalprint(Gfx.CENTER, liney + i, Inventory.itemlist[cl].description[i]);
				}
			case "inventory":
				if (currentmenu < menusize-1) {
					liney = 7 - Inventory.itemlist[Inventory.inventory[currentmenu]].descriptionsize;
					for (i in 0 ... Inventory.itemlist[Inventory.inventory[currentmenu]].descriptionsize) {
						Draw.terminalprint(Gfx.CENTER, liney + i, Inventory.itemlist[Inventory.inventory[currentmenu]].description[i]);
					}
					if (Inventory.itemlist[Inventory.inventory[currentmenu]].type == Inventory.WEAPON) {
						Draw.rterminalprint(31, 0, "WEAPON", Col.rgb(96, 96, 96));
						if (Inventory.itemlist[Inventory.inventory[currentmenu]].lethal) {
							if(Help.slowsine%32>=16){
								Draw.rterminalprint(31, 1, "LETHAL", Col.rgb(255, 96, 96));
							}else {
								Draw.rterminalprint(31, 1, "LETHAL", Col.rgb(128, 96, 96));
							}
						}else {
							Draw.rterminalprint(31, 1, "NON LETHAL", Col.rgb(96, 96, 255));
						}
						Draw.terminalprint(1, 0, "WALK INTO ENEMY TO USE WHEN EQUIPPED", 0xAADDAA);
					}
					if (Inventory.itemlist[Inventory.inventory[currentmenu]].type == Inventory.GADGET) {
						Draw.rterminalprint(31, 0, "GADGET", Col.rgb(96, 96, 96));
						if (Inventory.itemlist[Inventory.inventory[currentmenu]].lethal) {
							if(Help.slowsine%32>=16){
								Draw.rterminalprint(31, 1, "LETHAL", Col.rgb(255, 96, 96));
							}else {
								Draw.rterminalprint(31, 1, "LETHAL", Col.rgb(128, 96, 96));
							}
						}else{
							Draw.rterminalprint(31, 1, "NON LETHAL", Col.rgb(96, 96, 255));
						}
						Draw.rterminalprint(29, liney + Inventory.itemlist[Inventory.inventory[currentmenu]].descriptionsize+1, Inventory.itemlist[Inventory.inventory[currentmenu]].multiname+": x" + Std.string(Inventory.inventory_count[currentmenu]), Col.rgb(164, 164, 255));
						Draw.terminalprint(1, 0, "PRESS SPACE TO USE WHEN EQUIPPED", 0xAADDAA);
					}
					if (Inventory.itemlist[Inventory.inventory[currentmenu]].type == Inventory.USEABLE) {
						Draw.rterminalprint(29, 1, "ITEM", Col.rgb(96, 96, 96));
						Draw.rterminalprint(29, liney + Inventory.itemlist[Inventory.inventory[currentmenu]].descriptionsize+1, "x" + Std.string(Inventory.inventory_count[currentmenu]), Col.rgb(164, 164, 255));
					}
					if (Inventory.itemlist[Inventory.inventory[currentmenu]].type == Inventory.TREASURE) {
						Draw.rterminalprint(29, 1, "ITEM", Col.rgb(96, 96, 96));
						Draw.rterminalprint(29, liney + Inventory.itemlist[Inventory.inventory[currentmenu]].descriptionsize+1, "x" + Std.string(Inventory.inventory_count[currentmenu]), Col.rgb(164, 164, 255));
					}
				}
			case "error":
				Draw.terminalprint(Gfx.CENTER, liney, "ERROR! ERROR! ABORT! ABORT!");
			//default:
				//Draw.terminalprint(Gfx.CENTER, liney, "\"" + showscript + "\"");
		}
	}
	
	public static function backtogame():Void {
    textmode = 0;
		if (Inventory.changedequippedarmor) {
			Inventory.changedequippedarmor = false;
		}
		if (Inventory.changedequippedweapon && Inventory.changedequippedgadget) {
			Inventory.changedequippedweapon = false;
			Inventory.changedequippedgadget = false;
			Obj.entities[Obj.getplayer()].setmessage("Equipped " + Inventory.itemlist[Inventory.equippedweapon].name+ " and " +Inventory.itemlist[Inventory.equippedgadget].name + "!", "player");
		}else if (Inventory.changedequippedweapon) {
			Inventory.changedequippedweapon = false;
			Obj.entities[Obj.getplayer()].setmessage("Equipped " + Inventory.itemlist[Inventory.equippedweapon].name + "!", "player");
		}else if (Inventory.changedequippedgadget) {
			Inventory.changedequippedgadget = false;
			Obj.entities[Obj.getplayer()].setmessage("Equipped " + Inventory.itemlist[Inventory.equippedgadget].name + "!", "player");
		}
	}
	
	public static function createmenu(t:String):Void {
		clearmenucol();
		menusize = 1;
		showscript = t;
		currentmenu = 0;
		
		switch(t) {
			case "drink_question":
				menuoptions[0] = "Drink";
				menuoptions[1] = "Don't drink";
				menusize = 2;
			case "destroyletter":
				menuoptions[0] = "Yes";
				menuoptions[1] = "No";
				menusize = 2;
			case "gameoptions":
				//Main game options menu
				menusize = 0;
				/*
				if (equippedgadget == 2) {
					menuoptions[menusize] = "Use Tazer";		menusize++;
				}
				if (equippedweapon == 3) {
					menuoptions[menusize] = "Stabby Stabby";		menusize++;
				}
				*/
				menuoptions[menusize] = "Open inventory";		menusize++;
				menuoptions[menusize] = "back";		menusize++;
				/*
				if (availableaction == Localworld.DOOR){
					menuoptions[1] = "Pick lock";
				}else {
					menuoptions[1] = "and nothing else";
				}*/
			case "inventory":
				for (i in 0 ... Inventory.numitems) {
					menuoptions[i] = Inventory.itemlist[Inventory.inventory[i]].name;
					/*
					if (Game.equippedarmor == Game.inventory[i]) {
						menuoptions[i] = Game.itemlist[Game.inventory[i]].name + " (equipped)";
						menucol[i] = 1;
					}
					*/
					/*
					if (Inventory.equippedweapon == Inventory.inventory[i] && Inventory.itemlist[Inventory.inventory[i]].type == Inventory.WEAPON) {
						menuoptions[i] = Inventory.itemlist[Inventory.inventory[i]].name + " (close range equipped)";
						menucol[i] = 1;
					}
					*/
					if (Inventory.equippedgadget == Inventory.inventory[i] && Inventory.itemlist[Inventory.inventory[i]].type == Inventory.GADGET) {
						menuoptions[i] = Inventory.itemlist[Inventory.inventory[i]].name + " (equipped)";
						menucol[i] = 2;
					}
				}
				menuoptions[Inventory.numitems] = "back";
				menusize = Inventory.numitems+1;
			default:
				menuoptions[0] = "";
				menusize = 1;	
		}
	}
	
	public static function init():Void {
		for (i in 0 ... 120){
			menuoptions.push("");
			menucol.push(0);
		}
		menusize = 0;
		currentmenu = 0;
	}
	
	public static function clearmenucol():Void {
		for (i in 0...120) {
			menucol[i] = 0;
		}
	}
	
	public static var menuoptions:Array<String> = new Array<String>();
	public static var menucol:Array<Int> = new Array<Int>();
	public static var menusize:Int; 
	public static var currentmenu:Int = 0;
	public static var menuoffset:Int;
	public static var showscript:String = "none";
	public static var textmode:Int = 0;
	public static var availableaction:Int = 0;
}