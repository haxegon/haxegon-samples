package;

import haxegon.*;
import entities.entities.*;
import gamecontrol.Game;
import modernversion.Modern;
import entities.Obj;
import util.TinyRand;
import visuals.Starfield;

class Init {
	public static function loadresources() {
		//Load Music
		//to do
		
		//Load Soundeffects
		var soundlist:Array<String> = [
			"collectgem",
			"collectitem",
			"collectkey",
			"damaged",
			"destroy",
			"nextfloor",
			"lockeddoor",
			"opendoor",
			"shoot",
			"spotted",
			"stun",
			"unlock",
			"useitem",
			"talk",
			"alarm",
			"ticker",
			"victory",
			"fall",
			"start",
			"restart"
		];
		for (i in 0 ... soundlist.length) {
			Sound.load(soundlist[i]);
		}
		
		Sound.load("helicopter", 0.25);
		
		Sound.load("silence");
		Music.play("silence");
		
		//Load Tiles
		Gfx.loadtiles("terminal", 12, 12);
		Gfx.loadtiles("colorterminal", 12, 12);
		
		Gfx.loadimage("guibar");
		
		//Import fonts
		Text.size = 1; Text.font = "fffhomepage";
		Text.size = 1; Text.font = "fffhomepagebold";	
	}
	
	public static function init():Void {		
		//Init all entity types
		Obj.templates.push(new PlayerEntity());
		Obj.templates.push(new EnemyEntity());
		Obj.templates.push(new ItemEntity());
		Obj.templates.push(new TreasureEntity());
		Obj.templates.push(new ShopkeeperEntity());
		Obj.loadtemplates();
		
		//Load resources
		loadresources();
		
		TinyRand.setseed(Std.int(Math.random() * 50000));
		
		Starfield.init();
		
		//Init the game
		Game.changestate(Game.TITLEMODE);
		Sound.play("start");
		Modern.start();
		
		//Start the game
		Text.font = "fffhomepage";
		//Game.changestate(Game.ENDINGMODE);
	}
}