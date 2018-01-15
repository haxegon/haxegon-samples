package objs;

import flash.display.*;
import flash.geom.*;
import flash.events.*;
import flash.net.*;
import gamecontrol.*;
import haxegon.*;
import terrylib.util.*;
import modernversion.*;
import terrylib.*;

class Ent_npc extends Ent_generic {
	public function new() {
		super();
		
		name = "npc";
		init_drawframe = 1;
	}
	
	override public function create(i:Int, xp:Float, yp:Float, para1:String = "0", para2:String = "0", para3:String = "0"):Void {
		Obj.entities[i].rule = "npc";
		Obj.entities[i].tileset = "terminal";
		
		var itemnum:Int = Inventory.getitemlistnum(para1);
		//Name can be "Key" or any item name
		Obj.entities[i].name = para1;
		Obj.entities[i].tile = 2;
		//if(para2 != "preplaced"){
		//	Obj.entities[i].lightsource = "bubble";
		//}else {
		Obj.entities[i].lightsource = "none";
		//}
		Obj.entities[i].para = 5;
		Obj.entities[i].col = Rand.ppickint(Col.rgb(255, 128, 128), Col.rgb(255, 255, 128), Col.rgb(196, 196, 255));
		Modern.shopkeepcol = Obj.entities[i].col;
		
		setupcollision(i);
	}
	
	override public function update(i:Int):Void {
		if (Obj.entities[i].state == 0) {
		}
	}
	
	override public function animate(i:Int):Void {
		Obj.entities[i].drawframe = Obj.entities[i].tile;
	}
	
	override public function drawentity(i:Int):Void {
		if (Localworld.fogat(Std.int(Obj.entities[i].xp), Std.int(Obj.entities[i].yp)) == 1){
			Draw.draw_default(i);
		}else {
			//Draw.draw_unknown(i);
		}
	}
	
	override public function drawinit(i:Int, xoff:Int, yoff:Int, frame:Int):Void {
		Draw.draw_defaultinit(i, xoff, yoff, frame);
	}
	
	override public function collision(i:Int, j:Int):Void {
		//i is this entity, j is the other
	}
	
	override public function setupcollision(i:Int):Void {
		Obj.entities[i].cx = 0;
		Obj.entities[i].cy = 0;
		Obj.entities[i].w = Draw.tilewidth;
		Obj.entities[i].h = Draw.tileheight;
	}
}