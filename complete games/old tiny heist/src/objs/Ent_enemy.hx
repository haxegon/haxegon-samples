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

class Ent_enemy extends Ent_generic {
	public function new() {
		super();
		
		name = "enemy";
		init_drawframe = 1;
		
		addpara1("guard", 0);
	}
	
	/*
	
	Complete enemy list for refence:
	//THIS APPEARS TO BE OUT OF DATE
	
	guard
	dog
	camera
	lasercamera
	sentinal
	lasersentinal
	fireman
	robot
	rook
	terminator
	drone_light
	drone_laser
	
	//Planned
	laserguard
	
	*/
	
	override public function create(i:Int, xp:Float, yp:Float, para1:String = "0", para2:String = "0", para3:String = "0"):Void {
		Obj.entities[i].rule = "enemy";
		Obj.entities[i].tileset = "terminal";
		Obj.entities[i].name = para1;
		Obj.entities[i].type = para1;
		setupcollision(i);
		
		switch(Obj.entities[i].type) {
			case Enemy.TRIPWIRE_UP, Enemy.TRIPWIRE_DOWN, Enemy.TRIPWIRE_LEFT, Enemy.TRIPWIRE_RIGHT:
				if (Obj.entities[i].type == Enemy.TRIPWIRE_UP) {
					Obj.entities[i].tile = 144;
					Obj.entities[i].dir = Help.UP;
				}
				if (Obj.entities[i].type == Enemy.TRIPWIRE_DOWN) {
					Obj.entities[i].tile = 145;
					Obj.entities[i].dir = Help.DOWN;
				}
				if (Obj.entities[i].type == Enemy.TRIPWIRE_LEFT) {
					Obj.entities[i].tile = 146;
					Obj.entities[i].dir = Help.LEFT;
				}
				if (Obj.entities[i].type == Enemy.TRIPWIRE_RIGHT) {
					Obj.entities[i].tile = 147;
					Obj.entities[i].dir = Help.RIGHT;
				}
				
				Obj.entities[i].lightsource = "directional_narrow";
				Obj.entities[i].col = 0xFFFFFF;
				//laser_narrow
				Obj.entities[i].ai = "none";
				Obj.entities[i].canturn = false;
				Obj.entities[i].canattack = false;
				Obj.entities[i].fireproof = true;
				Obj.entities[i].collidable = true;
			case "camera", "lasercamera":
				Obj.entities[i].tile = "C".charCodeAt(0) + Game.cameraframe(Obj.entities[i].cameradir);
				Obj.entities[i].ai = "none";
				Obj.entities[i].lightsource = Obj.entities[i].type;
				Obj.entities[i].speed = 1;
				Obj.entities[i].health = 1;
				Obj.entities[i].isarobot = true;
				//Stick to wall!
				if (para2 == "preplaced") {
					Game.faceawayfromwall(i);
				}else{
					Game.attachtocorner(i);
					Game.faceawayfromwall(i);
				}
				//Cameras try to pick a useful direction to point in.
				if (World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Help.oppositedirection(Obj.entities[i].dir);
				if (World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Help.clockwise(Obj.entities[i].dir);
				if (World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Help.oppositedirection(Obj.entities[i].dir);
				if (World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Help.clockwise(Obj.entities[i].dir);
				
				Obj.entities[i].col = 0xFFFFFF;
				if (Obj.entities[i].type == "lasercamera") Obj.entities[i].col = 0xFF0000;
				Obj.entities[i].cameradir = Help.convertcardinaltoangle(Obj.entities[i].dir);
				Obj.entities[i].camerapower = 8;
				Obj.entities[i].alertbysound = false;
				Obj.entities[i].canattack = false;
				Obj.entities[i].para = 18;
				
				if (World.collide(Obj.entities[i].xp + Localworld.xstep(Help.clockwise(Obj.entities[i].dir)), Obj.entities[i].yp + Localworld.ystep(Help.clockwise(Obj.entities[i].dir)))) {
					if (World.collide(Obj.entities[i].xp + Localworld.xstep(Help.anticlockwise(Obj.entities[i].dir)), Obj.entities[i].yp + Localworld.ystep(Help.anticlockwise(Obj.entities[i].dir)))) {
						//If we're tucked into a corridor, then it's a special case!
						if (World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir) + Localworld.xstep(Help.clockwise(Obj.entities[i].dir)), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir) + Localworld.ystep(Help.clockwise(Obj.entities[i].dir)))) {
							Obj.entities[i].state = Game.CAMERA_SCANLEFT;
							Obj.entities[i].stringpara = "left";
						}else {
							Obj.entities[i].state = Game.CAMERA_SCANRIGHT;
							Obj.entities[i].stringpara = "right";
						}
					}else{
						Obj.entities[i].state = Game.CAMERA_SCANLEFT;
						Obj.entities[i].stringpara = "left";
					}
				}else {
					if (World.collide(Obj.entities[i].xp + Localworld.xstep(Help.anticlockwise(Obj.entities[i].dir)), Obj.entities[i].yp + Localworld.ystep(Help.anticlockwise(Obj.entities[i].dir)))) {
						Obj.entities[i].state = Game.CAMERA_SCANRIGHT;
						Obj.entities[i].stringpara = "right";	
					}else {
						Obj.entities[i].cameradir += 45;
						Obj.entities[i].state = Game.CAMERA_SCANRIGHT;
						Obj.entities[i].stringpara = "right";	
					}					
				}
				
				if (Game.alarm) {
					Localworld.alertedtoplayer(i);
				}
			case "sentinal", "lasersentinal":
				Obj.entities[i].tile = "c".charCodeAt(0);
				Obj.entities[i].ai = "none";
				Obj.entities[i].lightsource = Obj.entities[i].type;
				Obj.entities[i].speed = 1;
				Obj.entities[i].health = 1;
				Obj.entities[i].isarobot = true;
				//Try to be in the middle of a room
				Obj.entities[i].dir = Help.randomdirection();
				Obj.entities[i].col = 0xFFFFFF;
				if (Obj.entities[i].type == "lasersentinal") Obj.entities[i].col = 0xFF0000;
				
				Obj.entities[i].cameradir = 0;
				Obj.entities[i].camerapower = 8;
				Obj.entities[i].alertbysound = false;
				Obj.entities[i].canattack = false;
				Obj.entities[i].state = Game.NORMAL;
				
				if (Game.alarm) {
					Localworld.alertedtoplayer(i);
				}
			case "guard", "laserguard", "guard_clockwise_u", "guard_clockwise_r", "guard_clockwise_d", "guard_clockwise_l":
				Obj.entities[i].dir = Help.randomdirection();
				Obj.entities[i].tile = "G".charCodeAt(0) + Obj.entities[i].dir;
				if (S.isinstring(Obj.entities[i].type, "clockwise")) {
					switch(S.getlastbranch(Obj.entities[i].type, "_")) {
					  case "u": Obj.entities[i].dir = Help.UP;
						case "d": Obj.entities[i].dir = Help.DOWN;
						case "l": Obj.entities[i].dir = Help.LEFT;
						case "r": Obj.entities[i].dir = Help.RIGHT;
					}
					
					Obj.entities[i].ai = "clockwiserandommarch";
					Obj.entities[i].type = "guard";
				}else{
					Obj.entities[i].ai = Rand.ppickstring("clockwiserandommarch", "anticlockwiserandommarch");
				}
				Obj.entities[i].stringpara = Obj.entities[i].ai;
				Obj.entities[i].speed = 1;
				Obj.entities[i].health = 1;
				if (Obj.entities[i].type == "laserguard") {
					Obj.entities[i].lightsource = "laserdirectional";
				}else if(Obj.entities[i].type == "guard"){
					Obj.entities[i].lightsource = "directional";
				}
				Obj.entities[i].col = 0xFFFFFF;
				Obj.entities[i].isarobot = false;
				
				if (Game.alarm) {
					Localworld.alertedtoplayer(i);
				}
			case "fireman":
				Obj.entities[i].tile = "f".charCodeAt(0);
				Obj.entities[i].ai = "random";
				Obj.entities[i].stringpara = Obj.entities[i].ai;
				Obj.entities[i].lightsource = "none";
				Obj.entities[i].para = 6;
				Obj.entities[i].speed = 3;
				Obj.entities[i].health = 1;
				Obj.entities[i].dir = Help.randomdirection();
				Obj.entities[i].fireproof = true;
				Obj.entities[i].canattack = false;
				Obj.entities[i].isarobot = false;
				
				if (Game.alarm) {
					Localworld.alertedtoplayer(i);
				}
			case "dog":
				Obj.entities[i].tile = "s".charCodeAt(0);
				Obj.entities[i].ai = "none";
				Obj.entities[i].stringpara = Obj.entities[i].ai;
				Obj.entities[i].lightsource = "dogbubble";
				Obj.entities[i].cameradir = 0;
				update(i);
				Obj.entities[i].speed = 1;
				Obj.entities[i].health = 1;
				Obj.entities[i].dir = Help.RIGHT;
				Obj.entities[i].dogdir = Help.RIGHT;
				Obj.entities[i].canattack = true;
				Obj.entities[i].isarobot = false;
				
				if (Game.alarm) {
					Localworld.alertedtoplayer(i);
				}
			case "bombbot":
				Obj.entities[i].tile = 206;
				Obj.entities[i].ai = "none";
				Obj.entities[i].stringpara = Obj.entities[i].ai;
				Obj.entities[i].lightsource = "none";
				Obj.entities[i].speed = 0;
				Obj.entities[i].health = 1;
				Obj.entities[i].dir = Help.RIGHT;
				Obj.entities[i].canattack = false;
				Obj.entities[i].isarobot = true;
				
				if (Game.alarm) {
					Localworld.alertedtoplayer(i);
				}
			case "robot":
				Obj.entities[i].tile = 236;
				Obj.entities[i].ai = "pathfind";
				Obj.entities[i].stringpara = Obj.entities[i].ai;
				Obj.entities[i].lightsource = "laser_narrow";
				Obj.entities[i].speed = 1;
				Obj.entities[i].health = 1;
				Obj.entities[i].col = 0xFF4444;
				Obj.entities[i].alertbysound = false;
				Obj.entities[i].canattack = false;
				Obj.entities[i].fireproof = true;
				Obj.entities[i].isarobot = true;
			case "terminator":
				Obj.entities[i].tile = 252;
				Obj.entities[i].ai = "pathfind";
				Obj.entities[i].stringpara = Obj.entities[i].ai;
				Obj.entities[i].lightsource = "laser_bubble";
				Obj.entities[i].speed = 1;
				Obj.entities[i].health = 1;
				Obj.entities[i].para = 1;
				Obj.entities[i].col = 0xFFFF44;
				Obj.entities[i].alertbysound = false;
				Obj.entities[i].canattack = false;
				Obj.entities[i].fireproof = true;
				Obj.entities[i].isarobot = true;
			case "rook":
				Obj.entities[i].tile = 165;
				Obj.entities[i].ai = "pathfind_rush";
				Obj.entities[i].stringpara = Obj.entities[i].ai;
				Obj.entities[i].lightsource = "laserbeside";
				Obj.entities[i].speed = 0;
				Obj.entities[i].health = 1;
				Obj.entities[i].alertbysound = false;
				Obj.entities[i].fireproof = true;
				Obj.entities[i].isarobot = true;
				
				if (Game.alarm) {
					Localworld.alertedtoplayer(i);
				}
			case "drone_light", "drone_laser":
				Obj.entities[i].tile = 15;
				Obj.entities[i].ai = Rand.ppickstring("clockwisefollowwall", "anticlockwisefollowwall");
				Obj.entities[i].stringpara = Obj.entities[i].ai;
				Obj.entities[i].speed = 0;
				Obj.entities[i].health = 1;
				Obj.entities[i].isarobot = true;
				if (Obj.entities[i].type == "drone_light") {
					Obj.entities[i].col = 0xFFFFFF;
				  //Obj.entities[i].lightsource = "directional_narrow";
					Obj.entities[i].lightsource = "laserbeside";
				}else if (Obj.entities[i].type == "drone_laser") {
					Obj.entities[i].col = 0xFF0000;
				  //Obj.entities[i].lightsource = "laser_narrow";
					Obj.entities[i].lightsource = "laserbeside";
					Obj.entities[i].alertbysound = false;
				}
				Obj.entities[i].canturn = false;
				Obj.entities[i].canattack = false;
				Obj.entities[i].fireproof = true;
				
				//Stick to wall!
				Game.attachtowall(i);
		}
	}
	
	override public function update(i:Int):Void {
		switch(Obj.entities[i].type) {
			case Enemy.TRIPWIRE_UP, Enemy.TRIPWIRE_DOWN, Enemy.TRIPWIRE_LEFT, Enemy.TRIPWIRE_RIGHT:
				if (Obj.entities[i].state == Game.NORMAL) {
					//Normal
					Obj.entities[i].para = (Obj.entities[i].para + 1) % 2;
					if (Obj.entities[i].para == 0) {
						Obj.entities[i].lightsource = "directional_narrow";
					}else if (Obj.entities[i].para == 1) {
						Obj.entities[i].lightsource = "none";
					}
				}else if (Obj.entities[i].state == Game.ALERTED) {
					//Alert
					Obj.entities[i].lightsource = "directional_narrow";
				}else if (Obj.entities[i].state == Game.STUNNED) {
					if (Obj.entities[i].life > 0) {
						Obj.entities[i].life--;
						if (Obj.entities[i].life <= 0) {
							Obj.entities[i].state = Game.NORMAL;
							Obj.entities[i].col = 0xFFFFFF;
							Obj.entities[i].lightsource = "directional_narrow";
							Obj.entities[i].para = 0;
							Obj.entities[i].setmessage(Rand.ppickstring("REBOOTING...", "ALL SYSTEMS OPERATIONAL!"), "whisper");
							Obj.entities[i].collidable = true;
						}
					}
				}
			case "camera", "lasercamera":
				if (Obj.entities[i].state == Game.CAMERA_SCANLEFT) {
					//Normal
					Obj.entities[i].stringpara = "left";
					if (Obj.entities[i].para > -4) {
						Obj.entities[i].para--;
						if (Obj.entities[i].para > 0) {
							Obj.entities[i].cameradir += 5;
						}
					}else {
						Obj.entities[i].para = 18;
						Obj.entities[i].state = Game.CAMERA_SCANRIGHT;
					}
				}else if (Obj.entities[i].state == Game.CAMERA_SCANRIGHT) {
					//Normal
					Obj.entities[i].stringpara = "right";
					if (Obj.entities[i].para > -4) {
						Obj.entities[i].para--;
						if (Obj.entities[i].para > 0) {
							Obj.entities[i].cameradir -= 5;
						}
					}else {
						Obj.entities[i].para = 18;
						Obj.entities[i].state = Game.CAMERA_SCANLEFT;
					}
				}else if (Obj.entities[i].state == Game.ALERTED) {
					//Alert
				}else if (Obj.entities[i].state == Game.STUNNED) {
					//Knocked out
					if (Obj.entities[i].life > 0) {
						Obj.entities[i].life--;
						if (Obj.entities[i].life <= 0) {
							if(Obj.entities[i].stringpara == "right"){
								Obj.entities[i].state = Game.CAMERA_SCANRIGHT;
							}else {
								Obj.entities[i].state = Game.CAMERA_SCANLEFT;
							}
							Obj.entities[i].col = 0xFFFFFF;
							if (Obj.entities[i].type == "lasercamera") Obj.entities[i].col = 0xFF0000;
							Obj.entities[i].lightsource = Obj.entities[i].type;
							Obj.entities[i].collidable = true;
							Obj.entities[i].setmessage(Rand.ppickstring("REBOOTING...", "SCANNING AREA..."), "whisper");
						}
					}
				}
			case "sentinal", "lasersentinal":
				if (Obj.entities[i].state == Game.NORMAL) {
					//Normal
					Obj.entities[i].cameradir = (Obj.entities[i].cameradir + 1) % 12;
				}else if (Obj.entities[i].state == Game.ALERTED) {
					//Alert
				}else if (Obj.entities[i].state == Game.STUNNED) {
					//Knocked out
					if (Obj.entities[i].life > 0) {
						Obj.entities[i].life--;
						if (Obj.entities[i].life <= 0) {
							Obj.entities[i].state = Game.NORMAL;
							Obj.entities[i].col = 0xFFFFFF;
							if (Obj.entities[i].type == "lasersentinal") Obj.entities[i].col = 0xFF0000;
							Obj.entities[i].lightsource = Obj.entities[i].type;
							Obj.entities[i].collidable = true;
							Obj.entities[i].setmessage(Rand.ppickstring("REBOOTING...", "SCANNING AREA..."), "whisper");
						}
					}
				}
			case "fireman":
				if (Obj.entities[i].state == Game.STUNNED) {
					//Knocked out
					if (Obj.entities[i].life > 0) {
						Obj.entities[i].life--;
						if (Obj.entities[i].life <= 0) {
							Obj.entities[i].state = Game.NORMAL;
							Obj.entities[i].ai = Obj.entities[i].stringpara;
							Obj.entities[i].lightsource = "none";
							Obj.entities[i].setmessage(Rand.ppickstring("Lol, fire", "HAHAHA"), "whisper");
							Obj.entities[i].collidable = true;
						}
					}
				}else {
					if (Game.turnspeed(Obj.entities[i].speed)) Localworld.startfire(Obj.entities[i].xp, Obj.entities[i].yp);
				}
			case "rook":
				if (Obj.entities[i].state == Game.NORMAL) {
					//Normal
					if (Obj.entities[i].life > 0) {
						Obj.entities[i].life--;
						Obj.entities[i].lightsource = "none";
						if (Obj.entities[i].life <= 8) {
							if (Obj.entities[i].life % 2 == 0) {
								Obj.entities[i].lightsource = "laserbeside";
							}	
						}
						if (Obj.entities[i].life == 0) {
							Obj.entities[i].lightsource = "laserbeside";
						}
					}
				}else if (Obj.entities[i].state == Game.ALERTED) {
					//Alert
				}else if (Obj.entities[i].state == Game.STUNNED) {
					//Knocked out
					if (Obj.entities[i].life > 0) {
						Obj.entities[i].life--;
						if (Obj.entities[i].life <= 0) {
							Obj.entities[i].state = Game.NORMAL;
							Obj.entities[i].col = 0xFFFFFF;
							Obj.entities[i].ai = Obj.entities[i].stringpara;
							Obj.entities[i].lightsource = "laserbeside";
							Obj.entities[i].collidable = true;
							Obj.entities[i].setmessage(Rand.ppickstring("REBOOTING...", "SCANNING AREA..."), "whisper");
						}
					}
				}
			case "guard", "laserguard":
				if (Obj.entities[i].state == Game.NORMAL) {
					//Normal
				}else if (Obj.entities[i].state == Game.ALERTED) {
					//Alert
				}else if (Obj.entities[i].state == Game.STUNNED) {
					//Knocked out
					if (Obj.entities[i].life > 0) {
						Obj.entities[i].life--;
						if (Obj.entities[i].life <= 0) {
							Obj.entities[i].state = Game.NORMAL;
							Obj.entities[i].ai = Obj.entities[i].stringpara;
							if (Obj.entities[i].type == "guard") {
								Obj.entities[i].lightsource = "directional";
							}else if (Obj.entities[i].type == "laserguard") {
								Obj.entities[i].lightsource = "laserdirectional";
							}
							Obj.entities[i].col = 0xFFFFFF;
							Obj.entities[i].speed = 1;
							Obj.entities[i].setmessage(Rand.ppickstring("???", "What was that?", "Ugh, my head...", "Huh?", "Ouch..."), "whisper");
							Obj.entities[i].collidable = true;
							if (Game.alarm) Localworld.alertedtoplayer(i);
						}
					}
				}
			case "dog":
				Obj.entities[i].lightsource = "none";
				if (Obj.entities[i].state == Game.NORMAL) {
					//Normal
					Obj.entities[i].lightsource = "dogbubble";
					Obj.entities[i].cameradir++;
					if (Obj.entities[i].cameradir >= 20) {
						Obj.entities[i].cameradir = 0;
					}
					if (Obj.entities[i].cameradir < 8) {
						Obj.entities[i].para = 0;
					}else if (Obj.entities[i].cameradir < 12) {
						Obj.entities[i].para = 1;
					}else if (Obj.entities[i].cameradir < 16) {
						Obj.entities[i].para = 2;
					}else {
						Obj.entities[i].para = 1;
					}
				}else if (Obj.entities[i].state == Game.ALERTED) {
					//Alert:
					/*
					//Ok! Look for an unalerted guard!
					var guardarray:Array<Int> = new Array<Int>();
					for (j in 0 ... Obj.nentity) {
						if (Obj.entities[j].active) {
							if (Obj.entities[j].rule == "enemy" && (Obj.entities[j].type == "guard" || Obj.entities[j].type == "laserguard")) {
								if (Obj.entities[j].state != Game.ALERTED) {
									guardarray.push(j);
								}
							}
						}
					}
					
					if (guardarray.length > 0) {
						Obj.entities[i].target = Rand.fromArray(guardarray);
						Obj.entities[i].ai = "pathfind_totarget";
						Obj.entities[i].state = Game.DOG_SEEKGUARD;
					}else {*/
						//Can't find any other guards! Let's just go for the player, woof!
						//Obj.entities[i].ai = "pathfind";
						//Obj.entities[i].state = Game.DOG_CHASEPLAYER;
					//}
				}else if (Obj.entities[i].state == Game.STUNNED) {
					//Knocked out
					if (Obj.entities[i].life > 0) {
						Obj.entities[i].life--;
						if (Obj.entities[i].life <= 0) {							
							Obj.entities[i].collidable = true;
							Obj.entities[i].col = 0xFFFFFF;
							//Obj.entities[i].state = Game.ALERTED;
							Obj.entities[i].state = Game.NORMAL;
							Obj.entities[i].ai = Obj.entities[i].stringpara;
							Obj.entities[i].lightsource = "none";
							if (Game.alarm) Localworld.alertedtoplayer(i);
						}
					}
				}else if (Obj.entities[i].state == Game.DOG_SEEKGUARD) {
					//Looking for a guard!
					if (Game.adjacent(Obj.entities[i].xp, Obj.entities[i].yp, Obj.entities[Obj.entities[i].target].xp, Obj.entities[Obj.entities[i].target].yp)) {
						Obj.entities[i].state = Game.ALERTED;
						Obj.entities[i].setmessage(Rand.ppickstring("WOOF! WOOF! WOOF!", "WOOF!", "WOOF! WOOF!"), "flashing");
						Localworld.alertedtoplayer(Obj.entities[i].target);
					}
				}else if (Obj.entities[i].state == Game.DOG_CHASEPLAYER) {
					//Chasing the player
				}
			case "bombbot":
				if (Obj.entities[i].state == Game.NORMAL) {
					//Normal - Just sit there until we're alerted.
				}else if (Obj.entities[i].state == Game.ALERTED) {
					//Alert
					//Bombbots wait until they're about 10 steps away from the player. 
					//When they are, they start the countdown.
					if (Obj.entities[i].life == 10) {
						var player:Int = Obj.getplayer();
						player = Generator.closestroom_getdist_straight(Obj.entities[player].xp, Obj.entities[player].yp, Obj.entities[i].xp, Obj.entities[i].yp);
						if (player <= 10) Obj.entities[i].life--;
					}else {
						Obj.entities[i].life--;
						if (Obj.entities[i].life == 0) {
							Localworld.explode(Obj.entities[i].xp, Obj.entities[i].yp, 3);
							Obj.entities[i].active = false;
						}
					}
				}else if (Obj.entities[i].state == Game.STUNNED) {
					//If a bombbot is attacked at all, they detonate...
					Obj.entities[i].active = false;
					Localworld.explode(Obj.entities[i].xp, Obj.entities[i].yp, 3);
				}
			case "drone_light", "drone_laser":
				if (Obj.entities[i].state == Game.ALERTED) {
					if (Obj.entities[i].life > 0) {
						Obj.entities[i].life--;
						if (Obj.entities[i].life == 0) {
							Obj.entities[i].state = Game.NORMAL;
							Obj.entities[i].speed = 1;
							if(Obj.entities[i].type == "drone_laser"){
								Obj.entities[i].col = 0xFF0000;
								Obj.entities[i].lightsource = "laser_narrow";
							}else if(Obj.entities[i].type == "drone_light"){
								Obj.entities[i].col = 0xFFFFFF;
								Obj.entities[i].lightsource = "directional_narrow";
							}
							Obj.entities[i].ai = Obj.entities[i].stringpara;
						}
					}
				}else if (Obj.entities[i].state == Game.STUNNED) {
					if (Obj.entities[i].life > 0) {
						Obj.entities[i].life--;
						if (Obj.entities[i].life <= 0) {
							Obj.entities[i].state = Game.NORMAL;
							Obj.entities[i].ai = Obj.entities[i].stringpara;
							if(Obj.entities[i].type == "drone_laser"){
								Obj.entities[i].col = 0xFF0000;
								Obj.entities[i].lightsource = "laser_narrow";
							}else if(Obj.entities[i].type == "drone_light"){
								Obj.entities[i].col = 0xFFFFFF;
								Obj.entities[i].lightsource = "directional_narrow";
							}
							Obj.entities[i].speed = 1;
							Obj.entities[i].setmessage(Rand.ppickstring("REBOOTING...", "ALL SYSTEMS OPERATIONAL!"), "whisper");
							Obj.entities[i].collidable = true;
						}
					}
				}
			case "robot":
				if (Obj.entities[i].state == Game.ALERTED) {
					if (Obj.entities[i].life > 0) {
						Obj.entities[i].life--;
						if (Obj.entities[i].life == 0) {
							Obj.entities[i].state = Game.NORMAL;
							Obj.entities[i].col = 0xFF4444;
							Obj.entities[i].lightsource = "laser_narrow";
						}
					}
				}else if (Obj.entities[i].state == Game.STUNNED) {
					if (Obj.entities[i].life > 0) {
						Obj.entities[i].life--;
						if (Obj.entities[i].life <= 0) {
							Obj.entities[i].state = Game.NORMAL;
							Obj.entities[i].ai = Obj.entities[i].stringpara;
							Obj.entities[i].col = 0xFF0000;
							Obj.entities[i].lightsource = "laser_narrow";
							Obj.entities[i].collidable = true;
							Obj.entities[i].setmessage(Rand.ppickstring("REBOOTING...", "SCANNING AREA..."), "whisper");
						}
					}
				}
			case "terminator":
				if (Obj.entities[i].state == Game.ALERTED) {
					if (Obj.entities[i].life > 0) {
						Obj.entities[i].life--;
						if (Obj.entities[i].life == 0) {
							Obj.entities[i].state = Game.NORMAL;
							Obj.entities[i].col = 0xFFFF44;
							Obj.entities[i].lightsource = "laser_bubble";
						}
					}
				}else if (Obj.entities[i].state == Game.STUNNED) {
					if (Obj.entities[i].life > 0) {
						Obj.entities[i].life--;
						if (Obj.entities[i].life <= 0) {
							Obj.entities[i].state = Game.NORMAL;
							Obj.entities[i].ai = Obj.entities[i].stringpara;
							Obj.entities[i].col = 0xFFFF44;
							Obj.entities[i].lightsource = "laser_bubble";
							Obj.entities[i].collidable = true;
							Obj.entities[i].setmessage(Rand.ppickstring("REBOOTING...", "SCANNING AREA..."), "whisper");
						}
					}
				}
		}
	}
	
	override public function insight(i:Int):Void {
		//Most entities don't do anything special when they catch someone in thier sights:
		//This is mostly for enemies that fire when they see you.
		switch(Obj.entities[i].type) {
			case "drone_laser", "robot", "lasercamera", "lasersentinal":
				Obj.entities[i].setmessage("ENEMY DETECTED! FIRING!", "red");
				Game.hurtplayer(Obj.entities[i].dir);
				Game.checkifplayerdead();
			case "laserguard":
				Obj.entities[i].setmessage(Rand.ppickstring("Enemy detected! Firing!", "Got you!"), "shout");
				Game.hurtplayer(Obj.entities[i].dir);
				Game.checkifplayerdead();
			case "rook":
				Obj.entities[i].state = Game.NORMAL;
				Obj.entities[i].life = 12;
				Obj.entities[i].setmessage("BZZZZZZZZZZ...", "red");
				Game.hurtplayer(Help.NODIRECTION);
				Game.checkifplayerdead();
			case "terminator":
				Obj.entities[i].setmessage("ENEMY DETECTED! FIRING!", "red");
				Game.hurtplayer(Obj.entities[i].dir);
				Game.checkifplayerdead();
		}
	}
	
	override public function dealert(i:Int):Void {
		Obj.entities[i].state = Game.STUNNED;
		Obj.entities[i].life = 1;
		update(i);
		
		//That puts all enemies back to normal, but they'll say the wrong stuff.
		
		switch(Obj.entities[i].type) {
			case "dog":
				Obj.entities[i].setmessage("Woof?", "whisper");
			case "guard", "laserguard":
				Obj.entities[i].setmessage(Rand.ppickstring("Huh?", "Where they'd go?", "Must be imagining things..."), "whisper");
			case "sentinal", "lasersentinal", "camera", "lasercamera", "drone_light", "drone_laser", "robot", "bombbot":
				Obj.entities[i].setmessage(Rand.ppickstring("Error!", "Target Lost..."), "whisper");
			case "terminator":
				Obj.entities[i].setmessage("YOU CANNOT HIDE FROM ME", "flashing");
			default:
				Obj.entities[i].setmessage("???", "whisper");
		}
	}
	
	override public function alert(i:Int):Void {
		switch(Obj.entities[i].type) {
			case Enemy.TRIPWIRE_UP, Enemy.TRIPWIRE_DOWN, Enemy.TRIPWIRE_LEFT, Enemy.TRIPWIRE_RIGHT:
				if(Obj.entities[i].state != Game.ALERTED) Music.playsound("spotted");
				Obj.entities[i].state = Game.ALERTED;
				if (Obj.entities[i].jumpframe <= 0) {
					Obj.entities[i].col = 0xFF0000;
					Obj.entities[i].jumpframe = 120;
					Obj.entities[i].setmessage("BZZZZZZ", "flashing");
					Game.alertallenemies();
				}
			case "fireman":
				Obj.entities[i].ai = "pathfind";
				Obj.entities[i].state = Game.NORMAL;
				if (Obj.entities[i].messagedelay <= 0) {
					Obj.entities[i].setmessage(Rand.ppickstring("HAHAHAHAHAHAHAHA", "BWAAHAHAHA!", "Burn!"), "shout");
				}
			case "sentinal", "lasersentinal":
				if(Obj.entities[i].state != Game.ALERTED) Music.playsound("spotted");
				Obj.entities[i].state = Game.ALERTED;
				Obj.entities[i].lightsource = Obj.entities[i].lightsource;
				if (Obj.entities[i].jumpframe <= 0) {
					Obj.entities[i].col = 0xFF0000;
					Obj.entities[i].jumpframe = 120;
					Obj.entities[i].setmessage("INTRUDER DETECTED!", "flashing");
					Game.alertallenemies();
				}
			case "camera", "lasercamera":
				if(Obj.entities[i].state != Game.ALERTED) Music.playsound("spotted");
				Obj.entities[i].state = Game.ALERTED;
				Obj.entities[i].lightsource = Obj.entities[i].type;
				if (Obj.entities[i].jumpframe <= 0) {
					Obj.entities[i].col = 0xFF0000;
					Obj.entities[i].jumpframe = 120;
					Obj.entities[i].setmessage("INTRUDER DETECTED!", "flashing");
					Game.alertallenemies();
				}
			case "guard", "laserguard":
				Obj.entities[i].ai = "pathfind";
				Obj.entities[i].speed = 0;
				if(Obj.entities[i].state != Game.ALERTED) Music.playsound("spotted");
				Obj.entities[i].state = Game.ALERTED;
				Obj.entities[i].lightsource = "none";
				if (Obj.entities[i].jumpframe <= 0) {
					Obj.entities[i].col = 0xFF0000;
					Obj.entities[i].jumpframe = 120;
					Obj.entities[i].setmessage(Rand.ppickstring("Error! Intruder detected!", "Intruder!", "Stop!", "Intruder!", "Found you!"), "shout");
				}
			case "dog":
				if(Obj.entities[i].state != Game.ALERTED){
					Obj.entities[i].speed = 0; 
					Obj.entities[i].cameradir = 0;
					Obj.entities[i].ai = "pathfind";
				  if(Obj.entities[i].state != Game.ALERTED) Music.playsound("spotted");
					Obj.entities[i].state = Game.ALERTED;
					if (Obj.entities[i].jumpframe <= 0) {
						Obj.entities[i].col = 0xFF0000;
						Obj.entities[i].jumpframe = 120;
						Obj.entities[i].setmessage(Rand.ppickstring("WOOF! WOOF! WOOF!", "WOOF!", "WOOF! WOOF!"), "flashing");
					}
				}
			case "bombbot":
				if (Obj.entities[i].state != Game.ALERTED) {
					if(Obj.entities[i].state != Game.ALERTED) Music.playsound("spotted");	
					Obj.entities[i].state = Game.ALERTED;
					Obj.entities[i].life = 10;
					Obj.entities[i].ai = "pathfind";
					Obj.entities[i].lightsource = "bombbot";
					if (Obj.entities[i].jumpframe <= 0) {
						Obj.entities[i].col = 0xFF0000;
						Obj.entities[i].jumpframe = 120;
						Obj.entities[i].setmessage("ACTIVATED!", "flashing");
					}
				}
			case "drone_light":
				Obj.entities[i].speed = 0;
				if(Obj.entities[i].state != Game.ALERTED) Music.playsound("spotted");
				Obj.entities[i].state = Game.ALERTED;
				Obj.entities[i].ai = "none";
				if (Obj.entities[i].jumpframe <= 0) {
					Obj.entities[i].col = 0xFF0000;
					Obj.entities[i].jumpframe = 120;
					Obj.entities[i].setmessage("BZZZZZZ", "flashing");
					Game.alertallenemies();
				}
			case "drone_laser":
				Obj.entities[i].speed = 0;
				if(Obj.entities[i].state != Game.ALERTED) Music.playsound("spotted");
				Obj.entities[i].state = Game.ALERTED;
				Obj.entities[i].ai = "none";
				if (Obj.entities[i].jumpframe <= 0) {
					Obj.entities[i].col = 0xFF0000;
					Obj.entities[i].jumpframe = 120;
					Obj.entities[i].life = 10;
				}
			case "robot":
				if(Obj.entities[i].state != Game.ALERTED) Music.playsound("spotted");
				Obj.entities[i].state = Game.ALERTED;
				if (Obj.entities[i].jumpframe <= 0) {
					Obj.entities[i].col = 0xFF0000;
					Obj.entities[i].jumpframe = 120;
					Obj.entities[i].life = 10;
				}
			case "terminator":
				if(Obj.entities[i].state != Game.ALERTED) Music.playsound("spotted");
				Obj.entities[i].state = Game.ALERTED;
				if (Obj.entities[i].jumpframe <= 0) {
					Obj.entities[i].col = 0xFF0000;
					Obj.entities[i].jumpframe = 120;
					Obj.entities[i].life = 10;
				}
		}
	}
	
	override public function stun(i:Int, time:Int):Void {
		switch(Obj.entities[i].type) {
			case "guard", "laserguard", "dog":
				Draw.screenshake = 10;
				Draw.flashlight = 5;
				Obj.entities[i].state = Game.STUNNED;
				Obj.entities[i].ai = "none";
				Obj.entities[i].lightsource = "none";
				Obj.entities[i].life = time;
				
				Obj.entities[i].collidable = false;	
			case "fireman":
				Draw.screenshake = 10;
				Draw.flashlight = 5;
				if (Obj.entities[i].state != Game.STUNNED) {
				  Localworld.fireextinguisher_explode(Obj.entities[i].xp, Obj.entities[i].yp, 5);
				}
				Obj.entities[i].state = Game.STUNNED;
				Obj.entities[i].ai = "none";
				Obj.entities[i].lightsource = "none";
				Obj.entities[i].life = time;
				
				Obj.entities[i].collidable = false;
			case "bombbot":
				//Oh dear...
				Obj.entities[i].state = Game.STUNNED;
				update(i);
			case "drone_light", "drone_laser", "robot", "rook", "camera", 
			     "lasercamera", "sentinal", "lasersentinal", "terminator",
					 Enemy.TRIPWIRE_UP, Enemy.TRIPWIRE_DOWN, Enemy.TRIPWIRE_LEFT, Enemy.TRIPWIRE_RIGHT:
				Draw.screenshake = 10;
				Draw.flashlight = 5;
				Obj.entities[i].state = Game.STUNNED;
				Obj.entities[i].ai = "none";
				Obj.entities[i].lightsource = "none";
				Obj.entities[i].life = time;
				Obj.entities[i].collidable = false;
		}
	}
	
	override public function kill(i:Int):Void {
		switch(Obj.entities[i].type) {
			case "bombbot":
				Obj.entities[i].state = Game.STUNNED;
				update(i);
			case "guard", "laserguard", "dog":
				World.placetile(Std.int(Obj.entities[i].xp), Std.int(Obj.entities[i].yp), Localworld.BLOOD);
				Obj.entities[i].active = false;
				Draw.screenshake = 10;
				Draw.flashlight = 5;
			case "fireman":
				Localworld.fireextinguisher_explode(Obj.entities[i].xp, Obj.entities[i].yp, 5);
				
				World.placetile(Std.int(Obj.entities[i].xp), Std.int(Obj.entities[i].yp), Localworld.BLOOD);
				Obj.entities[i].active = false;
				Draw.screenshake = 10;
				Draw.flashlight = 5;
			case "oldterminator":
				//World.placetile(Std.int(Obj.entities[i].xp), Std.int(Obj.entities[i].yp), Localworld.RUBBLE);
				//Obj.entities[i].active = false;
				Obj.entities[i].health--;
				if(Obj.entities[i].health>0){
					Obj.entities[i].ai = "none";
					Obj.entities[i].setmessage(Rand.ppickstring("TAKING DAMAGE!", "SYSTEM FAILURE!", "ERROR! ERROR!"), "red");
					Obj.entities[i].life = 5;
					Obj.entities[i].state = Game.STUNNED;
					Draw.screenshake = 10;
					Draw.flashlight = 5;
				}else {
					Localworld.explode(Obj.entities[i].xp, Obj.entities[i].yp, 6);		
					Obj.entities[i].active = false;
				}
			case "drone_light", "drone_laser", "robot", "rook", "camera", "lasercamera", 
			     "sentinal", "lasersentinal", "terminator",
					 Enemy.TRIPWIRE_UP, Enemy.TRIPWIRE_DOWN, Enemy.TRIPWIRE_LEFT, Enemy.TRIPWIRE_RIGHT:
				World.placetile(Std.int(Obj.entities[i].xp), Std.int(Obj.entities[i].yp), Localworld.RUBBLE);
				Obj.entities[i].active = false;
				Draw.screenshake = 10;
				Draw.flashlight = 5;
		}
	}
	
	override public function animate(i:Int):Void {
		if (Obj.entities[i].shakecount > 0) Obj.entities[i].shakecount--;
		
		if (Game.timestop <= 0) {
			switch(Obj.entities[i].type) {
				case "rook":
					if (Help.slowsine % 32 >= 16) {
						Obj.entities[i].tile = 165;
					}else {
						Obj.entities[i].tile = 164;
					}
						
					Obj.entities[i].jumpframe--;
					if (Obj.entities[i].jumpframe <= 0) Obj.entities[i].jumpframe = 120;
					if (Obj.entities[i].jumpframe % 20 >= 10) {
						Obj.entities[i].col = 0xFFFF00;
					}else {
						Obj.entities[i].col = 0xFF0000;
					}
					
					if (Obj.entities[i].state == Game.STUNNED) {
						if (Help.slowsine % 32 >= 16) {
							Obj.entities[i].tile = 165;
						}else {
							if (Obj.entities[i].life >= 10) {
								Obj.entities[i].tile = "z".charCodeAt(0) + Rand.pint(1, 10);
							}else{
								Obj.entities[i].tile = "0".charCodeAt(0) + Obj.entities[i].life;
							}
						}
						Obj.entities[i].col = 0xAAAAAA;
					}
				case "fireman":
					Obj.entities[i].tile = "f".charCodeAt(0);
					
					Obj.entities[i].jumpframe--;
					if (Obj.entities[i].jumpframe <= 0) Obj.entities[i].jumpframe = 120;
					if (Obj.entities[i].jumpframe % 20 >= 10) {
						Obj.entities[i].col = 0xFFFF00;
					}else {
						Obj.entities[i].col = 0xFF0000;
					}
					
					if (Obj.entities[i].state == Game.ALERTED) {
						if (Help.tenseconds % 60 >= 30) {
							Obj.entities[i].tile = "f".charCodeAt(0);
						}else {
							Obj.entities[i].tile = "!".charCodeAt(0);
						}
					}
					
					if (Obj.entities[i].state == Game.STUNNED) {
						if (Help.slowsine % 32 >= 16) {
							Obj.entities[i].tile = "f".charCodeAt(0);
						}else {
							//Obj.entities[i].tile = "z".charCodeAt(0);
							if (Obj.entities[i].life >= 10) {
								Obj.entities[i].tile = "z".charCodeAt(0) + Rand.pint(1, 10);
							}else{
								Obj.entities[i].tile = "0".charCodeAt(0) + Obj.entities[i].life;
							}
						}
						Obj.entities[i].col = 0xAAAAAA;
					}
				case "guard", "laserguard":
					Obj.entities[i].tile = "G".charCodeAt(0) + Obj.entities[i].dir;
					
					if (Obj.entities[i].state == Game.ALERTED) {
						Obj.entities[i].jumpframe--;
						if (Obj.entities[i].jumpframe <= 0) Obj.entities[i].jumpframe = 120;
						if (Obj.entities[i].jumpframe % 20 >= 10) {
							Obj.entities[i].col = 0xFFFF00;
						}else {
							Obj.entities[i].col = 0xFF0000;
						}
						if (Help.tenseconds % 60 >= 30) {
							Obj.entities[i].tile = "G".charCodeAt(0) + Obj.entities[i].dir;
						}else {
							Obj.entities[i].tile = "!".charCodeAt(0);
						}
					}else if (Obj.entities[i].state == Game.STUNNED) {
						if (Help.slowsine % 32 >= 16) {
							Obj.entities[i].tile = "G".charCodeAt(0) + Obj.entities[i].dir;
						}else {
							//Obj.entities[i].tile = "z".charCodeAt(0);
							if (Obj.entities[i].life >= 10) {
								Obj.entities[i].tile = "z".charCodeAt(0) + Rand.pint(1, 10);
							}else{
								Obj.entities[i].tile = "0".charCodeAt(0) + Obj.entities[i].life;
							}
						}
						Obj.entities[i].col = 0xAAAAAA;
					}
				case "dog":
					Obj.entities[i].tile = "s".charCodeAt(0);
					
					switch(Obj.entities[i].state){
						case Game.NORMAL:
							//Inactive
							if (Help.tenseconds % 60 >= 15) {
								Obj.entities[i].tile = "s".charCodeAt(0);
								Obj.entities[i].col = 0xFFFFFF;
							}else {
								Obj.entities[i].tile = "s".charCodeAt(0) + 1;
								Obj.entities[i].col = 0xAAAAAA;
							}
						case Game.ALERTED, Game.DOG_CHASEPLAYER, Game.DOG_SEEKGUARD:
							Obj.entities[i].jumpframe--;
							if (Obj.entities[i].jumpframe <= 0) Obj.entities[i].jumpframe = 120;
							if (Obj.entities[i].jumpframe % 20 >= 10) {
								Obj.entities[i].col = 0xFFFF00;
							}else {
								Obj.entities[i].col = 0xFF0000;
							}
							if (Help.tenseconds % 60 >= 30) {
								if (Help.slowsine % 16 >= 8) {
									if(Obj.entities[i].dogdir == Help.LEFT){
										Obj.entities[i].tile = "s".charCodeAt(0) + 3;
									}else {
										Obj.entities[i].tile = "s".charCodeAt(0) + 2;
									}
								}else {
									if(Obj.entities[i].dogdir == Help.LEFT){
										Obj.entities[i].tile = "s".charCodeAt(0) + 5;
									}else {
										Obj.entities[i].tile = "s".charCodeAt(0) + 4;
									}
								}
							}else {
								Obj.entities[i].tile = "!".charCodeAt(0);
							}
						case Game.STUNNED:
							if (Help.slowsine % 32 >= 16) {
								Obj.entities[i].tile = "s".charCodeAt(0);
							}else {
								//Obj.entities[i].tile = "z".charCodeAt(0);
								if (Obj.entities[i].life >= 10) {
									Obj.entities[i].tile = "z".charCodeAt(0) + Rand.pint(1, 10);
								}else{
									Obj.entities[i].tile = "0".charCodeAt(0) + Obj.entities[i].life;
								}
							}
							Obj.entities[i].col = 0xAAAAAA;
					}
				case "robot":
					Obj.entities[i].tile = 236 + Obj.entities[i].dir;
					
					if (Obj.entities[i].state == Game.ALERTED) {
						Obj.entities[i].jumpframe--;
						if (Obj.entities[i].jumpframe <= 0) Obj.entities[i].jumpframe = 120;
						if (Obj.entities[i].jumpframe % 20 >= 10) {
							Obj.entities[i].col = 0xFFFF00;
						}else {
							Obj.entities[i].col = 0xFF0000;
						}
						if (Help.tenseconds % 60 >= 30) {
							Obj.entities[i].tile = 236 + Obj.entities[i].dir;
						}else {
							Obj.entities[i].tile = "!".charCodeAt(0);
						}
					}else if (Obj.entities[i].state == Game.STUNNED) {
						if (Help.slowsine % 32 >= 16) {
							Obj.entities[i].tile = 236 + Obj.entities[i].dir;
						}else {
							if (Obj.entities[i].life >= 10) {
								Obj.entities[i].tile = "z".charCodeAt(0) + Rand.pint(1, 10);
							}else{
								Obj.entities[i].tile = "0".charCodeAt(0) + Obj.entities[i].life;
							}
						}
						Obj.entities[i].col = 0xAAAAAA;
					}
				case "bombbot":
					if (Obj.entities[i].state == Game.ALERTED) {
						Obj.entities[i].tile = 220 + Obj.entities[i].dir;
						Obj.entities[i].jumpframe--;
						if (Obj.entities[i].jumpframe <= 0) Obj.entities[i].jumpframe = 120;
						if (Obj.entities[i].jumpframe % 20 >= 10) {
							Obj.entities[i].col = 0xFFFF00;
						}else {
							Obj.entities[i].col = 0xFF0000;
						}
						if (Help.tenseconds % 60 >= 45) {
							Obj.entities[i].tile = 220 + Obj.entities[i].dir;
						}else {
							if (Obj.entities[i].life >= 10) {
								Obj.entities[i].tile = 220 + Obj.entities[i].dir;
							}else{
								Obj.entities[i].tile = Std.string(Obj.entities[i].life).charCodeAt(0);
							}
						}
					}else {
						Obj.entities[i].tile = 206;
						if (Help.tenseconds % 120 >= 60) {
							Obj.entities[i].tile = 206;
						}else {
							Obj.entities[i].tile = 207;
						}
						Obj.entities[i].col = 0xAAAAAA;
					}
				case "sentinal", "lasersentinal":
					Obj.entities[i].tile = "c".charCodeAt(0);
					
					if (Obj.entities[i].state == Game.ALERTED) {
						Obj.entities[i].jumpframe--;
						if (Obj.entities[i].jumpframe <= 0) Obj.entities[i].jumpframe = 120;
						if (Obj.entities[i].jumpframe % 20 >= 10) {
							Obj.entities[i].col = 0xFFFF00;
						}else {
							Obj.entities[i].col = 0xFF0000;
						}
						if (Help.tenseconds % 60 >= 30) {
							Obj.entities[i].tile = "c".charCodeAt(0);
						}else {
							Obj.entities[i].tile = "!".charCodeAt(0);
						}
					}else if (Obj.entities[i].state == Game.STUNNED) {
						if (Help.slowsine % 32 >= 16) {
							Obj.entities[i].tile = "c".charCodeAt(0);
						}else {
							if (Obj.entities[i].life >= 10) {
								Obj.entities[i].tile = "z".charCodeAt(0) + Rand.pint(1, 10);
							}else{
								Obj.entities[i].tile = "0".charCodeAt(0) + Obj.entities[i].life;
							}
						}
						Obj.entities[i].col = 0xAAAAAA;
					}
				case "camera", "lasercamera":
					Obj.entities[i].tile = "C".charCodeAt(0) + Game.cameraframe(Obj.entities[i].cameradir);
					
					if (Obj.entities[i].state == Game.ALERTED) {
						Obj.entities[i].jumpframe--;
						if (Obj.entities[i].jumpframe <= 0) Obj.entities[i].jumpframe = 120;
						if (Obj.entities[i].jumpframe % 20 >= 10) {
							Obj.entities[i].col = 0xFFFF00;
						}else {
							Obj.entities[i].col = 0xFF0000;
						}
						if (Help.tenseconds % 60 >= 30) {
							Obj.entities[i].tile = "C".charCodeAt(0) + Game.cameraframe(Obj.entities[i].cameradir);
						}else {
							Obj.entities[i].tile = "!".charCodeAt(0);
						}
					}else if (Obj.entities[i].state == Game.STUNNED) {
						if (Help.slowsine % 32 >= 16) {
							Obj.entities[i].tile = "C".charCodeAt(0)+ Game.cameraframe(Obj.entities[i].cameradir);
						}else {
							if (Obj.entities[i].life >= 10) {
								Obj.entities[i].tile = "z".charCodeAt(0) + Rand.pint(1, 10);
							}else{
								Obj.entities[i].tile = "0".charCodeAt(0) + Obj.entities[i].life;
							}
						}
						Obj.entities[i].col = 0xAAAAAA;
					}
				case "terminator":
					Obj.entities[i].tile = 252 + Obj.entities[i].dir;
					
					if (Obj.entities[i].state == Game.ALERTED) {
						Obj.entities[i].jumpframe--;
						if (Obj.entities[i].jumpframe <= 0) Obj.entities[i].jumpframe = 120;
						if (Obj.entities[i].jumpframe % 20 >= 10) {
							Obj.entities[i].col = 0xFFFF00;
						}else {
							Obj.entities[i].col = 0xFF0000;
						}
						if (Help.tenseconds % 60 >= 30) {
							Obj.entities[i].tile = 252 + Obj.entities[i].dir;
						}else {
							Obj.entities[i].tile = "!".charCodeAt(0);
						}
					}else if (Obj.entities[i].state == Game.STUNNED) {
						if (Help.slowsine % 32 >= 16) {
							Obj.entities[i].tile = 252 + Obj.entities[i].dir;
						}else {
							if (Obj.entities[i].life >= 10) {
								Obj.entities[i].tile = "z".charCodeAt(0) + Rand.pint(1, 10);
							}else{
								Obj.entities[i].tile = "0".charCodeAt(0) + Obj.entities[i].life;
							}
						}
						Obj.entities[i].col = 0xAAAAAA;
					}
				case "drone_light", "drone_laser":
					Obj.entities[i].tile = 15;
					
					if (Obj.entities[i].state == Game.ALERTED) {
						Obj.entities[i].jumpframe--;
						if (Obj.entities[i].jumpframe <= 0) Obj.entities[i].jumpframe = 120;
						if (Obj.entities[i].jumpframe % 20 >= 10) {
							Obj.entities[i].col = 0xFFFF00;
						}else {
							Obj.entities[i].col = 0xFF0000;
						}
						if (Help.tenseconds % 60 >= 30) {
							Obj.entities[i].tile = 15;
						}else {
							Obj.entities[i].tile = "!".charCodeAt(0);
						}
					}else if (Obj.entities[i].state == Game.STUNNED) {
						if (Help.slowsine % 32 >= 16) {
							Obj.entities[i].tile = 15;
						}else {
							if (Obj.entities[i].life >= 10) {
								Obj.entities[i].tile = "z".charCodeAt(0) + Rand.pint(1, 10);
							}else{
								Obj.entities[i].tile = "0".charCodeAt(0) + Obj.entities[i].life;
							}
						}
						Obj.entities[i].col = 0xAAAAAA;
					}
				case Enemy.TRIPWIRE_UP, Enemy.TRIPWIRE_DOWN, Enemy.TRIPWIRE_LEFT, Enemy.TRIPWIRE_RIGHT:
					if (Obj.entities[i].type == Enemy.TRIPWIRE_UP) {
						Obj.entities[i].tile = 144;
					}
					if (Obj.entities[i].type == Enemy.TRIPWIRE_DOWN) {
						Obj.entities[i].tile = 145;
					}
					if (Obj.entities[i].type == Enemy.TRIPWIRE_LEFT) {
						Obj.entities[i].tile = 146;
					}
					if (Obj.entities[i].type == Enemy.TRIPWIRE_RIGHT) {
						Obj.entities[i].tile = 147;
					}
					
					if (Obj.entities[i].state == Game.ALERTED) {
						Obj.entities[i].jumpframe--;
						if (Obj.entities[i].jumpframe <= 0) Obj.entities[i].jumpframe = 120;
						if (Obj.entities[i].jumpframe % 20 >= 10) {
							Obj.entities[i].col = 0xFFFF00;
						}else {
							Obj.entities[i].col = 0xFF0000;
						}
						if (Help.tenseconds % 60 >= 30) {
						}else {
							Obj.entities[i].tile = "!".charCodeAt(0);
						}
					}else if (Obj.entities[i].state == Game.STUNNED) {
						if (Help.slowsine % 32 >= 16) {
						}else {
							if (Obj.entities[i].life >= 10) {
								Obj.entities[i].tile = "z".charCodeAt(0) + Rand.pint(1, 10);
							}else{
								Obj.entities[i].tile = "0".charCodeAt(0) + Obj.entities[i].life;
							}
						}
						Obj.entities[i].col = 0xAAAAAA;
					}
			}
			Obj.entities[i].drawframe = Obj.entities[i].tile;
		}
	}
	
	override public function drawentity(i:Int):Void {
		if (Localworld.fogat(Std.int(Obj.entities[i].xp), Std.int(Obj.entities[i].yp)) == 1) {
			Draw.draw_default(i);
		}else {
			if (Obj.entities[i].type == "robot" || Obj.entities[i].type == "terminator") {
				Draw.draw_unknown_dangerous(i);
			}else{
				Draw.draw_unknown(i);
			}
		}
	}
	
	override public function drawinit(i:Int, xoff:Int, yoff:Int, frame:Int):Void {
		Draw.draw_defaultinit(i, xoff, yoff, frame);
	}
	
	override public function collision(i:Int, j:Int):Void {
		//i is this entity, j is the other
	}
	
	override public function getinsights_thisframe(t:Int):Bool {
		return Obj.entities[t].insights_thisframe;
	}
	
	override public function setinsights_thisframe(t:Int):Void {
		Obj.entities[t].insights_thisframe = true;
	}
	
	override public function getalerted_thisframe(t:Int):Bool {
		return Obj.entities[t].alerted_thisframe;
	}
	
	override public function setalerted_thisframe(t:Int):Void {
		Obj.entities[t].alerted_thisframe = true;
	}
	
	override public function setupcollision(i:Int):Void {
		Obj.entities[i].cx = 0;
		Obj.entities[i].cy = 0;
		Obj.entities[i].w = Draw.tilewidth;
		Obj.entities[i].h = Draw.tileheight;
		Obj.entities[i].collidable = true;
	}
}