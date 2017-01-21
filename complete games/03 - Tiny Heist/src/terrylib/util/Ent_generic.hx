package terrylib.util;

import haxegon.*;
import terrylib.*;

class Ent_generic {
	public function new() {
	}
	
	public function create(i:Int, xp:Float, yp:Float, para1:String = "0", para2:String = "0", para3:String = "0"):Void {
	}
	
	public function insight(i:Int):Void {
	}
	
	public function dealert(i:Int):Void {
	}
	
	public function alert(i:Int):Void {
	}
	
	public function stun(i:Int, time:Int):Void {
	}
	
	public function kill(i:Int):Void {
	}
	
	public function setupcollision(i:Int):Void {
	}
	
	public function update(i:Int):Void {
	}
	
	public function animate(i:Int):Void {
	}
	
	public function drawentity(i:Int):Void {
	}
	
	public function drawinit(i:Int, xoff:Int, yoff:Int, frame:Int):Void {
	}
	
	public function collision(i:Int, j:Int):Void {
	}
	
	public function addpara1(t:String, f:Int = -1):Void {
		para1.push(t);
		if (f == -1) {
			para1_drawframe.push(init_drawframe);
		}else{ 
			para1_drawframe.push(f);
		}
	}
	
	public function addpara2(t:String, f:Int = -1):Void {
		para2.push(t);
		if (f == -1) {
			para2_drawframe.push(init_drawframe);
		}else{ 
			para2_drawframe.push(f);
		}
	}
	
	public function addpara3(t:String, f:Int = -1):Void {
		para3.push(t);
		if (f == -1) {
			para3_drawframe.push(init_drawframe);
		}else{ 
			para3_drawframe.push(f);
		}
	}
	
	public function setpara1selection(t:Int):Void {
		for (i in 0...para1.length) {
			if (Obj.initentities[t].para1 == para1[i]) {
				Obj.initentities[t].para1_selection = i;
			}
		}
	}
	
	public function setpara2selection(t:Int):Void {
		for (i in 0...para2.length) {
			if (Obj.initentities[t].para2 == para2[i]) {
				Obj.initentities[t].para2_selection = i;
			}
		}
	}
	
	public function setpara3selection(t:Int):Void {
		for (i in 0...para3.length) {
			if (Obj.initentities[t].para3 == para3[i]) {
				Obj.initentities[t].para3_selection = i;
			}
		}
	}
	
	public function getinsights_thisframe(t:Int):Bool {
		return false;
	}
	
	public function setinsights_thisframe(t:Int):Void {
	}
	
	public function getalerted_thisframe(t:Int):Bool {
		return false;
	}
	
	public function setalerted_thisframe(t:Int):Void {
	}
	
	public var name:String;
	public var init_drawframe:Int;
	
	public var para1:Array<String> = new Array<String>();
	public var para2:Array<String> = new Array<String>();
	public var para3:Array<String> = new Array<String>();
	public var para1_name:String;
	public var para2_name:String;
	public var para3_name:String;
	public var para1_drawframe:Array<Int> = new Array<Int>();
	public var para2_drawframe:Array<Int> = new Array<Int>();
	public var para3_drawframe:Array<Int> = new Array<Int>();
}