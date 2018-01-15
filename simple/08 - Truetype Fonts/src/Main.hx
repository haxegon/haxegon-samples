import haxegon.*;

class Main {
	// These fonts are located in the data/fonts/ directory.
	
	// Haxegon supports both TrueType fonts (which are high resolution and anti aliased)
	// or Bitmap fonts (which are crisp and good for low resolutions). This demo
	// shows truetype fonts only.
	
	var fontscale:Float;
	
	function init(){
		//Truetype fonts look a LOT better when we don't scale the canvas!
		Gfx.resizescreen(0, 0);
	}
	
	function update() {
		//Let's figure out a scale that's proportional to a 480 pixel high screen
		fontscale = Gfx.screenheight / 480;
		
		// Draw a white background
		Gfx.clearscreen(Col.WHITE);
		
		Text.font = "oswald";
		Text.size = 32 * fontscale;
		Text.display(Text.CENTER, 5 * fontscale, "Haxegon TrueType Font examples:", Col.BLACK);
		Text.size = 16 * fontscale;
		Text.display(Text.CENTER, 55 * fontscale, "(try resizing this window!)", Col.BLACK);
		
		Text.size = 32 * fontscale;
		Text.display(10, 80 * fontscale, "Oswald", Col.BLACK);
		
		Text.size = 16 * fontscale;
		Text.display(10, 120 * fontscale, "The quick brown fox jumps over the lazy dog.", Col.BLACK);
		
		Text.font = "inconsolata";
		Text.size = 32 * fontscale;
		Text.display(10, 180 * fontscale, "Inconsolata", Col.BLACK);
		
		Text.size = 16 * fontscale;
		Text.display(10, 220 * fontscale, "Amazingly few discotheques provide jukeboxes.", Col.BLACK);
		
		Text.font = "inconsolata_bold";
		Text.size = 32 * fontscale;
		Text.display(10, 280 * fontscale, "Inconsolata Bold", Col.BLACK);
		
		Text.size = 16 * fontscale;	
		Text.display(10, 320 * fontscale, "Heavy boxes perform quick waltzes and jigs.", Col.BLACK);
		
		Text.font = "shadowsintolight";
		Text.size = 32 * fontscale;
		Text.display(10, 380 * fontscale, "Shadows Into Light", Col.BLACK);
		
		Text.size = 16 * fontscale;
		Text.display(10, 420 * fontscale, "Jackdaws love my big sphinx of quartz.", Col.BLACK);
	}
}
