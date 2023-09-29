package states;

import haxegon.Gfx;
import haxegon.Text;
import gamecontrol.Game;
import modernversion.Modern;
import visuals.Draw;
import visuals.Fade;
import visuals.Backdrop;
import visuals.Starfield;
import world.World;

class FallingFromTower{
	public static function input() {
		//Nothing!
	}
	
	public static function logic() {
		if (EndingScreen.endingstate == "start") {
		  EndingScreen.endingstatepara++;
			if (EndingScreen.endingstatepara >= 5) {
				EndingScreen.endingstatepara = 0;
			  EndingScreen.endingstate = "start2";	
			}
		}else if (EndingScreen.endingstate == "start2") {
		  EndingScreen.endingstatepara++;
			if (EndingScreen.endingstatepara >= 30) {
				EndingScreen.endingstatepara = 0;
			  EndingScreen.endingstate = "start3";	
			}
		}else if (EndingScreen.endingstate == "start3") {
		  EndingScreen.endingstatepara++;
			if (EndingScreen.endingstatepara >= 15) {
				EndingScreen.endingstatepara = 0;
			  EndingScreen.endingstate = "start4";	
			}
		}else if (EndingScreen.endingstate == "start4") {
			EndingScreen.endingstate = "start5";	
			Modern.endlevelanimationstate = 1;
			Modern.endlevelanimationaction = "outsideworld";
		}
		
		if (Modern.endlevelanimationstate > 0) {	
			Modern.endlevelanimationdelay++;
			if(Modern.endlevelanimationdelay >= Modern.endlevelanimationspeed){
				Modern.endlevelanimationstate += 2;
				Modern.endlevelanimationdelay = 0;
				if (Modern.endlevelanimationstate > Draw.screentileheight) {
					if(Modern.endlevelanimationaction == "outsideworld"){
						Game.changestate(Game.GAMEMODE);
						Modern.outsideworld();
					}
				}
			}
		}else if (Modern.endlevelanimationstate < 0) {
			Modern.endlevelanimationdelay++;
			if (Modern.endlevelanimationdelay >= Modern.endlevelanimationspeed) {
				Modern.endlevelanimationstate-= 2;
				Modern.endlevelanimationdelay = 0;
				if (Modern.endlevelanimationstate < -Draw.screentileheight) {
				  Modern.endlevelanimationstate = 0;
					Modern.endlevelanimationdelay = 0;
				}
			}
		}
	}
	
	public static function render() {
		//Draw a quick starfield
		Starfield.draw();
		
		Backdrop.draw(3, Gfx.screenheightmid - 60, 50, 0x05240f, 0, 0);
		Backdrop.draw(5, Gfx.screenheightmid - 30, 50, 0x054119, 0, 0);
		Backdrop.draw(8, Gfx.screenheightmid + 30, 30, 0x0d7e31, 0, 0);
		
		if (Modern.lefttowerdir == "right") {
			Gfx.scale(3, 3);
			for (i in 0 ... 6) {
				for (j in 0 ... 8) {
					Draw.precoloured_drawtile(-10 + (i * (Draw.tilewidth * 3)), -10 + (j * (Draw.tileheight * 3)), 204);	
				}
			}
			
			Gfx.scale(1, 1);
			
			if(EndingScreen.endingstate == "start2"){
				Gfx.scale(3, 3);
				Gfx.imagecolor = 0xffea03;	
				Gfx.drawtile(Gfx.screenwidthmid - (Draw.tilewidth * 0.5) + 60, -(Draw.tileheight * 3) + Std.int((Gfx.screenheight + (Draw.tileheight * 3)) * (EndingScreen.endingstatepara / 30)), "terminal", 28 + (((flash.Lib.getTimer() % 200) > 100)?1:0));
				Gfx.resetcolor();
				Gfx.scale(1, 1);
			}
		}else{
			Gfx.scale(3, 3);
			for (i in 0 ... 6) {
				for (j in 0 ... 8) {
					Draw.precoloured_drawtile(Gfx.screenwidthmid + (i * (Draw.tilewidth * 3)), -10 + (j * (Draw.tileheight * 3)), 204);	
				}
			}
			
			Gfx.scale(1, 1);
			
			if(EndingScreen.endingstate == "start2"){
				Gfx.scale(3, 3);
				Gfx.imagecolor = 0xffea03;	
				Gfx.drawtile(Gfx.screenwidthmid - (Draw.tilewidth * 0.5) - 60, -(Draw.tileheight * 3) + Std.int((Gfx.screenheight + (Draw.tileheight * 3)) * (EndingScreen.endingstatepara / 30)), "terminal", 28 + (((flash.Lib.getTimer() % 200) > 100)?1:0));
				Gfx.resetcolor();
				Gfx.scale(1, 1);
			}
		}
		
		Text.align = Text.LEFT;
		
		if (Modern.endlevelanimationstate > 0) {
			Fade.draw_topoint_withoutmap(16, 10, Std.int(Math.max(Draw.screentileheight - 10, 10)) - Modern.endlevelanimationstate);
		}else if (Modern.endlevelanimationstate < 0) {
			Fade.draw_topoint_withoutmap(16, 10, -Modern.endlevelanimationstate);
		}
	}
}