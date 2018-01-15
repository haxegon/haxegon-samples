package terrylib;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;
import openfl.filesystem.*;
import haxegon.*;

class StraightAstar {
	//We use ALL of the Astar variables for this reimplmentation!
	public static function onclosedlist(t:Int):Bool{
		for (i in 0 ... Astar.cln) {
			if (Astar.closedlist[i] == t) return true;
		}
		return false;
	}
	
	public static function onopenlist(t:Int):Bool{
		for (i in 0 ... Astar.oln) {
			if (Astar.openlist[i] == t) return true;
		}
		return false;
	}
	
	public static function blockcheck(t:Int):Bool {
		if (Astar.contents[t] == 1) return true;
		return false;
	}
	
	public static function heuristic(t:Int, dir:Int, xp:Int, yp:Int):Int {
		var x:Int, y:Int, xdist:Int, ydist:Int;
		x = t % Astar.mapwidth; y = Std.int((t - x) / Astar.mapwidth);
		
		xdist = Std.int(Math.abs(x - xp));
		ydist = Std.int(Math.abs(y - yp));
		if (dir == Help.LEFT || dir == Help.RIGHT) xdist += 1;
		return xdist + ydist;
	}
	 
	public static function checksquare(t:Int, dir:Int, cost:Int, xp:Int, yp:Int):Void {	
		if(!onclosedlist(t)){
			if(onopenlist(t)){ 
				if (Astar.gcost[t] + cost < Astar.gcost[Astar.currentsquare]) {
					Astar.parentsquare[t] = Astar.currentsquare;
					Astar.gcost[t] = cost + Astar.gcost[Astar.currentsquare];
					Astar.fcost[t] = cost + Astar.gcost[t] + heuristic(t, dir, xp, yp);
				}
			}else{
				if (!blockcheck(t)) {
					Astar.openlist[Astar.oln] = t; Astar.oln++;
					Astar.parentsquare[t] = Astar.currentsquare;
					Astar.gcost[t] = cost + Astar.gcost[Astar.currentsquare];
					Astar.fcost[t] = cost + Astar.gcost[t] + heuristic(t, dir, xp, yp);
				}
			}
		}    
	}
	
	public static function pathfind(x1:Int, y1:Int, x2:Int, y2:Int):Void {
		Astar.pathx[0] = x1; Astar.pathy[0] = y1; 
		findpath(x2, y2);
	}
	
	public static function findpath(xp:Int, yp:Int):Void{
		Astar.oln=1; Astar.cln=0;
		Astar.currentsquare = Astar.pathx[0] + Astar.vmult[Astar.pathy[0]];
		Astar.openlist[0] = Astar.currentsquare;
		Astar.fcost[Astar.currentsquare] = 0;
		Astar.gcost[Astar.currentsquare] = 0;
		Astar.parentsquare[Astar.currentsquare] = Astar.currentsquare;
		do{
			if (Astar.oln == 0) break;
			Astar.currentsquare = 0; Astar.pathtemp = Astar.fcost[Astar.openlist[0]]; 
			for (i in 1 ... Astar.oln) {
				if (Astar.fcost[Astar.openlist[i]] < Astar.pathtemp) {
					Astar.pathtemp = Astar.fcost[Astar.openlist[i]];
					Astar.currentsquare = i;
				}
			}
			Astar.closedlist[Astar.cln] = Astar.openlist[Astar.currentsquare]; Astar.cln++;
			for (i in Astar.currentsquare ... Astar.oln - 1) {
				Astar.openlist[i] = Astar.openlist[i + 1];
			}
			Astar.oln--;
			Astar.currentsquare = Astar.closedlist[Astar.cln - 1];
			if (Astar.onclosedlist(xp + Astar.vmult[yp])) {
				Astar.pathx[1] = xp;
				Astar.pathy[1] = yp;
				Astar.pathtemp = 2;
				while (Astar.pathx[Astar.pathtemp - 1] != Astar.pathx[0] || Astar.pathy[Astar.pathtemp - 1] != Astar.pathy[0]) {
					Astar.pathx[Astar.pathtemp] = Astar.parentsquare[Astar.pathx[Astar.pathtemp - 1] + Astar.vmult[Astar.pathy[Astar.pathtemp - 1]]];
					Astar.pathy[Astar.pathtemp] = Astar.pathx[Astar.pathtemp];
					Astar.pathx[Astar.pathtemp] = Astar.pathx[Astar.pathtemp] % Astar.mapwidth;
					Astar.pathy[Astar.pathtemp] = Std.int((Astar.pathy[Astar.pathtemp] - Astar.pathx[Astar.pathtemp]) / Astar.mapwidth);
					Astar.pathtemp++;
				}
				Astar.pathlength = Astar.pathtemp;
				break;
			}
			
			Astar.pathtemp = Astar.currentsquare % Astar.mapwidth;
			if (Astar.currentsquare > Astar.mapwidth - 1) checksquare(Astar.currentsquare-Astar.mapwidth, Help.UP, 10, xp, yp);
			if (Astar.currentsquare > 0 && Astar.pathtemp != 0) checksquare(Astar.currentsquare-1, Help.LEFT, 10, xp, yp);
			if (Astar.currentsquare < Astar.mapwidth * Astar.mapheight && Astar.pathtemp != Astar.mapwidth - 1) checksquare(Astar.currentsquare + 1, Help.RIGHT, 10, xp, yp);
			if (Astar.currentsquare < (Astar.mapwidth - 1) * Astar.mapheight) checksquare(Astar.currentsquare + Astar.mapwidth, Help.DOWN, 10, xp, yp);
		}while(true);
	}
	
	public static var currentx:Int;
	public static var currenty:Int;
}