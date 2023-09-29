package entities.entities;

import haxegon.*;
import entities.Obj;
import util.Glow;
import util.Direction;
import gamecontrol.Game;
import visuals.Draw;

//Note: "player" is special as a rule, with default implementations in several places
class PlayerEntity extends BaseEntity {
	public function new() {
		super();
		
		name = "player";
	}
	
	override public function create(i:Int, xp:Float, yp:Float, unusedparameter1:String = "", unusedparameter2:String = ""):Void {
		super.create(i, xp, yp, "", "");
		
		Obj.entities[i].rule = "player";
		
		Obj.entities[i].tile = 64;
		Obj.entities[i].col = 0xffea03;
		Obj.entities[i].dir = Game.playerdir;
		
		Obj.entities[i].lightsource = "close";
		Obj.entities[i].health = Game.health;
		
		Obj.entities[i].checkcollision = true; //Do collision FROM this entity - avoids NxN tests
	}
	
	override public function animate(i:Int):Void {
		super.animate(i);
		
		if (Obj.entities[i].shakecount > 0) Obj.entities[i].shakecount--;
		
		if (Obj.entities[i].health == 3) {
			Obj.entities[i].col = 0xffea03;
		}else if (Obj.entities[i].health == 2) {
			if (Glow.slowsine % 32 >= 16) {
				Obj.entities[i].col = 0xD1F1F5;
			}else {
				Obj.entities[i].col = 0xFFF144;
			}
		}else if (Obj.entities[i].health == 1) {
			if (Glow.slowsine % 16 >= 8) {
				Obj.entities[i].col = 0xFF1111;
			}else {
				Obj.entities[i].col = 0xFF4444;
			}
		}
		
		if (Game.cloaked > 0) {
			Obj.entities[i].col = Col.rgb(164 + Glow.glow, 164 + Glow.glow, 164 + Glow.glow);
		}
		
		if (Game.timestop > 0) {
			if (Glow.slowsine % 16 >= 8) {
				Obj.entities[i].col = Col.rgb(255, 255, 255);
			}else {
				Obj.entities[i].col = Col.rgb(32, 32, 255);
			}
		}
		
		Obj.entities[i].framedelay--;
		if (Obj.entities[i].framedelay <= 0) {
			Obj.entities[i].framedelay = 4;
			Obj.entities[i].walkingframe = (Obj.entities[i].walkingframe+1) % 2;
		}
		
		if (Obj.entities[i].animated > 0) {
			Obj.entities[i].animated--;
			Obj.entities[i].drawframe = Obj.entities[i].tile + (Obj.entities[i].dir * 16) + Obj.entities[i].walkingframe + 1;
		}else{
			Obj.entities[i].drawframe = Obj.entities[i].tile + (Obj.entities[i].dir * 16);
		}
		
		if (Game.cloaked > 0) {
			Obj.entities[i].drawframe = 8;
		}
	}
	
	override public function drawentity(i:Int):Void {
		if (Game.health <= 0) {
			Gfx.fillbox(Std.int(Obj.entities[i].xp - Camera.x) * Draw.tilewidth, Std.int(Obj.entities[i].yp - Camera.y) * Draw.tileheight, Draw.tilewidth, Draw.tileheight, Game.backgroundcolour);
			Gfx.imagecolor = 0xffea03;
			Gfx.drawtile(Std.int(Obj.entities[i].xp - Camera.x) * Draw.tilewidth, Std.int(Obj.entities[i].yp - Camera.y) * Draw.tileheight, Obj.entities[i].tileset, "#".charCodeAt(0));
			Gfx.resetcolor();
		}else{
			Draw.draw_default_player(i);
		}
	}
}