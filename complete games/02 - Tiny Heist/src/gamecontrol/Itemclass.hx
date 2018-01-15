package gamecontrol;

import haxegon.*;
import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;
	
class Itemclass{
	public function new(t:Int):Void {
		for (i in 0 ... 10) {
			description.push("");
		}
		
		clear();
		inititem(t);
	}
	
	public function clear():Void {
		name = "";
		for (i in 0 ... 10) {
			description[i] = "";
		}
		descriptionsize = 0;
		power = 0; ability = 0; type = Inventory.TREASURE;
		lethal = false; letter = "";
		typical = 1;
		cost = 3;
		hasmultipleshots = false;
		multiname = "CHARGE";
	}
	
	public function inititem(t:Int):Void {
		index = t;
		r = -1;
		switch(t) {
			case 0:
				name = "Photograph";
				
				description[0] = "An old, faded photograph of what the";
				description[1] = "world looked like before the whole";
				description[2] = "armageddon thing happened.";
				
				descriptionsize = 3;
				
				type = Inventory.TREASURE;
			case 1:
				name = "First Aid Kit";
				
				description[0] = "Restores some of your health.";
				descriptionsize = 1;
				
				type = Inventory.USEABLE;
				
				character = String.fromCharCode(6);
				r = 128; g = 225; b = 128;
				highlightcol = Col.rgb(144, 255, 144);
			case 2:
				name = "Tazer";
				
				description[0] = "Can knock someone out at very close range.";
				description[1] = "(Between 1-5 spaces).";
				descriptionsize = 2;
				
				multiname = "CHARGE";
				
				type = Inventory.GADGET;
				typical = 8;
			case 3:
				name = "Time Stopper";
				
				description[0] = "Stops time.";
				description[1] = "";
				description[2] = "If you attack someone or use a gadget while";
				description[3] = "time is stopped, time will start again!";
				descriptionsize = 4;
				
				type = Inventory.USEABLE;
				
				character = String.fromCharCode(13);
				r = 128; g = 128; b = 255;
				highlightcol = Col.rgb(128, 128, 255);
			case 4:
				name = "Pistol";
				
				description[0] = "Multiple uses. Very noisy, but effective!";
				description[2] = "Destroys whatever it aims at, but alerts";
				description[3] = "everything on the current floor to you.";
				descriptionsize = 4;
				hasmultipleshots = true;
				multiname = "AMMO";
				
				type = Inventory.GADGET;
				lethal = true;
				typical = 4;
			case 5:
				name = "Signal Jammer";
				
				description[0] = "Temporarily disable nearby cameras and sentinels.";
				descriptionsize = 1;
				
				type = Inventory.USEABLE;
				
				character = String.fromCharCode(5);
				r = 140; g = 140; b = 255;
				highlightcol = Col.rgb(174, 174, 255);
			case 6:
				name = "Cardboard Box";
				
				description[0] = "Hide from enemies! You might not be able to";
				description[1] = "see where you're going when you wear it, though.";
				descriptionsize = 2;
				
				type = Inventory.USEABLE;
				
				character = String.fromCharCode(8);
				r = 192; g = 192; b = 192;
				highlightcol = Col.rgb(226, 226, 226);
			case 7:
				name = "Skateboard";
				
				description[0] = "Skate forward until you bump into something!";
				descriptionsize = 1;
				
				multiname = "CHARGE";
				
				type = Inventory.GADGET;
				typical = 3;
				hasmultipleshots = true;
				
				character = "d";
				r = 96; g = 255; b = 96;
				highlightcol = Col.rgb(96, 255, 96);
			case 8:
				name = "Tranquilizer";
				
				description[0] = "Shoots tranquilizer darts. Puts human and animal";
				description[1] = "enemies to sleep for a while.";
				description[2] = "";
				description[3] = "No effect on robots.";
				descriptionsize = 4;
				multiname = "AMMO";
				
				type = Inventory.GADGET;
				typical = 3;
			case 9:
				name = "Sniper Rifle";
				
				description[0] = "Kill someone from a long way away, without";
				description[1] = "making any noise.";
				descriptionsize = 2;
				multiname = "AMMO";
				
				type = Inventory.GADGET;
				lethal = true;
				typical = 3;
			case 10:
				name = "Knockout Gas";
				
				description[0] = "Knocks out nearby human and animal enemies.";
				description[1] = "No effect on robots.";
				descriptionsize = 2;
				multiname = "CANISTER";
				
				type = Inventory.GADGET;
				typical = 4;
			case 11:
				name = "Lightbulb";
				
				description[0] = "Switch on the lights so you can see properly!";
				descriptionsize = 1;
				
				type = Inventory.USEABLE;
				
				character = String.fromCharCode(4);
				r = 255; g = 255; b = 24;
				highlightcol = Col.rgb(255, 255, 48);
			case 12:
				name = "Drill";
				
				description[0] = "Make a hole in a wall big enough to walk through.";
				description[1] = "Drills all the way through to the other side.";
				descriptionsize = 2;
				
				type = Inventory.USEABLE;
				typical = 3;
				
				character = String.fromCharCode(7);
				r = 255; g = 255; b = 255;
				highlightcol = Col.rgb(255, 255, 255);
			case 13:
				name = "Letter from Terry";
				
				description[0] = "The back reads, \"from Terry\".";
				description[2] = "Some kind of instructions, maybe?";
				descriptionsize = 3;
				
				letter = "terryletter";
				
				type = Inventory.LETTER;
			case 14:
				name = "Valuable Art";
				
				description[0] = "A very valuable art. Highly sought after";
				description[1] = "as a source of fuel.";
				
				descriptionsize = 2;
				
				type = Inventory.TREASURE;
			case 15:
				name = "Ice Cube";
				
				description[0] = "Swallow to make you immune to fire for";
				description[1] = "a short time.";
				descriptionsize = 2;
				
				type = Inventory.USEABLE;
			case 16:
				name = "World Map";
				
				description[0] = "A rough sketch of the city, updated";
				description[1] = "throughout your travels.";
				
				descriptionsize = 2;
				
				type = Inventory.MAP;
			case 17:
				name = "Storeroom Inventory";
				
				description[0] = "";
				descriptionsize = 1;
				
				letter = "storeroomletter";
				
				type = Inventory.LETTER;
			case 18:
				name = "Fire Extinguisher";
				
				description[0] = "Puts out fires! Also stuns whatever";
				description[1] = "it hits - cameras, robots, everything.";
				descriptionsize = 2;
				
				character = String.fromCharCode(41);
				
				r = 225; g = 128; b = 128;
				highlightcol = Col.rgb(144, 255, 144);
				type = Inventory.GADGET;
				hasmultipleshots = true;
				typical = 6;
			case 19:
				name = "Matchstick";
				
				description[0] = "Probably completely safe to use.";
				descriptionsize = 1;
				
				type = Inventory.GADGET;
				typical = 10;
				
				character = String.fromCharCode(37);
				r = 230; g = 136; b = 60;
				highlightcol = Col.rgb(240, 177, 130);
			case 20:
				name = "Sword";
				
				description[0] = "Deadly sword slices through enemies.";
				description[1] = "";
				description[2] = "When used, dash forwards until you hit a";
				description[3] = "wall, and destroy everything in your path.";
				descriptionsize = 4;
				multiname = "CHARGES";
				
				type = Inventory.GADGET;
				lethal = true;
				typical = 6;
				
				character = String.fromCharCode(14);
				r = 255; g = 255; b = 255;
				highlightcol = Col.rgb(255, 255, 255);
			case 21:
				name = "Leaf Blower";
				
				description[0] = "Shoots a powerful gust of air that";
				description[1] = "knocks back anything chasing you.";
				descriptionsize = 2;
				
				multiname = "CHARGE";
				
				type = Inventory.GADGET;
				typical = 8;
				
				character = String.fromCharCode(16);
				r = 96; g = 255; b = 96;
				highlightcol = Col.rgb(96, 255, 96);
			case 22:
				name = "Teleporter";
				
				description[0] = "Miniture teleporting device!";
				description[1] = "";
				description[2] = "Teleports you somewhere nearby.";
				description[3] = "Can be used multiple times!";
				descriptionsize = 4;
				
				multiname = "CHARGE";
				type = Inventory.GADGET;
				typical = 3;
				
				hasmultipleshots = true;
				
				character = String.fromCharCode(162);
				r = 87; g = 241; b = 238;
				highlightcol = Col.rgb(176, 246, 245);
			case 23:
				name = "EMP Blaster";
				
				description[0] = "Knocks out all nearby machines.";
				description[1] = "No effect on humans.";
				descriptionsize = 2;
				multiname = "CHARGE";
				
				type = Inventory.GADGET;
				typical = 4;
			case 24:
				name = "Lockdown";
				
				description[0] = "Shuts all doors in a level.";
				descriptionsize = 1;
				
				type = Inventory.USEABLE;
			case 25:
				name = "Portable Door";
				
				description[0] = "Instead of door, portable door!";
				description[0] = "Can be placed in walls.";
				descriptionsize = 2;
				
				type = Inventory.USEABLE;
				
				character = String.fromCharCode(10);
				r = Col.getred(0xa04c14);
				g = Col.getgreen(0xa04c14);
				b = Col.getblue(0xa04c14);
				highlightcol = 0xea7a30;
			case 26:
				name = "Banana";
				
				description[0] = "Delicious Banana! Be careful to properly dispose";
				description[1] = "of the banana peel afterwards, or pursuing";
				description[2] = "guards may slip on it.";
				descriptionsize = 3;
				
				type = Inventory.USEABLE;
				
				character = String.fromCharCode(160);
				r = Col.getred(0xe9e573);
				g = Col.getgreen(0xe9e573);
				b = Col.getblue(0xe9e573);
				highlightcol = 0xf8f5c2;
			case 27:
				name = "Bomb";
				
				description[0] = "Explodes, destroying everything up to three";
				description[1] = "squares away.";
				description[2] = "";
				description[3] = "Anything left after you use this is alerted!";
				descriptionsize = 4;
				multiname = "CANISTER";
				
				type = Inventory.GADGET;
				typical = 4;
				
				character = String.fromCharCode(163);
				r = Col.getred(0x7dc8f9);
				g = Col.getgreen(0x7dc8f9);
				b = Col.getblue(0x7dc8f9);
				highlightcol = 0xafddfb;
			case 28:
				name = "Helix Wing";
				
				description[0] = "Summons a helicopter to immediately pick you up";
				description[1] = "and bring you home. Can be used from anywhere.";
				description[2] = "";
				description[3] = "Worth 10 gems at the end if you don't use it...";
				descriptionsize = 4;
				
				type = Inventory.USEABLE;
				
				character = String.fromCharCode(31);
				r = Col.getred(0xe297f9);
				g = Col.getgreen(0xe297f9);
				b = Col.getblue(0xe297f9);
				highlightcol = 0xe297f9;
			case 29:
				name = "Error";
				
				descriptionsize = 0;
				
				type = Inventory.GADGET;
				
				character = String.fromCharCode(59);
				r = Col.getred(0xe9e573);
				g = Col.getgreen(0xe9e573);
				b = Col.getblue(0xe9e573);
				highlightcol = 0xf8f5c2;
		}
		
		if (r == -1){
			if (type == Inventory.USEABLE) {
				character = "*";
				r = 96; g = 96; b = 255;
				highlightcol = Col.rgb(144, 144, 255);
			}else if (type == Inventory.WEAPON) {
				character = "/";
				r = 225; g = 128; b = 128;
				highlightcol = Col.rgb(144, 255, 144);
			}else if (type == Inventory.GADGET) {
				character = String.fromCharCode(21);
				r = 255; g = 128; b = 128;
				highlightcol = Col.rgb(255, 144, 144);
			}else if (type == Inventory.TREASURE) {
				character = "$";
				r = 196; g = 196; b = 32;
				highlightcol = Col.rgb(255, 255, 96);
			}else if (type == Inventory.LETTER) {
				character = String.fromCharCode(20);
				r = 180; g = 180; b = 180;
				highlightcol = Col.rgb(224, 224, 224);
			}
		}
	}
	
	//Fundamentals
	public var name:String;
	public var description:Array<String> = new Array<String>();
	public var descriptionsize:Int;
	public var power:Int;
	public var ability:Int;
	public var type:Int;
	public var lethal:Bool;
	public var letter:String;
	public var typical:Int;
	public var multiname:String;
	public var cost:Int;
	public var hasmultipleshots:Bool;
	
	public var character:String;
	public var r:Int;
	public var g:Int;
	public var b:Int;
	public var highlightcol:Int;
	
	public var index:Int;
}
