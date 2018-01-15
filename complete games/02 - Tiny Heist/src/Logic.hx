package;

import haxegon.*;
import gamecontrol.*;
import config.*;
import modernversion.*;
import terrylib.*;

class Logic {
	public static var endingstate:String = "start";
	public static var endingstatepara:Int = 0;
	public static var endingstatedelay:Int = 0;
	
	public static function splashscreenlogic() {
	}
	
	public static function fallfromtowerlogic() {
		if (endingstate == "start") {
		  endingstatepara++;
			if (endingstatepara >= 5) {
				endingstatepara = 0;
			  endingstate = "start2";	
			}
		}else if (endingstate == "start2") {
		  endingstatepara++;
			if (endingstatepara >= 30) {
				endingstatepara = 0;
			  endingstate = "start3";	
			}
		}else if (endingstate == "start3") {
		  endingstatepara++;
			if (endingstatepara >= 15) {
				endingstatepara = 0;
			  endingstate = "start4";	
			}
		}else if (endingstate == "start4") {
			endingstate = "start5";	
			Modern.endlevelanimationstate = 1;
			Modern.endlevelanimationaction = "outsideworld";
		}
		
		if (Modern.endlevelanimationstate > 0) {	
			Modern.endlevelanimationdelay++;
			if(Modern.endlevelanimationdelay >= Modern.endlevelanimationspeed){
				Modern.endlevelanimationstate += 2;
				Modern.endlevelanimationdelay = 0;
				if (Modern.endlevelanimationstate > Draw.screentileheight) {
					if(Modern.endlevelanimationaction == "outsideworld"){
						Game.changestate(Game.GAMEMODE);
						Modern.outsideworld();
					}
				}
			}
		}else if (Modern.endlevelanimationstate < 0) {
			Modern.endlevelanimationdelay++;
			if (Modern.endlevelanimationdelay >= Modern.endlevelanimationspeed) {
				Modern.endlevelanimationstate-= 2;
				Modern.endlevelanimationdelay = 0;
				if (Modern.endlevelanimationstate < -Draw.screentileheight) {
				  Modern.endlevelanimationstate = 0;
					Modern.endlevelanimationdelay = 0;
				}
			}
		}
	}
	
	public static function rank(c:Int):Int {
	  if (c == 0) {
			return 0;
		}else if(c > 0 && c < 5){
			return 1;
		}else if(c < 10){
			return 2;
		}else if(c < 15){
			return 3;
		}else if(c < 25){
			return 4;
		}else if(c < 50){
			return 5;
		}
		
		//Don't acknowledge higher ranks than 5 for achievements
		return 5;
	}
	
