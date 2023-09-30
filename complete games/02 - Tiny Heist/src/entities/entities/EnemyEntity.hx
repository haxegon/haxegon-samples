package entities.entities;

import haxegon.*;
import modernversion.*;
import visuals.Draw;
import gamecontrol.Game;
import world.Generator;
import world.Localworld;
import world.World;
import entities.Obj;
import util.TinyRand;
import util.Glow;
import util.Direction;
import visuals.ScreenEffects;

class EnemyEntity extends BaseEntity {
	public function new() {
		super();
		
		name = "enemy";
		init_drawframe = 1;
	}
	
	override public function create(i:Int, xp:Float, yp:Float, enemyname:String = "", ispreplaced:String = ""):Void {
		super.create(i, xp, yp, enemyname, ispreplaced);
		
		Obj.entities[i].rule = "enemy";
		Obj.entities[i].name = enemyname;
		Obj.entities[i].type = enemyname;
		
		switch(Obj.entities[i].type) {
			case EnemyType.CAMERA, EnemyType.LASERCAMERA:
				Obj.entities[i].tile = "C".charCodeAt(0) + Game.cameraframe(Obj.entities[i].cameradir);
				Obj.entities[i].ai = "none";
				Obj.entities[i].lightsource = Obj.entities[i].type;
				Obj.entities[i].speed = 1;
				Obj.entities[i].health = 1;
				Obj.entities[i].isarobot = true;
				//Stick to wall!
				if (ispreplaced == "preplaced") {
					Game.faceawayfromwall(i);
				}else{
					Game.attachtocorner(i);
					Game.faceawayfromwall(i);
				}
				//Cameras try to pick a useful direction to point in.
				if (World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Direction.opposite(Obj.entities[i].dir);
				if (World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Direction.clockwise(Obj.entities[i].dir);
				if (World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Direction.opposite(Obj.entities[i].dir);
				if (World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir))) Obj.entities[i].dir = Direction.clockwise(Obj.entities[i].dir);
				
				Obj.entities[i].col = 0xFFFFFF;
				if (Obj.entities[i].type == EnemyType.LASERCAMERA) Obj.entities[i].col = 0xFF0000;
				Obj.entities[i].cameradir = Direction.convertcardinaltoangle(Obj.entities[i].dir);
				Obj.entities[i].camerapower = 8;
				Obj.entities[i].alertbysound = false;
				Obj.entities[i].canattack = false;
				Obj.entities[i].mysteryvalue = 18;
				
				if (World.collide(Obj.entities[i].xp + Localworld.xstep(Direction.clockwise(Obj.entities[i].dir)), Obj.entities[i].yp + Localworld.ystep(Direction.clockwise(Obj.entities[i].dir)))) {
					if (World.collide(Obj.entities[i].xp + Localworld.xstep(Direction.anticlockwise(Obj.entities[i].dir)), Obj.entities[i].yp + Localworld.ystep(Direction.anticlockwise(Obj.entities[i].dir)))) {
						//If we're tucked into a corridor, then it's a special case!
						if (World.collide(Obj.entities[i].xp + Localworld.xstep(Obj.entities[i].dir) + Localworld.xstep(Direction.clockwise(Obj.entities[i].dir)), Obj.entities[i].yp + Localworld.ystep(Obj.entities[i].dir) + Localworld.ystep(Direction.clockwise(Obj.entities[i].dir)))) {
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
					if (World.collide(Obj.entities[i].xp + Localworld.xstep(Direction.anticlockwise(Obj.entities[i].dir)), Obj.entities[i].yp + Localworld.ystep(Direction.anticlockwise(Obj.entities[i].dir)))) {
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
			case EnemyType.SENTINAL, EnemyType.LASERSENTINAL:
				Obj.entities[i].tile = "c".charCodeAt(0);
				Obj.entities[i].ai = "none";
				Obj.entities[i].lightsource = Obj.entities[i].type;
				Obj.entities[i].speed = 1;
				Obj.entities[i].health = 1;
				Obj.entities[i].isarobot = true;
				//Try to be in the middle of a room
				Obj.entities[i].dir = Direction.random();
				Obj.entities[i].col = 0xFFFFFF;
				if (Obj.entities[i].type == EnemyType.LASERSENTINAL) Obj.entities[i].col = 0xFF0000;
				
				Obj.entities[i].cameradir = 0;
				Obj.entities[i].camerapower = 8;
				Obj.entities[i].alertbysound = false;
				Obj.entities[i].canattack = false;
				Obj.entities[i].state = Game.NORMAL;
				
				if (Game.alarm) {
					Localworld.alertedtoplayer(i);
				}
			case EnemyType.GUARD, EnemyType.LASERGUARD, 
				EnemyType.GUARD_CLOCKWISE_UP, 
				EnemyType.GUARD_CLOCKWISE_DOWN, 
				EnemyType.GUARD_CLOCKWISE_LEFT, 
				EnemyType.GUARD_CLOCKWISE_RIGHT:
					
				switch(Obj.entities[i].type){
					case EnemyType.GUARD, EnemyType.LASERGUARD:
						Obj.entities[i].dir = Direction.random();
						Obj.entities[i].ai = TinyRand.ppickstring("clockwiserandommarch", "anticlockwiserandommarch");
					case EnemyType.GUARD_CLOCKWISE_UP:
						Obj.entities[i].dir = Direction.UP;
						Obj.entities[i].type = EnemyType.GUARD;
						Obj.entities[i].ai = "clockwiserandommarch";
					case EnemyType.GUARD_CLOCKWISE_DOWN:
						Obj.entities[i].dir = Direction.DOWN;
						Obj.entities[i].type = EnemyType.GUARD;
						Obj.entities[i].ai = "clockwiserandommarch";
					case EnemyType.GUARD_CLOCKWISE_LEFT:
						Obj.entities[i].dir = Direction.LEFT;
						Obj.entities[i].type = EnemyType.GUARD;
						Obj.entities[i].ai = "clockwiserandommarch";
					case EnemyType.GUARD_CLOCKWISE_RIGHT:
						Obj.entities[i].dir = Direction.RIGHT;
						Obj.entities[i].type = EnemyType.GUARD;
						Obj.entities[i].ai = "clockwiserandommarch";
				}
				
				Obj.entities[i].tile = "G".charCodeAt(0) + Obj.entities[i].dir;
				Obj.entities[i].stringpara = Obj.entities[i].ai;
				Obj.entities[i].speed = 1;
				Obj.entities[i].health = 1;
				if (Obj.entities[i].type == EnemyType.LASERGUARD) {
					Obj.entities[i].lightsource = "laserdirectional";
				}else if(Obj.entities[i].type == EnemyType.GUARD){
					Obj.entities[i].lightsource = "directional";
				}
				Obj.entities[i].col = 0xFFFFFF;
				Obj.entities[i].isarobot = false;
				
				if (Game.alarm) {
					Localworld.alertedtoplayer(i);
				}
			case EnemyType.FIREMAN:
				Obj.entities[i].tile = "f".charCodeAt(0);
				Obj.entities[i].ai = "random";
				Obj.entities[i].stringpara = Obj.entities[i].ai;
				Obj.entities[i].lightsource = "none";
				Obj.entities[i].mysteryvalue = 6;
				Obj.entities[i].speed = 3;
				Obj.entities[i].health = 1;
				Obj.entities[i].dir = Direction.random();
				Obj.entities[i].fireproof = true;
				Obj.entities[i].canattack = false;
				Obj.entities[i].isarobot = false;
				
				if (Game.alarm) {
					Localworld.alertedtoplayer(i);
				}
			case EnemyType.DOG:
				Obj.entities[i].tile = "s".charCodeAt(0);
				Obj.entities[i].ai = "none";
				Obj.entities[i].stringpara = Obj.entities[i].ai;
				Obj.entities[i].lightsource = "dogbubble";
				Obj.entities[i].cameradir = 0;
				update(i);
				Obj.entities[i].speed = 1;
				Obj.entities[i].health = 1;
				Obj.entities[i].dir = Direction.RIGHT;
				Obj.entities[i].dogdir = Direction.RIGHT;
				Obj.entities[i].canattack = true;
				Obj.entities[i].isarobot = false;
				
				if (Game.alarm) {
					Localworld.alertedtoplayer(i);
				}
			case EnemyType.BOMBBOT:
				Obj.entities[i].tile = 206;
				Obj.entities[i].ai = "none";
				Obj.entities[i].stringpara = Obj.entities[i].ai;
				Obj.entities[i].lightsource = "none";
				Obj.entities[i].speed = 0;
				Obj.entities[i].health = 1;
				Obj.entities[i].dir = Direction.RIGHT;
				Obj.entities[i].canattack = false;
				Obj.entities[i].isarobot = true;
				
				if (Game.alarm) {
					Localworld.alertedtoplayer(i);
				}
			case EnemyType.ROBOT:
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
			case EnemyType.TERMINATOR:
				Obj.entities[i].tile = 252;
				Obj.entities[i].ai = "pathfind";
				Obj.entities[i].stringpara = Obj.entities[i].ai;
				Obj.entities[i].lightsource = "laser_bubble";
				Obj.entities[i].speed = 1;
				Obj.entities[i].health = 1;
				Obj.entities[i].mysteryvalue = 1;
				Obj.entities[i].col = 0xFFFF44;
				Obj.entities[i].alertbysound = false;
				Obj.entities[i].canattack = false;
				Obj.entities[i].fireproof = true;
				Obj.entities[i].isarobot = true;
			case EnemyType.ROOK:
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
		}
	}
	
	override public function update(i:Int):Void {
		switch(Obj.entities[i].type) {
			case EnemyType.CAMERA, EnemyType.LASERCAMERA:
				if (Obj.entities[i].state == Game.CAMERA_SCANLEFT) {
					//Normal
					Obj.entities[i].stringpara = "left";
					if (Obj.entities[i].mysteryvalue > -4) {
						Obj.entities[i].mysteryvalue--;
						if (Obj.entities[i].mysteryvalue > 0) {
							Obj.entities[i].cameradir += 5;
						}
					}else {
						Obj.entities[i].mysteryvalue = 18;
						Obj.entities[i].state = Game.CAMERA_SCANRIGHT;
					}
				}else if (Obj.entities[i].state == Game.CAMERA_SCANRIGHT) {
					//Normal
					Obj.entities[i].stringpara = "right";
					if (Obj.entities[i].mysteryvalue > -4) {
						Obj.entities[i].mysteryvalue--;
						if (Obj.entities[i].mysteryvalue > 0) {
							Obj.entities[i].cameradir -= 5;
						}
					}else {
						Obj.entities[i].mysteryvalue = 18;
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
							if (Obj.entities[i].type == EnemyType.LASERCAMERA) Obj.entities[i].col = 0xFF0000;
							Obj.entities[i].lightsource = Obj.entities[i].type;
							Obj.entities[i].collidable = true;
							Obj.entities[i].setmessage(TinyRand.ppickstring("REBOOTING...", "SCANNING AREA..."), "whisper");
						}
					}
				}
			case EnemyType.SENTINAL, EnemyType.LASERSENTINAL:
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
							if (Obj.entities[i].type == EnemyType.LASERSENTINAL) Obj.entities[i].col = 0xFF0000;
							Obj.entities[i].lightsource = Obj.entities[i].type;
							Obj.entities[i].collidable = true;
							Obj.entities[i].setmessage(TinyRand.ppickstring("REBOOTING...", "SCANNING AREA..."), "whisper");
						}
					}
				}
			case EnemyType.FIREMAN:
				if (Obj.entities[i].state == Game.STUNNED) {
					//Knocked out
					if (Obj.entities[i].life > 0) {
						Obj.entities[i].life--;
						if (Obj.entities[i].life <= 0) {
							Obj.entities[i].state = Game.NORMAL;
							Obj.entities[i].ai = Obj.entities[i].stringpara;
							Obj.entities[i].lightsource = "none";
							Obj.entities[i].setmessage(TinyRand.ppickstring("Lol, fire", "HAHAHA"), "whisper");
							Obj.entities[i].collidable = true;
						}
					}
				}else {
					if (Game.turnspeed(Obj.entities[i].speed)) Localworld.startfire(Obj.entities[i].xp, Obj.entities[i].yp);
				}
			case EnemyType.ROOK:
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
							Obj.entities[i].setmessage(TinyRand.ppickstring("REBOOTING...", "SCANNING AREA..."), "whisper");
						}
					}
				}
			case EnemyType.GUARD, EnemyType.LASERGUARD:
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
							if (Obj.entities[i].type == EnemyType.GUARD) {
								Obj.entities[i].lightsource = "directional";
							}else if (Obj.entities[i].type == EnemyType.LASERGUARD) {
								Obj.entities[i].lightsource = "laserdirectional";
							}
							Obj.entities[i].col = 0xFFFFFF;
							Obj.entities[i].speed = 1;
							Obj.entities[i].setmessage(TinyRand.ppickstring("???", "What was that?", "Ugh, my head...", "Huh?", "Ouch..."), "whisper");
							Obj.entities[i].collidable = true;
							if (Game.alarm) Localworld.alertedtoplayer(i);
						}
					}
				}
			case EnemyType.DOG:
				Obj.entities[i].lightsource = "none";
				if (Obj.entities[i].state == Game.NORMAL) {
					//Normal
					Obj.entities[i].lightsource = "dogbubble";
					Obj.entities[i].cameradir++;
					if (Obj.entities[i].cameradir >= 20) {
						Obj.entities[i].cameradir = 0;
					}
					if (Obj.entities[i].cameradir < 8) {
						Obj.entities[i].mysteryvalue = 0;
					}else if (Obj.entities[i].cameradir < 12) {
						Obj.entities[i].mysteryvalue = 1;
					}else if (Obj.entities[i].cameradir < 16) {
						Obj.entities[i].mysteryvalue = 2;
					}else {
						Obj.entities[i].mysteryvalue = 1;
					}
				}else if (Obj.entities[i].state == Game.ALERTED) {
					//Alerted
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
						Obj.entities[i].setmessage(TinyRand.ppickstring("WOOF! WOOF! WOOF!", "WOOF!", "WOOF! WOOF!"), "flashing");
						Localworld.alertedtoplayer(Obj.entities[i].target);
					}
				}else if (Obj.entities[i].state == Game.DOG_CHASEPLAYER) {
					//Chasing the player
				}
			case EnemyType.BOMBBOT:
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
			case EnemyType.ROBOT:
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
							Obj.entities[i].setmessage(TinyRand.ppickstring("REBOOTING...", "SCANNING AREA..."), "whisper");
						}
					}
				}
			case EnemyType.TERMINATOR:
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
							Obj.entities[i].setmessage(TinyRand.ppickstring("REBOOTING...", "SCANNING AREA..."), "whisper");
						}
					}
				}
		}
	}
	
	override public function insight(i:Int):Void {
		//Most entities don't do anything special when they catch someone in thier sights:
		//This is mostly for enemies that fire when they see you.
		switch(Obj.entities[i].type) {
			case EnemyType.ROBOT, EnemyType.LASERCAMERA, EnemyType.LASERSENTINAL:
				Obj.entities[i].setmessage("ENEMY DETECTED! FIRING!", "red");
				Game.hurtplayer(Obj.entities[i].dir);
				Game.checkifplayerdead();
			case EnemyType.LASERGUARD:
				Obj.entities[i].setmessage(TinyRand.ppickstring("Enemy detected! Firing!", "Got you!"), "shout");
				Game.hurtplayer(Obj.entities[i].dir);
				Game.checkifplayerdead();
			case EnemyType.ROOK:
				Obj.entities[i].state = Game.NORMAL;
				Obj.entities[i].life = 12;
				Obj.entities[i].setmessage("BZZZZZZZZZZ...", "red");
				Game.hurtplayer(Direction.NONE);
				Game.checkifplayerdead();
			case EnemyType.TERMINATOR:
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
			case EnemyType.DOG, EnemyType.LASERDOG:
				Obj.entities[i].setmessage("Woof?", "whisper");
			case EnemyType.GUARD, EnemyType.LASERGUARD:
				Obj.entities[i].setmessage(TinyRand.ppickstring("Huh?", "Where they'd go?", "Must be imagining things..."), "whisper");
			case EnemyType.SENTINAL, EnemyType.LASERSENTINAL, EnemyType.CAMERA, EnemyType.LASERCAMERA, EnemyType.ROBOT, EnemyType.BOMBBOT:
				Obj.entities[i].setmessage(TinyRand.ppickstring("Error!", "Target Lost..."), "whisper");
			case EnemyType.TERMINATOR:
				Obj.entities[i].setmessage("YOU CANNOT HIDE FROM ME", "flashing");
			default:
				Obj.entities[i].setmessage("???", "whisper");
		}
	}
	
	override public function alert(i:Int):Void {
		switch(Obj.entities[i].type) {
			case EnemyType.FIREMAN:
				Obj.entities[i].ai = "pathfind";
				Obj.entities[i].state = Game.NORMAL;
				if (Obj.entities[i].messagedelay <= 0) {
					Obj.entities[i].setmessage(TinyRand.ppickstring("HAHAHAHAHAHAHAHA", "BWAAHAHAHA!", "Burn!"), "shout");
				}
			case EnemyType.SENTINAL, EnemyType.LASERSENTINAL:
				if(Obj.entities[i].state != Game.ALERTED) Sound.play("spotted");
				Obj.entities[i].state = Game.ALERTED;
				Obj.entities[i].lightsource = Obj.entities[i].lightsource;
				if (Obj.entities[i].alertframe <= 0) {
					Obj.entities[i].col = 0xFF0000;
					Obj.entities[i].alertframe = 120;
					Obj.entities[i].setmessage("INTRUDER DETECTED!", "flashing");
					Game.alertallenemies();
				}
			case EnemyType.CAMERA, EnemyType.LASERCAMERA:
				if(Obj.entities[i].state != Game.ALERTED) Sound.play("spotted");
				Obj.entities[i].state = Game.ALERTED;
				Obj.entities[i].lightsource = Obj.entities[i].type;
				if (Obj.entities[i].alertframe <= 0) {
					Obj.entities[i].col = 0xFF0000;
					Obj.entities[i].alertframe = 120;
					Obj.entities[i].setmessage("INTRUDER DETECTED!", "flashing");
					Game.alertallenemies();
				}
			case EnemyType.GUARD, EnemyType.LASERGUARD:
				Obj.entities[i].ai = "pathfind";
				Obj.entities[i].speed = 0;
				if(Obj.entities[i].state != Game.ALERTED) Sound.play("spotted");
				Obj.entities[i].state = Game.ALERTED;
				Obj.entities[i].lightsource = "none";
				if (Obj.entities[i].alertframe <= 0) {
					Obj.entities[i].col = 0xFF0000;
					Obj.entities[i].alertframe = 120;
					Obj.entities[i].setmessage(TinyRand.ppickstring("Error! Intruder detected!", "Intruder!", "Stop!", "Intruder!", "Found you!"), "shout");
				}
			case EnemyType.DOG:
				if(Obj.entities[i].state != Game.ALERTED){
					Obj.entities[i].speed = 0; 
					Obj.entities[i].cameradir = 0;
					Obj.entities[i].ai = "pathfind";
				  if(Obj.entities[i].state != Game.ALERTED) Sound.play("spotted");
					Obj.entities[i].state = Game.ALERTED;
					if (Obj.entities[i].alertframe <= 0) {
						Obj.entities[i].col = 0xFF0000;
						Obj.entities[i].alertframe = 120;
						Obj.entities[i].setmessage(TinyRand.ppickstring("WOOF! WOOF! WOOF!", "WOOF!", "WOOF! WOOF!"), "flashing");
					}
				}
			case EnemyType.BOMBBOT:
				if (Obj.entities[i].state != Game.ALERTED) {
					if(Obj.entities[i].state != Game.ALERTED) Sound.play("spotted");	
					Obj.entities[i].state = Game.ALERTED;
					Obj.entities[i].life = 10;
					Obj.entities[i].ai = "pathfind";
					Obj.entities[i].lightsource = "bombbot";
					if (Obj.entities[i].alertframe <= 0) {
						Obj.entities[i].col = 0xFF0000;
						Obj.entities[i].alertframe = 120;
						Obj.entities[i].setmessage("ACTIVATED!", "flashing");
					}
				}
			case EnemyType.ROBOT:
				if(Obj.entities[i].state != Game.ALERTED) Sound.play("spotted");
				Obj.entities[i].state = Game.ALERTED;
				if (Obj.entities[i].alertframe <= 0) {
					Obj.entities[i].col = 0xFF0000;
					Obj.entities[i].alertframe = 120;
					Obj.entities[i].life = 10;
				}
			case EnemyType.TERMINATOR:
				if(Obj.entities[i].state != Game.ALERTED) Sound.play("spotted");
				Obj.entities[i].state = Game.ALERTED;
				if (Obj.entities[i].alertframe <= 0) {
					Obj.entities[i].col = 0xFF0000;
					Obj.entities[i].alertframe = 120;
					Obj.entities[i].life = 10;
				}
		}
	}
	
	override public function stun(i:Int, time:Int):Void {
		switch(Obj.entities[i].type) {
			case EnemyType.GUARD, EnemyType.LASERGUARD, EnemyType.DOG:
				ScreenEffects.screenshake = 10;
				Obj.entities[i].state = Game.STUNNED;
				Obj.entities[i].ai = "none";
				Obj.entities[i].lightsource = "none";
				Obj.entities[i].life = time;
				
				Obj.entities[i].collidable = false;	
			case EnemyType.FIREMAN:
				ScreenEffects.screenshake = 10;
				if (Obj.entities[i].state != Game.STUNNED) {
				  Localworld.fireextinguisher_explode(Obj.entities[i].xp, Obj.entities[i].yp, 5);
				}
				Obj.entities[i].state = Game.STUNNED;
				Obj.entities[i].ai = "none";
				Obj.entities[i].lightsource = "none";
				Obj.entities[i].life = time;
				
				Obj.entities[i].collidable = false;
			case EnemyType.BOMBBOT:
				//Oh dear...
				Obj.entities[i].state = Game.STUNNED;
				update(i);
			case EnemyType.ROBOT, EnemyType.ROOK, EnemyType.CAMERA, 
			     EnemyType.LASERCAMERA, EnemyType.SENTINAL, 
					 EnemyType.LASERSENTINAL, EnemyType.TERMINATOR:
				ScreenEffects.screenshake = 10;
				Obj.entities[i].state = Game.STUNNED;
				Obj.entities[i].ai = "none";
				Obj.entities[i].lightsource = "none";
				Obj.entities[i].life = time;
				Obj.entities[i].collidable = false;
		}
	}
	
	override public function kill(i:Int):Void {
		switch(Obj.entities[i].type) {
			case EnemyType.BOMBBOT:
				Obj.entities[i].state = Game.STUNNED;
				update(i);
			case EnemyType.GUARD, EnemyType.LASERGUARD, EnemyType.DOG:
				World.placetile(Std.int(Obj.entities[i].xp), Std.int(Obj.entities[i].yp), Localworld.BLOOD);
				Obj.entities[i].active = false;
				ScreenEffects.screenshake = 10;
			case EnemyType.FIREMAN:
				Localworld.fireextinguisher_explode(Obj.entities[i].xp, Obj.entities[i].yp, 5);
				
				World.placetile(Std.int(Obj.entities[i].xp), Std.int(Obj.entities[i].yp), Localworld.BLOOD);
				Obj.entities[i].active = false;
				ScreenEffects.screenshake = 10;
			case EnemyType.ROBOT, EnemyType.ROOK, EnemyType.CAMERA, EnemyType.LASERCAMERA, 
			     EnemyType.SENTINAL, EnemyType.LASERSENTINAL, EnemyType.TERMINATOR:
				World.placetile(Std.int(Obj.entities[i].xp), Std.int(Obj.entities[i].yp), Localworld.RUBBLE);
				Obj.entities[i].active = false;
				ScreenEffects.screenshake = 10;
		}
	}
	
	override public function animate(i:Int):Void {
		super.animate(i);
		
		if (Obj.entities[i].shakecount > 0) Obj.entities[i].shakecount--;
		
		if (Game.timestop <= 0) {
			switch(Obj.entities[i].type) {
				case EnemyType.ROOK:
					if (Glow.slowsine % 32 >= 16) {
						Obj.entities[i].tile = 165;
					}else {
						Obj.entities[i].tile = 164;
					}
						
					Obj.entities[i].alertframe--;
					if (Obj.entities[i].alertframe <= 0) Obj.entities[i].alertframe = 120;
					if (Obj.entities[i].alertframe % 20 >= 10) {
						Obj.entities[i].col = 0xFFFF00;
					}else {
						Obj.entities[i].col = 0xFF0000;
					}
					
					if (Obj.entities[i].state == Game.STUNNED) {
						if (Glow.slowsine % 32 >= 16) {
							Obj.entities[i].tile = 165;
						}else {
							if (Obj.entities[i].life >= 10) {
								Obj.entities[i].tile = "z".charCodeAt(0) + TinyRand.pint(1, 10);
							}else{
								Obj.entities[i].tile = "0".charCodeAt(0) + Obj.entities[i].life;
							}
						}
						Obj.entities[i].col = 0xAAAAAA;
					}
				case EnemyType.FIREMAN:
					Obj.entities[i].tile = "f".charCodeAt(0);
					
					Obj.entities[i].alertframe--;
					if (Obj.entities[i].alertframe <= 0) Obj.entities[i].alertframe = 120;
					if (Obj.entities[i].alertframe % 20 >= 10) {
						Obj.entities[i].col = 0xFFFF00;
					}else {
						Obj.entities[i].col = 0xFF0000;
					}
					
					if (Obj.entities[i].state == Game.ALERTED) {
						if (Glow.tenseconds % 60 >= 30) {
							Obj.entities[i].tile = "f".charCodeAt(0);
						}else {
							Obj.entities[i].tile = "!".charCodeAt(0);
						}
					}
					
					if (Obj.entities[i].state == Game.STUNNED) {
						if (Glow.slowsine % 32 >= 16) {
							Obj.entities[i].tile = "f".charCodeAt(0);
						}else {
							//Obj.entities[i].tile = "z".charCodeAt(0);
							if (Obj.entities[i].life >= 10) {
								Obj.entities[i].tile = "z".charCodeAt(0) + TinyRand.pint(1, 10);
							}else{
								Obj.entities[i].tile = "0".charCodeAt(0) + Obj.entities[i].life;
							}
						}
						Obj.entities[i].col = 0xAAAAAA;
					}
				case EnemyType.GUARD, EnemyType.LASERGUARD:
					Obj.entities[i].tile = "G".charCodeAt(0) + Obj.entities[i].dir;
					
					if (Obj.entities[i].state == Game.ALERTED) {
						Obj.entities[i].alertframe--;
						if (Obj.entities[i].alertframe <= 0) Obj.entities[i].alertframe = 120;
						if (Obj.entities[i].alertframe % 20 >= 10) {
							Obj.entities[i].col = 0xFFFF00;
						}else {
							Obj.entities[i].col = 0xFF0000;
						}
						if (Glow.tenseconds % 60 >= 30) {
							Obj.entities[i].tile = "G".charCodeAt(0) + Obj.entities[i].dir;
						}else {
							Obj.entities[i].tile = "!".charCodeAt(0);
						}
					}else if (Obj.entities[i].state == Game.STUNNED) {
						if (Glow.slowsine % 32 >= 16) {
							Obj.entities[i].tile = "G".charCodeAt(0) + Obj.entities[i].dir;
						}else {
							//Obj.entities[i].tile = "z".charCodeAt(0);
							if (Obj.entities[i].life >= 10) {
								Obj.entities[i].tile = "z".charCodeAt(0) + TinyRand.pint(1, 10);
							}else{
								Obj.entities[i].tile = "0".charCodeAt(0) + Obj.entities[i].life;
							}
						}
						Obj.entities[i].col = 0xAAAAAA;
					}
				case EnemyType.DOG:
					Obj.entities[i].tile = "s".charCodeAt(0);
					
					switch(Obj.entities[i].state){
						case Game.NORMAL:
							//Inactive
							if (Glow.tenseconds % 60 >= 15) {
								Obj.entities[i].tile = "s".charCodeAt(0);
								Obj.entities[i].col = 0xFFFFFF;
							}else {
								Obj.entities[i].tile = "s".charCodeAt(0) + 1;
								Obj.entities[i].col = 0xAAAAAA;
							}
						case Game.ALERTED, Game.DOG_CHASEPLAYER, Game.DOG_SEEKGUARD:
							Obj.entities[i].alertframe--;
							if (Obj.entities[i].alertframe <= 0) Obj.entities[i].alertframe = 120;
							if (Obj.entities[i].alertframe % 20 >= 10) {
								Obj.entities[i].col = 0xFFFF00;
							}else {
								Obj.entities[i].col = 0xFF0000;
							}
							if (Glow.tenseconds % 60 >= 30) {
								if (Glow.slowsine % 16 >= 8) {
									if(Obj.entities[i].dogdir == Direction.LEFT){
										Obj.entities[i].tile = "s".charCodeAt(0) + 3;
									}else {
										Obj.entities[i].tile = "s".charCodeAt(0) + 2;
									}
								}else {
									if(Obj.entities[i].dogdir == Direction.LEFT){
										Obj.entities[i].tile = "s".charCodeAt(0) + 5;
									}else {
										Obj.entities[i].tile = "s".charCodeAt(0) + 4;
									}
								}
							}else {
								Obj.entities[i].tile = "!".charCodeAt(0);
							}
						case Game.STUNNED:
							if (Glow.slowsine % 32 >= 16) {
								Obj.entities[i].tile = "s".charCodeAt(0);
							}else {
								//Obj.entities[i].tile = "z".charCodeAt(0);
								if (Obj.entities[i].life >= 10) {
									Obj.entities[i].tile = "z".charCodeAt(0) + TinyRand.pint(1, 10);
								}else{
									Obj.entities[i].tile = "0".charCodeAt(0) + Obj.entities[i].life;
								}
							}
							Obj.entities[i].col = 0xAAAAAA;
					}
				case EnemyType.ROBOT:
					Obj.entities[i].tile = 236 + Obj.entities[i].dir;
					
					if (Obj.entities[i].state == Game.ALERTED) {
						Obj.entities[i].alertframe--;
						if (Obj.entities[i].alertframe <= 0) Obj.entities[i].alertframe = 120;
						if (Obj.entities[i].alertframe % 20 >= 10) {
							Obj.entities[i].col = 0xFFFF00;
						}else {
							Obj.entities[i].col = 0xFF0000;
						}
						if (Glow.tenseconds % 60 >= 30) {
							Obj.entities[i].tile = 236 + Obj.entities[i].dir;
						}else {
							Obj.entities[i].tile = "!".charCodeAt(0);
						}
					}else if (Obj.entities[i].state == Game.STUNNED) {
						if (Glow.slowsine % 32 >= 16) {
							Obj.entities[i].tile = 236 + Obj.entities[i].dir;
						}else {
							if (Obj.entities[i].life >= 10) {
								Obj.entities[i].tile = "z".charCodeAt(0) + TinyRand.pint(1, 10);
							}else{
								Obj.entities[i].tile = "0".charCodeAt(0) + Obj.entities[i].life;
							}
						}
						Obj.entities[i].col = 0xAAAAAA;
					}
				case EnemyType.BOMBBOT:
					if (Obj.entities[i].state == Game.ALERTED) {
						Obj.entities[i].tile = 220 + Obj.entities[i].dir;
						Obj.entities[i].alertframe--;
						if (Obj.entities[i].alertframe <= 0) Obj.entities[i].alertframe = 120;
						if (Obj.entities[i].alertframe % 20 >= 10) {
							Obj.entities[i].col = 0xFFFF00;
						}else {
							Obj.entities[i].col = 0xFF0000;
						}
						if (Glow.tenseconds % 60 >= 45) {
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
						if (Glow.tenseconds % 120 >= 60) {
							Obj.entities[i].tile = 206;
						}else {
							Obj.entities[i].tile = 207;
						}
						Obj.entities[i].col = 0xAAAAAA;
					}
				case EnemyType.SENTINAL, EnemyType.LASERSENTINAL:
					Obj.entities[i].tile = "c".charCodeAt(0);
					
					if (Obj.entities[i].state == Game.ALERTED) {
						Obj.entities[i].alertframe--;
						if (Obj.entities[i].alertframe <= 0) Obj.entities[i].alertframe = 120;
						if (Obj.entities[i].alertframe % 20 >= 10) {
							Obj.entities[i].col = 0xFFFF00;
						}else {
							Obj.entities[i].col = 0xFF0000;
						}
						if (Glow.tenseconds % 60 >= 30) {
							Obj.entities[i].tile = "c".charCodeAt(0);
						}else {
							Obj.entities[i].tile = "!".charCodeAt(0);
						}
					}else if (Obj.entities[i].state == Game.STUNNED) {
						if (Glow.slowsine % 32 >= 16) {
							Obj.entities[i].tile = "c".charCodeAt(0);
						}else {
							if (Obj.entities[i].life >= 10) {
								Obj.entities[i].tile = "z".charCodeAt(0) + TinyRand.pint(1, 10);
							}else{
								Obj.entities[i].tile = "0".charCodeAt(0) + Obj.entities[i].life;
							}
						}
						Obj.entities[i].col = 0xAAAAAA;
					}
				case EnemyType.CAMERA, EnemyType.LASERCAMERA:
					Obj.entities[i].tile = "C".charCodeAt(0) + Game.cameraframe(Obj.entities[i].cameradir);
					
					if (Obj.entities[i].state == Game.ALERTED) {
						Obj.entities[i].alertframe--;
						if (Obj.entities[i].alertframe <= 0) Obj.entities[i].alertframe = 120;
						if (Obj.entities[i].alertframe % 20 >= 10) {
							Obj.entities[i].col = 0xFFFF00;
						}else {
							Obj.entities[i].col = 0xFF0000;
						}
						if (Glow.tenseconds % 60 >= 30) {
							Obj.entities[i].tile = "C".charCodeAt(0) + Game.cameraframe(Obj.entities[i].cameradir);
						}else {
							Obj.entities[i].tile = "!".charCodeAt(0);
						}
					}else if (Obj.entities[i].state == Game.STUNNED) {
						if (Glow.slowsine % 32 >= 16) {
							Obj.entities[i].tile = "C".charCodeAt(0)+ Game.cameraframe(Obj.entities[i].cameradir);
						}else {
							if (Obj.entities[i].life >= 10) {
								Obj.entities[i].tile = "z".charCodeAt(0) + TinyRand.pint(1, 10);
							}else{
								Obj.entities[i].tile = "0".charCodeAt(0) + Obj.entities[i].life;
							}
						}
						Obj.entities[i].col = 0xAAAAAA;
					}
				case EnemyType.TERMINATOR:
					Obj.entities[i].tile = 252 + Obj.entities[i].dir;
					
					if (Obj.entities[i].state == Game.ALERTED) {
						Obj.entities[i].alertframe--;
						if (Obj.entities[i].alertframe <= 0) Obj.entities[i].alertframe = 120;
						if (Obj.entities[i].alertframe % 20 >= 10) {
							Obj.entities[i].col = 0xFFFF00;
						}else {
							Obj.entities[i].col = 0xFF0000;
						}
						if (Glow.tenseconds % 60 >= 30) {
							Obj.entities[i].tile = 252 + Obj.entities[i].dir;
						}else {
							Obj.entities[i].tile = "!".charCodeAt(0);
						}
					}else if (Obj.entities[i].state == Game.STUNNED) {
						if (Glow.slowsine % 32 >= 16) {
							Obj.entities[i].tile = 252 + Obj.entities[i].dir;
						}else {
							if (Obj.entities[i].life >= 10) {
								Obj.entities[i].tile = "z".charCodeAt(0) + TinyRand.pint(1, 10);
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
			if (Obj.entities[i].type == EnemyType.ROBOT || Obj.entities[i].type == EnemyType.TERMINATOR) {
				Draw.draw_unknown_dangerous(i);
			}else{
				Draw.draw_unknown(i);
			}
		}
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
}