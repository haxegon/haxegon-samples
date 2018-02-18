import haxegon.*;
import openfl.geom.Point;

class Country{
	public function new(_countrydata:Dynamic){
		countrydata = _countrydata;
		
		name = countrydata.data_name;
		parsesvg(countrydata.d);
	}
	
	public function parsesvg(svgdata:String){
		var cursorx:Float = 0;
		var cursory:Float = 0;
		var currentloop:Int = 0;
		
		loops = [];
		loops.push([]);
		
		var drawcommands:Array<String> = svgdata.split(" ");
		var i:Int = 0;
		while (i < drawcommands.length){
			if (drawcommands[i] == "M"){
				//Absolute move
				i++;
				var position:Array<String> = drawcommands[i].split(",");
			  cursorx = (Std.parseFloat(position[0]));
				cursory = (Std.parseFloat(position[1]));
				loops[currentloop].push(new Point(cursorx, cursory));
			}else if (drawcommands[i] == "m"){
				//Relative move
				i++;
				var position:Array<String> = drawcommands[i].split(",");
			  cursorx = cursorx + (Std.parseFloat(position[0]));
				cursory = cursory + (Std.parseFloat(position[1]));
				loops[currentloop].push(new Point(cursorx, cursory));
			}else if (drawcommands[i] == "z"){
				loops.push([]);
				currentloop++;
			}else{
				var newposition:Array<String> = drawcommands[i].split(",");
				
				var newcursorx:Float = Std.parseFloat(newposition[0]);
				var newcursory:Float = Std.parseFloat(newposition[1]);
				cursorx = cursorx + newcursorx;
				cursory = cursory + newcursory;
				
				loops[currentloop].push(new Point(newcursorx, newcursory));
			}
			i++;
		}
		
		if (loops[loops.length - 1].length == 0){
			loops.splice(loops.length - 1, 1);
		}
	}
	
	public function draw(xpos:Float, ypos:Float, zoom:Float, c:Int){
		for (j in 0 ... loops.length){
			initialx = cursorx = xpos + (loops[j][0].x * zoom);
			initialy = cursory = ypos + (loops[j][0].y * zoom);
				
			var i:Int = 1;
			while (i < (loops[j].length - 1)){
				cursorx2 = loops[j][i + 1].x * zoom;
				cursory2 = loops[j][i + 1].y * zoom;
				
				Gfx.drawline(cursorx, cursory, cursorx + cursorx2, cursory + cursory2, c);
				cursorx = cursorx + cursorx2;
				cursory = cursory + cursory2;
				i++;
			}
			
			Gfx.drawline(cursorx, cursory, initialx, initialy, c);
		}
	}
	
	private var initialx:Float;
	private var initialy:Float;
	private var cursorx:Float;
	private var cursory:Float;
	private var cursorx2:Float;
	private var cursory2:Float;
	
	public var loops:Array<Array<Point>>;
	
	public var countrydata:Dynamic;
	public var name:String;
}