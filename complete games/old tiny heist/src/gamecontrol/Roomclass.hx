package gamecontrol;

import haxegon.*;
import gamecontrol.misc.*;
import config.*;
import modernversion.*;
import terrylib.*;

class Roomclass {
	public function new() {
		for (j in 0 ... 20) {
			for (i in 0 ... 20) {
				contents.push(0);
				odds.push(0);
			}
		}
		
		for (i in 0...30) {
			vmult.push(0);
			connections.push(new Roomconnection());
			
			connectedrooms.push(0);
		}
		numconnectedrooms = 0;
	}
	
	public function changemapsize(w:Int, h:Int):Void {
	  width = w; height = h;
		for (i in 0 ... height) {
			vmult[i] = i * width;
		}
	}
	
	public function clear():Void {
		for (j in 0 ... 20) {
			for (i in 0 ... 20) {
				contents[i + (j*20)] = 0;
				contents[i + (j*20)] = 0;
			}
		}
		numconnections = 0;
		numconnectedrooms = 0;
		grounded = false;
	}
	
	public function load(x:Int, y:Int, _category:String, _roomnumber:Int):Void {
		setrect(x, y, Roomcache.width(_category, _roomnumber), Roomcache.height(_category, _roomnumber));
		category = _category;
		roomnumber = _roomnumber;
		numconnectedrooms = 0;
		grounded = false;
		doorodds = 2;
		if (Help.isinstring(category, "ripple")) {
			doorodds = 1;
		}else if (Help.isinstring(category, "exit")) {
			doorodds = 3;
		}
		
		fillcontents();
		makeconnectionlist();
	}
	
	public function setrect(_x:Int, _y:Int, _w:Int, _h:Int):Void {
		x = _x;
		y = _y;
		changemapsize(_w, _h);
	}
	
	/** True if point (xp,yp) is in the room */
	public function contains(xp:Int, yp:Int):Bool {
		if (xp >= x && yp >= y) {
			if (xp < x + width && yp < y + height) {
				return true;
			}
		}
		return false;
	}
	
