package;

import haxegon.*;
import gamecontrol.*;
import config.*;
import modernversion.*;
import terrylib.*;

class Render {
	//Create some arrays for the starfield.
	public static var star_x:Array<Float> = [];
	public static var star_y:Array<Float> = [];
	public static var star_speed:Array<Float> = [];
	
	public static function initstars() {
		//Initalise the arrays, and put some default values in them.
		star_x = []; star_y = []; star_speed = [];
		
		for (i in 0 ... 50) {
			star_x.push(Random.int(0, Gfx.screenwidth));  //Random x position on screen
			star_y.push(Random.int(0, Gfx.screenheight)); //Random y position on screen
			star_speed.push(Random.float(0.25, 2.5));    //Random speed between 8/16 pixels per frame
		}
	}
	
	public static function drawstarfield() {
	  Gfx.clearscreen(0x000022);
		
		for (i in 0 ... 50) {
			//Draw slow stars darker than bright stars to give a parallex effect.
			Draw.twinkle = (flash.Lib.getTimer() + ((Std.int(star_y[i])) * 100)) % 1000;
			if (Draw.twinkle >= 800) {
				Draw.twinkle = Draw.twinkle - 800;
				if (Draw.twinkle >= 100) {
					Draw.twinkle = 2;
				}else {
					Draw.twinkle = 1;	
				}
			}else {
				Draw.twinkle = 0;	
			}
			Draw.precoloured_drawtile(Gfx.screenwidth - star_x[i], star_y[i], 23 + Draw.twinkle);
			
			//Move the star position by the speed value
			star_x[i] -= star_speed[i];
			
			if (star_x[i] < -30) {
				//If the star is off screen, move it to the right hand side.
				star_x[i] += Gfx.screenwidth + 40;
				star_y[i] = Random.int(0, Gfx.screenheight);
				star_speed[i] = Random.float(0.25, 2.5);
			}
		}	
	}
	
	public static function drawhelicopter(x:Int, y:Int, scale:Float) {
		Draw.twinkle = (((flash.Lib.getTimer() % 200) > 100)?0:3);
			
		Gfx.scale(scale, scale);
		Gfx.imagecolor();
		Gfx.drawtile(x, y, "terminal", 138 + Draw.twinkle);
		Gfx.drawtile(x + (Draw.tilewidth * scale), y, "terminal", 139 + Draw.twinkle);
		Gfx.drawtile(x + (Draw.tilewidth * scale) * 2, y, "terminal", 140 + Draw.twinkle);
		Gfx.drawtile(x, y + (Draw.tileheight * scale), "terminal", 154 + Draw.twinkle);
		Gfx.drawtile(x + (Draw.tilewidth * scale), y + (Draw.tileheight * scale), "terminal", 155 + Draw.twinkle);
		Gfx.drawtile(x + (Draw.tilewidth * scale) * 2, y + (Draw.tileheight * scale), "terminal", 156 + Draw.twinkle);
		
		Gfx.drawtile(x + (Draw.tilewidth * scale), y + (Draw.tileheight * scale) * 2, "terminal", 26);
		
		Gfx.imagecolor(0xffea03);	
		Gfx.drawtile(x + (Draw.tilewidth * scale) * 1.5,  y + (Draw.tileheight * scale) * 3, "terminal", 27);
		Gfx.imagecolor();
		
		Gfx.scale(1, 1);
	}
	
	public static function drawbackdrop(divisions:Int, position:Int, height:Int, col:Int, speed:Int, dir:Int) {
		Draw.twinkle = Std.int((Gfx.screenwidth / divisions));
		scrolloffset = - Std.int(((Core.time * speed) % Draw.twinkle));
		
		if(dir < 0){
			for (j in 0 ... divisions + 1) {
				Gfx.filltri((j * Draw.twinkle) - scrolloffset - Draw.twinkle, position + height, (j + 1) * Draw.twinkle - scrolloffset, position, (j + 1) * Draw.twinkle - scrolloffset, position + height, col); 
			}
		}else if (dir > 0) {
			for (j in 0 ... divisions + 1) {
				Gfx.filltri((j * Draw.twinkle) - scrolloffset - Draw.twinkle, position, (j + 1) * Draw.twinkle - scrolloffset, position + height, j * Draw.twinkle - scrolloffset, position + height, col); 
			}
		}else {
			for (j in 0 ... divisions + 1) {
				Gfx.filltri((j * Draw.twinkle) - scrolloffset - Draw.twinkle, position + height, (j + 0.5) * Draw.twinkle - scrolloffset - Draw.twinkle, position, (j + 0.5) * Draw.twinkle - scrolloffset - Draw.twinkle, position + height, col); 
				Gfx.filltri(((j + 0.5) * Draw.twinkle) - scrolloffset - Draw.twinkle, position, (j + 1) * Draw.twinkle - scrolloffset - Draw.twinkle, position + height, (j + 0.5) * Draw.twinkle - scrolloffset - Draw.twinkle, position + height, col); 
			}
		}	
		
		Gfx.fillbox(0, position + height, Gfx.screenwidth, Gfx.screenheight - (position + height), col);
	}
	
