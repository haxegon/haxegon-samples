package states;

import gamecontrol.Game;
import modernversion.Modern;
import haxegon.Gfx;
import haxegon.Text;
import haxegon.Col;
import haxegon.Sound;
import haxegon.Music;
import util.Lerp;
import world.World;
import visuals.Draw;
import visuals.Fade;
import visuals.Starfield;
import visuals.Backdrop;
import visuals.Helicopter;

class EndingScreen{
	public static var endingstate:String = "start";
	public static var endingstatepara:Int = 0;
	public static var endingstatedelay:Int = 0;
	
	public static function init(){
		endingstate	= "start";
		endingstatepara = 0;
		endingstatedelay = 0;
	}
	
	public static function input() {
		if(endingstate == "pressspace"){
			if (Controls.justpressed("action")) {
				Modern.endlevelanimationstate = 1;
				Modern.endlevelanimationaction = "titlescreen";
				Music.play("silence");
				Sound.play("start");
			}
		}
	}
	
	public static function logic() {
		if (endingstate == "start") {
		  endingstatepara++;
			if (endingstatepara >= 5) {
				endingstatepara = 0;
			  endingstate = "start2";	
			}
		}else if (endingstate == "start2") {
		  endingstatepara++;
			if (endingstatepara >= 30) {
				endingstatepara = 0;
			  endingstate = "start3";	
			}
		}else if (endingstate == "start3") {
		  endingstatepara++;
			if (endingstatepara >= 120) {
				Sound.play("ticker");
				endingstatepara = 0;
			  endingstate = "start4";	
			}
		}else if (endingstate == "start4") {
		  endingstatepara++;
			if (endingstatepara >= 30) {
				Sound.play("ticker");
				endingstatepara = 0;
			  endingstate = "start5";	
			}
		}else if (endingstate == "start5") {
		  endingstatepara++;
			if (endingstatepara >= 30) {
				endingstatepara = 0;
				if (Game.gems == 0) {
					Sound.play("collectitem");
					endingstate = "nocash";
				}else {
					if(Game.gems > 1)	Sound.play("collectgem");
					endingstate = "countcash";	
					endingstatepara = 1;
					endingstatedelay = 5;
				}
			}
		}else if (endingstate == "countcash") {
			if (endingstatedelay <= 0) {
				Sound.play("collectgem");
				endingstatepara++;
				endingstatedelay = 5;
				if (endingstatepara >= Game.gems) {
				  endingstatepara = 0;
					endingstatedelay = 0;
					endingstate = "countcash2";
				}
			}else {
				endingstatedelay--;	
			}
		}else if (endingstate == "countcash2") {
		  endingstatepara++;
			if (endingstatepara >= 30) {
				Sound.play("victory");
				endingstatepara = 0;
			  endingstate = "nocash2";	
			}
		}else if (endingstate == "nocash") {
		  endingstatepara++;
			if (endingstatepara >= 60) {
				Sound.play("victory");
				endingstatepara = 0;
			  endingstate = "nocash2";	
			}
		}else if (endingstate == "nocash2") {
		  endingstatepara++;
			if (endingstatepara >= 60) {
				Sound.play("ticker");
				endingstatepara = 0;
			  endingstate = "nocash3";	
			}
		}else if (endingstate == "nocash3") {
		  endingstatepara++;
			if (endingstatepara >= 30) {
				Sound.play("ticker");
				endingstatepara = 0;
			  endingstate = "pressspace";	
			}
		}
		
		if (Modern.endlevelanimationstate > 0) {	
			Modern.endlevelanimationdelay++;
			if(Modern.endlevelanimationdelay >= Modern.endlevelanimationspeed){
				Modern.endlevelanimationstate+=2;
				Modern.endlevelanimationdelay = 0;
				if (Modern.endlevelanimationstate > Draw.screentileheight) {
					if(Modern.endlevelanimationaction == "titlescreen"){
						Game.changestate(Game.TITLEMODE);
						Modern.endlevelanimationstate = -1;
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
		if (endingstate == "start") {
			//Draw a quick starfield
			Starfield.draw();
		}else if (endingstate == "start2") {
			//Draw a quick starfield
			Starfield.draw();
			
			//Draw a little background
			Backdrop.draw(3, Std.int(Gfx.screenheightmid - 60 + (Gfx.screenheightmid + 100) - Lerp.to_value(0, Gfx.screenheightmid + 100, endingstatepara, 30, "back_out")), 50, 0x05240f, 20, 0);
			Backdrop.draw(5, Std.int(Gfx.screenheightmid - 30 + (Gfx.screenheightmid + 100) - Lerp.to_value(0, Gfx.screenheightmid + 100, endingstatepara, 30, "back_out")), 50, 0x054119, 40, 0);
			Backdrop.draw(8, Std.int(Gfx.screenheightmid + 30 + (Gfx.screenheightmid + 100) - Lerp.to_value(0, Gfx.screenheightmid + 100, endingstatepara, 30, "back_out")), 30, 0x0d7e31, 60, 0);
		}else	if (endingstate == "start3") {
			//Draw a quick starfield
			Starfield.draw();
			
			//Draw a little background
			Backdrop.draw(3, Gfx.screenheightmid - 60, 50, 0x05240f, 20, 0);
			Backdrop.draw(5, Gfx.screenheightmid - 30, 50, 0x054119, 40, 0);
			Backdrop.draw(8, Gfx.screenheightmid + 30, 30, 0x0d7e31, 60, 0);
			
			//Helicopter
			Helicopter.draw(Std.int(40 + Gfx.screenwidth - Lerp.to_value(0, Gfx.screenwidth, endingstatepara, 120, "sine_out")), 40 + Std.int((Math.sin(flash.Lib.getTimer() / 800) * 20)), 3);
		}else if (endingstate == "start4") {
			Backdrop.standardbacking();
			
			showyouescaped(30);
		}else if (endingstate == "start5") {
			Backdrop.standardbacking();
			
			showyouescaped(30);
			showyouleftthetowerwith(70);
		}else if (endingstate == "nocash" || endingstate == "countcash2") {
			Backdrop.standardbacking();
			
			showyouescaped(30);
			showyouleftthetowerwith(70);
			showgemcount(Game.gems, 85);
		}else if (endingstate == "nocash2") {
			Backdrop.standardbacking();
			
			showyouescaped(30);
			showyouleftthetowerwith(70);
			showgemcount(Game.gems, 85);
			showcongratulationsyouhavereachedrank(115);
			showranknumber(Game.gems, 135);
		}else if (endingstate == "nocash3") {
			Backdrop.standardbacking();
			
			showyouescaped(30);
			showyouleftthetowerwith(70);
			showgemcount(Game.gems, 85);
			showcongratulationsyouhavereachedrank(115);
			showranknumber(Game.gems, 135);
		  
			showrankname(165);
		}else if (endingstate == "countcash") {
			Backdrop.standardbacking();
			
			showyouescaped(30);
			showyouleftthetowerwith(70);
			showgemcount(endingstatepara, 85);
		}else if (endingstate == "pressspace") {
			Backdrop.standardbacking();
			
			showyouescaped(30);
			showyouleftthetowerwith(70);
			showgemcount(Game.gems, 85);
			showcongratulationsyouhavereachedrank(115);
			showranknumber(Game.gems, 135);
		  
			showrankname(165);
			
			Draw.setnormaltext(); Text.size = 1;
			Text.display(Gfx.screenwidthmid, Gfx.screenheight - 20, "[press SPACE to return to title]");
		}
		
		if (Modern.endlevelanimationstate > 0) {
			Fade.draw_topoint_withoutmap(16, 10, Std.int(Math.max(Draw.screentileheight - 10, 10)) - Modern.endlevelanimationstate);
		}else if (Modern.endlevelanimationstate < 0) {
			Fade.draw_topoint_withoutmap(16, 10, -Modern.endlevelanimationstate);
		}
		
		Text.align = Text.LEFT;
	}
	
	public static function showranknumber(gems:Int, ypos:Int) {	
		var xoff:Int = 0;
		if (gems == 0) {
			Gfx.imagecolor = Col.rgb(255, 255, 96);
			Gfx.fillbox((Gfx.screenwidth * 0.75) - 12, ypos, 25, 25, Col.BLACK);
			Gfx.scale(2, 2);
			Gfx.drawtile((Gfx.screenwidth * 0.75) - 12, ypos + 1, "terminal", 48);
			Gfx.scale(1, 1);
			Gfx.resetcolor();
		}else if (gems >= 100) {
			//Rank info
			xoff = Std.int((Gfx.screenwidth * 0.75) - 105 - 12);
			for (i in 0 ... 7) {
				Gfx.fillbox(xoff + (i * 30), ypos, 25, 25, Col.BLACK);
				if ((i == 0 && gems < 5) 
				 || (i == 1 && gems >= 5 && gems < 10)
				 || (i == 2 && gems >= 10 && gems < 15)
				 || (i == 3 && gems >= 15 && gems < 25)
				 || (i == 4 && gems >= 25 && gems < 50)
				 || (i == 5 && gems >= 50 && gems < 100)
				 || (i == 6 && gems >= 100)) {
					Gfx.imagecolor = Col.rgb(255, 255, 96);
				}else {
					Gfx.imagecolor = Col.rgb(40, 40, 40);
				}
				Gfx.scale(2, 2);
				Gfx.drawtile(xoff + (i * 30) + 1, ypos + 1, "terminal", 49 + i);
				Gfx.scale(1, 1);
				Gfx.resetcolor();
			}
		}else if (gems >= 50) {
			//Rank info
			xoff = Std.int((Gfx.screenwidth * 0.75) - 90 + 3);
			for (i in 0 ... 6) {
				Gfx.fillbox(xoff + (i * 30), ypos, 25, 25, Col.BLACK);
				if ((i == 0 && gems < 5) 
				 || (i == 1 && gems >= 5 && gems < 10)
				 || (i == 2 && gems >= 10 && gems < 15)
				 || (i == 3 && gems >= 15 && gems < 25)
				 || (i == 4 && gems >= 25 && gems < 50)
				 || (i == 5 && gems >= 50)) {
					Gfx.imagecolor = Col.rgb(255, 255, 96);
				}else {
					Gfx.imagecolor = Col.rgb(40, 40, 40);
				}
				Gfx.scale(2, 2);
				Gfx.drawtile(xoff + (i * 30) + 1, ypos + 1, "terminal", 49 + i);
				Gfx.scale(1, 1);
				Gfx.resetcolor();
			}
		}else{
			//Rank info
			xoff = Std.int((Gfx.screenwidth * 0.75) - 75 + 3);
			for (i in 0 ... 5) {
				Gfx.fillbox(xoff + (i * 30), ypos, 25, 25, Col.BLACK);
				if ((i == 0 && gems < 5) 
				 || (i == 1 && gems >= 5 && gems < 10)
				 || (i == 2 && gems >= 10 && gems < 15)
				 || (i == 3 && gems >= 15 && gems < 25)
				 || (i == 4 && gems >= 25)) {
					Gfx.imagecolor = Col.rgb(255, 255, 96);
				}else {
					Gfx.imagecolor = Col.rgb(40, 40, 40);
				}
				Gfx.scale(2, 2);
				Gfx.drawtile(xoff + (i * 30) + 1, ypos + 1, "terminal", 49 + i);
				Gfx.scale(1, 1);
				Gfx.resetcolor();
			}
		}	
	}
	
	public static function showyouescaped(ypos:Int) {
		Draw.setboldtext();
		Text.size = 2;
		
		Text.align = Text.CENTER;
		Text.display(Gfx.screenwidth * 0.75, ypos, "YOU ESCAPED", 0xffea03);
	}
	
	public static function showcongratulationsyouhavereachedrank(ypos:Int) {	
		Draw.setnormaltext();	Text.size = 1;
		Text.align = Text.CENTER;
		Text.display(Gfx.screenwidth * 0.75, ypos, "Congratulations! You have reached rank:", Col.WHITE);
	}
	
	public static function showrankname(ypos:Int) {
		if (Game.gems == 0) {
			Draw.setboldtext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos, "Not in it for the money", Col.WHITE);
			Draw.setnormaltext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos + 15, "[Zero gems]", Col.WHITE);	
		}else if(Game.gems > 0 && Game.gems < 5){
			Draw.setboldtext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos, "Better safe than sorry", Col.WHITE);
			Draw.setnormaltext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos + 15, "[less than 5 gems]", Col.WHITE);
		}else if(Game.gems < 10){
			Draw.setboldtext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos, "Underachiever with potential", Col.WHITE);
			Draw.setnormaltext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos + 15, "[between 5-10 gems]", Col.WHITE);	
		}else if(Game.gems < 15){
			Draw.setboldtext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos, "Unstoppable", Col.WHITE);
			Draw.setnormaltext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos + 15, "[between 10-15 gems]", Col.WHITE);	
		}else if(Game.gems < 25){
			Draw.setboldtext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos, "The Master", Col.WHITE);
			Draw.setnormaltext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos + 15, "[between 15-25 gems]", Col.WHITE);	
		}else if(Game.gems < 50){
			Draw.setboldtext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos, "The best of the best", Col.WHITE);
			Draw.setnormaltext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos + 15, "[more than 25 gems!]", Col.WHITE);	
		}else if(Game.gems < 100){
			Draw.setboldtext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos, "A whole other level", Col.WHITE);
			Draw.setnormaltext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos + 15, "[more than 50 gems!]", Col.WHITE);	
		}else{
			Draw.setboldtext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos, "Is this even possible?", Col.WHITE);
			Draw.setnormaltext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos + 15, "[more than 100 gems?!]", Col.WHITE);	
			Text.display(Gfx.screenwidth * 0.75, ypos + 30, "(This is the final rank.)", Col.WHITE);
		}	
	}
	
	public static function showgemcount(gems:Int, ypos:Int) {
		if (gems == 0) {
			Draw.setboldtext(); Text.size = 2;
			Text.display(Gfx.screenwidth * 0.75, ypos, "No gems!", Col.rgb(255, 255, 96));
		}else{
			Draw.setboldtext(); Text.size = 2;
			Gfx.imagecolor = Col.rgb(255, 255, 96);
			Text.align = Text.LEFT;

			var xoff:Int = Std.int((Gfx.screenwidth * 0.75) - (Text.width(" " + gems + " gem" + ((gems > 1)?"s":"")) / 2) - 12);
			Gfx.scale(2, 2);
			Gfx.drawtile(xoff, ypos + 1, "terminal", 36);
			Gfx.scale(1, 1);
			Gfx.resetcolor();
			Text.display(xoff + 24, ypos, " " + gems + " gem" + ((gems > 1)?"s":""), Col.rgb(255, 255, 96));
			Draw.setnormaltext();	Text.size = 1;
		}
	}
	
	public static function showyouleftthetowerwith(ypos:Int) {
		Draw.setnormaltext();	Text.size = 1;
		Text.display(Gfx.screenwidth * 0.75, ypos, "You've left the tower with", Col.WHITE);
	}
}