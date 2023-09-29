package entities.entities;

import haxegon.*;
import entities.Obj;
import world.Localworld;
import visuals.Draw;
import GameData.ItemData;

class ItemEntity extends BaseEntity {
	public function new() {
		super();
		
		name = "item";
		init_drawframe = 1;
	}
	
	override public function create(i:Int, xp:Float, yp:Float, itemname:String = "", unusedparameter:String = ""):Void {
		super.create(i, xp, yp, itemname, "");
		
		Obj.entities[i].rule = "item";
		
		itemname = itemname.toLowerCase();
		var item:ItemData = GameData.getitem(itemname);
		
		Obj.entities[i].name = itemname;
		Obj.entities[i].tile = item.sprite;
		Obj.entities[i].mysteryvalue = item.numuses;
		Obj.entities[i].col = item.col;
	}
	
	override public function update(i:Int):Void {
		if (Obj.entities[i].shakecount > 0) Obj.entities[i].shakecount--;
	}
	
	override public function drawentity(i:Int):Void {
		if (Localworld.fogat(Std.int(Obj.entities[i].xp), Std.int(Obj.entities[i].yp)) == 1){
			Draw.draw_default_items(i);
		}else {
			Draw.draw_unknown(i);
		}
	}
}