	/** For placing the actual block on the level! */
	public function blockat(xp:Int, yp:Int):Int {
		/*
		blocks.push(new Blocktype("Locked Door", c("O"), "doorgreen"));
		
		blocks.push(new Blocktype("Any Collectable", c("?"), "white"));
		blocks.push(new Blocktype("Any Treasure", c("$"), "yellow"));
		blocks.push(new Blocktype("High Value", c("!"), "lightyellow", 1));
		
		blocks.push(new Blocktype("Any Item", c("*"), "blue"));
		blocks.push(new Blocktype("Health Pack", c("+"), "lightblue", 1));
		blocks.push(new Blocktype("Key", 12, "doorgreen", 1));
		
		//blocks.push(new Blocktype("Any Weapon", c("/"), "pink"));
		
		blocks.push(new Blocktype("Any Gadget", 21, "green"));
		blocks.push(new Blocktype("Something new", 19, "lightgreen", 1));
		blocks.push(new Blocktype("Ammo", c("A"), "lightgreen", 1));
		blocks.push(new Blocktype("Fire Extinguisher", 159, "lightgreen", 1));
		
		blocks.push(new Blocktype("Any Enemy", 234, "red"));
		blocks.push(new Blocktype("Guard", c("G"), "lightred", 1));
		blocks.push(new Blocktype("Clockwise", c(">"), "lightred", 2));
		blocks.push(new Blocktype("Anti-Clockwise", c("<"), "lightred", 2));
		blocks.push(new Blocktype("Laser Guard", c("E"), "lightred", 1));
		blocks.push(new Blocktype("Clockwise", 16, "lightred", 2));
		blocks.push(new Blocktype("Anti-Clockwise", 17, "lightred", 2));
		blocks.push(new Blocktype("Dog", c("D"), "lightred", 1));
		blocks.push(new Blocktype("Light Drone", 15, "lightred", 1));
		blocks.push(new Blocktype("Laser Drone", 162, "lightred", 1));
		blocks.push(new Blocktype("Bot", 233, "lightred", 1));
		blocks.push(new Blocktype("Rook", 165, "lightred", 1));
		blocks.push(new Blocktype("Fireman", c("F"), "lightred", 1));
		blocks.push(new Blocktype("Terminator", 234, "lightred", 1));
		*/
		temp = at(xp - x, yp - y);
		switch(temp) {
			case 46:
				//FLOOR
				return Localworld.FLOOR;
			case 177: 
				return Localworld.WALL; //Actual wall
			case 7: 
				return Localworld.WALL;   //Connection
		  case 32:
				return Localworld.BACKGROUND; //Background
		  case 79:
				//Regular Door
				return Localworld.DOOR;
		  case 38:
				//Locked door
				return Localworld.LOCKEDDOOR;
		  case 240:
				//Stairs
				Game.addplacement("stairs", "stairs", xp, yp, 0);
				return Localworld.FLOOR;
      case 63:
				//Any item
				Game.addplacement("collectable", "any", xp, yp, 0);
				return Localworld.FLOOR;
		  case 12:
				//Key
				return Localworld.KEY;
      case 24:
				//An ok item
				Generator.placelater(xp, yp, "item", Rand.ppickstring(
				  Item.DRILL, Item.LIGHTBULB, Item.FIRSTAIDKIT, Item.SIGNALJAMMER,
					Weapon.SKATEBOARD, Weapon.LEAFBLOWER, Item.BANANAPEEL
				));
				return Localworld.FLOOR;
			case 25:
				//A great item
				Generator.placelater(xp, yp, "item", Rand.ppickstring(
				  Item.DRILL, Item.TIMESTOPPER, Item.CARDBOARDBOX, Weapon.TELEPORTER,
					Weapon.PISTOL, Weapon.FIREEXTINGUISHER, Weapon.SWORD, Item.BOMB
				));
				return Localworld.FLOOR;
			case 21:
				//Pistol
				Generator.placelater(xp, yp, "item", Weapon.PISTOL);
				return Localworld.FLOOR;
			case 23:
				//Drill
				Generator.placelater(xp, yp, "item", Item.DRILL);
				return Localworld.FLOOR;
			case 14:
				//Sword
				Generator.placelater(xp, yp, "item", Weapon.SWORD);
				return Localworld.FLOOR;
			case 16:
				//Leafblower
				Generator.placelater(xp, yp, "item", Weapon.LEAFBLOWER);
				return Localworld.FLOOR;
			case 4:
				//Lightbulb
				Generator.placelater(xp, yp, "item", Item.LIGHTBULB);
				return Localworld.FLOOR;
			case 90:
				//Portable door
				Generator.placelater(xp, yp, "item", Item.PORTABLEDOOR);
				return Localworld.FLOOR;
			case 78:
				//Bomb
				Generator.placelater(xp, yp, "item", Item.BOMB);
				return Localworld.FLOOR;
		  case 36:
				//Gem
				Generator.placelater(xp, yp, "treasure", "gem");
				return Localworld.FLOOR;
			case 68:
				//DOG
				Generator.placelater(xp, yp, "enemy", "dog");
				return Localworld.FLOOR;
			case 83:
				//SENTINAL
				Generator.placelater(xp, yp, "enemy", "sentinal");
				return Localworld.FLOOR;
			case 76:
				//LASER SENTINAL
				Generator.placelater(xp, yp, "enemy", Enemy.LASERSENTINAL);
				return Localworld.FLOOR;
			case 67:
				//CAMERA
				Generator.placelater(xp, yp, "enemy", "camera");
				return Localworld.FLOOR;
			case 88:
				//LASER CAMERA
				Generator.placelater(xp, yp, "enemy", Enemy.LASERCAMERA);
				return Localworld.FLOOR;
			case 15:
				//Light Drone
				Generator.placelater(xp, yp, "enemy", "drone_light");
				return Localworld.FLOOR;
			case 18:
				//LASER Drone
				Generator.placelater(xp, yp, "enemy", Enemy.DRONE_LASER);
				return Localworld.FLOOR;
			case 233:
				//ROBOT
				Generator.placelater(xp, yp, "enemy", Enemy.ROBOT);
				return Localworld.FLOOR;
			case 165:
				//ROOK
				Generator.placelater(xp, yp, "enemy", Enemy.ROOK);
				return Localworld.FLOOR;
			case 66:
				//BOMBBOT
				Generator.placelater(xp, yp, "enemy", "bombbot");
				return Localworld.FLOOR;
			case 70:
				//FIREMAN
				Generator.placelater(xp, yp, "enemy", Enemy.FIREMAN);
				return Localworld.FLOOR;
			case 234:
				//Terminator
				Generator.placelater(xp, yp, "enemy", Enemy.TERMINATOR);
				return Localworld.FLOOR;
			case 71:
				//GUARD
				Generator.placelater(xp, yp, "enemy", "guard");
				return Localworld.FLOOR;
			case 72:
				//GUARD, Clockwise UP
				Generator.placelater(xp, yp, "enemy", "guard_clockwise_u");
				return Localworld.FLOOR;
			case 73:
				//GUARD, Clockwise RIGHT
				Generator.placelater(xp, yp, "enemy", "guard_clockwise_r");
				return Localworld.FLOOR;
			case 74:
				//GUARD, Clockwise DOWN
				Generator.placelater(xp, yp, "enemy", "guard_clockwise_d");
				return Localworld.FLOOR;
			case 75:
				//GUARD, Clockwise LEFT
				Generator.placelater(xp, yp, "enemy", "guard_clockwise_l");
				return Localworld.FLOOR;
			case 69:
				//LASERGUARD
				Generator.placelater(xp, yp, "enemy", Enemy.LASERGUARD);
				return Localworld.FLOOR;
			case 2:
				//NPC
				Generator.placelater(xp, yp, "npc", "Key");
				return Localworld.FLOOR;
			case 3:
				//Item NPC
				Generator.placelater(xp, yp, "npc", "randomitem");
				return Localworld.FLOOR;
			case 144:
				//Tripwire Up
				Generator.placelater(xp, yp, "enemy", Enemy.TRIPWIRE_UP);
				return Localworld.FLOOR;
			case 145:
				//Tripwire Down
				Generator.placelater(xp, yp, "enemy", Enemy.TRIPWIRE_DOWN);
				return Localworld.FLOOR;
			case 146:
				//Tripwire Left
				Generator.placelater(xp, yp, "enemy", Enemy.TRIPWIRE_LEFT);
				return Localworld.FLOOR;
			case 147:
				//Tripwire Right
				Generator.placelater(xp, yp, "enemy", Enemy.TRIPWIRE_RIGHT);
				return Localworld.FLOOR;
			case 148:
				//Laserwire Up
				Generator.placelater(xp, yp, "enemy", Enemy.LASERWIRE_UP);
				return Localworld.FLOOR;
			case 149:
				//Laserwire Down
				Generator.placelater(xp, yp, "enemy", Enemy.LASERWIRE_DOWN);
				return Localworld.FLOOR;
			case 150:
				//Laserwire Left
				Generator.placelater(xp, yp, "enemy", Enemy.LASERWIRE_LEFT);
				return Localworld.FLOOR;
			case 151:
				//Laserwire Right
				Generator.placelater(xp, yp, "enemy", Enemy.LASERWIRE_RIGHT);
				return Localworld.FLOOR;
			default:
				if(Buildconfig.showtraces) trace("uncaught case " + temp + " in blueprint " + category + "/" + roomnumber);
		}
		return Localworld.FLOOR;
	}
	
