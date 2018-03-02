package gamecontrol;

import modernversion.AIDirector;
import modernversion.Modern;
import modernversion.Weapon;
import openfl.geom.*;
import config.*;
import haxegon.*;
import terrylib.*;
import gamecontrol.misc.*;

class Generator {
	public static function init() {
		tpoint = new Point();
		tpoint2 = new Point();
		for (i in 0 ... 25) rooms.push(new Roomclass());
		numrooms = 0;
		
		for (i in 0 ... 10) lines.push(new Line());
		numlines = 0;
		
		for (i in 0 ... 100) connectionsort.push(0);
		numconnectionsort = 0;
		
		thingstoplace = new Numlist();
		thingstoplace_type = new Numlist();
		for (i in 0 ... 100) {
			xplace.push(0);
			yplace.push(0);
		}
	}
	
	public static function shift_thingstoplace(xoff:Int, yoff:Int):Void {
		for (i in 0 ... thingstoplace.length) {
			xplace[i] += xoff;
			yplace[i] += yoff;
		}
	}
	
	public static function placelater(x:Int, y:Int, thing:String, type:String):Void {
		xplace[thingstoplace.length] = x;
		yplace[thingstoplace.length] = y;
		thingstoplace.add(thing);
		thingstoplace_type.add(type);
	}
	
	public static function clearthingstoplace():Void {
		thingstoplace.clear();
		thingstoplace_type.clear();
	}
	
	public static function placethethings():Void {
		if(!rejectmap){
			for (i in 0 ... thingstoplace.length) {
				Obj.createentity(xplace[i], yplace[i], thingstoplace.list[i], thingstoplace_type.list[i], "preplaced");
			}
		}
		
		clearthingstoplace();
	}
	
	public static function changemapsize(w:Int, h:Int):Void {
		World.changemapsize(w, h);
	}
	
	public static function clearmap():Void {
		if(!rejectmap){
			for (j in 0 ... World.mapheight) {
				for (i in 0 ... World.mapwidth) {
					World.placetile(i, j, Localworld.BACKGROUND);
				}
			}
		}
	}
	
	public static function randomwall():Void {
		World.placetile(Rand.pint(0, World.mapwidth - 1), Rand.pint(0, World.mapheight - 1), Localworld.WALL);
	}
	
	public static function checkfreespace(x:Int, y:Int, w:Int, h:Int, offset:Int = 0):Bool {
		x -= offset;
		y -= offset;
		w += offset * 2;
		h += offset * 2;
		//Check that the given rectangle doesn't contain anything except background
		if (x < 0) return false;
		if (y < 0) return false;
		for (j in y ... y + h) {
			for (i in x ... x + w) {
				if (World.at(i, j) != Localworld.BACKGROUND) return false;
				if (i >= World.mapwidth) return false;
				if (j >= World.mapheight) return false;
			}
		}
		return true;
	}
	
	public static function placerooms():Void {
		for (i in 0 ... numrooms) {
			placeactualroom(i);
		}
	}
	
	public static function placeactualroom(roomindex:Int = -1):Void {
		if (roomindex == -1) roomindex = numrooms - 1;
		for (j in rooms[roomindex].y ... rooms[roomindex].y + rooms[roomindex].height) {
			for (i in rooms[roomindex].x ... rooms[roomindex].x + rooms[roomindex].width) {
				tr = rooms[roomindex].blockat(i, j);
				if (tr > Localworld.BACKGROUND) {
					World.placetile(i, j, tr);
				}
			}
		}
	}
	
	public static function placeactualroom_nochecks(x:Int, y:Int, w:Int, h:Int, floortile:Int = -1, walltile:Int = -1):Void {
		if (floortile == -1) floortile = Localworld.FLOOR;
		if (walltile == -1) walltile = Localworld.WALL;
		
		for (j in y ... y + h) {
			for (i in x ... x + w) {
				World.placetile(i, j, floortile);
				if (i == x) World.placetile(i, j, walltile);
				if (i == x + w - 1) World.placetile(i, j, walltile);
				if (j == y) World.placetile(i, j, walltile);
				if (j == y + h - 1) World.placetile(i, j, walltile);
			}
		}
	}
	
	public static function clearrooms():Void {
		for (i in 0 ... numrooms) {
			rooms[i].clear();
		}
		numrooms = 0;
		
		clearmap();
	}
	
	public static function addroom(x:Int, y:Int, category:String, n:Int):Void {
		rooms[numrooms].load(x, y, category, n);
		numrooms++;
	}
	
	public static function addroom_rect(_x:Int, _y:Int, _w:Int, _h:Int):Void {
		rooms[numrooms].setrect(_x, _y, _w, _h);
		numrooms++;
	}
	
	public static function setbounds(position:String):Void {
		switch(position) {
			case "anywhere":
				boundx = 0; boundy = 0;
				boundw = World.mapwidth;
				boundh = World.mapheight;
			case "topleft", "tl", "lefttop", "lt":
				boundx = 0;
				boundy = 0;
				boundw = Std.int((World.mapwidth / 2) * 3);
				boundh = Std.int(World.mapheight / 2);
			case "topcenter", "tc", "centertop", "ct":
				boundx = Std.int(World.mapwidth / 6);
				boundy = 0;
				boundw = Std.int((World.mapwidth / 2) * 3);
				boundh = Std.int(World.mapheight / 2);
			case "topright", "tr", "righttop", "rt":
				boundx = Std.int(World.mapwidth / 3);
				boundy = 0;
				boundw = World.mapwidth - boundx;
				boundh = Std.int(World.mapheight / 2);
			case "middleleft", "ml", "leftmiddle", "lm":
				boundx = 0;
				boundy = Std.int(World.mapheight / 4);
				boundw = Std.int((World.mapwidth / 2)*3);
				boundh = Std.int(World.mapheight / 2);
			case "middlecenter", "mc", "centermiddle", "cm":
				boundx = Std.int(World.mapwidth / 6);
				boundy = Std.int(World.mapheight / 4);
				boundw = Std.int((World.mapwidth / 2)*3);
				boundh = Std.int(World.mapheight / 2);
			case "middleright", "mr", "rightmiddle", "rm":
				boundx = Std.int(World.mapwidth / 3);
				boundy = Std.int(World.mapheight / 4);
				boundw = World.mapwidth - boundx;
				boundh = Std.int(World.mapheight / 2);
			case "bottomleft", "bl", "leftbottom", "lb":
				boundx = 0;
				boundy = Std.int(World.mapheight / 2);
				boundw = Std.int((World.mapwidth / 2)*3);
				boundh = Std.int(World.mapheight / 2);
			case "bottomcenter", "bc", "centerbottom", "cb":
				boundx = Std.int(World.mapwidth / 6);
				boundy = Std.int(World.mapheight / 2);
				boundw = Std.int((World.mapwidth / 2)*3);
				boundh = Std.int(World.mapheight / 2);
			case "bottomright", "br", "rightbottom", "rb":
				boundx = Std.int(World.mapwidth / 3);
				boundy = Std.int(World.mapheight / 2);
				boundw = World.mapwidth - boundx;
				boundh = Std.int(World.mapheight / 2);
			case "top":
				boundx = 0;
				boundy = 0;
				boundw = World.mapwidth;
				boundh = Std.int(World.mapheight / 2);
			case "bottom":
				boundx = 0;
				boundy = Std.int(World.mapheight / 2);
				boundw = World.mapwidth;
				boundh = Std.int(World.mapheight / 2);
			case "middle":
				boundx = 0;
				boundy = Std.int(World.mapheight / 4);
				boundw = World.mapwidth;
				boundh = Std.int(World.mapheight / 2);
			case "left":
				boundx = 0;
				boundy = 0;
				boundw = Std.int((World.mapwidth / 2)*3);
				boundh = World.mapheight;
			case "right":
				boundx = Std.int(World.mapwidth / 2);
				boundy = 0;
				boundw = World.mapwidth - boundx;
				boundh = World.mapheight;
			case "center":
				boundx = Std.int(World.mapwidth / 6);
				boundy = 0;
				boundw = Std.int((World.mapwidth / 2)*3);
				boundh = World.mapheight;
		}
	}
	
	public static function setposition(position:String):Void {
		switch(position) {
			case "anywhere":
				boundx = 0; boundy = 0;
			case "topleft", "tl", "lefttop", "lt":
				boundx = 0;
				boundy = 0;
			case "topcenter", "tc", "centertop", "ct":
				boundx = Std.int(World.mapwidth / 2);
				boundy = 0;
			case "topright", "tr", "righttop", "rt":
				boundx = World.mapwidth - 1;
				boundy = 0;
			case "middleleft", "ml", "leftmiddle", "lm":
				boundx = 0;
				boundy = Std.int(World.mapheight / 2);
			case "middlecenter", "mc", "centermiddle", "cm":
				boundx = Std.int(World.mapwidth / 2);
				boundy = Std.int(World.mapheight / 2);
			case "middleright", "mr", "rightmiddle", "rm":
				boundx = World.mapwidth - 1;
				boundy = Std.int(World.mapheight / 2);
			case "bottomleft", "bl", "leftbottom", "lb":
				boundx = 0;
				boundy = World.mapheight - 1;
			case "bottomcenter", "bc", "centerbottom", "cb":
				boundx = Std.int(World.mapwidth / 2);
				boundy = World.mapheight - 1;
			case "bottomright", "br", "rightbottom", "rb":
				boundx = World.mapwidth - 1;
				boundy = World.mapheight - 1;
			case "top":
				boundx = Rand.pint(0, World.mapwidth - 1);
				boundy = 0;
			case "bottom":
				boundx = Rand.pint(0, World.mapwidth - 1);
				boundy = World.mapheight - 1;
			case "middle":
				boundx = Rand.pint(0, World.mapwidth - 1);
				boundy = Std.int(World.mapheight / 2);
			case "left":
				boundx = 0;
				boundy = Rand.pint(0, World.mapheight - 1);
			case "right":
				boundx = World.mapwidth -1;
				boundy = Rand.pint(0, World.mapheight - 1);
			case "center":
				boundx = Std.int(World.mapwidth / 2);
				boundy = Rand.pint(0, World.mapheight - 1);
		}
	}
	
