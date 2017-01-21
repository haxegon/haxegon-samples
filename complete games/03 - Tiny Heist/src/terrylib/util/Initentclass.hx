package terrylib.util;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;

class Initentclass{
	public function new(){
		clear();
	}
	
	public function clear():Void {
		xp = 0; yp = 0;	rule = "null"; para1 = ""; para2 = ""; para3 = "";
		
		entity = -1; drawframe = 0;
		para1_selection = 0; para2_selection = 0; para3_selection = 0;
	}
	
	public var xp:Int;
	public var yp:Int;
	public var rule:String;
	public var para1:String;
	public var para2:String;
	public var para3:String;
	public var para1_selection:Int;
	public var para2_selection:Int; 
	public var para3_selection:Int;
	
	public var entity:Int;
	public var drawframe:Int;
}
