package objs;

import flash.display.*;
import flash.geom.*;
import flash.events.*;
import flash.net.*;
import gamecontrol.*;
import haxegon.*;
import terrylib.util.*;
import terrylib.*;

//Note: "player" is special as a rule, with default implementations in several places
class Ent_player extends Ent_generic {
	public function new() {
		super();
		
		name = "player";
	}
	
	override public function create(i:Int, xp:Float, yp:Float, para1:String = "0", para2:String = "0", para3:String = "0"):Void {
		Obj.entities[i].rule = "player";
		Obj.entities[i].tileset = "terminal";
		setupcollision(i);
		
		Obj.entities[i].tile = 64;
		Obj.entities[i].col = 0xffea03;
		Obj.entities[i].dir = Game.playerdir;
		
		Obj.entities[i].lightsource = "close";
		Obj.entities[i].health = Game.health;
		
		Obj.entities[i].checkcollision = true; //Do collision FROM this entity - avoids NxN tests
	}
	
	override public function update(i:Int):Void {
		//Player entity's actual position is usually controlled
		//in the input class: this is for state changes
		if (Obj.entities[i].state == 0) {
			
		}
	}
	
	override public function animate(i:Int):Void {
		if (Obj.entities[i].shakecount > 0) Obj.entities[i].shakecount--;
		
		if (Obj.entities[i].health == 3) {
			Obj.entities[i].col = 0xffea03;
		}else if (Obj.entities[i].health == 2) {
			if (Help.slowsine % 32 >= 16) {
				Obj.entities[i].col = 0xD1F1F5;
			}else {
				Obj.entities[i].col = 0xFFF144;
			}
		}else if (Obj.entities[i].health == 1) {
			if (Help.slowsine % 16 >= 8) {
				Obj.entities[i].col = 0xFF1111;
			}else {
				Obj.entities[i].col = 0xFF4444;
			}
		}
		
		if (Game.icecube > 0) {
			Obj.entities[i].col = Col.rgb(64, 64, Std.int(255 - (Math.random() * Help.glow * 2)));
		}
		
		if (Game.cloaked > 0) {
			Obj.entities[i].col = Col.rgb(164 + Help.glow, 164 + Help.glow, 164 + Help.glow);
		}
		
		if (Game.timestop > 0) {
			if (Help.slowsine % 16 >= 8) {
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
			Gfx.fillbox(Std.int(Obj.entities[i].xp - World.camerax) * Draw.tilewidth, Std.int(Obj.entities[i].yp - World.cameray) * Draw.tileheight, Draw.tilewidth, Draw.tileheight, Game.backgroundcolour);
			Gfx.imagecolor = 0xffea03;
			Gfx.drawtile(Std.int(Obj.entities[i].xp - World.camerax) * Draw.tilewidth, Std.int(Obj.entities[i].yp - World.cameray) * Draw.tileheight, Obj.entities[i].tileset, "#".charCodeAt(0));
			Gfx.resetcolor();
		}else{
			Draw.draw_default_player(i);
		}
	}
	
	override public function drawinit(i:Int, xoff:Int, yoff:Int, frame:Int):Void {
		Draw.draw_defaultinit(i, xoff, yoff, frame);
	}
	
	override public function collision(i:Int, j:Int):Void {
		//i is this entity, j is the other
		if (Obj.entities[j].rule == "enemy") {
			if (Obj.entitycollide(i, j)) {
				//trace("collision");
			}
		}
	}
	
	override public function setupcollision(i:Int):Void {
		Obj.entities[i].cx = 0;
		Obj.entities[i].cy = 0;
		Obj.entities[i].w = Draw.tilewidth;
		Obj.entities[i].h = Draw.tileheight;
	}
}