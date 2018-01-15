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

	var enemyx:Float = 730;
	var enemyy:Float = 10;
	var enemyscore:Int = 0;
	
	function init() {
		Gfx.resizescreen(768, 480);
		
    Text.font = "ganon";
    
	  Sound.load("bounce");
		Sound.load("hit");
		Sound.load("score");
		Sound.load("miss");
	}

	function updateball(){
		Gfx.fillhexagon(ballx, bally, 12, ballx / 100, Col.WHITE);
		
		ballx += xchange;
		bally += ychange;
		
		if (ballx > Gfx.screenwidth) {
			Sound.play("score");
			
			//Reset the ball position
			ballx = Gfx.screenwidth / 2;
			bally = Gfx.screenheight / 2;
			
			playerscore += 1;
			
			if(playerscore >= 3){
				gamestate = "title";
			}
		}else if (ballx < 0) {
		  Sound.play("miss");	
			
			//Reset the ball position
			ballx = Gfx.screenwidth / 2;
			bally = Gfx.screenheight / 2;
			
			enemyscore += 1;
			
			if(enemyscore >= 3){
				gamestate = "title";
			}
		}
		
		if(bally > Gfx.screenheight){
			Sound.play("bounce");
			ychange = -ballspeed;
		}else if(bally < 0){
			Sound.play("bounce");
			ychange = ballspeed;
		}
		
		if(Geom.inbox(ballx, bally, playerx, playery, 15, 75) || 
			 Geom.inbox(ballx - 12, bally, playerx, playery, 15, 75) ||
			 Geom.inbox(ballx + 12, bally, playerx, playery, 15, 75)){
			Sound.play("hit");
			xchange = ballspeed;
		}
		
		if(Geom.inbox(ballx, bally, enemyx, enemyy, 15, 75) || 
			 Geom.inbox(ballx - 12, bally, enemyx, enemyy, 15, 75) ||
			 Geom.inbox(ballx + 12, bally, enemyx, enemyy, 15, 75)){
			Sound.play("hit");
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
		
		if(Input.pressed(Key.SPACE)){
			gamestate = "game";
				
			//Reset ball position
			ballx = Gfx.screenwidth / 2;
			bally = Gfx.screenheight / 2;
				
			//Reset score
			playerscore = 0;
			enemyscore = 0;
		}
	}

	function update(){
		if(gamestate == "title"){
			titlescreen();
		}else if(gamestate == "game"){
			playgame();
		}
	}
}
