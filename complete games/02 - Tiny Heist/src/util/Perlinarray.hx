package util;

import openfl.Assets;
import haxe.Json;

class Perlinarray {
	public static var perlinnoise:Array<Array<Int>>;
	
	public static function load(){
		var jsonfile = Json.parse(Assets.getText("data/text/perlinnoise.json"));
		perlinnoise = Reflect.getProperty(jsonfile, "perlinnoise");
	}
	
	public static function unload(){
		perlinnoise = null;
	}
}	