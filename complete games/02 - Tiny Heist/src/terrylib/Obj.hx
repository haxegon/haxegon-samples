package terrylib;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;
import haxegon.*;
import terrylib.util.*;
import gamecontrol.*;
import config.*;
import objs.*;

class Obj {		
	public static inline var BLOCK:Int = 0;
	public static inline var TRIGGER:Int = 1;
	public static inline var DAMAGE:Int = 2;
	public static inline var DOOR:Int = 3;
	
	public static function init():Void {		
		nentity = 0; nparticles = 0;
		nblocks = 0;
		temprect = new Rectangle();
		temprect2 = new Rectangle();
		activedoor = "null";
		roomname = ""; roomnamemode = 0;
		
		for (z in 0...500) {
			var entity:Entclass = new Entclass();
			entities.push(entity);
			
			var initentity:Initentclass = new Initentclass();
			initentities.push(initentity);
			
			var part:Particleclass = new Particleclass();
			particles.push(part);
			
			var block:Blockclass = new Blockclass();
			blocks.push(block);
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
	
	public static function getgridpoint(t:Int, gridwidth:Int):Int { //This function often needs to be adjusted
		t = Std.int((t - (t % gridwidth)) / gridwidth);
		return t;
	}
	
	public static function createblock(t:Int, xp:Int = 0, yp:Int = 0, w:Int = 0, h:Int = 0, trig:String="null", 
															       destx:Int = 0, desty:Int = 0, doorname:String=""):Void {
		var i:Int, z:Int;
		if(nblocks == 0) {
			//If there are no active blocks, Z=0;
			z = 0; 
		}else {
			i = 0; z = -1;
			while (i < nblocks) {
				if (!blocks[i].active) {
					z = i; i = nblocks;
				}
				i++;
			}
			if (z == -1) {
				z = nblocks;
				nblocks++;
			}
		}
		
		blocks[z].clear();
		blocks[z].active = true;
		switch(t) {
			case Obj.BLOCK: //Block
				blocks[z].type = BLOCK;
				blocks[z].xp = xp;
				blocks[z].yp = yp;
				blocks[z].wp = w;
				blocks[z].hp = h;
				blocks[z].rectset(xp, yp, w, h);
				 
				nblocks++;
			case Obj.TRIGGER: //Trigger
				blocks[z].type = TRIGGER;
				blocks[z].xp = xp;
				blocks[z].yp = yp;
				blocks[z].wp = w;
				blocks[z].hp = h;
				blocks[z].rectset(xp, yp, w, h);
				blocks[z].trigger = trig;
				 
				nblocks++;
			case Obj.DAMAGE: //Damage
				blocks[z].type = DAMAGE;
				blocks[z].xp = xp;
				blocks[z].yp = yp;
				blocks[z].wp = w;
				blocks[z].hp = h;
				blocks[z].rectset(xp, yp, w, h);
				 
				nblocks++;
			case Obj.DOOR: //Trigger
				blocks[z].type = DOOR;
				blocks[z].xp = xp;
				blocks[z].yp = yp;
				blocks[z].wp = w;
				blocks[z].hp = h;
				blocks[z].rectset(xp, yp, w, h);
				blocks[z].trigger = trig;
				blocks[z].destx = destx;
				blocks[z].desty = desty;
				blocks[z].doorname = doorname;
				 
				nblocks++;
		}
	}		

	public static function createtrigger(xp:Int, yp:Int, trig:String = "null"):Void {
		createblock(1, xp * Draw.tilewidth, yp * Draw.tileheight, Draw.tilewidth, Draw.tileheight, trig); 
	}

	public static function createdoor(xp:Int, yp:Int, trigs:String, destx:Int, desty:Int, dname:String = ""):Void {
		createblock(3, xp * Draw.tilewidth, yp * Draw.tileheight, Draw.tilewidth, Draw.tileheight, trigs, destx, desty, dname); 
	}

	public static function removeallblocks():Void{
		for(i in 0...nblocks) blocks[i].clear();
		nblocks=0;
	}
	
	public static function removeblock(t:Int):Void{
		blocks[t].clear();
		var i:Int = nblocks - 1; while (i >= 0 && !blocks[i].active) { nblocks--; i--; }
	}
	
	public static function removeblockat(x:Int, y:Int):Void{
		for(i in 0...nblocks){
			if (blocks[i].xp == x && blocks[i].yp == y) removeblock(i);
		}
	}
	
	public static function activeblocks():Int {
		var t:Int = 0;
		for (i in 0...nblocks) if (blocks[i].active) t++;
		return t;
	}
	
	public static function removetrigger(t:String):Void{
		for(i in 0...nblocks){
			if(blocks[i].type == TRIGGER) {
				if(blocks[i].trigger == t) {
					removeblock(i);
				}
			}
		}
	}
	
	public static function updateentitylogic(t:Int):Void {
		entities[t].oldxp = entities[t].xp; entities[t].oldyp = entities[t].yp;
		
		entities[t].vx = entities[t].vx + entities[t].ax;
		entities[t].vy = entities[t].vy + entities[t].ay;
		entities[t].ax = 0;
		
		if (entities[t].jumping) {
			if (entities[t].ay < 0) entities[t].ay++;
			if (entities[t].ay > -1) entities[t].ay = 0;
			entities[t].jumpframe--;
			if(entities[t].jumpframe<=0){
				entities[t].jumping=false;
			}
		}else {
			if (entities[t].gravity) entities[t].ay = 3;
		}
		
		//if (entities[t].gravity) applyfriction(t, 0, 0.5);
		
		entities[t].newxp = entities[t].xp + entities[t].vx;
		entities[t].newyp = entities[t].yp + entities[t].vy;
	}

	public static function entitymapcollision(t:Int, tileset:String):Void {
		if (testwallsx(t, Std.int(entities[t].newxp), Std.int(entities[t].yp))) {
			entities[t].xp = entities[t].newxp;
		}else {
			if (entities[t].onwall > 0) entities[t].state = entities[t].onwall;
			if (entities[t].onxwall > 0) entities[t].state = entities[t].onxwall;
		}
		if (testwallsy(t, Std.int(entities[t].xp), Std.int(entities[t].newyp))) {
			entities[t].yp = entities[t].newyp;
		}else {
			if (entities[t].onwall > 0) entities[t].state = entities[t].onwall;
			if (entities[t].onywall > 0) entities[t].state = entities[t].onywall;
			entities[t].jumpframe = 0;
		}
		
		//Is this entity on the ground? (needed for jumping)
		if (entitycollidefloor(t)) { 
			entities[t].onground = 2;
		}else {	
			entities[t].onground--; 
		}
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
		
		for (i in 0...nentity) {
			if (entities[i].name == t) {
				return i;
			}
		}
		
		return -1;
	}
	
	public static function rectset(xi:Int, yi:Int, wi:Int, hi:Int):Void {
		temprect.x = xi; temprect.y = yi; temprect.width = wi; temprect.height = hi;
	}

	public static function rect2set(xi:Int, yi:Int, wi:Int, hi:Int):Void {
		temprect2.x = xi; temprect2.y = yi; temprect2.width = wi; temprect2.height = hi;
	}

	public static function entitycollide(a:Int, b:Int):Bool {
		//Do entities a and b collide?
		tempx = Std.int(entities[a].xp + entities[a].cx); 
		tempy = Std.int(entities[a].yp + entities[a].cy);
		tempw = entities[a].w; temph = entities[a].h;
		rectset(tempx, tempy, tempw, temph);
		
		tempx = Std.int(entities[b].xp + entities[b].cx); 
		tempy = Std.int(entities[b].yp + entities[b].cy);
		tempw = entities[b].w; temph = entities[b].h;
		rect2set(tempx, tempy, tempw, temph);
		if (temprect.intersects(temprect2)) return true;
		return false;
	}

	public static function checkdamage():Bool{
		//Returns true if player entity (rule 0) collides with a damagepoInt
		for(i in 0...nentity) {
			if (entities[i].rule == "player") {
				tempx = Std.int(entities[i].xp + entities[i].cx); 
				tempy = Std.int(entities[i].yp + entities[i].cy);
				tempw = entities[i].w; temph = entities[i].h;
				rectset(tempx, tempy, tempw, temph);
				
				for (j in 0...nblocks) {
					if (blocks[j].type == DAMAGE && blocks[j].active){
						if(blocks[j].rect.intersects(temprect)) {
							return true;
						}
					}
				}
			}
		}
		return false;
	}

	public static function checktrigger():String{
		//Returns an Int player entity (rule 0) collides with a trigger
		for(i in 0...nentity) {
			if (entities[i].rule == "player") {
				tempx = Std.int(entities[i].xp + entities[i].cx); 
				tempy = Std.int(entities[i].yp + entities[i].cy);
				tempw = entities[i].w; temph = entities[i].h;
				rectset(tempx, tempy, tempw, temph);
				
				for (j in 0...nblocks) {
					if (blocks[j].type == TRIGGER && blocks[j].active){
						if (blocks[j].rect.intersects(temprect)) {
							activetrigger = blocks[j].trigger;
							blocks[j].active = false;
							return blocks[j].trigger;
						}
					}
				}
			}
		}
		return "null";
	}

	public static function checkdoor():String{
		//Returns an Int player entity (rule 0) collides with a trigger
		for(i in 0...nentity) {
			if (entities[i].rule == "player") {
				tempx = Std.int(entities[i].xp + entities[i].cx); 
				tempy = Std.int(entities[i].yp + entities[i].cy);
				tempw = entities[i].w; temph = entities[i].h;
				rectset(tempx, tempy, tempw, temph);
				
				for (j in 0...nblocks) {
					if (blocks[j].type == DOOR && blocks[j].active){
						if (blocks[j].rect.intersects(temprect)) {
							activetrigger = blocks[j].trigger;
							doortox = blocks[j].destx;
							doortoy = blocks[j].desty;
							actualdoor = j;
							return blocks[j].trigger;
						}
					}
				}
			}
		}
		return "null";
	}
			
	public static function checkblocks():Bool {
		for (i in 0...nblocks) {
			if (blocks[i].active) {
				if (blocks[i].type == BLOCK){
					if (blocks[i].rect.intersects(temprect)) {
						return true;
					}
				}
			}
		}
		return false;
	}
			

	public static function checkwall():Bool{
		//Returns true if entity setup in temprect collides with a wall
		//used for proper collision functions; you can't just, like, call it
		//whenever you feel like it and expect a response
		//
		//that won't work at all
		if (checkblocks()) return true;
		
		tempx = getgridpoint(Std.int(temprect.x), Draw.tilewidth); tempy = getgridpoint(Std.int(temprect.y), Draw.tileheight);
		tempw = getgridpoint(Std.int(temprect.x + temprect.width - 1), Draw.tilewidth); temph = getgridpoint(Std.int(temprect.y + temprect.height - 1), Draw.tileheight);
		if (World.collide(tempx, tempy)) return true;
		if (World.collide(tempw, tempy)) return true;
		if (World.collide(tempx, temph)) return true;
		if (World.collide(tempw, temph)) return true;
		if (temprect.height >= 12) {
			tpy1 = getgridpoint(Std.int(temprect.y + 6), Draw.tileheight);
			if (World.collide(tempx, tpy1)) return true;
			if (World.collide(tempw, tpy1)) return true;
			if (temprect.height >= 18) {
				tpy1 = getgridpoint(Std.int(temprect.y + 12), Draw.tileheight);
				if (World.collide(tempx, tpy1)) return true;
				if (World.collide(tempw, tpy1)) return true;
				if (temprect.height >= 24) {
					tpy1 = getgridpoint(Std.int(temprect.y + 18), Draw.tileheight);
					if (World.collide(tempx, tpy1)) return true;
					if (World.collide(tempw, tpy1)) return true;
				}
			}
		}
		if (temprect.width >= 12) {
			tpx1 = getgridpoint(Std.int(temprect.x + 6), Draw.tilewidth);
		if (World.collide(tpx1, tempy)) return true;
		if (World.collide(tpx1, temph)) return true;
		}
		return false;
	}

	public static function entitycollidefloor(t:Int):Bool{
		//see? like here, for example!
		tempx = Std.int(entities[t].xp + entities[t].cx); 
		tempy = Std.int(entities[t].yp + entities[t].cy + 1);
		tempw = entities[t].w; temph = entities[t].h;
		rectset(tempx, tempy, tempw, temph);
		
		if (checkwall()) return true;
		return false;
	}

	public static function testwallsx(t:Int, tx:Int, ty:Int):Bool{
		tempx = tx + entities[t].cx; tempy = ty + entities[t].cy;
		tempw = entities[t].w; temph = entities[t].h;
		rectset(tempx, tempy, tempw, temph);
		
		//Ok, now we check walls
		if (checkwall()) {
			if (entities[t].vx > 1) {
				entities[t].vx--;
				entities[t].newxp = Std.int(entities[t].xp + entities[t].vx);
				return testwallsx(t, Std.int(entities[t].newxp), Std.int(entities[t].yp));
			}else if (entities[t].vx < -1) {
				entities[t].vx++;
				entities[t].newxp = Std.int(entities[t].xp + entities[t].vx);
				return testwallsx(t, Std.int(entities[t].newxp), Std.int(entities[t].yp));
			}else {
				entities[t].vx=0;
				return false;
			}
		}
		return true;
	}

	public static function testwallsy(t:Int, tx:Int, ty:Int):Bool {
		tempx = tx + entities[t].cx; tempy = ty + entities[t].cy;
		tempw = entities[t].w; temph = entities[t].h;
		rectset(tempx, tempy, tempw, temph);
		
		//Ok, now we check walls
		if (checkwall()) {
			if (entities[t].vy > 1) {
				entities[t].vy--;
				entities[t].newyp = Std.int(entities[t].yp + entities[t].vy);
				return testwallsy(t, Std.int(entities[t].xp), Std.int(entities[t].newyp));
			}else if (entities[t].vy < -1) {
				entities[t].vy++;
				entities[t].newyp = Std.int(entities[t].yp + entities[t].vy);
				return testwallsy(t, Std.int(entities[t].xp), Std.int(entities[t].newyp));
			}else {
				entities[t].vy=0;
				return false;
			}
		}
		return true;
	}

	public static function applyfriction(t:Int, xrate:Int, yrate:Int):Void{
		if (entities[t].vx > 0) entities[t].vx -= xrate;
		if (entities[t].vx < 0) entities[t].vx += xrate;
		if (entities[t].vy > 0) entities[t].vy -= yrate;
		if (entities[t].vy < 0) entities[t].vy += yrate;
		if (entities[t].vy > 4) entities[t].vy = 4;
		if (entities[t].vy < -4) entities[t].vy = -4;
		if (entities[t].vx > 4) entities[t].vx = 4;
		if (entities[t].vx < -4) entities[t].vx = -4;
		
		if (Math.abs(entities[t].vx) <= xrate) entities[t].vx = 0;
		if (Math.abs(entities[t].vy) <= yrate) entities[t].vy = 0;
	}
	
	public static function stopmovement(i:Int):Void {
		entities[i].vx = 0;
		entities[i].vy = 0;
		entities[i].ax = 0;
		entities[i].ay = 0;
	}
	
	public static function cleanup():Void {
		var i:Int = 0;
		i = nentity - 1; while (i >= 0 && !entities[i].active) { nentity--; i--; }
		i = nparticles - 1; while (i >= 0 && !particles[i].active) { nparticles--; i--; }
	}
	
	public static function createparticle(xp:Float, yp:Float, t:String, ax:Float = 0, ay:Float = 0, vx:Float = 0, vy:Float = 0):Void {
		//Find the first inactive case z that we can use to index the new entity
		var i:Int, z:Int;
		if (nparticles == 0) {
			//If there are no active entities, Z=0;
			z = 0; nparticles++;
		}else {
			i = 0; z = -1;
			while (i < nparticles) {
				if (!particles[i].active) {
					z = i; i = nparticles;
				}
				i++;
			}
			if (z == -1) {
				z = nparticles;
				nparticles++;
			}
		}
		
		particles[z].clear();
		particles[z].active = true;
		particles[z].type = t;
		particles[z].colour = 0;
		particles[z].life = 0;
		particles[z].xp = xp;
		particles[z].yp = yp;
		particles[z].ax = ax;
		particles[z].ay = ay;
		particles[z].vx = vx;
		particles[z].vy = vy;
		
		Particlelogic.initparticle(z);
	}
	
	public static function updateparticles():Bool {
		for (i in 0...nparticles) {
			if (particles[i].active) {
				if (particles[i].statedelay <= 0) {
					Particlelogic.updateparticle(i);
				}else {
					particles[i].statedelay--;
					if (particles[i].statedelay < 0) particles[i].statedelay = 0;
				}
			}
		}
		return true;
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
	
	public static function createentity(xp:Int, yp:Int, t:String, para1:String = "", para2:String = "", para3:String = ""):Int {
		/*var tracestring:String = "Obj.createentity(" + xp + ", " + yp + ", " + t;
		if (para1 != "") tracestring += ", " + para1;
		if (para2 != "") tracestring += ", " + para2;
		if (para3 != "") tracestring += ", " + para3;
		tracestring += ");";
		trace(tracestring);*/
		
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
		if (Help.isNumber(para1)) entities[z].vx = Std.parseInt(para1);
		if (Help.isNumber(para2)) entities[z].vy = Std.parseInt(para2);
		if (Help.isNumber(para3)) entities[z].para = Std.parseInt(para3);
		
		templates[entindex.get(t)].create(z, xp, yp, para1, para2, para3);
		return z;
	}
	
	public static function randomwalk(i:Int, repeat:Int):Void {
		var dir = Help.randomdirection();
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
	
	public static function entitycollisioncheck():Void {
		var i:Int, j:Int;
		for (i in 0...nentity) {
			if (entities[i].active) {
				if (entities[i].checkcollision) {
					for (j in 0...nentity) {
						if (entities[j].active && i != j) {
							templates[entindex.get(entities[i].rule)].collision(i, j);
						}
					}
				}
			}
		}
		
		//can't have the player being stuck...
		j = getplayer();
		if (j > -1) {
			if (!testwallsx(j, Std.int(entities[j].xp), Std.int(entities[j].yp))) {
				//Let's try to get out...
				entities[j].yp -= 3;
			}
		}
		
		activetrigger = "null";
		if (checktrigger() > "null") {
			i = getplayer();
			stopmovement(i);
			Script.load(activetrigger);
		}
		
		activedoor = "null";
		activedoor = checkdoor();
		if (activedoor != "null") {
			roomname = blocks[actualdoor].doorname;
			roomnamemode = -1;
		}
	}
	
	public static var nentity:Int;
	public static var entities:Array<Entclass> = new Array<Entclass>();
	public static var tempx:Int;
	public static var tempy:Int;
	public static var tempw:Int;
	public static var temph:Int;
	public static var temp:Int;
	public static var temp2:Int;
	public static var tpx1:Int;
	public static var tpy1:Int;
	public static var tpx2:Int;
	public static var tpy2:Int;
	public static var temprect:Rectangle;
	public static var temprect2:Rectangle;
	public static var activetrigger:String;
	
	public static var blocks:Array<Blockclass> = new Array<Blockclass>();
	public static var nblocks:Int;
	
	public static var doortox:Int;
	public static var doortoy:Int;
	public static var activedoor:String;
	public static var activedoordest:String;
	public static var actualdoor:Int; // Kludge: checkdoor returns trigger, but it is useful to know the actual door address for roomnames
	public static var roomname:String;
	public static var roomnamemode:Int;
	
	public static var templates:Array<Ent_generic> = new Array<Ent_generic>();
	public static var numtemplate:Int;
	public static var entindex:Map<String, Int> = new Map<String, Int>();
	
	//Particles!
	public static var particles:Array<Particleclass> = new Array<Particleclass>();
	public static var nparticles:Int;
	
	//Entity init states
	public static var initentities:Array<Initentclass> = new Array<Initentclass>();
	public static var ninitentities:Int;
}