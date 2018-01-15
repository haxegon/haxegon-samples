import haxegon.*;

class Main {	
	var currentfilter = "None";
	
	function update(){
		Gfx.drawimage(0, 0, "constellation");
		
		Text.align(Text.CENTER);
		Text.size = 2;
		Text.display(Gfx.screenwidthmid, 4, "FILTER EXAMPLE - PRESS 1 - 4 to change");
		Text.display(Gfx.screenwidthmid, Gfx.screenheight - 20, "Current Filter: " + currentfilter);
		
		if (Input.justpressed(Key.ONE)){
			//Turn on bloom
			Filter.reset();
			Filter.bloom = 1;
			currentfilter = "Bloom = 1.0";
		}else if (Input.justpressed(Key.TWO)){
			//Turn on bloom
			Filter.reset();
			Filter.bloom = 2;
			currentfilter = "Bloom = 2.0";
		}else if (Input.justpressed(Key.THREE)){
			//Turn on blur
			Filter.reset();
			Filter.blur = 1;
			currentfilter = "Blur";
		}else if (Input.justpressed(Key.FOUR)){
			//Turn off everything
			Filter.reset();
			currentfilter = "None";
		}
	}
}