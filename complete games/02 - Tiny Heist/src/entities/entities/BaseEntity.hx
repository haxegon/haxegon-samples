package entities.entities;

import entities.Obj;

class BaseEntity {
	public function new() {
	}
	
	public function create(i:Int, xp:Float, yp:Float, para1:String = "", para2:String = ""):Void {
		Obj.entities[i].tileset = "terminal";
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
	
	public function update(i:Int):Void {
	}
	
	public function animate(i:Int):Void {
		Obj.entities[i].drawframe = Obj.entities[i].tile;
	}
	
	public function drawentity(i:Int):Void {
	}
	
	public function drawinit(i:Int, xoff:Int, yoff:Int, frame:Int):Void {
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
}