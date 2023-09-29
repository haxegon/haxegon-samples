package util;

import haxegon.Geom;
import world.Localworld;
import world.World;

//Basic A* implemention
class Astar {
	public static function init():Void {
		for (i in 0...100) {
			vmult.push(Std.int(i * 100));
		}
		//We create a blank map for pathfinding
		for (j in 0...100) {
			for (i in 0...100) {
				contents.push(0);
				openlist.push(0);
				closedlist.push(0);
				parentsquare.push(0);
				fcost.push(0);
				gcost.push(0);
				pathx.push(0);
				pathy.push(0);
			}
		}
		
		mapwidth = 0; mapheight = 0;
	}
	
	public static function getnextmove():Int {
		//Return the direction that the character should move next.
		/*
		 * path[0] will be the coordinates of b, and
			path[1] will be the coordinates of a.
			
			A's next step will be path[2].
		*/
		if (!pathexists()) {
			return Direction.NONE;
		}else {
			if (pathx[2] > pathx[1]) return Direction.RIGHT;
			if (pathx[2] < pathx[1]) return Direction.LEFT;
			if (pathy[2] > pathy[1]) return Direction.DOWN;
			if (pathy[2] < pathy[1]) return Direction.UP;
		}
		return Direction.NONE;
	}
	
	public static function pathexists():Bool {
		//Does the currently calculated path exist?
		//This seems to work: if the first node and the last node are the same,
		//then it's a real path
		if (pathlength < 2) return false;
		if (pathx[0] == pathx[pathlength - 1] && pathy[0] == pathy[pathlength - 1]) return true;
		return false;
	}
	
	public static function setmapcollision():Void {
    //This only need to be done if the map's actually changed
    changemapsize(World.mapwidth, World.mapheight);
    for (j in 0 ... World.mapheight) {
      for (i in 0 ... World.mapwidth) {
        if (World.at(i, j) == Localworld.DOOR) {
          contents[i + vmult[j]] = 0;
        }else if (World.collide(i, j)) {
          contents[i + vmult[j]] = 1;
        }else {
          contents[i + vmult[j]] = 0;
        }
      }
    }
	}
	
	public static function setcollidepoint(x:Int, y:Int):Void {
		if (Geom.inbox(x, y, 0, 0, mapwidth, mapheight)) contents[x + vmult[y]] = 1;
	}
	
	public static function changemapsize(x:Int, y:Int):Void {
		if (mapwidth != x || mapheight != y) {
			mapwidth = x; mapheight = y;
			for (i in 0...mapheight) {
				vmult[i] = i * mapwidth;
			}
		}
	}
	
	public static function onclosedlist(t:Int):Bool{
		//Is square t on the closed list?
		for (i in 0...cln) {
			if (closedlist[i] == t) return true;
		}
		return false;
	}
	
	public static function onopenlist(t:Int):Bool{
		//Is square t on the open list?
		for (i in 0...oln) {
			if (openlist[i] == t) return true;
		}
		return false;
	}
	
	public static function blockcheck(t:Int):Bool {
		//Index free block check for pathfinding
		if (contents[t] == 1) return true;
		return false;
	}
	
	public static function heuristic(t:Int, xp:Int, yp:Int):Int {
		//return 0;
		var x:Int, y:Int, xdist:Int, ydist:Int;
		x = t % mapwidth; y = Std.int((t - x) / mapwidth);
		
		xdist = Std.int(Math.abs(x - xp));
		ydist = Std.int(Math.abs(y - yp));
		if (xdist > ydist) {
			return Std.int(14 * ydist + 10 * (xdist - ydist));
		}else{
			return Std.int(14 * xdist + 10 * (ydist - xdist));
		}
	}
	 
	public static function checksquare(t:Int, cost:Int, xp:Int, yp:Int):Void {	
		if(!onclosedlist(t)){
			if(onopenlist(t)){ 
				if (gcost[t] + cost < gcost[currentsquare]) {
					parentsquare[t] = currentsquare;
					gcost[t] = cost + gcost[currentsquare];
					fcost[t] = cost + gcost[t] + heuristic(t, xp, yp);
				}
			}else{
				if (!blockcheck(t)) {
					openlist[oln] = t; oln++;
					parentsquare[t] = currentsquare;
					gcost[t] = cost + gcost[currentsquare];
					fcost[t] = cost + gcost[t] + heuristic(t, xp, yp);
				}
			}
		}    
	}
	
	public static function pathfind(x1:Int, y1:Int, x2:Int, y2:Int):Void {
		pathx[0] = x1; pathy[0] = y1; 
		findpath(x2, y2);
	}
	
