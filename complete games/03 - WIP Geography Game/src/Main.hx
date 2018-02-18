import haxegon.*;

class Main {
	function init(){
		Gfx.resizescreen(0, 0);
		onresize();
		
		var worlddata:Dynamic = Data.loadxml("world.svg");
		country = [];
		for (i in 0 ... worlddata.svg.path.length){
			country.push(new Country(worlddata.svg.path[i]));
		}
	}
	
	var country:Array<Country>;
	var currentcountry:Int = 0;
	var textheight:Float;
	
	function onresize(){
		fontscale = Gfx.screenheight / 720;
		Text.setfont("roboto", 20 * fontscale);
		textheight = Text.height();
	}
	
	function update() {
		if (Gfx.onwindowresized()) onresize();
		
		if (Input.delaypressed(Key.LEFT, 4)){
			currentcountry = Std.int((currentcountry + (country.length - 1)) % country.length);
		}
		if (Input.delaypressed(Key.RIGHT, 4) || Mouse.leftclick()){
			currentcountry = Std.int((currentcountry + 1) % country.length);
		}
		
		var oldzoom:Float = zoom;
		
		if (Mouse.mousewheel < 0) {
			zoom = zoom * 0.8;
			if (zoom < 0.2)	zoom = 0.1;
			
			xpos = Gfx.screenwidthmid + xfocus - ((gridwidth * zoom) / 2);
			ypos = Gfx.screenheightmid + yfocus - ((gridheight * zoom) / 2);
		}else if (Mouse.mousewheel > 0) {
			zoom = zoom * 1.2;
			if (zoom > 200) zoom = 200;
			
			xpos = Gfx.screenwidthmid + xfocus - ((gridwidth * zoom) / 2);
			ypos = Gfx.screenheightmid + yfocus - ((gridheight * zoom) / 2);
		}
		if (oldzoom != zoom){
			xfocus = xfocus / oldzoom;
			yfocus = yfocus / oldzoom;
			xfocus = xfocus * zoom;
			yfocus = yfocus * zoom;
			
			xpos = Gfx.screenwidthmid + xfocus - ((gridwidth * zoom) / 2);
			ypos = Gfx.screenheightmid + yfocus - ((gridheight * zoom) / 2);
		}
			
		if (Mouse.middleheld()) {
			xfocus += (Mouse.deltax * 1);
			yfocus += (Mouse.deltay * 1);
		}
	}
	
	function render(){
		Gfx.clearscreen(colour_background);
		
		xpos = Gfx.screenwidthmid + xfocus - ((gridwidth * zoom) / 2);
		ypos = Gfx.screenheightmid + yfocus - ((gridheight * zoom) / 2);
		scaledwidth = gridwidth * zoom;
		scaledheight = gridheight * zoom;
		
		//Draw the grid
		Gfx.drawbox(xpos, ypos, scaledwidth, scaledheight, colour_grid);
		
		for (i in 1 ... subdivisions) {
			var xoffset:Float = i * (scaledwidth / subdivisions);
			var yoffset:Float = i * (scaledheight / subdivisions);
			if(i % 2 == 0) Gfx.drawline(xpos + 1, ypos + yoffset, xpos + scaledwidth - 1, ypos + yoffset, colour_grid);
			Gfx.drawline(xpos + xoffset, ypos + 1, xpos + xoffset, ypos + scaledheight - 1, colour_grid);
		}
		
		for (i in 0 ... country.length){
			country[i].draw(xpos, ypos, zoom, colour_lines);
		}
		country[currentcountry].draw(xpos, ypos, zoom, Col.YELLOW);
		
		Text.display(Text.CENTER, (textheight / 4), country[currentcountry].name, Col.LIGHTGREEN);
		Text.display(Text.CENTER, (textheight) + (textheight / 4), "[left/right to change], [mouse wheel to zoom]", Col.LIGHTGREEN);
	}
	
	var xfocus:Float = 0;
	var yfocus:Float = 0;
	var xpos:Float;
	var ypos:Float;
	var zoom:Float = 2;
	
	var gridwidth:Int = 2000;
	var gridheight:Int = 1000;
	var subdivisions:Int = 20;
	var scaledwidth:Float;
	var scaledheight:Float;
	
	var fontscale:Float;
	
	var colour_background:Int = 0x114411;
	var colour_grid:Int = 0x448844;
	var colour_lines:Int = 0x88FF88;
}