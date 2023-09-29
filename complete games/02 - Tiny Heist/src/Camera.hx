import entities.Obj;
import world.World;

class Camera{
	public static var x:Int;
	public static var y:Int; 
	public static var xoff:Int;
	public static var yoff:Int;
	
	public static var disable_all:Bool;
	public static var disable_horizontal:Bool;
	public static var disable_vertical:Bool;
	
	static var oldx:Int;
	static var oldy:Int;
	static var temp:Int; 
	static var temp2:Int;
	
	public static function init():Void {
		x = 0; y = 0; oldx = 0; oldy = 0;
		
		disable_all = false;
		disable_horizontal = false;
		disable_vertical = false;
	}
	
	public static function update(){
		if (disable_all) {
			x = 0; y = 0;
		}else{
			if (disable_horizontal) x = 0; if (disable_vertical) y = 0;
		}
		
		xoff = 0;
		yoff = 0;
		var playerindex:Int = Obj.getplayer(); 
		if (playerindex > -1) {
			x = Obj.entities[playerindex].xp - 16;
			if (x < 0) x = 0;
			if (x + 32 > World.mapwidth) x = World.mapwidth - 32;
			if (x != 0) xoff = -Obj.entities[playerindex].animx;
			
			if (x >= -1 && x + 31 < World.mapwidth) xoff = -Obj.entities[playerindex].animx;
			if (Obj.entities[playerindex].xp - 15 <= 0 && xoff < 0) xoff = 0;
			if (Obj.entities[playerindex].xp - 16 <= 0 && xoff > 0) xoff = 0;
			if (Obj.entities[playerindex].xp + 15 >= World.mapwidth && xoff > 0) xoff = 0;
			if (Obj.entities[playerindex].xp + 16 >= World.mapwidth && xoff < 0) xoff = 0;
			
			y = Obj.entities[playerindex].yp - 10;
			if (y < 0) y = 0;
			if (y + 19 >= World.mapheight) y = World.mapheight - 19;
			
			if (y >= -1 && y + 18 < World.mapheight) yoff = -Obj.entities[playerindex].animy;
			if (Obj.entities[playerindex].yp - 9 <= 0 && yoff < 0) yoff = 0;
			if (Obj.entities[playerindex].yp - 10 <= 0 && yoff > 0) yoff = 0;
			if (Obj.entities[playerindex].yp + 8 >= World.mapheight && yoff > 0) yoff = 0;
			if (Obj.entities[playerindex].yp + 9 >= World.mapheight && yoff < 0) yoff = 0;
		}
	}
}