	/** Roughly place a room where you want it */
	public static function roughplace(type:String, position:String, offset:Int = 5):Void {
		setposition(position);
		place(type, boundx, boundy, offset);
	}
	
	public static function fillrect(x:Int, y:Int, w:Int, h:Int, _border:Int, _inside:Int):Void {
		for (j in y ... y + h) {
			for (i in x ... x + w) {
				if (World.at(i, j) == Localworld.BACKGROUND) {
					if (i == x || j == y || i == x + w - 1 || j == y + h -1) {
						World.placetile(i, j, _border);
					}else {
						World.placetile(i, j, _inside);
					}
				}
			}
		}
	}
	
	/** Place a room exactly where you want it, with a small variable */
	public static function place(type:String, x:Int, y:Int, offset:Int = 5):Void {
		if (!rejectmap) {
			setbounds("anywhere");
			//Try to place a random room on the map of the given type.
			tx1 = -1; ty1 = -1;
			tx2 = -1; ty2 = -1;
			attempts = 500;
			
			while (!checkfreespace(tx1, ty1, tx2, ty2, 1) && attempts > 0) {
				tr = Rand.pint(0, Roomcache.numrooms(type) - 1);
				tx2 = Roomcache.width(type, tr); ty2 = Roomcache.height(type, tr);
				tx1 = x + Rand.pint(-offset, offset);
				ty1 = y + Rand.pint(-offset, offset);
				
				attempts--;
			}
			
			if (attempts > 0) {
				addroom(tx1, ty1, type, tr);
				placeactualroom();
			}else {
				rejectmap = true;
			}
		}
	}
	
	/** Place a room exactly where you want it, with a small variable */
	public static function exactplace(type:String, x:Int, y:Int):Void {
		if (!rejectmap) {
			tr = Rand.pint(0, Roomcache.numrooms(type) - 1);
				
			addroom(x, y, type, tr);
			placeactualroom();
		}
	}
	
	/** Position can be any combo of: top, middle, bottom and left, center, right */
	public static function randomroom(type:String, position:String = "anywhere"):Void {
		if (!rejectmap) {
			setbounds(position);
			
			//Try to place a random room on the map of the given type.
			tx1 = -1; ty1 = -1;
			attempts = 500;
			
			while (!checkfreespace(tx1, ty1, tx2, ty2, 1) && attempts > 0) {
				tr = Rand.pint(0, Roomcache.numrooms(type) - 1);
				tx2 = Roomcache.width(type, tr); ty2 = Roomcache.height(type, tr);
				tx1 = Rand.pint(boundx, boundx + boundw - tx2 - 1);
				ty1 = Rand.pint(boundy, boundy + boundh - ty2 - 1);
				
				attempts--;
			}
			
			if (attempts > 0) {
				//trace("Placing room: " + type + " " +Std.string(tr) + " (" + Std.string(tx1) + "," + Std.string(ty1) + ")-[" + Std.string(tx2) + "x" + Std.string(ty2) + "]");
				addroom(tx1, ty1, type, tr);
				placeactualroom();
				//placeactualroom_nochecks(tx1, ty1, tx2, ty2);
			}else {
				//trace("ERROR: FAILED TO PLACE ROOM, PLACING TINY");
				/*
				if (type != "tiny") {
					randomroom("tiny");
				}else {
					rejectmap = true;
				}*/
				rejectmap = true;
			}
		}
	}
	
	public static function addwalls():Void {
		if(!rejectmap){
			for (j in 0 ... World.mapheight) {
				for (i in 0 ... World.mapwidth) {
					//Current approach is to fill entire map with walls because it looks better...
					
					if (World.at(i, j) == Localworld.BACKGROUND) {
						World.placetile(i, j, Localworld.WALL);
					}
					
					/*
					if (World.at(i, j) == Localworld.FLOOR) {
						for (j2 in -1 ... 2) {
							for (i2 in -1 ... 2) {
								if (World.at(i + i2, j + j2) == Localworld.BACKGROUND) {
									World.placetile(i + i2, j + j2, Localworld.WALL);
								}
							}
						}
					}
					*/
				}
			}
		}
	}
	
	public static function dustwalls():Void {
		//This weird little function adds walls to the map with a random chance!
		//The idea is that you force the pathfinder to make nicer paths if you can't 
		//just hug walls, for example.
		var wallnearby:Bool = false;
		if(!rejectmap){
			for (j in 0 ... World.mapheight) {
				for (i in 0 ... World.mapwidth) {
					if (World.at(i, j) == Localworld.FLOOR) {
						wallnearby = false;
						for (j2 in -2 ... 3) {
							for (i2 in -2 ... 3) {
								if (World.at(i + i2, j + j2) == Localworld.WALL) {
									wallnearby = true;
								}
							}
						}
						
						if(wallnearby){
							for (j2 in -1 ... 2) {
								for (i2 in -1 ... 2) {
									if (World.at(i + i2, j + j2) == Localworld.BACKGROUND) {
										World.placetile(i + i2, j + j2, Localworld.BLOOD);
									}
								}
							}
						}
					}
				}
			}
			
			for (j in 0 ... World.mapheight) {
				for (i in 0 ... World.mapwidth) {
					if (World.at(i, j) == Localworld.BLOOD) {
						World.placetile(i, j, Localworld.WALL);
					}
					/*
					if (World.at(i, j) == Localworld.FLOOR) {
						for (j2 in -1 ... 2) {
							for (i2 in -1 ... 2) {
								if (World.at(i + i2, j + j2) == Localworld.BACKGROUND) {
									if(Rand.pbool() && Rand.pbool()){
										//World.placetile(i + i2, j + j2, Localworld.WALL);
									}
								}
							}
						}
					}
					*/
				}
			}
		}
	}
	
	/** Helper function for connectrooms() - do A and B overlap vertically? */
	public static function roomoverlap_vertical(a:Int, b:Int):Bool {
		if (rooms[a].y >= rooms[b].y && rooms[a].y <= rooms[b].y + rooms[b].height - 1) {
			return true;
		}
		if (rooms[a].y + rooms[a].height - 1 >= rooms[b].y && rooms[a].y + rooms[a].height - 1 <= rooms[b].y + rooms[b].height - 1) {
			return true;
		}
		return false;
	}

	/** Helper function for connectrooms() - do A and B overlap horizontally? */
	public static function roomoverlap_horizontal(a:Int, b:Int):Bool {
		if (rooms[a].x >= rooms[b].x && rooms[a].x <= rooms[b].x + rooms[b].width - 1) {
			return true;
		}
		if (rooms[a].x + rooms[a].width - 1 >= rooms[b].x && rooms[a].x + rooms[a].width - 1 <= rooms[b].x + rooms[b].width - 1) {
			return true;
		}
		return false;
	}
	
	/** Do a simple drill between two points in a straight line */
	public static function simpledrill(x1:Int, y1:Int, x2:Int, y2:Int, testing:Bool = false):Bool {
		if (x1 == x2) {
			if (y1 != y2) {
				if (y1 > y2) {
					var tmp:Int = y1;
					y1 = y2;
					y2 = tmp;
				}
				for (j in y1 ... y2+1) {
					//trace("Checking point (" + Std.string(x1) + "," + Std.string(j) + ")");
					if (World.at(x1, j) == Localworld.BACKGROUND || World.at(x1, j) == Localworld.FLOOR) {
						if (!testing) {
							//Only actually place the tile once we've checked it's ok...
							World.placetile(x1, j, Localworld.FLOOR);
						}
					}else {
						if (testing) {
							//A collision! This path won't work...
							return false;
						}
					}
				}
			}
		}else if (y1 == y2) {
			if (x1 != x2) {
				if (x1 > x2) {
					var tmp:Int = x1;
					x1 = x2;
					x2 = tmp;
				}
				for (i in x1 ... x2+1) {
					//trace("Checking point (" + Std.string(i) + "," + Std.string(y1) + ")");
					if (World.at(i, y1) == Localworld.BACKGROUND || World.at(i, y2) == Localworld.FLOOR) {
						if (!testing) {
							//Only actually place the tile once we've checked it's ok...
							World.placetile(i, y1, Localworld.FLOOR);
						}
					}else {
						if (testing) {
							//A collision! This path won't work...
							return false;
						}
					}
				}
			}
		}
		return true;
	}
	
