package objs;

import haxegon.*;
import terrylib.*;

class Particlelogic {
	public static function initparticle(t:Int):Void {
		if (Obj.particles[t].type == "pixel") {
			Obj.particles[t].life = 45;
		}else if (Obj.particles[t].type == "rpgtext") {
			Obj.particles[t].colour = Std.int(Obj.particles[t].ax);
			Obj.particles[t].ax = 0;
			Obj.particles[t].life = 10;
		}
	}

	public static function updateparticle(i:Int):Void {
		if (Obj.particles[i].type == "rpgtext") {
			if (Obj.particles[i].state == 0) {
				Obj.particles[i].xp += (Math.random() * 11) - 5;
				Obj.particles[i].state=1;
			}else if (Obj.particles[i].state == 1) {
				Obj.particles[i].yp-=3;
				Obj.particles[i].life--;
				if (Obj.particles[i].life <= 5) { 
					Obj.particles[i].state = 2; 
					Obj.particles[i].statedelay = 2; 
				}
			}else if (Obj.particles[i].state == 2) {
				Obj.particles[i].yp += 3;
				Obj.particles[i].life--;
				if (Obj.particles[i].life <= 0) Obj.particles[i].state = 3;
			}else if (Obj.particles[i].state == 3) {
				Obj.particles[i].state = 4; Obj.particles[i].statedelay = 20;
			}else if (Obj.particles[i].state == 4) {
				Obj.particles[i].active = false;
			}
		}else {
			Obj.particles[i].vx = Obj.particles[i].vx + Obj.particles[i].ax;
			Obj.particles[i].vy = Obj.particles[i].vy + Obj.particles[i].ay;
			
			Obj.particles[i].xp = Obj.particles[i].xp + Obj.particles[i].vx;
			Obj.particles[i].yp = Obj.particles[i].yp + Obj.particles[i].vy;
			
			Obj.particles[i].life--;
			if (Obj.particles[i].life <= 0) Obj.particles[i].active = false;
		}
	}
}