	public static function endinglogic() {
		if (endingstate == "start") {
		  endingstatepara++;
			if (endingstatepara >= 5) {
				endingstatepara = 0;
			  endingstate = "start2";	
			}
		}else if (endingstate == "start2") {
		  endingstatepara++;
			if (endingstatepara >= 30) {
				endingstatepara = 0;
			  endingstate = "start3";	
			}
		}else if (endingstate == "start3") {
		  endingstatepara++;
			if (endingstatepara >= 120) {
				Sound.play("ticker");
				endingstatepara = 0;
			  endingstate = "start4";	
			}
		}else if (endingstate == "start4") {
		  endingstatepara++;
			if (endingstatepara >= 30) {
				Sound.play("ticker");
				endingstatepara = 0;
			  endingstate = "start5";	
			}
		}else if (endingstate == "start5") {
		  endingstatepara++;
			if (endingstatepara >= 30) {
				endingstatepara = 0;
				if (Game.cash == 0) {
					Sound.play("collectitem");
					endingstate = "nocash";
				}else {
					if(Game.cash > 1)	Sound.play("collectgem");
					endingstate = "countcash";	
					endingstatepara = 1;
					endingstatedelay = 5;
				}
			}
		}else if (endingstate == "countcash") {
			if (endingstatedelay <= 0) {
				Sound.play("collectgem");
				endingstatepara++;
				endingstatedelay = 5;
				if (endingstatepara >= Game.cash) {
					Achievements.award("win", rank(Game.cash));
				  endingstatepara = 0;
					endingstatedelay = 0;
					endingstate = "countcash2";
				}
			}else {
				endingstatedelay--;	
			}
		}else if (endingstate == "countcash2") {
		  endingstatepara++;
			if (endingstatepara >= 30) {
				Sound.play("victory");
				endingstatepara = 0;
			  endingstate = "nocash2";	
			}
		}else if (endingstate == "nocash") {
		  endingstatepara++;
			if (endingstatepara >= 60) {
				Achievements.award("win", 0);
				Sound.play("victory");
				endingstatepara = 0;
			  endingstate = "nocash2";	
			}
		}else if (endingstate == "nocash2") {
		  endingstatepara++;
			if (endingstatepara >= 60) {
				Sound.play("ticker");
				endingstatepara = 0;
			  endingstate = "nocash3";	
			}
		}else if (endingstate == "nocash3") {
		  endingstatepara++;
			if (endingstatepara >= 30) {
				Sound.play("ticker");
				endingstatepara = 0;
			  endingstate = "pressspace";	
			}
		}
		
		if (Modern.endlevelanimationstate > 0) {	
			Modern.endlevelanimationdelay++;
			if(Modern.endlevelanimationdelay >= Modern.endlevelanimationspeed){
				Modern.endlevelanimationstate+=2;
				Modern.endlevelanimationdelay = 0;
				if (Modern.endlevelanimationstate > Draw.screentileheight) {
					if(Modern.endlevelanimationaction == "titlescreen"){
						Game.changestate(Game.TITLEMODE);
						Modern.endlevelanimationstate = -1;
					}
				}
			}
		}else if (Modern.endlevelanimationstate < 0) {
			Modern.endlevelanimationdelay++;
			if (Modern.endlevelanimationdelay >= Modern.endlevelanimationspeed) {
				Modern.endlevelanimationstate-= 2;
				Modern.endlevelanimationdelay = 0;
				if (Modern.endlevelanimationstate < -Draw.screentileheight) {
				  Modern.endlevelanimationstate = 0;
					Modern.endlevelanimationdelay = 0;
				}
			}
		}
	}
	
	public static function titlelogic() {
		if (Modern.endlevelanimationstate > 0) {
			Modern.endlevelanimationdelay++;
			if(Modern.endlevelanimationdelay >= Modern.endlevelanimationspeed){
				Modern.endlevelanimationstate+=2;
				Modern.endlevelanimationdelay = 0;
				if (Modern.endlevelanimationstate > Draw.screentileheight) {
					if(Modern.endlevelanimationaction == "startgame"){
						Game.changestate(Game.GAMEMODE);
						Modern.start();
					}
				}
			}
		}else if (Modern.endlevelanimationstate < 0) {
			Modern.endlevelanimationdelay++;
			if (Modern.endlevelanimationdelay >= Modern.endlevelanimationspeed) {
				Modern.endlevelanimationstate-=2;
				Modern.endlevelanimationdelay = 0;
				if (Modern.endlevelanimationstate < -Draw.screentileheight) {
				  Modern.endlevelanimationstate = 0;
					Modern.endlevelanimationdelay = 0;
				}
			}
		}
	}
	
