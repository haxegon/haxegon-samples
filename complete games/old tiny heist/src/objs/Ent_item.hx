package objs;

import flash.display.*;
import flash.geom.*;
import flash.events.*;
import flash.net.*;
import gamecontrol.*;
import haxegon.*;
import terrylib.util.*;
import terrylib.*;

class Ent_item extends Ent_generic {
	public function new() {
		super();
		
		name = "item";
		init_drawframe = 1;
	}
	
	override public function create(i:Int, xp:Float, yp:Float, para1:String = "0", para2:String = "0", para3:String = "0"):Void {
		Obj.entities[i].rule = "item";
		Obj.entities[i].tileset = "terminal";
		
		para1 = para1.toLowerCase();
		var itemnum:Int = Inventory.getitemlistnum(para1);
		if (itemnum == -1) {
			trace("ERROR! Cannot figure out an itemnumber for " + para1);
		}
		
		Obj.entities[i].name = para1;
		Obj.entities[i].tile = Inventory.getitemlistcharacter(para1).charCodeAt(0);
		Obj.entities[i].para = Inventory.getitemlistamount(para1);
		Obj.entities[i].col = Col.rgb(Inventory.itemlist[itemnum].r, Inventory.itemlist[itemnum].g, Inventory.itemlist[itemnum].b);
		
		setupcollision(i);
	}
	
	override public function update(i:Int):Void {
		if (Obj.entities[i].shakecount > 0) Obj.entities[i].shakecount--;
		
		if (Obj.entities[i].state == 0) {
		}
	}
	
	override public function animate(i:Int):Void {
		Obj.entities[i].drawframe = Obj.entities[i].tile;
	}
	
	override public function drawentity(i:Int):Void {
		if (Localworld.fogat(Std.int(Obj.entities[i].xp), Std.int(Obj.entities[i].yp)) == 1){
			Draw.draw_default_items(i);
		}else {
			Draw.draw_unknown(i);
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