	public static function updateastarmap():Void {
		if(!rejectmap){
			//Clear the Astar collision map
			Astar.changemapsize(World.mapwidth, World.mapheight);
			for (j in 0 ... World.mapheight) {
				for (i in 0 ... World.mapwidth) {
					if(World.at(i,j) == Localworld.BACKGROUND || World.at(i,j) == Localworld.FLOOR){
						Astar.contents[i + Astar.vmult[j]] = 0;
					}else {
						Astar.contents[i + Astar.vmult[j]] = 1;
					}
					if (i == 0 || j == 0 || i >= World.mapwidth - 1 || j >= World.mapheight - 1) {
						Astar.contents[i + Astar.vmult[j]] = 1;
					}
				}
			}
		}
	}
	
	/** Drill a tunnel between two points on the map using pathfinding. The last resort! */
	public static function pathfinddrill(x1:Int, y1:Int, x2:Int, y2:Int):Void {
		Astar.contents[x1 + Astar.vmult[y1]] = 0;
		Astar.contents[x2 + Astar.vmult[y2]] = 0;
		//Astar.pathfind(x1, y1, x2, y2);
		StraightAstar.pathfind(x1, y1, x2, y2);
		if (Astar.pathlength == 0) {
			rejectmap = true;
		}else{
			for (i in 1 ... Astar.pathlength) {
				World.placetile(Astar.pathx[i], Astar.pathy[i], Localworld.FLOOR);
			}
		}
	}
	
	/** Helper function for getintersectionpoint: returns the direction from a point to tpoint */
	public static function getdir(x:Int, y:Int):Int {
		if (x == Std.int(tpoint.x)) {
			if (y == Std.int(tpoint.y)) {
				return Help.NODIRECTION;
			}else {
				if (y < Std.int(tpoint.y)) {
					return Help.DOWN;
				}else {
					return Help.UP;
				}
			}
		}else {
			if (y == Std.int(tpoint.y)) {
				if (x < Std.int(tpoint.x)) {
					return Help.RIGHT;
				}else {
					return Help.LEFT;
				}
			}
		}
		return Help.NODIRECTION;
	}
	
	/** Set tpoint to the intersection of two vectors. Returns false if there is none. */
	public static function getintersectionpoint(x1:Int, y1:Int, dir1:Int, x2:Int, y2:Int, dir2:Int):Bool {
		//There's probably a nice mathsy solution to this, but whatevs
		if (dir1 == Help.clockwise(dir2) || dir1 == Help.anticlockwise(dir2)) {
			//The lines are perpendicular
			if (dir1 == Help.LEFT || dir1 == Help.RIGHT) {
				tpoint.setTo(x2, y1);
				if (getdir(x1, y1) == dir1 && getdir(x2, y2) == dir2) {
					return true;
				}
			}else if (dir1 == Help.UP || dir1 == Help.DOWN) {
				tpoint.setTo(x1, y2);
				if (getdir(x1, y1) == dir1 && getdir(x2, y2) == dir2) {
					return true;
				}
			}
			return false;
		}
		//The lines are parallel: there's no intersection
		return false;
	}
	
	public static function addline(x1:Int, y1:Int, x2:Int, y2:Int):Void {
		lines[numlines].setto(x1, y1, x2, y2);
		numlines++;
	}
	
	public static function connectrooms(a:Int, b:Int):Void {
		if (!rejectmap) {
			if (!startconnections) {
				updateastarmap(); // Call this before connecting rooms to setup the collision map
				startconnections = true;
			}
			//Tunnel between rooms a and b! Basically, draw two lines of floor.
			//Firstly; do both rooms exist?
			if (numrooms > b && numrooms > a) {
				//Right: we need to decide how to connect the rooms - what side of the rooms
				//we're going to try to connect. It basically comes down to this:
				// - If there's vertical overlap, we connect the rooms horizontally.
				// - If there's horizontal overlap, we connect the rooms vertically.
				// - If there's neigher, we do an L-shaped tunnel.
				// - There should never be both: the way the rooms are placed ensure that.
				if (roomoverlap_vertical(a, b)) {
					if (rooms[a].x < rooms[b].x) {
						rooms[a].facing = Help.RIGHT;
						rooms[b].facing = Help.LEFT;
					}else {
						rooms[a].facing = Help.LEFT;
						rooms[b].facing = Help.RIGHT;
					}
				}else if (roomoverlap_horizontal(a, b)) {
					if (rooms[a].y < rooms[b].y) {
						rooms[a].facing = Help.DOWN;
						rooms[b].facing = Help.UP;
					}else {
						rooms[a].facing = Help.UP;
						rooms[b].facing = Help.DOWN;
					}
				}else {
					//Randomly pick between the two options!
					if (rooms[a].x < rooms[b].x) {
						rooms[a].facing = Help.RIGHT;
						if (rooms[a].y < rooms[b].y) {
							rooms[b].facing = Help.UP;
						}else {
							rooms[b].facing = Help.DOWN;
						}
					}else {
						rooms[a].facing = Help.LEFT;
						if (rooms[a].y < rooms[b].y) {
							rooms[b].facing = Help.UP;
						}else {
							rooms[b].facing = Help.DOWN;
						}
					}
				}
				
				connecta = rooms[a].getconnection(rooms[a].facing);
				if (connecta == -1) {
					connecta = rooms[a].getconnection();
				}else {
					if (rooms[a].connections[connecta].dir != rooms[a].facing) {
						connecta = rooms[a].getconnection();
					}
				}
				if (connecta == -1) {
					rejectmap = true;
					return;
				}
				tx1 = rooms[a].connections[connecta].x + rooms[a].x;
				ty1 = rooms[a].connections[connecta].y + rooms[a].y;
				
				connectb = rooms[b].getconnection(rooms[b].facing);
				if (connectb == -1) {
					connectb = rooms[b].getconnection();
				}else {
					if (rooms[b].connections[connectb].dir != rooms[b].facing) {
						connectb = rooms[b].getconnection();
					}
				}
				
				if (connectb == -1) {
					rejectmap = true;
					return;
				}
				
				tx2 = rooms[b].connections[connectb].x + rooms[b].x;
				ty2 = rooms[b].connections[connectb].y + rooms[b].y;
				
				World.placetile(tx1, ty1, Localworld.BACKGROUND);
				World.placetile(tx2, ty2, Localworld.BACKGROUND);
				
				//Alright, I've now got two points and two directions. I test the tunnel.
				numlines = 0;
				if (getintersectionpoint(tx1, ty1, rooms[a].facing, tx2, ty2, rooms[b].facing)) {
					//There's a collision point at tpoint.
					addline(tx1, ty1, Std.int(tpoint.x), Std.int(tpoint.y));
					addline(tx2, ty2, Std.int(tpoint.x), Std.int(tpoint.y));
				}else {
					//There's no collision point.
					if (rooms[a].facing == Help.oppositedirection(rooms[b].facing)) {
						if (rooms[a].facing == Help.LEFT || rooms[a].facing == Help.RIGHT) {
							tr = Std.int((tx1 + tx2) / 2);
							addline(tx1, ty1, tr, ty1);
							addline(tr, ty1, tr, ty2);
							addline(tx2, ty2, tr, ty2);
						}else if (rooms[a].facing == Help.UP || rooms[a].facing == Help.DOWN) {
							tr = Std.int((ty1 + ty2) / 2);
							addline(tx1, ty1, tx1, tr);
							addline(tx1, tr, tx2, tr);
							addline(tx2, ty2, tx2, tr);
						}
					}
				}
				
				if (numlines > 0) {
					tr = 0;
					for (i in 0 ... numlines) {
						if (!simpledrill(lines[i].x1, lines[i].y1, lines[i].x2, lines[i].y2, true)) {
							tr = 1;
							numlines = 0;
						}
					}
					
					if (tr == 0) {
						for (i in 0 ... numlines) {
							simpledrill(lines[i].x1, lines[i].y1, lines[i].x2, lines[i].y2);
						}
					}
				}
				
				if(numlines==0){
					pathfinddrill(tx1, ty1, tx2, ty2);
				}
				
				dustwalls();
				rooms[a].connectto(a, b);
				
				//Finally! Do we put doors here?
				//We consider locked doors on exit rooms!
				if(lockedtype == "A"){
					if (rooms[a].doorodds == 3) {
						World.placetile(tx1, ty1, Localworld.CONSIDERLOCKEDEXIT_A);	
					}
					if (rooms[b].doorodds == 3) {
						World.placetile(tx2, ty2, Localworld.CONSIDERLOCKEDEXIT_A);
					}
					lockedtype = "B";
				}else if(lockedtype == "B"){
					if (rooms[a].doorodds == 3) {
						World.placetile(tx1, ty1, Localworld.CONSIDERLOCKEDEXIT_B);	
					}
					if (rooms[b].doorodds == 3) {
						World.placetile(tx2, ty2, Localworld.CONSIDERLOCKEDEXIT_B);
					}
					lockedtype = "A";
				}
				
				if (rooms[a].doorodds == 1) {
					World.placetile(tx1, ty1, Localworld.CONSIDERLOCKEDDOOR);	
				}
				if (rooms[b].doorodds == 1) {
					World.placetile(tx2, ty2, Localworld.CONSIDERLOCKEDDOOR);
				}
				if (rooms[a].doorodds == 2) {
					if (Rand.pint(1, 8) == 1) World.placetile(tx1, ty1, Localworld.DOOR);
				}
				if (rooms[b].doorodds == 2) {
					if (Rand.pint(1, 8) == 1) World.placetile(tx2, ty2, Localworld.DOOR);
				}
			}
		}
	}
	public static var lockedtype:String = "A";
	public static var lastblueprint:String;
	