	public static var turndelay:Int = 0;
	public static function gamelogic() {
		dopopuplogic();
		updatetimersandanimations();
		
		//Deal with turns
		if (Game.turn == "playermove") {
			
		}
		
		while (Game.turn == "figureoutmove") {
			//trace("Starting new phase: Figuring out moves");
			for (i in 0 ... Obj.nentity) {
				if (Obj.entities[i].active) {
					if (!Obj.entities[i].actionset) {
						Game.clearchain();
						while (!Obj.entities[i].actionset) Game.figureoutmove(i);
					}
				}
			}
			if (Game.allactionsset()) {
				Game.turn = "domove";
				for (i in 0 ... Obj.nentity) {
					if (Obj.entities[i].active) {
						if (Obj.entities[i].action == "nothing") {
							//trace("*** ENTITY " + Std.string(i) + " IS DOING NOTHING THIS TURN ***");
							
							if (Game.couldtryagain(i)) {
								if (Obj.entities[i].type == "player") {
									//The player tries to move again in weird cases only: figure it out later
									//trace("oh fuck");
								}else {
									//Enemies get another try if they can move
									Game.resetenemymove(i);
									//trace("Can we try again?");
									//Go through list of possible moves. If any of them are a hit, great, we
									//can try again!
									var canmoveagain:Bool = false;
									Game.tx1 = Game.getcurrentx(i); 
									Game.ty1 = Game.getcurrenty(i);
									
									var j:Int = 0;
									while(j < Obj.entities[i].numpossibleactions) {
										if (Obj.entities[i].possibleactions[j] == "move_up") {
											canmoveagain = !Game.couldtry(Game.tx1, Game.ty1 - 1, i);
										}else if (Obj.entities[i].possibleactions[j] == "move_down") {
											canmoveagain = !Game.couldtry(Game.tx1, Game.ty1 + 1, i);
										}else if (Obj.entities[i].possibleactions[j] == "move_left") {
											canmoveagain = !Game.couldtry(Game.tx1 - 1, Game.ty1, i);
										}else if (Obj.entities[i].possibleactions[j] == "move_right") {
											canmoveagain = !Game.couldtry(Game.tx1 + 1, Game.ty1, i);
										}
										j++;
										if (canmoveagain) j = Obj.entities[i].numpossibleactions;
									}
									if (canmoveagain) {
										//trace("*** LET'S TRY AGAIN! ***");	
										Game.turn = "figureoutmove";
									}else {
										//trace("*** CAN'T DO ANYTHING, GIVING UP ***");								
										Obj.entities[i].action = "nothing";
										Obj.entities[i].actionset = true;
										Obj.entities[i].numpossibleactions = 0;
									}
								}
							}
						}
					}
				}
			}
			
			var playervar:Int = Obj.getplayer();
			if (playervar == -1) {
				Game.turn = "playermove";
			}else {
				if (Obj.entities[playervar].actionset && Obj.entities[playervar].action == "nothing") {
					//Cancel the entire move, the player can't do that
					Game.turn = "playermove";
					Game.speedframe += 11;
					if (Game.speedframe >= 12) Game.speedframe -= 12;
					
					Localworld.updatelighting();
					
					for (i in 0 ... Obj.nentity) {
						if (Obj.entities[i].active) {
							if (Obj.entities[i].userevertdir) {
								Obj.entities[i].dir = Obj.entities[i].revertdir;
							}
						}
					}
				}
			}
		}
		
		if (Game.turn == "domove") {
			//trace("Entering phase: Do moves!");
			//trace("------------");
			//Do it!
			for (i in 0 ... Obj.nentity) {
				if (Obj.entities[i].active) {
					Obj.entities[i].clearanim();
					if (Game.timestop <= 0 || Obj.entities[i].rule == "player") {
						if (Help.getroot(Obj.entities[i].action, "_") == "move") {
							if (Obj.entities[i].action == "move_up") { 
								if(Obj.entities[i].canturn) Obj.entities[i].dir = Help.UP;
								Obj.entities[i].yp--;
								
								Obj.entities[i].animy = 12;
								Obj.entities[i].animyrate = 4;
							}else if (Obj.entities[i].action == "move_down") { 
								if(Obj.entities[i].canturn) Obj.entities[i].dir = Help.DOWN;
								Obj.entities[i].yp++;
								
								Obj.entities[i].animy = -12;
								Obj.entities[i].animyrate = 4;
							}else if (Obj.entities[i].action == "move_left") { 
								if (Obj.entities[i].canturn) {
									Obj.entities[i].dir = Help.LEFT;
									Obj.entities[i].dogdir = Help.LEFT;
								}
								Obj.entities[i].xp--;
								
								Obj.entities[i].animx = 12;
								Obj.entities[i].animxrate = 4;
							}else if (Obj.entities[i].action == "move_right") { 
								if (Obj.entities[i].canturn) {
									Obj.entities[i].dir = Help.RIGHT;
									Obj.entities[i].dogdir = Help.RIGHT;
								}
								Obj.entities[i].xp++;
								
								Obj.entities[i].animx = -12;
								Obj.entities[i].animxrate = 4;
							}
						}
					}
				}
			}
			
			
			turndelay = 3;
			Game.turn = "animatemove";
		}
		
		if (Game.turn == "animatemove") {
			//Animate move and then...
			var animationcomplete:Bool = true;
			for (i in 0 ... Obj.nentity) {
				if (Obj.entities[i].active) {
					if (Obj.entities[i].animx != 0) {
						if (Obj.entities[i].animx > 0) {
						  Obj.entities[i].animx -= Obj.entities[i].animxrate;
							if (Obj.entities[i].animx <= 0) {
							  Obj.entities[i].animx = 0;	
							}else {
							  animationcomplete = false;	
							}
						}else if (Obj.entities[i].animx < 0) {
						  Obj.entities[i].animx += Obj.entities[i].animxrate;
							if (Obj.entities[i].animx >= 0) {
							  Obj.entities[i].animx = 0;	
							}else {
							  animationcomplete = false;	
							}
						}
					}
					if (Obj.entities[i].animy != 0) {
						if (Obj.entities[i].animy > 0) {
						  Obj.entities[i].animy -= Obj.entities[i].animyrate;
							if (Obj.entities[i].animy <= 0) {
							  Obj.entities[i].animy = 0;	
							}else {
							  animationcomplete = false;	
							}
						}else if (Obj.entities[i].animy < 0) {
						  Obj.entities[i].animy += Obj.entities[i].animyrate;
							if (Obj.entities[i].animy >= 0) {
							  Obj.entities[i].animy = 0;	
							}else {
							  animationcomplete = false;	
							}
						}
					}
				}
			}
			
			if (animationcomplete) {
				Game.turn = "endofturn";
			}
			
			if (turndelay > 0) turndelay--;
		}
		
		if (Game.turn == "endofturn") {
			if (turndelay > 0) {
			  turndelay--;	
			}else {
				//END of turn - update stuff here.	
				Game.turn = "playermove";
				endturn();
			}
		}
		
		for (i in 0 ... Obj.nentity) {
			Obj.animateentities(i);
			if (Obj.entities[i].messagedelay > 0) {
				Obj.entities[i].messagedelay--;
			}
		}
	}
	
