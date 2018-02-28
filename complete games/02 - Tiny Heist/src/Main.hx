package;

import modernversion.Itemstats;
import openfl.display.*;
import config.*;
import gamecontrol.*;
import haxegon.*;
import terrylib.*;
import openfl.geom.Rectangle;
import starling.core.Starling;

@:access(haxegon.Gfx)
class Main {
	public function new () {
		Gfx.resizescreen(384, 240);
		Gfx.createimage("cachemap", 384, 240);
		Achievements.init();
		
		Controls.init();
		Help.init();
		Lerp.init();
		Flag.init();
		Script.init();
		World.init();
		Obj.init();
		Textbox.init();
		
		Game.init();
		Localworld.init();
		Generator.init();
		Openworld.init();
		Draw.init();
		
		Itemstats.init();
		
		Rand.initperlin(Std.random(10), 8, 0.5);
		
		// Sitelock code!
		if (Achievements.sitelockpassed()) {
			Init.init();
		}else {
			Game.changestate(Game.EXPIREDMODE);
		}
		
		//Turn this on for testing
		//Profiler.init();
	}
	
	var standalonemode:Bool = false;
	var gamemenu:Bool = false;
	
	function update() {
		if (standalonemode) {
			if (!gamemenu) {
				if (Input.justpressed(Key.ESCAPE)) {
					gamemenu = true;	
				}
			}else {
				if (Input.justpressed(Key.ESCAPE)) {
					#if (!flash && !html5)
					  Sys.exit(0);
					#else
					#end
				}
			  if (Input.justpressed(Key.SPACE)) {
				  gamemenu = false;
					Input.forcerelease(Key.SPACE);
				}
			}
			
			if (Input.justpressed(Key.F5)) {
			  Gfx.fullscreen = !Gfx.fullscreen;	
			}
		}
	  doinput();
		dologic();
	}
	
	function render() {
		dorender();
		
		if (standalonemode) {
			if (gamemenu) {
			  Gfx.fillbox(0, 0, Gfx.screenwidth, Gfx.screenheight, Col.BLACK, 0.6);	
				Draw.setboldtext(); Text.size = 2;
				Text.align = Text.CENTER;
				
				Text.display(Gfx.screenwidthmid, Gfx.screenheightmid - 20, "Do you want to quit?");
				Draw.setnormaltext(); Text.size = 1;
				
				Text.display(Gfx.screenwidthmid, Gfx.screenheightmid + 20, "Press ESCAPE again to quit,");
				Text.display(Gfx.screenwidthmid, Gfx.screenheightmid + 35, "or SPACE to return to the game.");
				
				Text.display(Gfx.screenwidthmid, Gfx.screenheight - 25, "Press F5 to toggle fullscreen");
			}
		}
		
		//Profiler.callafterframe();
	}
	
	function doinput() {
		switch(Game.gamestate) {
			case Game.TITLEMODE: GameInput.titleinput();
			case Game.GAMEMODE: GameInput.gameinput();
			case Game.ENDINGMODE: GameInput.endinginput();
			case Game.FALLINGFROMTOWER: GameInput.fallfromtowerinput();
			case Game.SPLASHSCREEN: GameInput.splashscreeninput();
		}
	}
	
	function dologic() {
		Script.runscript();
		Textbox.updatetextboxes();
		Lerp.update();
		
		//Profiler.startframe(Profiler.PROFILE_LOGIC);
		switch(Game.gamestate) {
			case Game.TITLEMODE: Logic.titlelogic();
			case Game.GAMEMODE: Logic.gamelogic(); 
			case Game.ENDINGMODE: Logic.endinglogic();
			case Game.FALLINGFROMTOWER: Logic.fallfromtowerlogic();
			case Game.SPLASHSCREEN: Logic.splashscreenlogic();
		}
		//Profiler.endframe(Profiler.PROFILE_LOGIC);
		
		Game.fadelogic();
		Obj.cleanup();
		Draw.processfade();
		Help.updateglow();
		
		if (Draw.screenshake > 0) {
			var viewPortRectangle:Rectangle = Starling.current.viewPort;
			if(!screenshakestart){
			  realviewportx = viewPortRectangle.x;
			  realviewporty = viewPortRectangle.y;
				screenshakestart = true;
			}
			
			viewPortRectangle.x = realviewportx + Random.int( -4, 4);
			viewPortRectangle.y = realviewporty + Random.int( -4, 4);
			Starling.current.viewPort = viewPortRectangle;
			
			Draw.screenshake--;
			
			if (Draw.screenshake <= 0) {
				viewPortRectangle.x = realviewportx;
			  viewPortRectangle.y = realviewporty;
				Starling.current.viewPort = viewPortRectangle;
				screenshakestart = false;
			}
		}
	}
	
	function dorender() {
		//Profiler.startframe(Profiler.PROFILE_RENDER);
		switch(Game.gamestate) {
			case Game.TITLEMODE: Render.titlerender();
			case Game.GAMEMODE: Render.gamerender(); 
			case Game.ENDINGMODE: Render.endingrender();
			case Game.FALLINGFROMTOWER: Render.fallfromtowerrender();
			case Game.SPLASHSCREEN: Render.splashscreenrender();
		}
		//Profiler.endframe(Profiler.PROFILE_RENDER);
		
		Draw.drawfade();
	}
	
	var screenshakestart:Bool = false;
	var realviewportx:Float;
	var realviewporty:Float;
}