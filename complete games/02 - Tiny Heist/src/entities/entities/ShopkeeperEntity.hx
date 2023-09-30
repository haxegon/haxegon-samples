package entities.entities;

import haxegon.*;
import modernversion.*;
import visuals.Draw;
import world.Localworld;
import entities.Obj;
import util.TinyRand;

class ShopkeeperEntity extends BaseEntity {
	public function new() {
		super();
		
		name = "shopkeeper";
		init_drawframe = 1;
	}
	
	override public function create(i:Int, xp:Float, yp:Float, shopsells:String = "", unusedparameter:String = ""):Void {
		super.create(i, xp, yp, shopsells, unusedparameter);
		
		Obj.entities[i].rule = "shopkeeper";
		
		//Name can be "Key" or any item name
		Obj.entities[i].name = shopsells;
		Obj.entities[i].tile = 2;
		Obj.entities[i].lightsource = "none";
		Obj.entities[i].mysteryvalue = 5;
		Obj.entities[i].col = TinyRand.ppickint(Col.rgb(255, 128, 128), Col.rgb(255, 255, 128), Col.rgb(196, 196, 255));
		Modern.shopkeepcol = Obj.entities[i].col;
	}
	
	override public function drawentity(i:Int):Void {
		if (Localworld.fogat(Std.int(Obj.entities[i].xp), Std.int(Obj.entities[i].yp)) == 1){
			Draw.draw_default(i);
		}else {
			//Draw.draw_unknown(i);
		}
	}
}