	public static function findpath(xp:Int, yp:Int):Void{
		//debugfile << "Init pathfinding: Adding path[0] to open list.\n"; debugfile.flush();
		oln=1; cln=0;
		currentsquare = pathx[0] + vmult[pathy[0]];
		openlist[0] = currentsquare;
		fcost[currentsquare] = 0;
		gcost[currentsquare] = 0;
		parentsquare[currentsquare] = currentsquare;
		do{
			if (oln == 0) break;
			//We'll just assume that it's not sorted for the moment:
			//debugfile << "Finding lowest F cost:\n"; debugfile.flush();
			currentsquare = 0; pathtemp = fcost[openlist[0]]; 
			for (i in 1...oln) {
				if (fcost[openlist[i]] < pathtemp) {
					pathtemp = fcost[openlist[i]];
					currentsquare = i;
				}
			}
			//debugfile << "Found: List item " <<currentsquare
			//          <<" with F cost of "<< pathtemp <<" and index of "
			//          <<openlist[currentsquare] << ".\n"; debugfile.flush();
			//Ok! Now currentsquare contains the element of openlist with the lowest F cost!
			//We need to remove this element and add it to the closed list.
			closedlist[cln] = openlist[currentsquare]; cln++;
			//debugfile << "Added this to closed list: " << cln<<".\n"; debugfile.flush();
			for (i in currentsquare...oln - 1) {
				openlist[i] = openlist[i + 1];
			}
			oln--;
			//debugfile << "Removed from open list: "<<oln<<".\n"; debugfile.flush();
			currentsquare = closedlist[cln - 1];
			//debugfile << "Currentsquare is "<<currentsquare<<".\n"; debugfile.flush();
			//The next thing we do is to check to see if we've found the target
			//square: i.e. is the target square on the closed list? If so, we can create the
			//path and exit the routine
			//debugfile << "Is target on closed list?\n"; debugfile.flush();
			if (onclosedlist(xp + vmult[yp])) {
				//debugfile << "Yes! Excellent! Fulshing Closed List:\n"; debugfile.flush();
				//for(int i=0; i<cln; i++){
				//  debugfile << i << ": " << closedlist[i] << " " << parentsquare[closedlist[i]] <<"\n"; debugfile.flush();
				//}
				//Now we use the parentsquares to work our way back and create a path!
				//Problem is: we've got no idea how long the path is until we create it...
				//Will have to come back to this later to make it more efficient!
				pathx[1] = xp;
				pathy[1] = yp;
				pathtemp = 2;
				while (pathx[pathtemp - 1] != pathx[0] || pathy[pathtemp - 1] != pathy[0]) {
					pathx[pathtemp] = parentsquare[pathx[pathtemp - 1] + vmult[pathy[pathtemp - 1]]];
					pathy[pathtemp] = pathx[pathtemp];
					pathx[pathtemp] = pathx[pathtemp] % mapwidth;
					pathy[pathtemp] = Std.int((pathy[pathtemp] - pathx[pathtemp]) / mapwidth);
					pathtemp++;
				}
				pathlength=pathtemp;
				break;
			}
			//debugfile << "No - continuing.\n"; debugfile.flush();
			
			//If not: we add a few elements to the open list adjacent to the currentsquare
			pathtemp = currentsquare % mapwidth;
			//if (currentsquare > mapwidth - 1 && pathtemp != 0) checksquare(currentsquare-mapwidth - 1, 14, xp, yp);
			if (currentsquare > mapwidth - 1) checksquare(currentsquare-mapwidth, 10, xp, yp);
			//if (currentsquare > mapwidth - 1 && pathtemp != mapwidth - 1) checksquare(currentsquare-mapwidth + 1, 14, xp, yp);
			if (currentsquare > 0 && pathtemp != 0) checksquare(currentsquare-1, 10, xp, yp);
			if (currentsquare < mapwidth * mapheight && pathtemp != mapwidth - 1) checksquare(currentsquare + 1, 10, xp, yp);
			//if (currentsquare < (mapwidth - 1) * mapheight && pathtemp != 0) checksquare(currentsquare + mapwidth - 1, 14, xp, yp);
			if (currentsquare < (mapwidth - 1) * mapheight) checksquare(currentsquare + mapwidth, 10, xp, yp);
			//if (currentsquare < (mapwidth - 1) * mapheight && pathtemp != mapwidth - 1) checksquare(currentsquare + mapwidth + 1, 14, xp, yp);
		}while(true);
	}
	
	public static var openlist:Array<Int> = new Array<Int>();
	public static var parentsquare:Array<Int> = new Array<Int>();
	public static var fcost:Array<Int> = new Array<Int>();
	public static var gcost:Array<Int> = new Array<Int>();
	public static var closedlist:Array<Int> = new Array<Int>();
	public static var pathx:Array<Int> = new Array<Int>();
	public static var pathy:Array<Int> = new Array<Int>();
	public static var oln:Int;
	public static var cln:Int;
	public static var currentsquare:Int;
	public static var pathtemp:Int;
	public static var pathlength:Int;		
	
	public static var mapwidth:Int;
	public static var mapheight:Int;
	public static var contents:Array<Int> = new Array<Int>();
	public static var vmult:Array<Int> = new Array<Int>();
}