	public function at(xp:Int, yp:Int):Int {
		if (xp >= 0 && yp >= 0 && xp < width && yp < height) {
			return contents[xp + vmult[yp]];
		}
		return 0;
	}
	
	public function pset(xp:Int, yp:Int, t:Int):Void {
		if (xp >= 0 && yp >= 0 && xp < width && yp < height) {
			contents[xp + vmult[yp]] = t;
		}
	}
	
	public function psetodds(xp:Int, yp:Int, t:Int):Void {
		if (xp >= 0 && yp >= 0 && xp < width && yp < height) {
			odds[xp + vmult[yp]] = t;
		}
	}
	
	public function fillcontents():Void {
		//Based on the category and number of room, load the roomstring into the local arrays.
		roomarray = Roomcache.getroomstring(category, roomnumber);
		temp = 2;
		
		for (j in 0 ... height) {
			for (i in 0 ... width) {
				pset(i, j, roomarray[temp]);
				psetodds(i, j, roomarray[temp + 1]);
				temp += 2;
			}
		}
	}
	
	public function makeconnectionlist():Void {
		//Fill the array with unused connections to this room. Connections are a simple class
		//containing x, y, direction, in use bool.
		numconnections = 0;
		for (j in 0 ... height) {
			for (i in 0 ... width) {
				if (contents[i + vmult[j]] == 7) { //Connection tile num
					temp = Help.NODIRECTION;
					//If the connection is on the border, then the direction is obvious
					if (i == 0) {
						temp = Help.LEFT;
					}else if (j == 0) {
						temp = Help.UP;
					}else if (i == width - 1) {
						temp = Help.RIGHT;
					}else if (j == height - 1) {
						temp = Help.DOWN;
					}else {
						//If it's not, then we just check for adjacent background space.
						if (at(i, j - 1) == 32) {
							temp = Help.UP;
						}else if (at(i, j + 1) == 32) {
							temp = Help.DOWN;
						}else if (at(i - 1, j) == 32) {
							temp = Help.LEFT;
						}else if (at(i + 1, j) == 32) {
							temp = Help.RIGHT;
						}else {
							if(Buildconfig.showtraces) trace("Error: Can't figure out what direction a room connection point is facing.");
							temp = Help.NODIRECTION;
						}
					}
					connections[numconnections].set(i, j, temp);
					numconnections++;
				}
			}
		}
	}
	
