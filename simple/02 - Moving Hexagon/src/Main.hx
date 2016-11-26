import haxegon.*;

class Main {
	var x:Int;
	var y:Int;
	var radius:Int;
	var speed:Int;
	
	function new(){
		x = Gfx.screenwidthmid;
		y = Gfx.screenheightmid;
		radius = 80;
		speed = 5;
		
		Gfx.linethickness = 8;
	}
	
	function update() {
		//Move when the player presses a direction
		if (Input.pressed(Key.LEFT)){
			x -= speed;
		}
		if (Input.pressed(Key.RIGHT)){
			x += speed;
		}
		if (Input.pressed(Key.UP)){
			y -= speed;
		}
		if (Input.pressed(Key.DOWN)){
			y += speed;
		}
		
		//Prevent the player from leaving the screen
		if (x < radius) x = radius;
		if (y < radius) y = radius;
		
		if (x > Gfx.screenwidth - radius) x = Gfx.screenwidth - radius;
		if (y > Gfx.screenheight - radius) y = Gfx.screenheight - radius;
		
		//Draw the hexagon!
		//Set the angle to be xposition divided by 100 so we rotate 
		//slightly when we move across the screen
		Gfx.drawhexagon(x, y, radius, x / 100, Col.WHITE);
	}
}