	public static function debugroomconnections(currenttime:String = "unknown time"):Void {
		if(Buildconfig.showtraces) trace("Current state of room connections at " + currenttime);
		for (i in 0 ... numrooms) {
			if(Buildconfig.showtraces) trace("ROOM " + Std.string(i) + ":");
			if (rooms[i].grounded) trace("   - IS GROUNDED");
			for (j in 0 ... rooms[i].numconnectedrooms) {
				if(Buildconfig.showtraces) trace("   - Connected to room " + Std.string(rooms[i].connectedrooms[j]));
			}
		}
	}
	
	/** Connect all rooms to each other as efficently as possible! */
	public static function connectall():Void {
		if (!rejectmap) {
			rooms[0].grounded = true;
			
			for (i in 0 ... numrooms) {
				tr = closestroom_cutoff(i);
				if (tr == -1) {
					//If we're grounded, we connect to the closest ungrounded room.
					//Otherwise, connect to the closest grounded room!
					if (rooms[i].grounded) {
						tr = closestroom_ungrounded(i);
					}else {
						tr = closestroom_grounded(i);
					}
					
					if (tr == -1) {
						//No need to connect right now!
					}else{
						connectrooms(i, tr);
					}
				}else{
					connectrooms(i, tr);
				}
			}
			
			
			//Just in case: if any of the rooms have remained ungrounded, connect them
			//to something grounded now!
			var i:Int = 0;
			while (i < numrooms && !allroomsgrounded()) {
				if(!rooms[i].grounded){
					tr = closestroom_grounded(i);
					
					if (tr == -1) {
						rejectmap = true;
					}else{
						connectrooms(i, tr);
					}
				}
				i = (i + 1) % numrooms;
			}
		}
	}
	
	public static function allroomsgrounded():Bool {
		if (!rejectmap) {
			for (i in 0 ... numrooms) {
				if (!rooms[i].grounded) return false;
			}
		}
		return true;
	}
	
	/** Get the distance between two points. used for figuring out closest rooms. */
	public static function closestroom_getdist(x1:Int, y1:Int, x2:Int, y2:Int):Int {
		var xdist:Int = Std.int(Math.abs(x1 - x2));
		var ydist:Int = Std.int(Math.abs(y1 - y2));
		if (xdist > ydist) {
			return Std.int(14 * ydist + 10 * (xdist - ydist));
		}
		return Std.int(14 * xdist + 10 * (ydist - xdist));
	}
	
	/** Get the distance between two points. used for figuring out closest rooms. */
	public static function closestroom_getdist_straight(x1:Int, y1:Int, x2:Int, y2:Int):Int {
		return Std.int(Math.abs(x1 - x2)) + Std.int(Math.abs(y1 - y2));
	}
	
	/** Get the closest room to the given room that's grounded. */
	public static function closestroom_grounded(t:Int):Int {
		tx1 = rooms[t].x + Std.int(rooms[t].width / 2);
		ty1 = rooms[t].y + Std.int(rooms[t].height / 2);
		var roomdist:Int = -1;
		var currentdist:Int;
		var closest:Int = -1;
		for (i in 0 ... numrooms) {
			if (i != t) {
				if (rooms[i].grounded && !rooms[i].isconnectedtoroom(t)) { 
					tx2 = rooms[i].x + Std.int(rooms[i].width / 2);
					ty2 = rooms[i].y + Std.int(rooms[i].height / 2);
					
					currentdist = closestroom_getdist(tx1, ty1, tx2, ty2);
					if (currentdist < roomdist || roomdist == -1) {
						roomdist = currentdist;
						closest = i;
					}
				}
			}
		}
		return closest;
	}
	
	/** Get the closest room to the given room that's ungrounded. */
	public static function closestroom_ungrounded(t:Int):Int {
		tx1 = rooms[t].x + Std.int(rooms[t].width / 2);
		ty1 = rooms[t].y + Std.int(rooms[t].height / 2);
		var roomdist:Int = -1;
		var currentdist:Int;
		var closest:Int = -1;
		for (i in 0 ... numrooms) {
			if (i != t) {
				if (!rooms[i].grounded && !rooms[i].isconnectedtoroom(t)) { 
					tx2 = rooms[i].x + Std.int(rooms[i].width / 2);
					ty2 = rooms[i].y + Std.int(rooms[i].height / 2);
					
					currentdist = closestroom_getdist(tx1, ty1, tx2, ty2);
					if (currentdist < roomdist || roomdist == -1) {
						roomdist = currentdist;
						closest = i;
					}
				}
			}
		}
		return closest;
	}
	
	/** Get the closest room to the given room that's completely cutoff. */
	public static function closestroom_cutoff(t:Int):Int {
		tx1 = rooms[t].x + Std.int(rooms[t].width / 2);
		ty1 = rooms[t].y + Std.int(rooms[t].height / 2);
		var roomdist:Int = -1;
		var currentdist:Int;
		var closest:Int = -1;
		for (i in 0 ... numrooms) {
			if (i != t) {
				if (rooms[i].numconnectedrooms == 0) {
					tx2 = rooms[i].x + Std.int(rooms[i].width / 2);
					ty2 = rooms[i].y + Std.int(rooms[i].height / 2);
					
					currentdist = closestroom_getdist(tx1, ty1, tx2, ty2);
					if (currentdist < roomdist || roomdist == -1) {
						roomdist = currentdist;
						closest = i;
					}
				}
			}
		}
		return closest;
	}
	
	/** Get the closest room to the given room */
	public static function closestroom(t:Int):Int {
		tx1 = rooms[t].x + Std.int(rooms[t].width / 2);
		ty1 = rooms[t].y + Std.int(rooms[t].height / 2);
		var roomdist:Int = -1;
		var currentdist:Int;
		var closest:Int = -1;
		for (i in 0 ... numrooms) {
			if (i != t) {
				tx2 = rooms[i].x + Std.int(rooms[i].width / 2);
				ty2 = rooms[i].y + Std.int(rooms[i].height / 2);
				
				currentdist = closestroom_getdist(tx1, ty1, tx2, ty2);
				if (currentdist < roomdist || roomdist == -1) {
					roomdist = currentdist;
					closest = i;
				}
			}
		}
		return closest;
	}
	
	public static function shiftleft():Void {
		for (j in 0 ... World.mapheight) {
			for (i in 0 ... World.mapwidth - 1) {
				World.placetile(i, j, World.at(i + 1, j));
			}
		}
		
		for (j in 0 ... World.mapheight) {
			World.placetile(World.mapwidth - 1, j, Localworld.BACKGROUND);
		}
		
		for (j in 0 ... Game.placement.length) {
			for (i in 0 ... Game.placement[j].length) {
				Game.placement[j].shift(i, -1, 0);
			}
		}
		
		shift_thingstoplace( -1, 0);
	}
	
	public static function shiftup():Void {
		for (i in 0 ... World.mapwidth) {
			for (j in 0 ... World.mapheight - 1) {
				World.placetile(i, j, World.at(i, j+1));
			}
		}
		
		for (i in 0 ... World.mapwidth) {
			World.placetile(i, World.mapheight - 1, Localworld.BACKGROUND);
		}
		
		
		for (j in 0 ... Game.placement.length) {
			for (i in 0 ... Game.placement[j].length) {
				Game.placement[j].shift(i, 0, -1);
			}
		}
		
		shift_thingstoplace(0, -1);
	}
	
	public static function shiftright():Void {
		for (j in 0 ... World.mapheight) {
			var i:Int = World.mapwidth - 1;
			while (i > 0) {
				World.placetile(i, j, World.at(i - 1, j));
				i--;
			}
		}
		
		for (j in 0 ... World.mapheight) {
			World.placetile(0, j, Localworld.BACKGROUND);
		}
		
		for (j in 0 ... Game.placement.length) {
			for (i in 0 ... Game.placement[j].length) {
				Game.placement[j].shift(i, 1, 0);
			}
		}
		
		shift_thingstoplace(1, 0);
	}
	
	public static function shiftdown():Void {
		for (i in 0 ... World.mapwidth) {
			var j:Int = World.mapheight - 1;
			while (j > 0) {
				World.placetile(i, j, World.at(i, j - 1));
				j--;
			}
		}
		
		for (i in 0 ... World.mapwidth) {
			World.placetile(i, 0, Localworld.BACKGROUND);
		}
		
		for (j in 0 ... Game.placement.length) {
			for (i in 0 ... Game.placement[j].length) {
				Game.placement[j].shift(i, 0, 1);
			}
		}
		
		shift_thingstoplace(0, 1);
	}
	
	public static function centermap():Void {
		if(!rejectmap){
			//Ok! Find the boundary of the map first of all
			tx1 = World.mapwidth; ty1 = World.mapheight; tx2 = -1; ty2 = -1;
			
			for (j in 0 ... World.mapheight) {
				for (i in 0 ... World.mapwidth) {
					if (World.at(i, j) != Localworld.BACKGROUND) {
						if (i < tx1) tx1 = i;
						if (j < ty1) ty1 = j;
						if (i > tx2) tx2 = i;
						if (j > ty2) ty2 = j;
					}
				}
			}
			
			tx2 = World.mapwidth - 1 - tx2;
			ty2 = World.mapheight - 1 - ty2;
			while (tx1 - tx2 > 2) {
				shiftleft();
				tx1--; tx2++;
			}
			while (tx1 - tx2 < -2) {
				shiftright();
				tx1++; tx2--;
			}
			while (ty1 - ty2 > 1) {
				shiftup();
				ty1--; ty2++;
			}
			while (ty1 - ty2 < -1) {
				shiftdown();
				ty1++; ty2--;
			}
		}
	}
	
