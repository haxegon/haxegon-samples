package entities;

import openfl.geom.*;
import gamecontrol.*;
import entities.entities.BaseEntity;
import entities.Entclass;
import entities.Initentclass;
import world.Localworld;
import world.World;
import util.Glow;
import util.Direction;

class Obj {		
	public static function init():Void {		
		nentity = 0;
		
		for (z in 0 ... 500) {
			var entity:Entclass = new Entclass();
			entities.push(entity);
			
			var initentity:Initentclass = new Initentclass();
			initentities.push(initentity);
		}
	}
	
	public static function loadtemplates():Void {
		numtemplate = 0;
		for (i in 0 ... templates.length) {
			addtemplate(templates[i].name);
		}
	}
	
	public static function addtemplate(t:String):Void {
		entindex.set(t, numtemplate);
		numtemplate++;
	}
	
	public static function getrule(t:String):Bool {
		//Returns true is there is an entity of type t onscreen
		for (i in 0...nentity) {
			if (entities[i].rule == t) {
				return true;
			}
		}
		
		return false;
	}		
	
	public static function gettype(t:String):Bool {
		//Returns true is there is an entity of type t onscreen
		for (i in 0...nentity) {
			if (entities[i].type == t) {
				return true;
			}
		}
		
		return false;
	}		
	
	public static function getplayer():Int {
		//Returns the index of the first player entity
		for (i in 0...nentity) {
			if (entities[i].rule == "player") {
				return i;
			}
		}
		
		return -1;
	}
	
	public static function getnpc(t:String):Int {
		//Returns the index of the npc by name
		if (t == "player") return getplayer();
		
		for (i in 0 ... nentity) {
			if (entities[i].name == t) {
				return i;
			}
		}
		
		return -1;
	}
	
	public static function cleanup():Void {
		var i:Int = 0;
		i = nentity - 1; while (i >= 0 && !entities[i].active) { nentity--; i--; }
	}
	
	//Actual entityclass stuff is here
	public static function createinitentity(xp:Int, yp:Int, t:String, para1:String = "", para2:String = "", para3:String = ""):Int {
		var i:Int = ninitentities;
		
		initentities[i].xp = xp;
		initentities[i].yp = yp;
		initentities[i].rule = t;
		initentities[i].para1 = para1;
		initentities[i].para2 = para2;
		initentities[i].para3 = para3;
		
		initentities[i].entity = -1;
		initentities[i].drawframe = templates[entindex.get(t)].init_drawframe;
		initentities[i].para1_selection = 0;
		initentities[i].para2_selection = 0;
		initentities[i].para3_selection = 0;
		
		ninitentities++;
		return i;
	}
	
	public static function copyinitentity(a:Int, b:Int):Void {
		initentities[a].xp = initentities[b].xp;
		initentities[a].yp = initentities[b].yp;
		initentities[a].entity = initentities[b].entity;
		initentities[a].drawframe = initentities[b].drawframe;
		initentities[a].rule = initentities[b].rule;
		initentities[a].para1 = initentities[b].para1;
		initentities[a].para2 = initentities[b].para2;
		initentities[a].para3 = initentities[b].para3;
		initentities[a].para1_selection = initentities[b].para1_selection;
		initentities[a].para2_selection = initentities[b].para2_selection;
		initentities[a].para3_selection = initentities[b].para3_selection;
	}
	
	public static function removeinitentity(t:Int):Void {
		if (t != ninitentities - 1) {
			for (i in t...ninitentities) {
				copyinitentity(i, i + 1);
			}
		}
		ninitentities--;
	}
	
	public static function createentity(xp:Int, yp:Int, t:String, para1:String = "", para2:String = ""):Int {
		//Find the first inactive case z that we can use to index the new entity
		var i:Int, z:Int;
		if (nentity == 0) {
			//If there are no active entities, Z=0;
			z = 0; nentity++;
		}else {
			i = 0; z = -1;
			while (i < nentity) {
				if (!entities[i].active) {
					z = i; i = nentity;
				}
				i++;
			}
			if (z == -1) {
				z = nentity;
				nentity++;
			}
		}
		
		entities[z].clear();
		entities[z].active = true;
		entities[z].rule = t;
		entities[z].type = t;
		
		entities[z].xp = xp;
		entities[z].yp = yp;
		
		templates[entindex.get(t)].create(z, xp, yp, para1, para2);
		return z;
	}
	
	public static function randomwalk(i:Int, repeat:Int):Void {
		var dir = Direction.random();
		if (Game.checkforentity(entities[i].xp + Localworld.xstep(dir), entities[i].yp + Localworld.ystep(dir)) == -1) {
			entities[i].xp = entities[i].xp + Localworld.xstep(dir);
			entities[i].yp = entities[i].yp + Localworld.ystep(dir);
		}
		
		if (repeat > 0) randomwalk(i, repeat - 1);
	}
	
	public static function updateentities(i:Int):Bool {
		if(entities[i].active){
			if (entities[i].statedelay <= 0) {
				templates[entindex.get(entities[i].rule)].update(i);
			}else {
				entities[i].statedelay--;
				if (entities[i].statedelay < 0) entities[i].statedelay = 0;
			}
		}
		
		return true;
	}
	
	public static function animate_default(i:Int):Void {
		entities[i].drawframe = entities[i].tile;
	}
	
	public static function animateentities(i:Int):Void {
		if(entities[i].active){
			templates[entindex.get(entities[i].rule)].animate(i);
		}
	}
	
	public static var nentity:Int;
	public static var entities:Array<Entclass> = new Array<Entclass>();
	public static var temp:Int;
	
	public static var templates:Array<BaseEntity> = new Array<BaseEntity>();
	public static var numtemplate:Int;
	public static var entindex:Map<String, Int> = new Map<String, Int>();
	
	//Entity init states
	public static var initentities:Array<Initentclass> = new Array<Initentclass>();
	public static var ninitentities:Int;
}