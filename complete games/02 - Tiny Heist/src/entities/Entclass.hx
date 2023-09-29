package entities;

import haxegon.*;
import util.Rand;
import util.Lerp;

class Entclass {
	public function new() {
		clear();
	}
	
	public function clear():Void {
		//Set all values to a default, required for creating a new entity
		active = false; invis = false;
		tile = 0; rule = "null";
		type = "null";  
		name = "null"; stringpara = "null";
		state = 0; statedelay = 0; life = 0; mysteryvalue = 0;
		behave = 0; animate = 0;
		alertframe = 0;
		
		xp = 0; yp = 0;
		
		animx = 0; animy = 0;
		animxrate = 0; animyrate = 0;
		
		col = 0xFFFFFF;
		
		framedelay = 0; drawframe = 0; walkingframe = 0; dir = 0; actionframe = 0;
		speed = 0;
		health = 3;
		dogdir = 0;
		
		isarobot = false;
		
		canturn = true;
		canattack = true;
		alertbysound = true;
		
		tileset = "sprites";
		checkcollision = false;
		lightsource = "none";
		
		action = "nothing"; actionset = false; ai = "random";
		collidable = true;
		possibleactions = [];
		inchain = false;
		
		alerted_thisframe = false;
		insights_thisframe = false;
		
		userevertdir = false;
		revertdir = 0;
		
		message = "";
		messagecol = "";
		messagedelay = 0;
		
		camerapower = 0;
		cameradir = 0;
		
		animated = 0;
		
		fireproof = false;
	}
	
	public function setmessage(_message, _messagecol = "white", _messagedelay = 120):Void {
		message = " " + _message + " ";
		messagecol = _messagecol;
		messagedelay = _messagedelay;
	}
	
	public function resetactions():Void {
		possibleactions = [];
		actionset = false;
	}
	
	public function addaction(t:String):Void {
		possibleactions.push(t);
	}
	
	public function removeaction(t:String):Void {
		possibleactions.remove(t);
	}
	
	//Fundamentals
	public var action:String;
	public var actionset:Bool;
	public var possibleactions:Array<String> = new Array<String>();
	public var inchain:Bool;
	public var ai:String;
	public var lightsource:String;
	public var speed:Int;
	public var health:Int;
	public var canturn:Bool;
	public var canattack:Bool;
	public var alertbysound:Bool;
	public var fireproof:Bool;
	public var isarobot:Bool;
	
	public var alerted_thisframe:Bool;
	public var insights_thisframe:Bool;
	
	public var userevertdir:Bool;
	public var revertdir:Int;
	
	public var active:Bool;
	public var invis:Bool;
	public var type:String;
	public var tile:Int;
	public var rule:String;
	public var state:Int;
	public var statedelay:Int;
	public var behave:Int;
	public var animate:Int;
	public var mysteryvalue:Int;
	public var life:Int;
	public var name:String;
	public var stringpara:String;
	public var tileset:String;
	public var checkcollision:Bool;
	public var col:Int;
	public var target:Int;
	public var collidable:Bool;
	public var animated:Int;
	
	public var message:String;
	public var messagedelay:Int;
	public var messagecol:String;
	//Position and velocity
	public var xp:Int;
	public var yp:Int;
	
	//Animation
	public var framedelay:Int;
	public var drawframe:Int;
	public var walkingframe:Int;
	public var dir:Int;
	public var dogdir:Int;
	public var actionframe:Int;
	public var alertframe:Int;
	
	public var cameradir:Int;
	public var camerapower:Int;
	
	public var animx:Int;
	public var animy:Int;
	public var animxrate:Int;
	public var animyrate:Int;
	
	public function clearanim() {
	  animx = 0;
		animy = 0;
		animxrate = 0;
		animyrate = 0;
	}
	
	public function startshake(x:Int = 0, y:Int = 0) {
		xbound = x;
		ybound = y;
	  shakecount = 12;	
	}
	
	public function shakex():Float {
		if (xbound != 0 || ybound != 0) {
			return Rand.pint( -3, 3);	
		}
		
		if (xbound < 0) {
			if (shakecount >= 9) return -10;
			return Lerp.to_value(0, -10, shakecount, 9, "bounce_in");
		}else if (xbound > 0) {
			if (shakecount >= 9) return 10;
			return Lerp.to_value(0, 10, shakecount, 9, "bounce_in");
		}
		return 0;
	}
	
	public function shakey():Float {
		if (xbound != 0 || ybound != 0) {
			return Rand.pint( -3, 3);	
		}
		
		if (ybound < 0) {
			if (shakecount >= 9) return -10;
			return Lerp.to_value(0, -10, shakecount, 9, "bounce_in");
		}else if (ybound > 0) {
			if (shakecount >= 9) return 10;
			return Lerp.to_value(0, 10, shakecount, 9, "bounce_in");
		}
		return 0;
	}
	
	public var xbound:Int;
	public var ybound:Int;
	public var shakecount:Int;
}