	public static function dighole(x:Int, y:Int):Void {
		if (Help.inbox(x, y, Std.int(World.mapwidth / 2) - 10, Std.int(World.mapheight / 2) - 5, Std.int(World.mapwidth / 2) + 10, Std.int(World.mapheight / 2) + 5)) {
			if (World.at(x, y) != -100) {
				World.placetile(x, y, -100);
				if (Rand.pint(1, 2) == 1) dighole(x, y - 1);
				if (Rand.pint(1, 2) == 1) dighole(x, y + 1);
				if (Rand.pint(1, 2) == 1) dighole(x - 1, y);
				if (Rand.pint(1, 2) == 1) dighole(x + 1, y);
			}
		}
	}
	
	public static function placeoutsidecrater():Void {
		tx = Rand.pint(Std.int(World.mapwidth / 2) - 10, Std.int(World.mapwidth / 2) + 10);	ty = Rand.pint(Std.int(World.mapheight / 2) - 5, Std.int(World.mapheight / 2) + 5);
		//Don't care about collisions
		dighole(tx, ty);
		
		for (j in 0 ... World.mapheight) {
			for (i in 0 ... World.mapwidth) {
				if (World.at(i, j) == -100) {
					if (World.at(i, j - 1) != -100 && World.at(i, j - 1) != Localworld.OUTSIDE_EDGE && World.at(i, j - 1) != Localworld.OUTSIDE_ABYSS) {
						World.placetile(i, j, Localworld.OUTSIDE_EDGE);
					}else{
						World.placetile(i, j, Localworld.OUTSIDE_ABYSS);
					}
				}
			}
		}
	}
	
	/** Get a random point in the room, not including the edges */
	public static function getrandompoint_awayfromedge():Void {
		tx = Rand.pint(2, World.mapwidth - 3);	ty = Rand.pint(2, World.mapheight - 3);
	}
	
	
	/** Get a random point in the given rectangle*/
	public static function getrandompointin(x:Int, y:Int, w:Int, h:Int):Void {
		tx = Rand.pint(x, x + w - 1);	ty = Rand.pint(y, y + h - 1);
	}
	
	
	/** Pick a side of the rectangle and place a door randomly in it. Mostly for outdoors */
	public static function placedoorin(x:Int, y:Int, w:Int, h:Int, open:Bool = true):Void {
		if (Rand.pbool()) {
			//Horizontal
			tx = Rand.pint(x + 2, x + w - 4);
			if (Rand.pbool()) {
				//Top
				World.placetile(tx, y, open?Localworld.OUTSIDE_GROUND:Localworld.DOOR);
			}else {
				//Bottom
				World.placetile(tx, y+h-1, open?Localworld.OUTSIDE_GROUND:Localworld.DOOR);
			}
		}else {
			ty = Rand.pint(y + 2, y + h - 4);
			if (Rand.pbool()) {
				//Left
				World.placetile(x, ty, open?Localworld.OUTSIDE_GROUND:Localworld.DOOR);
			}else {
				//Right
				World.placetile(x+w-1, ty, open?Localworld.OUTSIDE_GROUND:Localworld.DOOR);
			}
		}
	}
	
	public static function placestairsin(x:Int, y:Int, w:Int, h:Int):Void {
		if (Rand.pbool()) {
			//Horizontal
			tx = Rand.pint(x + 2, x + w - 4);
			if (Rand.pbool()) {
				//Top
				World.placetile(tx, y, Localworld.STAIRS);
			}else {
				//Bottom
				World.placetile(tx, y+h-1, Localworld.STAIRS);
			}
		}else {
			ty = Rand.pint(y + 2, y + h - 4);
			if (Rand.pbool()) {
				//Left
				World.placetile(x, ty, Localworld.STAIRS);
			}else {
				//Right
				World.placetile(x+w-1, ty, Localworld.STAIRS);
			}
		}
	}
	
	public static function placeitemin(x:Int, y:Int, w:Int, h:Int, item:String):Void {
		//Randomly pick a point in the building for a thing to be in.
		tx = Rand.pint(x + 1, x + w - 2);
		ty = Rand.pint(y + 1, y + h - 2);
		
		if (item == "key") {
			World.placetile(tx, ty, Localworld.KEY);
		}else{
			Obj.createentity(26, 8, "item", item);
		}
	}
	
	public static function placeoutsideroom(roomtype:String):Void {
		switch(roomtype) {
			case "heistytower":
				tx1 = 11;
				ty1 = 4;
				tx2 = 11; 
				ty2 = 10;
				
				for (j in ty1 - 2 ... ty1 + ty2 + 4) {
					for (i in tx1 - 2 ... tx1 + tx2 + 4) {
						if(Rand.pint(0,100) >= 66){	
							World.placetile(i, j, Localworld.DEBRIS);
						}else {
							World.placetile(i, j, Localworld.FLOOR);
						}
					}
				}
				
				placeactualroom_nochecks(tx1, ty1, tx2, ty2, Localworld.BACKGROUND);
				
				World.placetile(16, 13, Localworld.STAIRS);
			case "campgrounds":
				tx1 = 10;
				ty1 = 5;
				tx2 = World.mapwidth - 20; 
				ty2 = World.mapheight - 10;
				
				for (j in ty1 - 1 ... ty1 + ty2 + 2) {
					for (i in tx1 - 1 ... tx1 + tx2 + 2) {
						World.placetile(i, j, Localworld.OUTSIDE_GROUND);
					}
				}
				
				placeactualroom_nochecks(tx1, ty1, tx2, ty2);
				
				for (j in ty1+1 ... ty1+ty2-1) {
					for (i in tx1+1 ... tx1+tx2-1) {
						World.placetile(i, j, Localworld.OUTSIDE_GROUND);
					}
				}
				
				World.placetile(10, 11, Localworld.OUTSIDE_GROUND);
				
				World.placetile(26, 5, Localworld.OUTSIDE_GROUND);
				World.placetile(26, 13, Localworld.OUTSIDE_GROUND);
				
				World.placetile(21, 8, Localworld.OUTSIDE_GROUND);
			case "pawnshop":
				tx1 = 12-3;
				ty1 = 7-3;
				tx2 = 6; 
				ty2 = 5;
				
				placeactualroom_nochecks(tx1, ty1, tx2, ty2, Localworld.OUTSIDE_GROUND);
				
				for (i in 13 ... 17) {
					World.placetile(i-3, 8-3, Localworld.OUTSIDE_EDGE);
				}
				World.placetile(15-3, 11-3, Localworld.OUTSIDE_GROUND);
			case "storeroom":
				tx1 = 20;
				ty1 = 10;
				tx2 = 9; 
				ty2 = 5;
				
				placeactualroom_nochecks(tx1, ty1, tx2, ty2, Localworld.BACKGROUND);
				
				World.placetile(24, 10, Localworld.STAIRS);
		}
	}
	
	public static var topfloorlayout:Array<Array<Int>>;
	
	public static function picktopfloorlayout() {
		//0 is entrance, 1 is exit, 2 is wide and 3 is long. 4 is ignored.
		var layout:Int = Rand.pint(0, 11);
		switch(layout) {
			case 0:	 topfloorlayout = [[2, 4, 3], [0, 3, 4], [3, 4, 3], [4, 1, 4]];
		  case 1:	 topfloorlayout = [[3, 3, 0], [4, 4, 3], [3, 1, 4], [4, 2, 4]];
		  case 2:  topfloorlayout = [[3, 2, 4], [4, 3, 0], [1, 4, 3], [2, 4, 4]];
			case 3:	 topfloorlayout = [[0, 2, 4], [2, 4, 3], [3, 1, 4], [4, 2, 4]];
			case 4:	 topfloorlayout = [[0, 2, 4], [3, 2, 4], [4, 3, 3], [1, 4, 4]];
			case 5:	 topfloorlayout = [[0, 2, 4], [2, 4, 3], [2, 4, 4], [1, 2, 4]];
		  case 6:	 topfloorlayout = [[2, 4, 0], [2, 4, 3], [2, 4, 4], [2, 4, 1]];
		  case 7:  topfloorlayout = [[0, 2, 4], [2, 4, 3], [2, 4, 4], [1, 2, 4]];
		  case 8:	 topfloorlayout = [[0, 2, 4], [3, 3, 3], [4, 4, 4], [2, 4, 1]];
		  case 9:  topfloorlayout = [[0, 2, 4], [2, 4, 3], [3, 3, 4], [4, 4, 1]];
			case 10: topfloorlayout = [[3, 0, 3], [4, 3, 4], [3, 4, 3], [4, 1, 4]];
			case 11: topfloorlayout = [[3, 2, 4], [4, 1, 3], [2, 4, 4], [0, 2, 4]];
		  default: topfloorlayout = [[3, 0, 3], [4, 3, 4], [3, 4, 3], [4, 1, 4]];
		}
	}
	
