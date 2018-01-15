package gamecontrol;

import config.*;
import terrylib.*;
import haxegon.*;
import terrylib.util.*;

class Script{
	public static function load(t:String):Void {
		//loads script name t into the array
		position = 0; scriptlength = 0; parsetext = false;
		if (t == "hardcoded") {
			s("talk(enter hardcoded scripts here, not in the generated script file!)");
		}else {
			//Always load externally first if possible - if not, check the local cache.
			if (!loadexternalscript(t)) {
				if (!Scriptcache.localloadscript(t)) {
					trace("Error: Can't find script " + t);
				}
			}
		}
		
		running = true;
	}
	
	public static function s(t:String):Void {	add(t); }

	public static function runscript():Void {
		//Heart of the scripting engine: script commands implemented here
		while (running && scriptdelay <= 0 && !pausescript) {
			if (position < scriptlength) {
				//Let's split or command in an array of words
				tokenize(commands[position]);
				
				//Ok, now we run a command based on that string
				if (parsetext) {
					Textbox.addline(Help.trimspaces(words[0]));
				}else if (words[0] == "if") {
					//USAGE: if(flag,newscript);
					if (Flag.istrue(words[1])) {
						load(words[2]); position--;
					}
				}else if (words[0] == "endif") {
					//USAGE: endif(flag);
					if (Flag.istrue(words[1])) {
						position = scriptlength;
					}
				}else if (words[0] == "settrue") {
					Flag.settrue(words[1]);
				}else if (words[0] == "setfalse") { 
					Flag.setfalse(words[1]);
				}else if (words[0] == "fadeout") {
					Draw.fademode = Draw.FADE_OUT;
					if (words[1] != "") {
						Draw.fadeaction = words[1];
					}
				}else if (words[0] == "music") {
					Music.play(words[1]);
				}else if (words[0] == "sound") {
					Sound.play(words[1]);
				}else if (words[0] == "fadein") {
					Draw.fademode = Draw.FADE_IN;
				}else if (words[0] == "delay") {
					//USAGE: delay(frames)
					scriptdelay = Std.parseInt(words[1]);
				}else if (words[0] == "flash") {
					//USAGE: flash(frames)
					Draw.flashlight = Std.parseInt(words[1]);
				}else if (words[0] == "shake") {
					//USAGE: shake(frames)
					Draw.screenshake = Std.parseInt(words[1]);
				}else if (words[0] == "changemap") {
					//USAGE: changemap("map
					Obj.activedoordest = words[1];
					Obj.doortox = Std.parseInt(words[2]);
					Obj.doortoy = Std.parseInt(words[3]);
					
					Draw.fademode = Draw.FADE_OUT;
					Draw.fadeaction = "changeroom";
				}else if (words[0] == "wait") {
					//USAGE: wait(fade) - Wait until the screen is faded out
					if(words[1]=="fade"){
						if (Draw.fademode != Draw.FADED_OUT && Draw.fademode != Draw.FADED_IN) {
							scriptdelay = 2; position--;
						}else {
							scriptdelay = 0;
						}
					}
				}else if (words[0] == "say") {
					speaker = words[1];
					Textbox.createtextbox(Obj.entities[Obj.getnpc(speaker)].stringpara, 0, 0, Textbox.col);
					parsetext = true;
				}else if (words[0] == "endsay") {
					//Prepare to speak a block of text
					if (speaker != "") Textbox.textboxposition(Obj.getnpc(speaker));
					Textbox.starttextbox();
					parsetext = false;
					
					pausescript = true;
				}else if (words[0] == "textboxstyle") {
					//Change textbox style:
					Textbox.col = Std.parseInt(words[1]);
				}
				
				position++;
			}else {
				running = false;
			}
		}
		
		if (scriptdelay > 0) {
			scriptdelay--;
		}
	}
	
	public static function add(t:String):Void {
		commands[scriptlength] = t;
		scriptlength++;
	}
	
	public static function loadexternalscript(t:String):Bool {
		#if flash
		return false;
		#else
		return Fileaccess.loadscriptfile(t);
		#end
	}
	
	public static function tokenize(t:String):Void {
		numwords = 0; tempword = "";
		
		if (parsetext) {
			words[0] = t;
		}
		
		if (!parsetext) {
			for (i in 0...t.length) {
				currentletter = t.substr(i, 1);
				if (currentletter == "(" || currentletter == ")" || currentletter == ",") {
					words[numwords] = tempword;
					//If it's an instruction to talk, then we do something different
					if (numwords == 0 && words[0] == "say") {
						words[1] = Help.getbrackets(t);
						break;
					}else if (numwords == 0 && words[0] == "talk") {
						words[1] = Help.getbrackets(t);
						break;
					}else if (numwords == 0 && words[0] == "speaker") {
						words[1] = Help.getbrackets(t);
						break;
					}else if (numwords == 0 && words[0] == "call") {
						words[1] = Help.getbrackets(t);
						break;
					}else {
						words[numwords] = words[numwords].toLowerCase();
					}
					numwords++; tempword = "";
				}else if (currentletter == " ") {
					//don't do anything - i.e. strip out spaces.
				}else {
					tempword += currentletter;
				}
			}
			
			if (tempword != "") {
				words[numwords] = tempword;
				numwords++;
			}
		}
		
		if (words[0].charAt(0) == "}") {
			words[0] = "endsay";
			parsetext = false;
		}
	}
	
	public static function init():Void {
		speaker = "";
		parsetext = false;
		pausescript = false; 
		
		for (i in 0...500) {
			commands.push(new String(""));
		}
		
		for (i in 0...100) {
			words.push(new String(""));
			txt.push(new String(""));
		}
		
		position = 0; scriptlength = 0; scriptdelay = 0;
		running = false;
		
		hascontrol = true; 
	}
	
	public static var commands:Array<String> = new Array<String>();
	public static var words:Array<String> = new Array<String>();
	public static var txt:Array<String> = new Array<String>();
	public static var scriptname:String;
	public static var position:Int;
	public static var scriptlength:Int;
	public static var looppoint:Int;
	public static var loopcount:Int;
	public static var pausescript:Bool;
	public static var hascontrol:Bool;
	
	public static var scriptdelay:Int;
	public static var running:Bool;
	public static var tempword:String;
	public static var currentletter:String;
	public static var numwords:Int;
	public static var parsetext:Bool;
	public static var speaker:String;
}