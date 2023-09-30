package;

import haxegon.*;
import gamecontrol.Game;
import entities.Obj;
import states.TitleScreen;
import states.EndingScreen;
import states.FallingFromTower;
import states.InGame;
import util.TinyRand;
import util.Glow;
import util.Lerp;
import util.BresenhamLine;
import util.Perlinarray;
import visuals.Draw;
import visuals.ScreenEffects;
import visuals.Fade;
import world.RoomData;
import world.Generator;
import world.Localworld;
import world.World;

class Main {
	var standalonemode:Bool = false;
	var gamemenu:Bool = false;
	
	public function new () {
		initcrashdumper();
		
		Core.fps = 30;
		Gfx.resizescreen(384, 240);
		
		GameData.init();
		Perlinarray.load();
		RoomData.load();
		
		Controls.init();
		Glow.init();
		BresenhamLine.init();
		Lerp.init();
		World.init();
		Camera.init();
		Obj.init();
		
		Game.init();
		Localworld.init();
		Generator.init();
		Draw.init();
		Init.init();
	}
	
	function cleanup(){
		Perlinarray.unload();
		RoomData.unload();
	}
	
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
		switch(Game.gamestate) {
			case Game.TITLEMODE: TitleScreen.render();
			case Game.GAMEMODE: InGame.render(); 
			case Game.ENDINGMODE: EndingScreen.render();
			case Game.FALLINGFROMTOWER: FallingFromTower.render();
		}
		
		Fade.draw();
		
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
	}
	
	function doinput() {
		switch(Game.gamestate) {
			case Game.TITLEMODE: TitleScreen.input();
			case Game.GAMEMODE: InGame.input();
			case Game.ENDINGMODE: EndingScreen.input();
			case Game.FALLINGFROMTOWER: FallingFromTower.input();
		}
	}
	
	function dologic() {
		Lerp.update();
		
		switch(Game.gamestate) {
			case Game.TITLEMODE: TitleScreen.logic();
			case Game.GAMEMODE: InGame.logic(); 
			case Game.ENDINGMODE: EndingScreen.logic();
			case Game.FALLINGFROMTOWER: FallingFromTower.logic();
		}
		
		Fade.fadelogic();
		Obj.cleanup();
		Fade.update();
		Glow.update();
		ScreenEffects.updatescreenshake();
	}
	
	public static function initcrashdumper() {
		// Crashdumper
		#if (crashdumper && (desktop || flash)) // (crashdumper && (desktop || flash || mobile)) not sure if crashdumper works in mobile or not

		//trace("Crashdumper is active.");
		var unique_id:String = crashdumper.SessionData.generateID("haxegon_");
		#if flash
		var crashDumper = new crashdumper.CrashDumper(unique_id, null, null, false, null, null, openfl.Lib.current.stage);
		#else
		var crashDumper = new crashdumper.CrashDumper(unique_id);
		#end

		crashDumper.session.version = "1";

		#if debug
		crashDumper.closeOnCrash = true;
		#else
		crashDumper.closeOnCrash = false;
		#end
		crashDumper.url = null;
		crashDumper.path = "%APP%";
		var path = new haxe.io.Path(crashDumper.path);
		// Avoid exposing user folder in MacOS
		#if !flash
		if (StringTools.startsWith(path.dir, "/Users")) {
			var split = path.dir.split('/');
			split.splice(0, 3);
			split.unshift('~');
			path.dir = split.join('/');
		}
		#end
		crashDumper.postCrashMethod = function(e) {
			var window = openfl.Lib.current.stage.application.window;
			if (window.fullscreen) {
				window.minimized = true;
			}
			#if !debug
			window.alert('Oh, no! What a terryible crash!\nCheck ${path.toString()} for the crash log.',
				"Tiny Heist crashed :(");
			#end
		}
		#end
	}
}