	public static function showranknumber(gems:Int, ypos:Int) {	
		var xoff:Int = 0;
		if (gems == 0) {
			Gfx.imagecolor(Col.rgb(255, 255, 96));
			Gfx.fillbox((Gfx.screenwidth * 0.75) - 12, ypos, 25, 25, Col.BLACK);
			Gfx.scale(2, 2);
			Gfx.drawtile((Gfx.screenwidth * 0.75) - 12, ypos + 1, "terminal", 48);
			Gfx.scale(1, 1);
			Gfx.imagecolor();
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
					Gfx.imagecolor(Col.rgb(255, 255, 96));
				}else {
					Gfx.imagecolor(Col.rgb(40, 40, 40));
				}
				Gfx.scale(2, 2);
				Gfx.drawtile(xoff + (i * 30) + 1, ypos + 1, "terminal", 49 + i);
				Gfx.scale(1, 1);
				Gfx.imagecolor();
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
					Gfx.imagecolor(Col.rgb(255, 255, 96));
				}else {
					Gfx.imagecolor(Col.rgb(40, 40, 40));
				}
				Gfx.scale(2, 2);
				Gfx.drawtile(xoff + (i * 30) + 1, ypos + 1, "terminal", 49 + i);
				Gfx.scale(1, 1);
				Gfx.imagecolor();
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
					Gfx.imagecolor(Col.rgb(255, 255, 96));
				}else {
					Gfx.imagecolor(Col.rgb(40, 40, 40));
				}
				Gfx.scale(2, 2);
				Gfx.drawtile(xoff + (i * 30) + 1, ypos + 1, "terminal", 49 + i);
				Gfx.scale(1, 1);
				Gfx.imagecolor();
			}
		}	
	}
	
	public static function showyouescaped(ypos:Int) {
		Draw.setboldtext();
		Text.size = 2;
		
		Text.align(Text.CENTER);
		Text.display(Gfx.screenwidth * 0.75, ypos, "YOU ESCAPED", 0xffea03);
	}
	
	public static function showcongratulationsyouhavereachedrank(ypos:Int) {	
		Draw.setnormaltext();	Text.size = 1;
		Text.align(Text.CENTER);
		Text.display(Gfx.screenwidth * 0.75, ypos, "Congratulations! You have reached rank:", Col.WHITE);
	}
	
	public static function showrankname(ypos:Int) {
		if (Game.cash == 0) {
			Draw.setboldtext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos, "Not in it for the money", Col.WHITE);
			Draw.setnormaltext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos + 15, "[Zero gems]", Col.WHITE);	
		}else if(Game.cash > 0 && Game.cash < 5){
			Draw.setboldtext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos, "Better safe than sorry", Col.WHITE);
			Draw.setnormaltext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos + 15, "[less than 5 gems]", Col.WHITE);
		}else if(Game.cash < 10){
			Draw.setboldtext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos, "Underachiever with potential", Col.WHITE);
			Draw.setnormaltext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos + 15, "[between 5-10 gems]", Col.WHITE);	
		}else if(Game.cash < 15){
			Draw.setboldtext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos, "Unstoppable", Col.WHITE);
			Draw.setnormaltext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos + 15, "[between 10-15 gems]", Col.WHITE);	
		}else if(Game.cash < 25){
			Draw.setboldtext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos, "The Master", Col.WHITE);
			Draw.setnormaltext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos + 15, "[between 15-25 gems]", Col.WHITE);	
		}else if(Game.cash < 50){
			Draw.setboldtext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos, "The best of the best", Col.WHITE);
			Draw.setnormaltext(); Text.size = 1;
			Text.display(Gfx.screenwidth * 0.75, ypos + 15, "[more than 25 gems!]", Col.WHITE);	
		}else if(Game.cash < 100){
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
			Gfx.imagecolor(Col.rgb(255, 255, 96));
			Text.align(Text.LEFT);

			var xoff:Int = Std.int((Gfx.screenwidth * 0.75) - (Text.width(" " + gems + " gem" + ((gems > 1)?"s":"")) / 2) - 12);
			Gfx.scale(2, 2);
			Gfx.drawtile(xoff, ypos + 1, "terminal", 36);
			Gfx.scale(1, 1);
			Gfx.imagecolor();
			Text.display(xoff + 24, ypos, " " + gems + " gem" + ((gems > 1)?"s":""), Col.rgb(255, 255, 96));
			Draw.setnormaltext();	Text.size = 1;
		}
	}
	
	public static function showyouleftthetowerwith(ypos:Int) {
		Draw.setnormaltext();	Text.size = 1;
		Text.display(Gfx.screenwidth * 0.75, ypos, "You've left the tower with", Col.WHITE);
	}
	
	public static function standardbacking() {
		//Draw a quick starfield
		drawstarfield();
		
		//Draw a little background
		drawbackdrop(3, Gfx.screenheightmid - 60, 50, 0x05240f, 20, 0);
		drawbackdrop(5, Gfx.screenheightmid - 30, 50, 0x054119, 40, 0);
		drawbackdrop(8, Gfx.screenheightmid + 30, 30, 0x0d7e31, 60, 0);
		
		//Helicopter
		drawhelicopter(40, 40 + Std.int((Math.sin(flash.Lib.getTimer() / 800) * 20)), 3);
	}
	
	public static var scrolloffset:Int;
	
	public static function fallfromtowerrender() {
		//Draw a quick starfield
		drawstarfield();
		
		drawbackdrop(3, Gfx.screenheightmid - 60, 50, 0x05240f, 0, 0);
		drawbackdrop(5, Gfx.screenheightmid - 30, 50, 0x054119, 0, 0);
		drawbackdrop(8, Gfx.screenheightmid + 30, 30, 0x0d7e31, 0, 0);
		
		if (Modern.lefttowerdir == "right") {
			Gfx.scale(3, 3);
			for (i in 0 ... 6) {
				for (j in 0 ... 8) {
					Draw.precoloured_drawtile(-10 + (i * (Draw.tilewidth * 3)), -10 + (j * (Draw.tileheight * 3)), 204);	
				}
			}
			
			Gfx.scale(1, 1);
			
			if(Logic.endingstate == "start2"){
				Gfx.scale(3, 3);
				Gfx.imagecolor(0xffea03);	
				Gfx.drawtile(Gfx.screenwidthmid - (Draw.tilewidth * 0.5) + 60, -(Draw.tileheight * 3) + Std.int((Gfx.screenheight + (Draw.tileheight * 3)) * (Logic.endingstatepara / 30)), "terminal", 28 + (((flash.Lib.getTimer() % 200) > 100)?1:0));
				Gfx.imagecolor();
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
			
			if(Logic.endingstate == "start2"){
				Gfx.scale(3, 3);
				Gfx.imagecolor(0xffea03);	
				Gfx.drawtile(Gfx.screenwidthmid - (Draw.tilewidth * 0.5) - 60, -(Draw.tileheight * 3) + Std.int((Gfx.screenheight + (Draw.tileheight * 3)) * (Logic.endingstatepara / 30)), "terminal", 28 + (((flash.Lib.getTimer() % 200) > 100)?1:0));
				Gfx.imagecolor();
				Gfx.scale(1, 1);
			}
		}
		
		Text.align(Text.LEFT);
		
		if (Modern.endlevelanimationstate > 0) {
			Draw.drawfade_withoutmap(16, 10, World.tileset, Std.int(Math.max(Draw.screentileheight - 10, 10)) - Modern.endlevelanimationstate);
		}else if (Modern.endlevelanimationstate < 0) {
			Draw.drawfade_withoutmap(16, 10, World.tileset, -Modern.endlevelanimationstate);
		}
	}
	
	public static function splashscreenrender() {
		//Draw a quick starfield
		drawstarfield();
		
		Text.display(Text.CENTER, Text.CENTER, "INSERT SPLASH SCREEN HERE", Col.YELLOW);
	}
	
	public static function endingrender() {
		if (Logic.endingstate == "start") {
			//Draw a quick starfield
			drawstarfield();
		}else if (Logic.endingstate == "start2") {
			//Draw a quick starfield
			drawstarfield();
			
			//Draw a little background
			drawbackdrop(3, Std.int(Gfx.screenheightmid - 60 + (Gfx.screenheightmid + 100) - Lerp.to_value(0, Gfx.screenheightmid + 100, Logic.endingstatepara, 30, "back_out")), 50, 0x05240f, 20, 0);
			drawbackdrop(5, Std.int(Gfx.screenheightmid - 30 + (Gfx.screenheightmid + 100) - Lerp.to_value(0, Gfx.screenheightmid + 100, Logic.endingstatepara, 30, "back_out")), 50, 0x054119, 40, 0);
			drawbackdrop(8, Std.int(Gfx.screenheightmid + 30 + (Gfx.screenheightmid + 100) - Lerp.to_value(0, Gfx.screenheightmid + 100, Logic.endingstatepara, 30, "back_out")), 30, 0x0d7e31, 60, 0);
		}else	if (Logic.endingstate == "start3") {
			//Draw a quick starfield
			drawstarfield();
			
			//Draw a little background
			drawbackdrop(3, Gfx.screenheightmid - 60, 50, 0x05240f, 20, 0);
			drawbackdrop(5, Gfx.screenheightmid - 30, 50, 0x054119, 40, 0);
			drawbackdrop(8, Gfx.screenheightmid + 30, 30, 0x0d7e31, 60, 0);
			
			//Helicopter
			drawhelicopter(Std.int(40 + Gfx.screenwidth - Lerp.to_value(0, Gfx.screenwidth, Logic.endingstatepara, 120, "sine_out")), 40 + Std.int((Math.sin(flash.Lib.getTimer() / 800) * 20)), 3);
		}else if (Logic.endingstate == "start4") {
			standardbacking();
			
			showyouescaped(30);
		}else if (Logic.endingstate == "start5") {
			standardbacking();
			
			showyouescaped(30);
			showyouleftthetowerwith(70);
		}else if (Logic.endingstate == "nocash" || Logic.endingstate == "countcash2") {
			standardbacking();
			
			showyouescaped(30);
			showyouleftthetowerwith(70);
			showgemcount(Game.cash, 85);
		}else if (Logic.endingstate == "nocash2") {
			standardbacking();
			
			showyouescaped(30);
			showyouleftthetowerwith(70);
			showgemcount(Game.cash, 85);
			showcongratulationsyouhavereachedrank(115);
			showranknumber(Game.cash, 135);
		}else if (Logic.endingstate == "nocash3") {
			standardbacking();
			
			showyouescaped(30);
			showyouleftthetowerwith(70);
			showgemcount(Game.cash, 85);
			showcongratulationsyouhavereachedrank(115);
			showranknumber(Game.cash, 135);
		  
			showrankname(165);
		}else if (Logic.endingstate == "countcash") {
			standardbacking();
			
			showyouescaped(30);
			showyouleftthetowerwith(70);
			showgemcount(Logic.endingstatepara, 85);
		}else if (Logic.endingstate == "pressspace") {
			standardbacking();
			
			showyouescaped(30);
			showyouleftthetowerwith(70);
			showgemcount(Game.cash, 85);
			showcongratulationsyouhavereachedrank(115);
			showranknumber(Game.cash, 135);
		  
			showrankname(165);
			
			Draw.setnormaltext(); Text.size = 1;
			Text.display(Gfx.screenwidthmid, Gfx.screenheight - 20, "[press SPACE to return to title]");
		}
		
		if (Modern.endlevelanimationstate > 0) {
			Draw.drawfade_withoutmap(16, 10, World.tileset, Std.int(Math.max(Draw.screentileheight - 10, 10)) - Modern.endlevelanimationstate);
		}else if (Modern.endlevelanimationstate < 0) {
			Draw.drawfade_withoutmap(16, 10, World.tileset, -Modern.endlevelanimationstate);
		}
		/*
		//Draw a quick starfield
		drawstarfield();
		
		//Draw a little background
		drawbackdrop(3, Gfx.screenheightmid - 60, 50, 0x05240f, 20, 0);
		drawbackdrop(5, Gfx.screenheightmid - 30, 50, 0x054119, 40, 0);
		drawbackdrop(8, Gfx.screenheightmid + 30, 30, 0x0d7e31, 60, 0);
		
		//Helicopter
		drawhelicopter(40, 40 + Std.int((Math.sin(flash.Lib.getTimer() / 800) * 20)), 3);
		
		//Draw.setnormaltext();
		showyouescaped(30);
		
		showyouleftthetowerwith(70);
		showgemcount(Game.cash, 85);	
		showcongratulationsyouhavereachedrank(115);
		showranknumber(Game.cash, 135);
		
		showrankname(165);
		
		*/
		
		Text.align(Text.LEFT);
	}
	/*
	public static var titletext:Array<String> = [ 
			"Hello! Thanks for playing the alpha of my new game!",
			"                     ",
			"This is a tiny little thing that I'm hoping to finish",
			"before the end of the year. If you run into any",
			"problems or have any feedback, let me know!",
			"",
			"I'm @terrycavanagh on twitter, or my blog is at",
			"http://www.distractionware.com."
		];
	public static var titlelettertime:Int = 0;
	*/
	
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
	
	public static function titlerender() {
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
					Gfx.imagecolor(0xFFFF00);
				}else {
					Gfx.imagecolor(0xFF0000);
				}
				
				if (Help.tenseconds % 60 >= 30) {
					if(titleguardframe == 72){
						Gfx.drawtile((titleherox * Draw.tilewidth * 2) + titleheroanimx, (titleheroy * Draw.tileheight * 2) + titleheroanimy, "terminal", titleguardframe - 1);
					}else {
						Gfx.drawtile((titleherox * Draw.tilewidth * 2) + titleheroanimx, (titleheroy * Draw.tileheight * 2) + titleheroanimy, "terminal", titleguardframe + 1);
					}
				}else {
					Gfx.drawtile((titleherox * Draw.tilewidth * 2) + titleheroanimx, (titleheroy * Draw.tileheight * 2) + titleheroanimy, "terminal", "!".charCodeAt(0));
				}
			}else{
				Gfx.imagecolor(0xffea03);
				if(titleheroframe == 64){
					Gfx.drawtile(((15 - titleherox) * Draw.tilewidth * 2) - titleheroanimx, ((9 - titleheroy) * Draw.tileheight * 2) - titleheroanimy, "terminal", titleheroframe + 1 + (((flash.Lib.getTimer() % 400) >= 200)?1:0) + 16);
				}else {
					Gfx.drawtile(((15 - titleherox) * Draw.tilewidth * 2) - titleheroanimx, ((9 - titleheroy) * Draw.tileheight * 2) - titleheroanimy, "terminal", titleheroframe + 1 + (((flash.Lib.getTimer() % 400) >= 200)?1:0) - 16);
				}
			}
		  
			Gfx.imagecolor();
		}else {
		  if(!titleshowguard){	
				Gfx.imagecolor(0xffea03);
				Gfx.drawtile((titleherox * Draw.tilewidth * 2) + titleheroanimx, (titleheroy * Draw.tileheight * 2) + titleheroanimy, "terminal", titleheroframe + 1 + (((flash.Lib.getTimer() % 400) >= 200)?1:0));
			}else{
				titleguardjumpframe-=2;
				if (titleguardjumpframe <= 0) titleguardjumpframe = 120;
				if (titleguardjumpframe % 20 >= 10) {
					Gfx.imagecolor(0xFFFF00);
				}else {
					Gfx.imagecolor(0xFF0000);
				}
				
				if (Help.tenseconds % 60 >= 30) {
					Gfx.drawtile(((15 - titleherox) * Draw.tilewidth * 2) - titleheroanimx, ((9 - titleheroy) * Draw.tileheight * 2) - titleheroanimy, "terminal", titleguardframe);
				}else {
					Gfx.drawtile(((15 - titleherox) * Draw.tilewidth * 2) - titleheroanimx, ((9 - titleheroy) * Draw.tileheight * 2) - titleheroanimy, "terminal", "!".charCodeAt(0));
				}
			}
			
			Gfx.imagecolor();
		}
		
		Gfx.scale(1, 1);
		
		Gfx.fillbox(76, 34 + 48 - 6, 232, 56, 0x112945);
		Gfx.fillbox(78, 36 + 48 - 6, 228, 50, 0x5892c7);
		Draw.setboldtext();
		Text.size = 4;
		Text.align(Text.CENTER);
		//Text.display(Gfx.screenwidthmid, 40, "Ataboy", Col.WHITE);
		//Text.display(Gfx.screenwidthmid, 40, "Arroba", Col.WHITE);
		//Text.display(Gfx.screenwidthmid, 80, "Rogue, like", Col.WHITE);
		Text.display(Gfx.screenwidthmid, 32 + 47 - 6, "Tiny Heist", Col.WHITE);
		
		//Text.display(Gfx.screenwidthmid, 80, "Heisty Tower", Col.WHITE);
		//BAD @ STEALTH
		
		//Bad @ Sneaking
		/*
		Draw.setboldtext();
		Text.size = 3;
		Text.align(Text.CENTER);
		Text.display(Gfx.screenwidthmid, 40, "BAD     SNEAKING", 0xffea03);
		Gfx.scale(3, 3);
		if (flash.Lib.getTimer() % 800 >= 400) {
		  Gfx.imagecolor(0xffea03);	
			Gfx.drawtile(Gfx.screenwidthmid - 64, 45, "terminal", 113);
			Gfx.imagecolor();
		}else {
			Gfx.imagecolor(0xffea03);	
			Gfx.drawtile(Gfx.screenwidthmid - 64, 45, "terminal", 114);
			Gfx.imagecolor();
		}
		
		Gfx.scale(1, 1);
		*/
		//Don't look @ me
		/*
		Draw.setboldtext();
		Text.size = 3;
		Text.align(Text.CENTER);
		Text.display(Gfx.screenwidthmid, 40, "Don't look     me", 0xffea03);
		Gfx.scale(3, 3);
		if (flash.Lib.getTimer() % 800 >= 400) {
		  Gfx.imagecolor(0xffea03);	
			Gfx.drawtile(Gfx.screenwidthmid + 37, 45, "terminal", 113);
			Gfx.imagecolor();
		}else {
			Gfx.imagecolor(0xffea03);	
			Gfx.drawtile(Gfx.screenwidthmid + 37, 45, "terminal", 114);
			Gfx.imagecolor();
		}
		
		Gfx.scale(1, 1);
		*/
		
		Draw.setnormaltext();
		Text.size = 1;
		Text.align(Text.LEFT);
		
		Text.align(Text.CENTER);
		
		/*Text.display(Gfx.screenwidthmid, 12 * 12, "ARROWS:   Move", Col.rgb(128, 128, 128));
		Text.display(Gfx.screenwidthmid, 13 * 12, "SPACE/Z:   Wait", Col.rgb(128, 128, 128));
		Text.display(Gfx.screenwidthmid, 14 * 12, "1/2/3:   Use Item", Col.rgb(128, 128, 128));	
		*/
		
		Gfx.fillbox(76 + 60 + 70, Gfx.screenheightmid + 4, 232 - 120, 24-6, 0x112945);
		Gfx.fillbox(78 + 60 + 70, Gfx.screenheightmid + 6, 228 - 120, 20-6, 0x5892c7);
		Text.display(Gfx.screenwidthmid + 70, Gfx.screenheightmid + 9 - 3, "Press SPACE", Col.WHITE);
		
		Gfx.fillbox(76, Gfx.screenheight - 36, 232, 24, 0x112945);
		Gfx.fillbox(78, Gfx.screenheight - 36, 228, 20, 0x5892c7);
		Text.display(Gfx.screenwidthmid, Gfx.screenheight - 33, "Terry Cavanagh 2016", Col.WHITE);
		Text.align(Text.LEFT);
		
		if (Modern.endlevelanimationstate > 0) {
			Draw.drawfade_withoutmap(16, 10, World.tileset, Std.int(Math.max(Draw.screentileheight - 10, 10)) - Modern.endlevelanimationstate);
		}else if (Modern.endlevelanimationstate < 0) {
			Draw.drawfade_withoutmap(16, 10, World.tileset,  -Modern.endlevelanimationstate);
		}
	}
	
	public static var texty:Int;
	public static function gamerender() {
		if (Menu.textmode == 0) {	
			Draw.drawbackground();
			Draw.drawmap(World.tileset);
			
			/*if (Game.alarm) {
				if ((flash.Lib.getTimer() % 1000) >= 500) {
					Draw.alarmtransform(flash.Lib.getTimer() % 500);
				}
			}*/
			Draw.drawentities();
			
			if (Modern.endlevelanimationstate > 0) {
				var player:Int = Obj.getplayer();
				
			  var playerx:Int = Obj.entities[player].xp;
				var playery:Int = Obj.entities[player].yp;
				
				Draw.drawmapfade(playerx, playery, World.tileset, Std.int(Math.max(Draw.screentileheight - playery, playery)) - Modern.endlevelanimationstate);
			}else if (Modern.endlevelanimationstate < 0) {
				Draw.drawmapfade(Modern.endlevelanimationx, Modern.endlevelanimationy, World.tileset, -Modern.endlevelanimationstate);
			}
			
			if (Game.timestop > 0) {
				Draw.grayscale();
				Obj.templates[Obj.entindex.get(Obj.entities[Obj.getplayer()].rule)].drawentity(Obj.getplayer());
			}
			
			Draw.setboldtext();
			Draw.drawentitymessages();
			Draw.setnormaltext();
			//Draw.drawparticles();
			Draw.drawgui();
			
			texty = Gfx.screenheight - 13;
			
			/*
			if (Game.alarm) {
				Draw.setboldtext();
				Gfx.fillbox(0, 0, 58, 14, Game.backgroundcolour);
				Text.display(floortextx, 0, "! ALARM !", Draw.messagecol("flashing"));
			}*/
			
			/*
			if (Modern.newrecord && Modern.highestfloor > 1) {
				Draw.setboldtext();
				Text.align(Text.RIGHT);
				Gfx.fillbox(Gfx.screenwidth - 74, 0, 74, 14, Game.backgroundcolour);
				Text.display(Gfx.screenwidth - floortextx, 0, "NEW RECORD!", Draw.messagecol("whisper"));
				Text.align(Text.LEFT);
				Draw.setnormaltext();
			}*/
			
			if (Game.messagedelay != 0) {
				Gfx.imagecolor(Draw.messagecolback(Game.messagecol));
			}else {
				Gfx.imagecolor(Game.backgroundcolour);
			}
			Gfx.drawimage(0, Gfx.screenheight - 29, "guibar");
			Gfx.imagecolor();
			
			if (Game.messagedelay != 0) {
				Draw.setboldtext();
				if(Game.messagecol == "kludge") Draw.setnormaltext();
				//Gfx.fillbox(0, Gfx.screenheight - 12, Gfx.screenwidth, 12, Draw.messagecolback(Game.messagecol));
				Text.align(Text.CENTER);
				Text.display((Gfx.screenwidth - (Modern.inventoryslots * 26)) / 2, texty, Game.message, Draw.messagecol(Game.messagecol));
				Text.align(Text.LEFT);
				Draw.setnormaltext();
			}else {
				Draw.setnormaltext();
				//Gfx.fillbox(0, Gfx.screenheight - 12, Gfx.screenwidth, 12, Game.backgroundcolour);
				
				if (AIDirector.outside) {
					Text.display(floortextx, texty, "???", Col.rgb(196, 196, 196));
				}else if (AIDirector.floor == 16) {
					Text.display(floortextx, texty, "ROOFTOP", Col.rgb(196, 196, 196));
				}else{
					Text.display(floortextx, texty, "FLOOR " + AIDirector.floor + "/" + 15, Col.rgb(196, 196, 196));
				}
				
				Draw.setnormaltext();
				
				if (Modern.hpflash == 0) {
					Text.display(hptextx, texty, "HP", Col.rgb(255, 64, 64));
					for (i in 0 ... 3) {
						//Gfx.imagecolor(Col.rgb(180, 64, 64));
						Draw.precoloured_drawtile(hptextx + 14 + (i * 12), texty + 1, 19);
						//Gfx.imagecolor();
					}
					for (i in 0 ... Game.health) {
						//Gfx.imagecolor(Col.rgb(255, 64, 64));
						Draw.precoloured_drawtile(hptextx + 14 + (i * 12), texty + 1, 3);
						//Gfx.imagecolor();
					}
				}else {
					var hpflashamount:Int = Col.rgb(Std.int(Math.min(220 + Modern.hpflash * 5, 255)), 
					                                Std.int(Math.min(64 + Modern.hpflash * 5, 255)), 
																					Std.int(Math.min(64 + Modern.hpflash * 5, 255)));
					Text.display(hptextx, texty, "HP", hpflashamount);
					for (i in 0 ... 3) {
						Gfx.imagecolor(Col.rgb(180, 64, 64));
						Gfx.drawtile(hptextx + 14 + (i * 12), texty + 1, "terminal", 19);
						Gfx.imagecolor();
					}
					for (i in 0 ... Game.health) {
						Gfx.imagecolor(hpflashamount);
						Gfx.drawtile(hptextx + 14 + (i * 12), texty + 1, "terminal", 3);
						Gfx.imagecolor();
					}
					Modern.hpflash--;
				}
				
				if (Game.keys > 0) {
					if (Modern.keyflash == 0) {
						Gfx.imagecolor(Col.rgb(128, 255, 128));
						Gfx.drawtile(keytextx, texty + 1, "terminal", 12);
						Gfx.imagecolor();
						Text.display(keytextx + 12, texty, "x" + Std.string(Game.keys), Col.rgb(128, 255, 128));
					}else {
						var keyflashcol:Int = Col.rgb(Std.int(Math.min(128 + Modern.keyflash * 8, 255)), 
					                                Std.int(Math.min(255 + Modern.keyflash * 8, 255)), 
																					Std.int(Math.min(128 + Modern.keyflash * 8, 255)));
						Gfx.imagecolor(keyflashcol);
						Gfx.drawtile(keytextx, texty + 1, "terminal", 12);
						Gfx.imagecolor();
						Text.display(keytextx + 12, texty, "x" + Std.string(Game.keys), keyflashcol);
					  Modern.keyflash--;	
					}
				}
				
				if (Game.cash > 0) {
					if(Modern.gemflash == 0){
						Gfx.imagecolor(Col.rgb(255, 255, 128));
						Gfx.drawtile(gemtextx, texty + 1, "terminal", "$".charCodeAt(0));
						Gfx.imagecolor();
						Text.display(gemtextx + 12, texty, "x" + Std.string(Game.cash), Col.rgb(255, 255, 128));
					}else {
						var gemflashcol:Int = Col.rgb(Std.int(Math.min(255 + Modern.gemflash * 8, 255)), 
					                                Std.int(Math.min(255 + Modern.gemflash * 8, 255)), 
																					Std.int(Math.min(128 + Modern.gemflash * 8, 255)));
						Gfx.imagecolor(gemflashcol);
						Gfx.drawtile(gemtextx, texty + 1, "terminal", "$".charCodeAt(0));
						Gfx.imagecolor();
						Text.display(gemtextx + 12, texty, "x" + Std.string(Game.cash), Col.rgb(255, 255, 128));
					  Modern.gemflash--;	
					}
				}
			}
			
			Modern.showitems();
			
			if (Modern.popupwindow) {
				showpopups();
			}
		}else if (Menu.textmode == 1) {
			//Menus
			Gfx.clearscreen(Col.BLACK);
			
			Menu.showtextbox();
			
			if (Menu.menusize == 1 && Menu.menuoptions[0] == "") {
			}else {
				Draw.drawmenu();
			}
		}else if (Menu.textmode == 2) {
			//World map
			Gfx.clearscreen(Col.BLACK);
			
			Openworld.drawmap(4, 1, World.tileset);
		}
	}
	
	public static function showpopups() {
		if (Modern.popupmode == "soldoutshopkeeper") {
			var boxheight:Int = 70;
			var tx = Gfx.screenwidthmid - 120;
			var ty = Gfx.screenheightmid - Std.int(boxheight / 2) - Std.int(Lerp.to_value(boxheight * 2, 0, Modern.popuplerp, Modern.popupspeed, ((Modern.popupstate<2)?Modern.popupanimationtype_appear:Modern.popupanimationtype_disappear)));
			
			Modern.drawbubble(tx, ty, 240, boxheight, Draw.shade(Modern.shopkeepcol, 0.8), 0x000000, 0x000000);
			ty += 2;
			
			Text.align(Text.CENTER);
			Draw.setboldtext();
			Gfx.imagecolor(Modern.shopkeepcol);
			Gfx.drawtile(Gfx.screenwidthmid - 6 - 40, ty + 5, "terminal", 2);
			Gfx.imagecolor();
			Text.display(Gfx.screenwidthmid, ty + 5, "    Shopkeeper", Draw.messagecol("white"));	
			Draw.setnormaltext();
			Text.display(Gfx.screenwidthmid, ty + 22, "Sorry, I've got nothing else to sell!", Draw.messagecol("white"));	
			Text.align(Text.LEFT);
			
			Text.align(Text.CENTER);
			Text.display(Gfx.screenwidthmid, ty + 40, "> Oh, ok. <", Draw.messagecol("flashing"));	
			
			Text.align(Text.LEFT);
		}else if (Modern.popupmode == "itemshopkeeper") {
			var boxheight:Int = 90;
			var tx = Gfx.screenwidthmid - 120;
			var ty = Gfx.screenheightmid - Std.int(boxheight / 2) - Std.int(Lerp.to_value(boxheight * 2, 0, Modern.popuplerp, Modern.popupspeed, ((Modern.popupstate<2)?Modern.popupanimationtype_appear:Modern.popupanimationtype_disappear)));
			
			Modern.drawbubble(tx, ty, 240, boxheight, Draw.shade(Modern.shopkeepcol, 0.8), 0x000000, 0x000000);
			ty += 2;
			
			Text.align(Text.CENTER);
			Draw.setboldtext();
			Gfx.imagecolor(Modern.shopkeepcol);
			Gfx.drawtile(Gfx.screenwidthmid - 6 - 40, ty + 5, "terminal", 2);
			Gfx.imagecolor();
			Text.display(Gfx.screenwidthmid, ty + 5, "    Shopkeeper", Draw.messagecol("white"));	
			Draw.setnormaltext();
			Text.align(Text.LEFT);
			var slen:Int = Std.int(Text.width("Can I interest you in this " + Modern.popupitem.name + "?") + 24);
			var slen2:Int = Std.int(Text.width("Can I interest you in this "));
			Text.display(Gfx.screenwidthmid - Std.int(slen / 2) - 3, ty + 22, "Can I interest you in this ", Draw.messagecol("white"));	
			Draw.setboldtext();
			Text.display(Gfx.screenwidthmid - Std.int(slen / 2) - 3 + slen2 + 18, ty + 22, Modern.popupitem.name + "?", Col.rgb(Modern.popupitem.r, Modern.popupitem.g, Modern.popupitem.b));	
			
			Gfx.imagecolor(Col.rgb(Modern.popupitem.r, Modern.popupitem.g, Modern.popupitem.b));
			Gfx.drawtile(Gfx.screenwidthmid - Std.int(slen / 2) - 3 + slen2 + 3, ty + 22, "terminal", Modern.popupitem.character.charCodeAt(0));
			Gfx.imagecolor();
			
			Draw.setnormaltext();
			
			Text.align(Text.LEFT);
			var slen:Int = Std.int(Text.width("It's yours for just " + Modern.popupitem.cost + " GEM" + (Modern.popupitem.cost>1?"S":"") + "!"));
			Text.display(Gfx.screenwidthmid - Std.int(slen / 2), ty + 34, "It's yours for just ", Draw.messagecol("white"));	
			var slen2:Int = Std.int(Gfx.screenwidthmid - Std.int(slen / 2) + Text.width("It's yours for just "));
			Draw.setboldtext();
			Text.display(slen2 + 4, ty + 34, Modern.popupitem.cost + " GEM" + (Modern.popupitem.cost>1?"S":"") + "!", Draw.messagecol("player"));	
			Draw.setnormaltext();
			
			Text.align(Text.CENTER);
			if (Modern.slotsfree() == 0 && Modern.popupstate != 2) {
				Text.display(Gfx.screenwidthmid, ty + 54 + 5, "> I don't have room for that! <", Draw.messagecol("flashing"));
			}else if (Modern.popupitem.cost > Game.cash && Modern.popupstate != 2) {
				Text.display(Gfx.screenwidthmid, ty + 54 + 5, "> I can't afford that! <", Draw.messagecol("flashing"));	
			}else{
				if (Modern.menuselection == 0) {
					Text.display(Gfx.screenwidthmid, ty + 54, "> Great, I'll take one! (cost: " + Modern.popupitem.cost + " GEM" + (Modern.popupitem.cost>1?"S":"") + ") <", Draw.messagecol("flashing"));	
				}else{
					Text.display(Gfx.screenwidthmid, ty + 54, "Great, I'll take one! (cost: " + Modern.popupitem.cost + " GEM" + (Modern.popupitem.cost>1?"S":"") + ")", Draw.messagecol("grayedout"));	
				}
				
				if (Modern.menuselection == 1) {
					Text.display(Gfx.screenwidthmid, ty + 66, "> No way! <", Draw.messagecol("flashing"));	
				}else {
					Text.display(Gfx.screenwidthmid, ty + 66, "No way!", Draw.messagecol("grayedout"));	
				}
			}
			
			Text.align(Text.LEFT);
		}else	if (Modern.popupmode == "shopkeeper") {
			var boxheight:Int = 90;
			var tx = Gfx.screenwidthmid - 120;
			var ty = Gfx.screenheightmid - Std.int(boxheight / 2) - Std.int(Lerp.to_value(boxheight * 2, 0, Modern.popuplerp, Modern.popupspeed, ((Modern.popupstate<2)?Modern.popupanimationtype_appear:Modern.popupanimationtype_disappear)));
			
			Modern.drawbubble(tx, ty, 240, boxheight, Draw.shade(Modern.shopkeepcol, 0.8), 0x000000, 0x000000);
			ty += 2;
			
			Text.align(Text.CENTER);
			Draw.setboldtext();
			Gfx.imagecolor(Modern.shopkeepcol);
			Gfx.drawtile(Gfx.screenwidthmid - 6 - 40, ty + 5, "terminal", 2);
			Gfx.imagecolor();
			Text.display(Gfx.screenwidthmid, ty + 5, "    Shopkeeper", Draw.messagecol("white"));	
			Draw.setnormaltext();
			Text.display(Gfx.screenwidthmid, ty + 22, "Hello! Want some keys? I can help!", Draw.messagecol("white"));	
			Text.align(Text.LEFT);
			var slen:Int = Std.int(Text.width("I sell keys for just " + Modern.keygemrate + " GEM" + (Modern.keygemrate>1?"S":"") + "!"));
			Text.display(Gfx.screenwidthmid - Std.int(slen / 2), ty + 34, "I sell keys for just ", Draw.messagecol("white"));	
			var slen2:Int = Std.int(Gfx.screenwidthmid - Std.int(slen / 2) + Text.width("I sell keys for just "));
			Draw.setboldtext();
			Text.display(slen2 + 3, ty + 34, Modern.keygemrate + " GEM" + (Modern.keygemrate>1?"S":"") + "!", Draw.messagecol("player"));	
			Draw.setnormaltext();
			
			Text.align(Text.CENTER);
			if (Modern.keygemrate > Game.cash && Modern.popupstate != 2) {
				Text.display(Gfx.screenwidthmid, ty + 54 + 5, "> I can't afford that! <", Draw.messagecol("flashing"));	
			}else{
				if (Modern.menuselection == 0) {
					Text.display(Gfx.screenwidthmid, ty + 54, "> Great, I'll take one! (cost: " + Modern.keygemrate + " GEM" + (Modern.keygemrate>1?"S":"") + ") <", Draw.messagecol("flashing"));	
				}else{
					Text.display(Gfx.screenwidthmid, ty + 54, "Great, I'll take one! (cost: " + Modern.keygemrate + " GEM" + (Modern.keygemrate>1?"S":"") + ")", Draw.messagecol("grayedout"));	
				}
				
				if (Modern.menuselection == 1) {
					Text.display(Gfx.screenwidthmid, ty + 66, "> No way! <", Draw.messagecol("flashing"));	
				}else {
					Text.display(Gfx.screenwidthmid, ty + 66, "No way!", Draw.messagecol("grayedout"));	
				}
			}
			
			Text.align(Text.LEFT);
		}else	if (Modern.popupmode == "newitem_drop" || Modern.popupmode == "newitem"){
			var boxheight:Int = 68 + (Modern.popupitem.descriptionsize * 10);
			var tx = Gfx.screenwidthmid - 120;
			var ty = Gfx.screenheightmid - Std.int(boxheight / 2) - Std.int(Lerp.to_value(boxheight * 2, 0, Modern.popuplerp, Modern.popupspeed, ((Modern.popupstate<2)?Modern.popupanimationtype_appear:Modern.popupanimationtype_disappear)));
			if (Modern.popupmode == "newitem_drop") ty -= 15;
			if(Modern.popupitem.hasmultipleshots){
				Modern.drawbubble(tx, ty, 240, boxheight, Draw.shade(Col.rgb(Modern.popupitem.r, Modern.popupitem.g, Modern.popupitem.b), 0.8), 0x000000, 0x000000);
				Gfx.imagecolor(Col.rgb(Modern.popupitem.r, Modern.popupitem.g, Modern.popupitem.b));
				Gfx.drawtile(Gfx.screenwidthmid - 6 - 8, ty + 25, "terminal", Modern.popupitem.character.charCodeAt(0));
				Gfx.imagecolor();
				
				Gfx.fillbox(Gfx.screenwidthmid - 6 + 6 - 1, ty + 26 - 1, Text.width("x" + Modern.popupitem.typical) + 4, 10 + 2, 0x000000);
				Gfx.fillbox(Gfx.screenwidthmid - 6 + 6, ty + 26, Text.width("x" + Modern.popupitem.typical) + 2, 10, Draw.shade(Col.rgb(Modern.popupitem.r, Modern.popupitem.g, Modern.popupitem.b), 0.8));
				Text.display(Gfx.screenwidthmid - 6 + 7, ty + 26 - 2, "x" + Modern.popupitem.typical, 0x000000);
			}else if (Modern.popupitem.type == Inventory.USEABLE) {
				Modern.drawbubble(tx, ty, 240, boxheight, Draw.shade(Col.rgb(Modern.popupitem.r, Modern.popupitem.g, Modern.popupitem.b), 0.8), 0x000000, 0x000000);
				Gfx.imagecolor(Col.rgb(Modern.popupitem.r, Modern.popupitem.g, Modern.popupitem.b));
				Gfx.drawtile(Gfx.screenwidthmid - 6, ty + 25, "terminal", Modern.popupitem.character.charCodeAt(0));
				Gfx.imagecolor();
			}else if(Modern.popupitem.type == Inventory.GADGET){
				Modern.drawbubble(tx, ty, 240, boxheight, Draw.shade(Col.rgb(Modern.popupitem.r, Modern.popupitem.g, Modern.popupitem.b), 0.8), 0x000000, 0x000000);
				Gfx.imagecolor(Col.rgb(Modern.popupitem.r, Modern.popupitem.g, Modern.popupitem.b));
				Gfx.drawtile(Gfx.screenwidthmid - 6, ty + 25, "terminal", Modern.popupitem.character.charCodeAt(0));
				Gfx.imagecolor();
			}
			
			Draw.setnormaltext();
			Modern.drawbubble(tx - 10, ty - 5, 60, 18, Draw.shade(Col.rgb(Modern.popupitem.r, Modern.popupitem.g, Modern.popupitem.b), 0.8), 0x000000, 0x000000);
			Text.display(tx - 4, ty - 3, "NEW ITEM!", Draw.messagecol("shout"));
			
			Text.align(Text.CENTER);
			Draw.setboldtext();
			Text.display(Gfx.screenwidthmid, ty + 5, Modern.popupitem.name, Draw.messagecol("shout"));
			
			Draw.setnormaltext();
			ty += 40;
			for (i in 0 ... Modern.popupitem.descriptionsize) {
				Text.display(Gfx.screenwidthmid, ty, Modern.popupitem.description[i], Draw.messagecol("white"));	
				ty += 10;
			}
			
			ty = Gfx.screenheightmid - Std.int(boxheight / 2) - Std.int(Lerp.to_value(boxheight * 2, 0, Modern.popuplerp, Modern.popupspeed, ((Modern.popupstate<2)?Modern.popupanimationtype_appear:Modern.popupanimationtype_disappear)));
			ty = ty + boxheight - 18;
			if (Modern.popupmode == "newitem_drop") {
				ty -= 15;
				Text.display(Gfx.screenwidthmid, ty, "[" + Controls.showfirstassigned("action") + ": drop item and return to game]", Draw.messagecol("whisper"));	
			}else{
				Text.display(Gfx.screenwidthmid, ty, "[" + Controls.showfirstassigned("action") + ": return to game]", Draw.messagecol("whisper"));	
			}
			
			if (Modern.popupmode == "newitem_drop") {
				//Also show a popup to drop an item...
				tx = Gfx.screenwidth - 200;
				ty = Gfx.screenheight - 70;
				
				//if (Modern.popupitem.type == Inventory.USEABLE) {
					//Modern.drawbubble(tx, ty, 240, 60, Draw.shade(Col.rgb(Modern.popupitem.r, Modern.popupitem.g, Modern.popupitem.b), 0.8), 0x000000, 0x000000);
				//}else if (Modern.popupitem.type == Inventory.GADGET) {
					//Modern.drawbubble(tx, ty, 240, 60, Draw.shade(Col.rgb(Modern.popupitem.r, Modern.popupitem.g, Modern.popupitem.b), 0.8), 0x000000, 0x000000);
				//}
				Modern.drawbubble(tx, ty, 200, 70, 0x888888, 0x000000, 0x000000);
				
				Draw.setnormaltext();
				Text.display(tx + 100, ty + 5, "You need to drop an item...", Draw.messagecol("white"));	
				
				ty += 25;
				var gap:Int = 32;
				tx = Gfx.screenwidth - 100 - 6 - Std.int((Modern.inventory.length * gap) / 2) + Std.int((gap - 24) / 2);
				Text.align(Text.LEFT);
				for (i in 0 ... Modern.inventory.length) {
					if (i == Modern.inventory.length - 1) {
						tx += 12;
						Text.display(tx + (i * gap) - 15, ty + 2, "or", Draw.messagecol("white"));	
					}
					if (i == Modern.currentslot) {
						//Use brighter colours and draw a border
						Draw.roundfillrect(tx + (i * gap) - 2, ty - 1, 24 + 2, 24, Localworld.worldblock[Localworld.WALL].front_fog);
					}
					Modern.currentitem = Itemstats.get(Modern.inventory[i]);
					if(Modern.currentitem.hasmultipleshots){
						Modern.drawbubble(tx + (i * gap), ty, 22, 22, Draw.shade(Col.rgb(Modern.currentitem.r, Modern.currentitem.g, Modern.currentitem.b), 0.8), 0x000000, 0x000000);
						Gfx.imagecolor(Col.rgb(Modern.currentitem.r, Modern.currentitem.g, Modern.currentitem.b));
						Gfx.drawtile(tx + (i * gap) + 5, ty + 5, "terminal", Modern.currentitem.character.charCodeAt(0));
						Gfx.imagecolor();
						
						Gfx.fillbox(tx + (i * gap) + 12 - 1, ty - 3 - 1, Text.width("x" + Modern.inventory_num[i]) + 4, 10 + 2, 0x000000);
						Gfx.fillbox(tx + (i * gap) + 12, ty - 3, Text.width("x" + Modern.inventory_num[i]) + 2, 10, Draw.shade(Col.rgb(Modern.currentitem.r, Modern.currentitem.g, Modern.currentitem.b), 0.8));
						Text.display(tx + (i * gap) + 13, ty - 5, "x" + Modern.inventory_num[i], 0x000000);
					}else if(Modern.currentitem.type == Inventory.USEABLE || Modern.currentitem.type == Inventory.GADGET){
						Modern.drawbubble(tx + (i * gap), ty, 22, 22, Draw.shade(Col.rgb(Modern.currentitem.r, Modern.currentitem.g, Modern.currentitem.b), 0.8), 0x000000, 0x000000);
						Gfx.imagecolor(Col.rgb(Modern.currentitem.r, Modern.currentitem.g, Modern.currentitem.b));
						Gfx.drawtile(tx + (i * gap) + 5, ty + 5, "terminal", Modern.currentitem.character.charCodeAt(0));
						Gfx.imagecolor();
					}else {
						Modern.drawbubble(tx + (i * gap), ty, 22, 22, 0x444444, 0x000000, 0x000000);
					}
				}
				
				Modern.currentitem = Itemstats.get(Modern.inventory[Modern.currentslot]);
				Text.align(Text.CENTER);
				if(Modern.currentitem.hasmultipleshots){
					Text.display(Gfx.screenwidth - 100, ty + 26, Modern.inventory[Modern.currentslot].toUpperCase() + " [x" + Modern.inventory_num[Modern.currentslot] +"]", Itemstats.get(Modern.inventory[Modern.currentslot]).highlightcol);	
				}else if (Modern.currentitem.type == Inventory.USEABLE || Modern.currentitem.type == Inventory.GADGET) {
					Text.display(Gfx.screenwidth - 100, ty + 26, Modern.inventory[Modern.currentslot].toUpperCase(), Itemstats.get(Modern.inventory[Modern.currentslot]).highlightcol);		
				}
				
				Text.align(Text.LEFT);
			}
		}
		Text.align(Text.LEFT);	
	}
	
	public static var floortextx:Int = 5;
	public static var hptextx:Int = 75;
	public static var keytextx:Int = 155;
	public static var gemtextx:Int = 195;
}