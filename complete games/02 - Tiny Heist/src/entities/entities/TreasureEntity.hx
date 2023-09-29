package entities.entities;

import haxegon.*;
import visuals.Draw;
import entities.Obj;
import world.Localworld;

class TreasureEntity extends BaseEntity {
	public function new() {
		super();
		
		name = "treasure";
		init_drawframe = 1;
	}
	
	override public function create(i:Int, xp:Float, yp:Float, unusedparameter1:String = "", unusedparameter2:String = ""):Void {
		super.create(i, xp, yp, "", "");
		
		Obj.entities[i].rule = "treasure";
		
		Obj.entities[i].life = 1;
		Obj.entities[i].tile = "$".charCodeAt(0);
		Obj.entities[i].col = Col.rgb(255, 255, 96);
	}
	
	override public function drawentity(i:Int):Void {
		if (Localworld.fogat(Std.int(Obj.entities[i].xp), Std.int(Obj.entities[i].yp)) == 1){
			Draw.draw_default_items(i);
		}else {
			Draw.draw_unknown(i);
		}
	}
}