import haxegon.*;

class Main {
	// These fonts are located in the data/fonts/ directory.
	
	// Haxegon supports both TrueType fonts (which are high resolution and anti aliased)
	// or Bitmap fonts (which are crisp and good for low resolutions). This demo
	// shows truetype fonts only.
	
	// For most target platforms, you only need a TTF file, but for HTML5, you need webfont
	// formats like .eof and .woff. You can create these using a generator like this:
	// http://www.fontsquirrel.com/tools/webfont-generator	
	function update() {
		// Draw a white background
		Gfx.clearscreen(Col.WHITE);
		
		//When changing font, it's usually best to change both the fontface and the size!
		Text.font = "oswald";
		Text.size = 32;
		Text.display(Text.CENTER, 5, "Haxegon TrueType Font examples:", Col.BLACK);
		Text.display(10, 80, "Oswald", Col.BLACK);
		
		Text.size = 16;
		Text.display(10, 120, "The quick brown fox jumps over the lazy dog.", Col.BLACK);
		
		Text.font = "inconsolata";
		Text.size = 32;
		Text.display(10, 180, "Inconsolata", Col.BLACK);
		
		Text.size = 16;
		Text.display(10, 220, "Amazingly few discotheques provide jukeboxes.", Col.BLACK);
		
		Text.font = "inconsolata_bold";
		Text.size = 32;
		Text.display(10, 280, "Inconsolata Bold", Col.BLACK);
		
		Text.size = 16;	
		Text.display(10, 320, "Heavy boxes perform quick waltzes and jigs.", Col.BLACK);
		
		Text.font = "shadowsintolight";
		Text.size = 32;
		Text.display(10, 380, "Shadows Into Light", Col.BLACK);
		
		Text.size = 16;
		Text.display(10, 420, "Jackdaws love my big sphinx of quartz.", Col.BLACK);
	}
}
