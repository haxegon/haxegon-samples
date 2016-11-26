import haxegon.*;

class Main{	
	var gamestate:String = "title";

	var ballx:Float = Gfx.screenwidth / 2;
	var bally:Float = Gfx.screenheight / 2;

	var xchange:Float = 7;
	var ychange:Float = 7;
	var ballspeed:Float = 7;

	var playerx:Float = 15;
	var playery:Float = 10;
	var playerspeed:Int = 15;
	var playerscore:Int = 0;

	var enemyx:Float = Gfx.screenwidth - 25;
	var enemyy:Float = 10;
	var enemyscore:Int = 0;
	
	function new() {
    Text.font = "ganon";
    
	  Music.loadsound("bounce");
		Music.loadsound("hit");
		Music.loadsound("score");
		Music.loadsound("miss");
	}

	function inbox(x:Float, y:Float, boxx:Float, boxy:Float, boxw:Float, boxh:Float){
		if(x >= boxx && x < boxx + boxw){
			if(y >= boxy && y < boxy + boxh){
				return true;
			}
		}
		return false;
	}

	function updateball(){
		Gfx.fillhexagon(ballx, bally, 12, ballx / 100, Col.WHITE);
		
		ballx += xchange;
		bally += ychange;
		
		if (ballx > Gfx.screenwidth) {
			Music.playsound("score");
			
			//Reset the ball position
			ballx = Gfx.screenwidth / 2;
			bally = Gfx.screenheight / 2;
			
			playerscore += 1;
			
			if(playerscore >= 3){
				gamestate = "title";
			}
		}else if (ballx < 0) {
		  Music.playsound("miss");	
			
			//Reset the ball position
			ballx = Gfx.screenwidth / 2;
			bally = Gfx.screenheight / 2;
			
			enemyscore += 1;
			
			if(enemyscore >= 3){
				gamestate = "title";
			}
		}
		
		if(bally > Gfx.screenheight){
			Music.playsound("bounce");
			ychange = -ballspeed;
		}else if(bally < 0){
			Music.playsound("bounce");
			ychange = ballspeed;
		}
		
		if(inbox(ballx, bally, playerx, playery, 15, 75) || 
			 inbox(ballx - 12, bally, playerx, playery, 15, 75) ||
			 inbox(ballx + 12, bally, playerx, playery, 15, 75)){
			Music.playsound("hit");
			xchange = ballspeed;
		}
		
		if(inbox(ballx, bally, enemyx, enemyy, 15, 75) || 
			 inbox(ballx - 12, bally, enemyx, enemyy, 15, 75) ||
			 inbox(ballx + 12, bally, enemyx, enemyy, 15, 75)){
			Music.playsound("hit");
			xchange = -ballspeed;
		}
	}

	function updateplayer(){
		Gfx.fillbox(playerx, playery, 15, 75, Col.WHITE);
		
		if(Input.pressed(Key.UP)){
			playery -= playerspeed;
			if(playery < 0) {
				playery = 0;
			}
		}
		
		if(Input.pressed(Key.DOWN)){
			playery += playerspeed;
			if(playery > Gfx.screenheight - 75){
				playery = Gfx.screenheight - 75;
			} 
		}
	}

	function updateenemy(){
		Gfx.fillbox(enemyx, enemyy, 15, 75, Col.WHITE);
		
		if(ballx > Gfx.screenwidthmid + 60 && xchange > 0){
			if(enemyy > bally){
				enemyy -= 6;  
			}else if(enemyy + 75 < bally){
				enemyy += 6;
			}
		}
		
		if(enemyy < 0) {
			enemyy = 0;
		}
		
		if(enemyy > Gfx.screenheight - 75){
			enemyy = Gfx.screenheight - 75;
		}
	}

	function playgame(){
		updateball();
		updateplayer();
		updateenemy();
		
		//Show the scores
		Text.size = 3;
		Text.display(Gfx.screenwidthmid - 20, 4, "" + playerscore);
		Text.display(Gfx.screenwidthmid + 20, 4, "" + enemyscore);
	}

	function titlescreen(){
		Text.size = 4;
		Text.display(Text.CENTER, Text.CENTER, "Unlicensed Ball and Paddle game");
		
		Text.size = 2;
		Text.display(Text.CENTER, Text.BOTTOM, "press space to start");
	}

	function update(){
		if(gamestate == "title"){
			titlescreen();
			
			if(Input.pressed(Key.SPACE)){
				gamestate = "game";
				
				//Reset ball position
				ballx = Gfx.screenwidth / 2;
				bally = Gfx.screenheight / 2;
				
				//Reset score
				playerscore = 0;
				enemyscore = 0;
			}
		}else if(gamestate == "game"){
			playgame();
		}
	}
}