	public function getconnection(d:Int = -1):Int {
		//Randomly pick a connection point that faces a given direction. Use a temporary array
		//from Localworld for this!
		Generator.numconnectionsort = 0;
		for (i in 0 ... numconnections) {
			if (connections[i].dir == d || d == -1 && !connections[i].inuse) {
				Generator.connectionsort[Generator.numconnectionsort] = i;
				Generator.numconnectionsort++;
			}
		}
		
		if (Generator.numconnectionsort > 0) {
			var pick:Int = Rand.pint(0, Generator.numconnectionsort - 1);
			connections[pick].inuse = true;
			return Generator.connectionsort[pick];
		}else {
			return -1;
		}
	}
	
	public function connectto(thisroom:Int, newroom:Int):Void {
		//Connect this room - this is different from connections!
		var alreadyconnected:Bool = false;
		for (i in 0 ... numconnectedrooms) {
			if (connectedrooms[i] == newroom) {
				alreadyconnected = true;
				if (grounded) {
					Generator.rooms[newroom].groundroom();
				}
			}
		}
		
		if (!alreadyconnected){
			connectedrooms[numconnectedrooms] = newroom;
			numconnectedrooms++;
			
			Generator.rooms[newroom].connectto(newroom, thisroom);
			if (grounded) Generator.rooms[newroom].groundroom();
		}
	}
	
	public function groundroom():Void {
		if (!grounded) {
			grounded = true;
			//Ground any rooms that we're connected to
			for (i in 0 ... numconnectedrooms) {
				Generator.rooms[i].groundroom();
			}
		}
	}
	
	public function isconnectedtoroom(t:Int):Bool {
		for (i in 0 ... numconnectedrooms) {
			if (connectedrooms[i] == t) return true;
		}
		return false;
	}
	
	public var x:Int;
	public var y:Int;
	public var width:Int;
	public var height:Int;
	public var temp:Int;
	public var grounded:Bool;
	public var doorodds:Int;
	
	public var category:String;
	public var roomnumber:Int;
	public var roomarray:Array<Int>;
	public var facing:Int;
	
	public var contents:Array<Int> = new Array<Int>();
	public var odds:Array<Int> = new Array<Int>();
	public var vmult:Array<Int> = new Array<Int>();
	
	public var connections:Array<Roomconnection> = new Array<Roomconnection>();
	public var numconnections:Int;
	
	public var connectedrooms:Array<Int> = new Array<Int>();
	public var numconnectedrooms:Int;
}