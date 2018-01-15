import haxegon.*;

class Main {
	function init(){
		Gfx.resizescreen(768, 480);
		Text.font = "c64";
	}
	
	function update() {
		//Change scene when you click the mouse.
		if (Mouse.leftclick()) {
			Scene.change(Space);           // Loads the "Space.hx" file.
		}
		
		//Show the title screen text.
		Text.size = 4;
		Text.align(Text.LEFT);
		Text.display(Text.CENTER, Gfx.screenheightmid - 30, "SCENE CHANGE EXAMPLE", Col.WHITE);
		Text.size = 2;
		Text.display(Text.CENTER, Gfx.screenheightmid + 10, "LEFT CLICK TO CHANGE", Col.WHITE);
  }
}