	public static function place2x2(x:Int, y:Int, t:Int) {
	  World.placetile(x, y, Localworld.WALL);
		World.placetile(x + 1, y, Localworld.WALL);
		World.placetile(x, y + 1, Localworld.WALL);
		World.placetile(x + 1, y + 1, Localworld.WALL);
	}
	
	public static function useblueprint(roomtype:String):Void {
		//Create a room using a given blueprint!
		//Useful functions for generation
		//changemapsize(32, 19);
		//clearrooms();
		
		//randomroom("roomtype");
		//place("roomtype", x, y, offset);
		//roughplace("roomtype", "position");
		//randomroom("roomtype", optional bounds);
		
		//connectall();
		//connectrooms(a,b);
		
		//centermap();
		//addwalls();
		lastblueprint = roomtype;
		lockedtype = "A";
		
		switch(roomtype) {
			case "robot_firstfloor":
				//All intro rooms are 32x19
				changemapsize(32, 19);
				clearrooms();
				
				exactplace("robot_normal", 1, 1);
				exactplace("robot_exit", 13, 3);
				exactplace("robot_ripple", 22, 1);
				exactplace("robot_bottomright", 22, 11);
				exactplace("robot_exit", 13, 10);
				exactplace("robot_ripple", 1, 11);
				
		    connectrooms(0, 1);
		    connectrooms(1, 2);
		    connectrooms(2, 3);
		    connectrooms(3, 4);
		    connectrooms(4, 5);
		    connectrooms(5, 0);
				addwalls();
			case "robot_small":
				changemapsize(32, 30);
				clearrooms();
				
				exactplace("robot_normal", 1, 1);        // 0
				exactplace("robot_exit", 13, 3);         // 1
				exactplace("robot_ripple", 22, 1);       // 2
				
				exactplace("robot_normal", 1, 11);       // 3
				exactplace("robot_connection", 13, 10);  // 4
				exactplace("robot_normal", 22, 11);      // 5
				
				exactplace("robot_ripple", 1, 21);       // 6
				exactplace("robot_exit", 13, 20);        // 7
				exactplace("robot_bottomright", 22, 21);      // 8
				
		    connectrooms(0, 1);
		    connectrooms(1, 2);
		    connectrooms(2, 5);
		    connectrooms(0, 3);
		    connectrooms(3, 4);
		    connectrooms(4, 5);
		    connectrooms(3, 6);
		    connectrooms(5, 8);
		    connectrooms(6, 7);
		    connectrooms(7, 8);
				addwalls();
			case "robot_large":
				changemapsize(32, 40);
				clearrooms();
				
				exactplace("robot_normal", 1, 1);        // 0
				exactplace("robot_exit", 13, 3);         // 1
				exactplace("robot_ripple", 22, 1);       // 2
				
				exactplace("robot_ripple", 1, 11);       // 3
				exactplace("robot_connection", 13, 10);  // 4
				exactplace("robot_normal", 22, 11);      // 5
				
				exactplace("robot_normal", 1, 21);       // 6
				exactplace("robot_connection", 13, 20);  // 7
				exactplace("robot_ripple", 22, 21);      // 8
				
				exactplace("robot_ripple", 1, 31);       // 9
				exactplace("robot_exit", 13, 30);        // 10
				exactplace("robot_bottomright", 22, 31);      // 11
				
		    connectrooms(0, 1);
		    connectrooms(1, 2);
		    connectrooms(2, 5);
		    connectrooms(0, 3);
		    connectrooms(3, 4);
		    connectrooms(4, 5);
		    connectrooms(3, 6);
		    connectrooms(5, 8);
		    connectrooms(6, 7);
		    connectrooms(7, 8);
		    connectrooms(6, 9);
		    connectrooms(8, 11);
		    connectrooms(9, 10);
		    connectrooms(10, 11);
				addwalls();
			case "intro_firstfloor":
				//All intro rooms are 32x19
				changemapsize(32, 19);
				clearrooms();
				
				roughplace("exit", "tl");
				place("exit", 25, 14);
				randomroom("normal");
				randomroom("normal");
				randomroom("normal");
				connectall();
				
				centermap();
				addwalls();
				/*
				tx = -1; ty = -1;
				while(World.at(tx, ty) != Localworld.FLOOR){
					tx = Rand.pint(0, World.mapwidth - 1); ty = Rand.pint(0, World.mapheight -1);
				}
				Generator.placelater(tx, ty, "item", "Letter from Terry");
				*/
			case "simpleempty":
				//All intro rooms are 32x19
				changemapsize(32, 19);
				clearrooms();
				
				roughplace("exit", "tl");
				place("exit", 25, 14);
				randomroom("normal");
				randomroom("normal");
				randomroom("normal");
				connectall();
				
				centermap();
				addwalls();
			case "intro_small":
				//All intro rooms are 32x19
				changemapsize(32, 19);
				clearrooms();
				
				if (Rand.pbool()) {
					roughplace("exit", "tl");
					place("exit", 25, 14);					
				}else {
					place("exit", 25, 1);
					place("exit", 3, 14);
				}
				place("intro_ripple", 16-6, 10-5);
				randomroom("normal");
				randomroom("normal");
				connectall();
				
				centermap();
				addwalls();
			case "intro_small2":
				//All intro rooms are 32x19
				changemapsize(32, 19);
				clearrooms();
				
				if (Rand.pbool()) {
					roughplace("exit", "tl");
					place("exit", 25, 14);					
				}else {
					place("exit", 25, 1);
					place("exit", 3, 14);
				}
				place("intro_ripple", 16-6, 10-5);
				randomroom("normal");
				randomroom("normal");
				randomroom("normal");
				connectall();
				
				centermap();
				addwalls();
			case "intro_small3":
				//All intro rooms are 32x19
				changemapsize(32, 19);
				clearrooms();
				
				if (Rand.pbool()) {
					roughplace("exit", "tl");
					place("exit", 25, 14);					
				}else {
					place("exit", 25, 1);
					place("exit", 3, 14);
				}
				place("intro_ripple", 16-6, 10-5);
				randomroom("normal");
				connectall();
				
				centermap();
				addwalls();
			case "floor11":
				//Shopkeeper room!
				changemapsize(32, 19);
				clearrooms();
				
				fillrect(0, 0, 32, 19, Localworld.WALL, Localworld.WALL);
				exactplace("shopfloor", 7, 3);
				/*exactplace("intro_topfloor_exit", 3, 2);
				exactplace("intro_topfloor", 12, 2);
				exactplace("intro_topfloor", 21, 2);
				exactplace("intro_topfloor", 3, 11);
				exactplace("intro_topfloor", 12, 11);
				exactplace("intro_topfloor_kingpin", 21, 11);
				*/
			case "rooftop":
				changemapsize(77, 77);
				clearrooms();
				
				fillrect(6, 6, 77 - 12, 77 - 12, Localworld.WALL, Localworld.FLOOR);
				fillrect(6, 77 - 11, 77 - 12, 11, Localworld.ROOFSIDE, Localworld.ROOFSIDE);
				
				for (j in 0 ... 77) {
					for (i in 0 ... 77) {
						if (World.at(i, j) == Localworld.BACKGROUND) {
							if(Random.chance(5)){
								World.placetile(i, j, Localworld.ROOFSTARS);
							}else {
								World.placetile(i, j, Localworld.ROOFBACKGROUND);	
							}
						}
					}
				}
				
				for(j in 0 ... 20){
					place2x2(25, 9 + (j * 3), Localworld.WALL);
					place2x2(28, 9 + (j * 3), Localworld.WALL);
					
					place2x2(47, 9 + (j * 3), Localworld.WALL);
					place2x2(50, 9 + (j * 3), Localworld.WALL);
				}
				
				for (i in 0 ... 5) {
					place2x2(9 + (i * 3), 25, Localworld.WALL);
					place2x2(9 + (i * 3), 28, Localworld.WALL);
					
					place2x2(9 + (i * 3), 47, Localworld.WALL);
					place2x2(9 + (i * 3), 50, Localworld.WALL);
					
					place2x2(32 + (i * 3), 25, Localworld.WALL);
					place2x2(32 + (i * 3), 28, Localworld.WALL);
					
					place2x2(32 + (i * 3), 47, Localworld.WALL);
					place2x2(32 + (i * 3), 50, Localworld.WALL);
					
					place2x2(53 + (i * 3), 25, Localworld.WALL);
					place2x2(53 + (i * 3), 28, Localworld.WALL);
					
					place2x2(53 + (i * 3), 47, Localworld.WALL);
					place2x2(53 + (i * 3), 50, Localworld.WALL);
				}
				
				exactplace("rooftop_exit", 27 + 4, 27 + 4);
				
				var roomlist:Array<String> = [];
				for (i in 0 ... 7) roomlist.push("rooftop_ripple");
				roomlist.push("rooftop_gemroom");
				Rand.pshuffle(roomlist);
				
				exactplace(roomlist.pop(), 9, 9);
				exactplace(roomlist.pop(), 27 + 4, 9);
				exactplace(roomlist.pop(), 45 + 8, 9);
				exactplace(roomlist.pop(), 9, 27 + 4);
				exactplace(roomlist.pop(), 45 + 8, 27 + 4);
				exactplace(roomlist.pop(), 9, 45 + 8);
				exactplace(roomlist.pop(), 27 + 4, 45 + 8);
				exactplace(roomlist.pop(), 45 + 8, 45 + 8);
			case "robot_topfloor":
				changemapsize(32, 80);
				clearrooms();
				
				exactplace("robot_topfloor_kingpin", 12, 5);
				exactplace("robot_topfloor_ripple", 12, 14);
				exactplace("robot_topfloor_alt", 12, 23);
				exactplace("robot_topfloor_middle", 12, 32);
				exactplace("robot_topfloor_ripple", 12, 41);
				exactplace("robot_topfloor_alt", 12, 50);
				exactplace("robot_topfloor_exit", 12, 59);
				
				centermap();
				addwalls();
			case "high_topfloor":
				changemapsize(32, 38);
				clearrooms();
				
				fillrect(0, 0, 32, 38, Localworld.WALL, Localworld.FLOOR);
				
				picktopfloorlayout();
				for (i in 0 ... 3) {
					for (j in 0 ... 4) {
						//0 is entrance, 1 is exit, 2 is wide and 3 is long. 4 is ignored.
						var r:Int = topfloorlayout[j][i];
						if (r == 0) {
							exactplace("high_topfloor_exit", 3 + (i * 9), 2 + (j * 9));
						}else if (r == 1) {
							exactplace("high_topfloor_kingpin", 3 + (i * 9), 2 + (j * 9));
						}else if (r == 2) {
							exactplace("high_topfloor_long", 3 + (i * 9), 2 + (j * 9));
						}else if (r == 3) {
							exactplace("high_topfloor_tall", 3 + (i * 9), 2 + (j * 9));
						}
					}
				}
			case "intro_topfloor":
				//Topfloor room! This is a really small one.
				changemapsize(32, 19);
				clearrooms();
				
				fillrect(0, 0, 32, 19, Localworld.WALL, Localworld.FLOOR);
				exactplace("intro_topfloor_exit", 3, 2);
				exactplace("intro_topfloor", 12, 2);
				exactplace("intro_topfloor", 21, 2);
				exactplace("intro_topfloor", 3, 11);
				exactplace("intro_topfloor", 12, 11);
				exactplace("intro_topfloor_kingpin", 21, 11);
				
				addwalls();
			case "firstfloor":
				changemapsize(32, 19);
				clearrooms();
				
				randomroom("exit");
				randomroom("normal");
				randomroom("normal");
				randomroom("exit");
				connectall();
				
				centermap();
				addwalls();
			case "small":
				changemapsize(32, 19);
				clearrooms();
				
				randomroom("big");
				randomroom("big");
				randomroom("exit");
				randomroom("exit");
				
				connectall();
				
				centermap();
				addwalls();
			case "high_medium1":
				//All high_medium rooms are 32x36
				changemapsize(32, 36);
				clearrooms();
				
				if (Rand.pbool()) {
					roughplace("exit", "tl");
					place("exit", 25, 14);					
				}else {
					place("exit", 25, 1);
					place("exit", 3, 14);
				}
				place("high_ripple", 16-6, 5);
				place("high_ripple", 16-6, 25);
				randomroom("normal");
				randomroom("normal");
				randomroom("big");
				connectall();
				
				centermap();
				addwalls();
			case "high_medium2":
				//All high_medium rooms are 32x36
				changemapsize(32, 36);
				clearrooms();
				
				if (Rand.pbool()) {
					roughplace("exit", "tl");
					place("exit", 25, 14);					
				}else {
					place("exit", 25, 1);
					place("exit", 3, 14);
				}
				place("high_ripple", 16-6, 5);
				place("high_ripple", 16-6, 25);
				randomroom("normal");
				randomroom("normal");
				randomroom("normal");
				connectall();
				
				centermap();
				addwalls();
			case "high_medium3":
				//All high_medium rooms are 32x36
				changemapsize(32, 36);
				clearrooms();
				
				if (Rand.pbool()) {
					roughplace("exit", "tl");
					place("exit", 25, 14);					
				}else {
					place("exit", 25, 1);
					place("exit", 3, 14);
				}
				place("high_ripple", 16-6, 5);
				place("high_ripple", 16-6, 25);
				randomroom("normal");
				randomroom("normal");
				randomroom("normal");
				randomroom("normal");
				connectall();
				
				centermap();
				addwalls();
			case "high_big1":
				//All high_big rooms are 32x50
				changemapsize(32, 50);
				clearrooms();
				
				if (Rand.pbool()) {
					roughplace("exit", "tl");
					place("exit", 25, 14);					
				}else {
					place("exit", 25, 1);
					place("exit", 3, 14);
				}
				place("high_ripple", 16-6, 5);
				place("high_ripple", 16 - 6, 25);
				if (Rand.pbool()) {
					place("high_ripple", 16 - 6, 25);
				}else{
					randomroom("normal");
				}
				if (Rand.prare()) {
					randomroom("intro_ripple");
				}else{
					randomroom("normal");
				}
				randomroom("normal");
				randomroom("normal");
				randomroom("big");
				randomroom("big");
				connectall();
				
				centermap();
				addwalls();
			case "high_big2":
				//All high_big rooms are 32x50
				changemapsize(32, 50);
				clearrooms();
				
				if (Rand.pbool()) {
					roughplace("exit", "tl");
					place("exit", 25, 14);					
				}else {
					place("exit", 25, 1);
					place("exit", 3, 14);
				}
				place("high_ripple", 16-6, 5);
				place("high_ripple", 16 - 6, 25);
				place("high_ripple", 16 - 6, 25);
				randomroom("intro_ripple");
				randomroom("normal");
				randomroom("normal");
				randomroom("big");
				randomroom("big");
				connectall();
				
				centermap();
				addwalls();
			case "high_big3":
				//All high_big rooms are 32x50
				changemapsize(32, 50);
				clearrooms();
				
				if (Rand.pbool()) {
					roughplace("exit", "tl");
					place("exit", 25, 14);					
				}else {
					place("exit", 25, 1);
					place("exit", 3, 14);
				}
				place("high_ripple", 16-6, 5);
				place("high_ripple", 16 - 6, 25);
				if (Rand.pbool()) {
					place("high_ripple", 16 - 6, 25);
				}else{
					randomroom("normal");
				}
				if (Rand.prare()) {
					randomroom("intro_ripple");
				}else{
					randomroom("normal");
				}
				randomroom("normal");
				randomroom("normal");
				randomroom("normal");
				randomroom("normal");
				randomroom("normal");
				connectall();
				
				centermap();
				addwalls();
			case "medium":
				changemapsize(32, 30);
				clearrooms();
				
				randomroom("exit");
				randomroom("exit");
				randomroom("big");
				randomroom("big");
				randomroom("normal");
				randomroom("normal");
				
				connectall();
				
				centermap();
				addwalls();
			case "big":
				changemapsize(32, 50);
				clearrooms();
				
				randomroom("exit");
				randomroom("exit");
				randomroom("big");
				randomroom("big");
				randomroom("big");
				for(i in 0 ... 4) randomroom("normal");
				
				connectall();
				
				centermap();
				addwalls();
			case "cross":
				changemapsize(32, 30);
				clearrooms();
				
				place("exit", 12, 10);
				place("big", 1, 10);
				place("big", 18, 1);
				place("big", 36, 10);
				place("big", 18, 20);				
				place("exit", 24, 10);
				
				connectrooms(1, 2);
				connectrooms(2, 3);
				connectrooms(3, 4);
				connectrooms(4, 1);
				connectrooms(0, 1);
				connectrooms(5, 3);
				
				centermap();
				addwalls();
			case "square":
				changemapsize(32, 30);
				clearrooms();
				
				place("exit", 12, 10);
				place("big", 1, 1);
				place("big", 36, 1);
				place("big", 36, 20);
				place("big", 1, 20);			
				place("exit", 24, 10);
				
				connectrooms(1, 2);
				connectrooms(2, 3);
				connectrooms(3, 4);
				connectrooms(4, 1);
				connectrooms(0, 1);
				connectrooms(5, 3);
				
				centermap();
				addwalls();
			default:
				if(Buildconfig.showtraces) trace("ERROR: No matching blueprint for " + roomtype);
		}
	}
	
