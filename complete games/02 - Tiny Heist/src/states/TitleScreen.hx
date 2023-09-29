package states;

import haxegon.Text;
import haxegon.Gfx;
import haxegon.Col;
import gamecontrol.Game;
import modernversion.Modern;
import util.Glow;
import visuals.Draw;
import visuals.Fade;
import world.World;

class TitleScreen{
	public static var titlescreenmap:Array<Array<Int>> = [
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
		[1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
		[1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
		[1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
		[1, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]];
	public static var titleherox:Int = 1;
	public static var titleheroy:Int = 10;
	public static var titleheroanimx:Int = 0;
	public static var titleheroanimy:Int = 0;
	public static var titleheroframe:Int = 112;
	public static var titleguardframe:Int = 112;
	public static var titleherostate:Int = 0;
	public static var titleherostatedelay:Int = 0;
	public static var titleplayeronleftguardonright:Bool = false;
	public static var titleshowguard:Bool = false;
	public static var titleguardjumpframe:Int = 0;
	
	public static function input() {
		if (Controls.justpressed("action")) {
			Modern.endlevelanimationstate = 1;
			Modern.endlevelanimationaction = "startgame";
		}
	}
	
	public static function logic(){
		if (Modern.endlevelanimationstate > 0) {
			Modern.endlevelanimationdelay++;
			if(Modern.endlevelanimationdelay >= Modern.endlevelanimationspeed){
				Modern.endlevelanimationstate+=2;
				Modern.endlevelanimationdelay = 0;
				if (Modern.endlevelanimationstate > Draw.screentileheight) {
					if(Modern.endlevelanimationaction == "startgame"){
						Game.changestate(Game.GAMEMODE);
						Modern.start();
					}
				}
			}
		}else if (Modern.endlevelanimationstate < 0) {
			Modern.endlevelanimationdelay++;
			if (Modern.endlevelanimationdelay >= Modern.endlevelanimationspeed) {
				Modern.endlevelanimationstate-=2;
				Modern.endlevelanimationdelay = 0;
				if (Modern.endlevelanimationstate < -Draw.screentileheight) {
				  Modern.endlevelanimationstate = 0;
					Modern.endlevelanimationdelay = 0;
				}
			}
		}
	}
	
	public static function render() {
		if (titleherostate == 0) {
		  titleherox = 1;
			titleheroy = 10;
			titleheroframe = 64;
			titleguardframe = 72;
			titleherostate++;
		}else if (titleherostate >= 1 && titleherostate < 30) {
			titleherostate++;
			titleherostatedelay = 0;
		}else if (titleherostate == 30) {
			if(titleherostatedelay <= 0){
				if (titleheroanimy == 0) {
					if (titleheroy == 2) {
						titleherostate++;
						titleherostatedelay = 15;
						titleheroframe = 64 + 16 + 16 + 16;
						titleguardframe = 73;
					}else{
						titleheroy--;
						titleheroanimy = 24;	
					}
				}else {
					titleheroanimy -= 8;
				}
				titleherostatedelay = 0;
			}else {
			  titleherostatedelay--;	
			}
		}else if (titleherostate == 31) {
			if (titleherostatedelay <= 0) {
			  titleherostate++;
			  titleherostatedelay = 0;	
			}else {
			  titleherostatedelay--;	
			}
		}else if (titleherostate == 32) {
			if(titleherostatedelay <= 0){
				if (titleheroanimx == 0) {
					if (titleherox == 14) {
						titleherostate++;
						titleherostatedelay = 15;
						titleheroframe = 64;
						titleguardframe = 72;
					}else{
						titleherox++;
						titleheroanimx = -24;	
					}
				}else {
					titleheroanimx += 8;
				}
				titleherostatedelay = 0;
			}else {
			  titleherostatedelay--;
			}
		}else if (titleherostate == 33) {
			if (titleherostatedelay <= 0) {
			  titleherostate++;
			  titleherostatedelay = 0;	
			}else {
			  titleherostatedelay--;	
			}
		}else if (titleherostate == 34) {
			if(titleherostatedelay <= 0){
				if (titleheroanimy == 0) {
					if (titleheroy == -2) {
						titleshowguard = !titleshowguard;
						if (titleshowguard) {
							titleplayeronleftguardonright = !titleplayeronleftguardonright;
						}
						titleherostate = 0;
						titleherostatedelay = 0;
						titleheroframe = 64;
						titleguardframe = 71;
					}else{
						titleheroy--;
						titleheroanimy = 24;	
					}
				}else {
					titleheroanimy -= 8;
				}
				titleherostatedelay = 0;
			}else {
			  titleherostatedelay--;	
			}
		}
		//Let's draw a fake level!
		Gfx.fillbox(0, 0, Gfx.screenwidth, Gfx.screenheight, 0x112945);
		Gfx.scale(2, 2);
		for (j in 0 ... 10) {
			for (i in 0 ... 16) {
				switch(titlescreenmap[j][i]){
					case 0:
						Draw.precoloured_drawtile((i * Draw.tilewidth * 2), (j * Draw.tileheight * 2), 224);
					case 1:
						Draw.precoloured_drawtile((i * Draw.tilewidth * 2), (j * Draw.tileheight * 2), 192);
					case 2:
						Draw.precoloured_drawtile((i * Draw.tilewidth * 2), (j * Draw.tileheight * 2), 193);
				}
			}
		}
		
		if (titleplayeronleftguardonright) {
			if(titleshowguard){
				titleguardjumpframe-= 2;
				if (titleguardjumpframe <= 0) titleguardjumpframe = 120;
				if (titleguardjumpframe % 20 >= 10) {
					Gfx.imagecolor = 0xFFFF00;
				}else {
					Gfx.imagecolor = 0xFF0000;
				}
				
				if (Glow.tenseconds % 60 >= 30) {
					if(titleguardframe == 72){
						Gfx.drawtile((titleherox * Draw.tilewidth * 2) + titleheroanimx, (titleheroy * Draw.tileheight * 2) + titleheroanimy, "terminal", titleguardframe - 1);
					}else {
						Gfx.drawtile((titleherox * Draw.tilewidth * 2) + titleheroanimx, (titleheroy * Draw.tileheight * 2) + titleheroanimy, "terminal", titleguardframe + 1);
					}
				}else {
					Gfx.drawtile((titleherox * Draw.tilewidth * 2) + titleheroanimx, (titleheroy * Draw.tileheight * 2) + titleheroanimy, "terminal", "!".charCodeAt(0));
				}
			}else{
				Gfx.imagecolor = 0xffea03;
				if(titleheroframe == 64){
					Gfx.drawtile(((15 - titleherox) * Draw.tilewidth * 2) - titleheroanimx, ((9 - titleheroy) * Draw.tileheight * 2) - titleheroanimy, "terminal", titleheroframe + 1 + (((flash.Lib.getTimer() % 400) >= 200)?1:0) + 16);
				}else {
					Gfx.drawtile(((15 - titleherox) * Draw.tilewidth * 2) - titleheroanimx, ((9 - titleheroy) * Draw.tileheight * 2) - titleheroanimy, "terminal", titleheroframe + 1 + (((flash.Lib.getTimer() % 400) >= 200)?1:0) - 16);
				}
			}
		  
			Gfx.resetcolor();
		}else {
		  if(!titleshowguard){	
				Gfx.imagecolor = 0xffea03;
				Gfx.drawtile((titleherox * Draw.tilewidth * 2) + titleheroanimx, (titleheroy * Draw.tileheight * 2) + titleheroanimy, "terminal", titleheroframe + 1 + (((flash.Lib.getTimer() % 400) >= 200)?1:0));
			}else{
				titleguardjumpframe-=2;
				if (titleguardjumpframe <= 0) titleguardjumpframe = 120;
				if (titleguardjumpframe % 20 >= 10) {
					Gfx.imagecolor = 0xFFFF00;
				}else {
					Gfx.imagecolor = 0xFF0000;
				}
				
				if (Glow.tenseconds % 60 >= 30) {
					Gfx.drawtile(((15 - titleherox) * Draw.tilewidth * 2) - titleheroanimx, ((9 - titleheroy) * Draw.tileheight * 2) - titleheroanimy, "terminal", titleguardframe);
				}else {
					Gfx.drawtile(((15 - titleherox) * Draw.tilewidth * 2) - titleheroanimx, ((9 - titleheroy) * Draw.tileheight * 2) - titleheroanimy, "terminal", "!".charCodeAt(0));
				}
			}
			
			Gfx.resetcolor();
		}
		
		Gfx.scale(1, 1);
		
		Gfx.fillbox(76, 34 + 48 - 6, 232, 56, 0x112945);
		Gfx.fillbox(78, 36 + 48 - 6, 228, 50, 0x5892c7);
		Draw.setboldtext();
		Text.size = 4;
		Text.align = Text.CENTER;
		Text.display(Gfx.screenwidthmid, 32 + 47 - 6, "Tiny Heist", Col.WHITE);
		
		Draw.setnormaltext();
		Text.size = 1;
		
		Text.align = Text.CENTER;
		
		Gfx.fillbox(76 + 60 + 70, Gfx.screenheightmid + 4, 232 - 120, 24-6, 0x112945);
		Gfx.fillbox(78 + 60 + 70, Gfx.screenheightmid + 6, 228 - 120, 20-6, 0x5892c7);
		Text.display(Gfx.screenwidthmid + 70, Gfx.screenheightmid + 9 - 3, "Press SPACE", Col.WHITE);
		
		Gfx.fillbox(76, Gfx.screenheight - 36, 232, 24, 0x112945);
		Gfx.fillbox(78, Gfx.screenheight - 36, 228, 20, 0x5892c7);
		Text.display(Gfx.screenwidthmid, Gfx.screenheight - 33, "Terry Cavanagh 2016", Col.WHITE);
		Text.align = Text.LEFT;
		
		if (Modern.endlevelanimationstate > 0) {
			Fade.draw_topoint_withoutmap(16, 10, Std.int(Math.max(Draw.screentileheight - 10, 10)) - Modern.endlevelanimationstate);
		}else if (Modern.endlevelanimationstate < 0) {
			Fade.draw_topoint_withoutmap(16, 10, -Modern.endlevelanimationstate);
		}
	}
}