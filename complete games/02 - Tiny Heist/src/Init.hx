package;

import modernversion.Modern;
import openfl.display.*;
import openfl.Assets;
import config.*;
import gamecontrol.*;
import haxegon.*;
import terrylib.*;
import objs.*;

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
		//Gfx.makescaledtiles("terminal", 12, 12);
		Gfx.loadtiles("terminal", 12, 12);
		Gfx.loadtiles("colorterminal", 12, 12);
		
		Gfx.loadimage("guibar");
		//Load large images
		//IMPLEMENT
		//Gfx.loadimage("perlin");
		//Draw.perlinnoise = Gfx.imageindex.get("perlin");
		
		//Import fonts
		Text.size = 1; Text.font = "fffhomepage";
		Text.size = 1; Text.font = "fffhomepagebold";	
	}
	
	public static function init():Void {
		World.changecamera("none");
		
		//Init all entity types
		Obj.templates.push(new Ent_player());
		Obj.templates.push(new Ent_enemy());
		Obj.templates.push(new Ent_item());
		Obj.templates.push(new Ent_treasure());
		Obj.templates.push(new Ent_npc());
		Obj.loadtemplates();
		
		//Load resources
		loadresources();
		
		Rand.setseed(Std.int(Math.random() * 50000));
		
		Openworld.generate("day5");
		
		Render.initstars();
		
		//Init the game
		if (Achievements.splashscreen) {
			Text.font = "fffhomepage";
			Game.changestate(Game.SPLASHSCREEN);
		}else{
			Game.changestate(Game.TITLEMODE);
			//Game.changestate(Game.GAMEMODE);
			Sound.play("start");
			Modern.start();
			
			//Start the game
			Text.font = "fffhomepage";
			//Game.changestate(Game.ENDINGMODE);
		}
	}
}