	/** As well as having specific placements for items and stuff, things can also be
	 * placed randomlly in the level in appropriate squares. This makes a list of those squares! */
	public static function setup_randomplacementlist():Void {
		//Right, first we make a map of legit flooring!
		Astar.changemapsize(World.mapwidth, World.mapheight);
		for (j in 0 ... World.mapheight) {
			for (i in 0 ... World.mapwidth) {
				if(World.at(i,j) == Localworld.FLOOR){
					Astar.contents[i + Astar.vmult[j]] = 0;
				}else {
					Astar.contents[i + Astar.vmult[j]] = 1;
				}
				if (i == 0 || j == 0 || i >= World.mapwidth - 1 || j >= World.mapheight - 1) {
					Astar.contents[i + Astar.vmult[j]] = 1;
				}
			}
		}
		
		//Next, we look through all the rooms and pick which ones aren't ok for randomplacements.
		//Any room type containing the words "exit" or "ripple" is off limit. Maybe make
		//this more general later if needs be, quick hack is good enough for now.
		for (k in 0 ... numrooms) {
			if (Help.isinstring(rooms[k].category, "exit") || 
					Help.isinstring(rooms[k].category, "ripple") ||
					Help.isinstring(rooms[k].category, "kingpin")) {
				for (j in 0 ... rooms[k].height) {
					for (i in 0 ... rooms[k].width) {
						Astar.contents[rooms[k].x + i + Astar.vmult[rooms[k].y + j]] = 1;
					}
				}
			}
		}
		
		//Right! Now we keep track of which squares are ok to use. Reusing the Astar buffers!
		//trace("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-");
		//trace("setup randomplacementlist called:");
		//var tempstring:String = "";
		Astar.oln = 0;
		for (j in 0 ... World.mapheight) {
			//tempstring = "";
			for (i in 0 ... World.mapwidth) {
				if (Astar.contents[i + Astar.vmult[j]] == 0) {
				  //tempstring += ".";	
					Astar.fcost[Astar.oln] = i;
					Astar.gcost[Astar.oln] = j;
					Astar.oln++;
				}else {
				  //tempstring += "#";	
				}
			}
			//trace(tempstring);
		}
		
	}
	