	public static function endturn() {
		//Update entity states:
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active) {
				if (Game.timestop <= 0 || Obj.entities[i].rule == "player") {
					Obj.updateentities(i);
				}
			}
		}
		
		//Did any enemies slip on that banana peel? If so, stun them now!
		var player:Int = Obj.getplayer();
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active) {
				if (Obj.entities[i].rule == "enemy") {
					if (Obj.entities[i].state != Game.STUNNED) {
						if (World.at(Obj.entities[i].xp, Obj.entities[i].yp) == Localworld.BANANAPEEL) {
							World.placetile(Obj.entities[i].xp, Obj.entities[i].yp, Localworld.FLOOR);
							Game.stunenemy(i, Modern.STANDARDSTUNTIME);
						}
					}else {
					  //If we're a stunned enemy, and we share a square with the player, then supress waking up
						if (player > -1) {
						  if (Obj.entities[i].xp == Obj.entities[player].xp) {
								if (Obj.entities[i].yp == Obj.entities[player].yp) {
									Obj.entities[i].life++;
								}
							}
						}
					}
				}
			}
		}
		
		if (AIDirector.darkroom || Game.cloaked > 0) {
			Localworld.setroomfog(0);
		}
		
		Localworld.updatelighting();
		if (Game.timestop <= 0) {
			Localworld.updatefire();
		}
		
		//If enemies are adjacent, they attack now
		if (Game.timestop <= 0) {
			if (Game.health > 0) Game.doenemyattack();
		}
		
		//Update icecube and other status effects
		Game.updatestatuseffects();
		
		//Burn everything that's on fire
		if (Localworld.onfire) Localworld.incinerate();
		
		//Bring in new reinforcements (depends on location, etc)
		if (Game.timestop <= 0) {
			Game.updatereinforcements();
		}
		
		if (AIDirector.glitchmode && !AIDirector.outside) {
		  AIDirector.glitch();
		}
		
		if (AIDirector.outside) {
		  var zone:Int = Std.int(Math.max(Math.abs(Modern.worldx - 50), Math.abs(Modern.worldy - 50)));
			if (zone >= 4) {
				AIDirector.glitchoutside(zone);
			}
		}
		
		//If EVERYONE waits, wait again.
		/* Don't do this, it makes things feel confusing
		var temp:Int = 0;
		for (i in 0 ... Obj.nentity) {
			if (Obj.entities[i].active) {
				if (Obj.entities[i].rule == "player" || Obj.entities[i].rule == "enemy") {
					if (Obj.entities[i].action != "wait") {
						temp = 1;
					}
				}
			}
		}
		if (temp == 0 && Game.numberofenemies() > 0) Game.startmove("wait");
		*/
		
		if (Modern.playerjustteleported) Modern.playerjustteleported = false;
		
		//If you walk off the map, load the new one
		//Openworld.checkforroomchange();
		Modern.checkfortowerexit();	
	}
	
	public static function dopopuplogic() {
		if (Modern.popupwindow) {
		  if (Modern.popupmode == "itemshopkeeper") {
				if (Modern.popupstate == 0) {
					Modern.popuplerp++;
					if (Modern.popuplerp >= Modern.popupspeed) {
					  Modern.popupstate = 1;	
					}
				}else if (Modern.popupstate >= 2) {
					Modern.popuplerp -= 2;
					if (Modern.popuplerp <= 0) {
					  Modern.popupwindow = false;	
					}
				}
			}if (Modern.popupmode == "shopkeeper") {
				if (Modern.popupstate == 0) {
					Modern.popuplerp++;
					if (Modern.popuplerp >= Modern.popupspeed) {
					  Modern.popupstate = 1;	
					}
				}else if (Modern.popupstate >= 2) {
					Modern.popuplerp -= 2;
					if (Modern.popuplerp <= 0) {
					  Modern.popupwindow = false;	
					}
				}
			}else if (Modern.popupmode == "soldoutshopkeeper") {
				if (Modern.popupstate == 0) {
					Modern.popuplerp++;
					if (Modern.popuplerp >= Modern.popupspeed) {
					  Modern.popupstate = 1;	
					}
				}else if (Modern.popupstate == 2) {
					Modern.popuplerp -= 2;
					if (Modern.popuplerp <= 0) {
					  Modern.popupwindow = false;	
					}
				}
			}else if (Modern.popupmode == "newitem") {
				if (Modern.popupstate == 0) {
					Modern.popuplerp++;
					if (Modern.popuplerp >= Modern.popupspeed) {
					  Modern.popupstate = 1;	
					}
				}else if (Modern.popupstate == 2) {
					Modern.popuplerp -= 2;
					if (Modern.popuplerp <= 0) {
					  Modern.popupwindow = false;	
					}
				}
			}else if (Modern.popupmode == "newitem_drop") {
				if (Modern.popupstate == 0) {
					Modern.popuplerp++;
					if (Modern.popuplerp >= Modern.popupspeed) {
					  Modern.popupstate = 1;	
					}
				}else if (Modern.popupstate == 2) {
					Modern.popuplerp -= 2;
					if (Modern.popuplerp <= 0) {
						if (Modern.currentslot == Modern.inventory.length - 1) {
						  //We're dropping the new pickup
							Modern.inventory[Modern.inventory.length - 1] = "";
							
							Modern.currentslot = Modern.oldcurrentslot;
						}else {
							//We're dropping an old thing!
							Modern.inventory[Modern.currentslot] = Modern.inventory[Modern.inventory.length - 1];
							Modern.inventory_num[Modern.currentslot] = Modern.inventory_num[Modern.inventory.length - 1];
							Modern.inventory[Modern.inventory.length - 1] = "";
							
							Modern.currentslot = Modern.oldcurrentslot;
						}
					  Modern.popupwindow = false;	
					}
				}
			}
		}	
	}
	
	public static function updatetimersandanimations() {
		/*
		if (Game.alarm) {
			if (Game.alarmsound <= 0) {
			  Music.playsound("alarm");
				Game.alarmsound = 120;
			}else {
				Game.alarmsound--;
			}
		}*/
		
		/*
		if (Game.alarm) {
			if((flash.Lib.getTimer() % 1000) >= 500){
				Modern.updatepalettealarm();
			}else {
				Modern.updatepalette();
			}	
		}*/
		
		
		if (Game.messagedelay > 0) Game.messagedelay--;
		if (Openworld.viewmap > 0) Openworld.viewmap--;
		
		if (Modern.endlevelanimationstate > 0) {	
			Modern.endlevelanimationdelay++;
			if(Modern.endlevelanimationdelay >= Modern.endlevelanimationspeed){
				Modern.endlevelanimationstate+=2;
				Modern.endlevelanimationdelay = 0;
				if (Modern.endlevelanimationstate > Draw.screentileheight) {
					if(Modern.endlevelanimationaction == "next"){
						Modern.usestairs_afteranimation();
					}else if (Modern.endlevelanimationaction == "endgame") {
					  Game.startending();
					}else if (Modern.endlevelanimationaction == "alpha_level12") {
						Menu.createmenu("terryletter");	
						Menu.textmode = 1;
						Game.lettertime = 0;
						Modern.endlevelanimationaction = "readletter";
						Modern.endlevelanimationstate = 0;
					}else if (Modern.endlevelanimationaction == "leftmap") {
						Game.leavetower();
					}else if(Modern.endlevelanimationaction == "restart"){
						Modern.restart();
					}else {
					  throw("Dunno what to do with " + Modern.endlevelanimationaction);	
					}
				}
			}
		}else if (Modern.endlevelanimationstate < 0) {
			Modern.endlevelanimationdelay++;
			if(Modern.endlevelanimationdelay >= Modern.endlevelanimationspeed){
				Modern.endlevelanimationstate-=2;
				Modern.endlevelanimationdelay = 0;
				if (Modern.endlevelanimationstate < -Draw.screentileheight) {
				  Modern.endlevelanimationstate = 0;
					Modern.endlevelanimationdelay = 0;
				}
			}
		}
		
		if (Inventory.useitemcountdown > 0) {
			Inventory.useitemcountdown--;
			if (Inventory.useitemcountdown == 0) {
				Use.doitemaction(Inventory.itemtouse);
			}
		}
		
		if (Game.highlightcooldown > 0) {
			Game.highlightcooldown--;
			if (Game.highlightcooldown == 0) {
				Localworld.clearhighlight();
			}
		}
		
		if (Menu.textmode == 1) {
		  if (Menu.showscript == "terryletter" || Menu.showscript == "alpha_secret") {
				Game.lettertime++;
			}
		}
	}
}