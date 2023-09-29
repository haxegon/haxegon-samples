package world;

import haxe.ds.Map;
import openfl.Assets;
import haxe.Json;

class RoomData{
	public static var data:Dynamic;
	public static var lookup:Map<String, Array<Array<Int>>>;
	public static var widthdata:Map<String, Array<Int>>;
	public static var heightdata:Map<String, Array<Int>>;
	
	public static function numrooms(category:String):Int {
		return lookup.get(category).length;
	}
	
	public static function width(category:String, n:Int):Int {
		return widthdata.get(category)[n];
	}
	
	public static function height(category:String, n:Int):Int {
		return heightdata.get(category)[n];
	}
	
	public static function getroomstring(category:String, n:Int):Array<Int> {
		return lookup.get(category)[n];
	}
	
	public static function load(){
		data = Json.parse(Assets.getText("data/text/rooms.json"));
		
		lookup = new Map<String, Array<Array<Int>>>();
		widthdata = new Map<String, Array<Int>>();
		heightdata = new Map<String, Array<Int>>();
		for (f in Reflect.fields(data)){
			if (f == "width"){
				var widthjson:Dynamic = Reflect.getProperty(data, f);
				for (w in Reflect.fields(widthjson)){
					widthdata.set(w, cast(Reflect.getProperty(widthjson, w)));
				}
			}else if (f == "height"){
				var heightjson:Dynamic = Reflect.getProperty(data, f);
				for (h in Reflect.fields(heightjson)){
					heightdata.set(h, cast(Reflect.getProperty(heightjson, h)));
				}
			}else{
				lookup.set(f, cast(Reflect.getProperty(data, f)));
			}
		}
	}
	
	public static function unload(){
		data = null;
		widthdata = null;
		heightdata = null;
	}
}