	public static function generateroom(name:String) {
		Game.currentblueprint = name;
		generate("indoors");
	}
	
	public static function generate(s:String, regenerate:Bool = false):Void {
		if (s == "indoors") {
			if(Buildconfig.showtraces) trace("Generating new room " + s + ", " + Game.currentblueprint + ": seed(" + Std.string(Rand.seed + numrejections) + ")");
		}else{
			if(Buildconfig.showtraces) trace("Generating new room " + s + ": seed(" + Std.string(Rand.seed + numrejections) + ")");
		}
		rejectmap = false; startconnections = false;
		if (!regenerate) numrejections = 0;
		if (numrejections > 0) {
			Rand.setseed(Rand.seed + numrejections);
		}
		World.tileset = "terminal";
		Draw.screentilewidth = Std.int(Gfx.screenwidth / Draw.tilewidth);
		Draw.screentileheight = Std.int(Gfx.screenheight / Draw.tileheight);
		treasuredrops = 3;
		
		for (i in 0 ... Game.placement.length) {
			Game.placement[i].clear();
		}
		clearthingstoplace();
		
		Localworld.clearfire();
		//Generate a level of type s!
		switch(s) {
			case "wasteland":
				changemapsize(32, 19);
				for (j in 0 ... World.mapheight) {
					for (i in 0 ... World.mapwidth) {
						World.placetile(i, j, Rand.pint(0, Localworld.numworldblocks - 1));
						while (World.at(i, j) == Localworld.STAIRS || World.at(i, j) == Localworld.KEY) World.placetile(i, j, Rand.pint(0, Localworld.numworldblocks - 1));
					}
				}
			case "outside_camp":
				changemapsize(32, 19);
				for (j in 0 ... World.mapheight) {
					for (i in 0 ... World.mapwidth) {
						if (Rand.pint(0, 100) > 90) {
							World.placetile(i, j, Localworld.WALL);
						}else{
							World.placetile(i, j, Localworld.OUTSIDE_GROUND);
						}
					}
				}
				
				placeoutsideroom("campgrounds");
				placeoutsideroom("pawnshop");
				placeoutsideroom("storeroom");
			case "outside_river":
				changemapsize(32, 19);
				for (j in 0 ... World.mapheight) {
					for (i in 0 ... World.mapwidth) {
						if (Rand.pint(0, 100) > 90) {
							World.placetile(i, j, Localworld.WALL);
						}else{
							World.placetile(i, j, Localworld.OUTSIDE_GROUND);
						}
						Localworld.startfire(i, j);
					}
				}
			case "outside_boundary":
				changemapsize(32, 19);
				for (j in 0 ... World.mapheight) {
					for (i in 0 ... World.mapwidth) {
						if (Rand.pint(0, 100) > 90) {
							World.placetile(i, j, Localworld.WALL);
						}else{
							World.placetile(i, j, Localworld.OUTSIDE_GROUND);
						}
					}
				}
				
				//Place boundary!
				if (Openworld.worldx == 0) {
					for (j in 0 ... World.mapheight) {
						tx = Rand.pint(3, 5);
						for(i in 0 ... tx){
							World.placetile(i, j, Localworld.WALL);
						}
					}
				}else if (Openworld.worldx == Openworld.worldwidth - 1) {
					for (j in 0 ... World.mapheight) {
						tx = Rand.pint(3, 5);
						for(i in 0 ... tx){
							World.placetile(World.mapwidth - 1 - i, j, Localworld.WALL);
						}
					}
				}
				
				if (Openworld.worldy == 0) {
					for (i in 0 ... World.mapwidth) {
						ty = Rand.pint(3, 5);
						for(j in 0 ... ty){
							World.placetile(i, j, Localworld.WALL);
						}
					}
				}else if (Openworld.worldy == Openworld.worldheight - 1) {
					for (i in 0 ... World.mapwidth) {
						ty = Rand.pint(3, 5);
						for(j in 0 ... ty){
							World.placetile(i, World.mapheight - 1 - j, Localworld.WALL);
						}
					}
				}
			case "outside_ruin":
				changemapsize(32, 19);
				for (j in 0 ... World.mapheight) {
					for (i in 0 ... World.mapwidth) {
						if (Rand.pint(0, 100) > 90) {
							World.placetile(i, j, Localworld.WALL);
						}else{
							World.placetile(i, j, Localworld.FLOOR);
						}
					}
				}
				
				tpoint.setTo(-1, -1);
				//1 in 10 chance of there being a crater in the room, away from the edges!
				if (Rand.pint(0, 100) > 90) {
					placeoutsidecrater();
					if (Rand.pint(0, 100) > 90) placeoutsidecrater();
				}else {
					//1 in 20 chance of there being a little hut in the room, with something inside!
					if (Rand.pint(0, 100) > 75) {
						tx1 = Rand.pint(3, World.mapwidth - 1 - 14);
						ty1 = Rand.pint(3, World.mapheight - 1 - 13);
						tx2 = Rand.pint(7, 12); 
						ty2 = Rand.pint(7, 10);
						
						for (j in ty1-1 ... ty1+ty2+2) {
							for (i in tx1-1 ... tx1+tx2+2) {
								World.placetile(i, j, Localworld.FLOOR);
							}
						}
						
						placeactualroom_nochecks(tx1, ty1, tx2, ty2);
						
						placedoorin(tx1, ty1, tx2, ty2);
						getrandompointin(tx1+1, ty1+1, tx2-2, ty2-2);
						Obj.createentity(tx, ty, "item", Rand.ppickstring("Fire Extinguisher", Weapon.MATCHSTICK, "Ice Cube"));
					}
				}
			case "outside_building":
				changemapsize(32, 19);
				for (j in 0 ... World.mapheight) {
					for (i in 0 ... World.mapwidth) {
						if (Rand.pint(0, 100) > 90) {
							World.placetile(i, j, Localworld.WALL);
						}else{
							World.placetile(i, j, Localworld.OUTSIDE_GROUND);
						}
					}
				}
				
				tx1 = Rand.pint(3, World.mapwidth - 1 - 18);
				ty1 = Rand.pint(3, World.mapheight - 1 - 14);
				tx2 = Rand.pint(12, 15); 
				ty2 = Rand.pint(8, 11);
				
				for (j in ty1-1 ... ty1+ty2+2) {
					for (i in tx1-1 ... tx1+tx2+2) {
						World.placetile(i, j, Localworld.OUTSIDE_GROUND);
					}
				}
				
				placeactualroom_nochecks(tx1, ty1, tx2, ty2);
				
				for (j in ty1+1 ... ty1+ty2-1) {
					for (i in tx1+1 ... tx1+tx2-1) {
						World.placetile(i, j, Localworld.OUTSIDE_ABYSS);
					}
				}
				
			  placestairsin(tx1, ty1, tx2, ty2);
			case "indoors":
				useblueprint(Game.currentblueprint);
				
				setup_randomplacementlist();
				placethethings();
		}
		
		if (rejectmap) {
			//Last ditch effort: Something has gone so badly wrong that we should just start again
			numrejections++;
			generate(s, true);
		}
	}
	
	public static var boundx:Int;
	public static var boundy:Int;
	public static var boundw:Int;
	public static var boundh:Int;
	
	public static var tx:Int;
	public static var ty:Int;
	public static var tdir:Int;
	public static var tx1:Int;
	public static var ty1:Int;
	public static var tx2:Int;
	public static var ty2:Int;
	public static var tr:Int;
	public static var tg:Int;
	public static var tb:Int;
	public static var attempts:Int;
	
	public static var connecta:Int;
	public static var connectb:Int;
	
	public static var tpoint:Point = new Point();
	public static var tpoint2:Point = new Point();
	
	public static var treasuredrops:Int;
	
	public static var lines:Array<Line> = new Array<Line>();
	public static var numlines:Int;
	
	public static var rooms:Array<Roomclass> = new Array<Roomclass>();
	public static var numrooms:Int;
	
	public static var connectionsort:Array<Int> = new Array<Int>();
	public static var numconnectionsort:Int;
	public static var rejectmap:Bool;
	public static var numrejections:Int = 0;
	public static var startconnections:Bool;
	
	public static var thingstoplace:Numlist = new Numlist();
	public static var thingstoplace_type:Numlist = new Numlist();
	public static var xplace:Array<Int> = new Array<Int>();
	public static var yplace:Array<Int> = new Array<Int>();
}