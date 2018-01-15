import haxegon.*;

class Main {
	//Gameplay variables
	var counter = 45;
	var boxsize = 80;
	var gamespeed = 90;

	//Current box position
	var x = 0;
	var y = 0;
	
	//Score and highscore variables
	var score = 0;
  var highscore = 0;
	
	function update(){
		if(Mouse.leftclick()){
			if (Mouse.x > x && Mouse.y > y && Mouse.x < x + boxsize && Mouse.y < y + boxsize) {
				Sound.play("hit");
				
			  //If we click on the box, increase our score and restart the counter
			  counter = 0;
				score++;
				if(score > highscore){
					highscore = score;
				}
				
				//The box gets smaller every time we click on it
				boxsize--;
				if (boxsize < 20) {
					boxsize = 20;
				}
				
				//... and starts moving faster!
				gamespeed = gamespeed - 3;
				if(gamespeed < 15){
					gamespeed = 15;
				}
				
				//Move the box to a random position
				x = Random.int(0, Gfx.screenwidth - boxsize);
				y = Random.int(0, Gfx.screenheight - boxsize);
			}else {
				Sound.play("miss");
				
			  //We missed the box: reset the game.	
			  counter = 0;
				score = 0;
				boxsize = 80;
				gamespeed = 90;
				
				x = Random.int(0, Gfx.screenwidth - boxsize);
				y = Random.int(0, Gfx.screenheight - boxsize);
			}
		}
		
		counter = counter + 1;
		if (counter >= gamespeed) {
			//Move the box every time counter > gamespeed
			x = Random.int(0, Gfx.screenwidth - boxsize);
			y = Random.int(0, Gfx.screenheight - boxsize);
			
			//The start the counter again
			counter = 0;
		}
		
		Gfx.fillbox(x, y, boxsize, boxsize, Col.RED);
		
		Text.size = 4;
		Text.display(Text.LEFT, 0, "SCORE: " + score);
		Text.display(Text.RIGHT, 0, "HIGHSCORE: " + highscore);
	}
}