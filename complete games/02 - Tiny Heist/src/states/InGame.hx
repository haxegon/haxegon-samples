package states;

import haxegon.*;
import entities.Obj;
import gamecontrol.Game;
import modernversion.Modern;
import modernversion.AIDirector;
import world.Glitch;
import world.Localworld;
import world.World;
import util.Direction;
import visuals.Draw;
import visuals.Fade;
import visuals.InventoryUi;
import visuals.MessageBox;

class InGame{
	static var turndelay:Int = 0;
	static var texty:Int;
	static var floortextx:Int = 5;
	static var hptextx:Int = 75;
	static var keytextx:Int = 155;
  static var gemtextx:Int = 195;
	
	public static function input() {
		Controls.getkeypriority();
		
		if (PopUp.windowactive) {
		  PopUp.input();
		}else {
			if (Modern.endlevelanimationstate <= 0 && Game.health > 0) {
				var useitemnow:Bool = false;
				if (Input.justpressed(Key.ONE) && Inventory.inventoryslots >= 1) {   			Inventory.currentslot = 0;	useitemnow = true;
				}else if (Input.justpressed(Key.TWO) && Inventory.inventoryslots >= 2) {   Inventory.currentslot = 1;	useitemnow = true;	
				}else if (Input.justpressed(Key.THREE) && Inventory.inventoryslots >= 3) { Inventory.currentslot = 2;	useitemnow = true;
				}else if (Input.justpressed(Key.FOUR) && Inventory.inventoryslots >= 4) {  Inventory.currentslot = 3;	useitemnow = true;
				}else if (Input.justpressed(Key.FIVE) && Inventory.inventoryslots >= 5) {	Inventory.currentslot = 4;	useitemnow = true;
				}else if (Input.justpressed(Key.SIX) && Inventory.inventoryslots >= 6) {	  Inventory.currentslot = 5;	useitemnow = true;
				}else if (Input.justpressed(Key.SEVEN) && Inventory.inventoryslots >= 7) { Inventory.currentslot = 6;	useitemnow = true;
				}else if (Input.justpressed(Key.EIGHT) && Inventory.inventoryslots >= 8) {	Inventory.currentslot = 7;	useitemnow = true;
				}
				
				if (useitemnow) {
					var player:Int = Obj.getplayer();
					if(player > -1){
						if (Inventory.inventory[Inventory.currentslot] != "") {
							Inventory.useitem(Obj.entities[player], Inventory.inventory[Inventory.currentslot]);
							Game.startmove("wait");
						}else {
							Game.showmessage("NO ITEM EQUIPPED IN SLOT " + (Inventory.currentslot + 1) + "...", "flashing", 120);
						}
					}
				}
				
				if (Game.turn == "playermove") {
					for (i in 0 ... Obj.nentity) {
						if (Obj.entities[i].rule == "player") {
							if (Obj.entities[i].active) {
								if(Controls.pressed("action")){
									Game.startmove("wait");
								}else if(Controls.lastpressed == "left"){
									Obj.entities[i].animated = 5;
									Obj.entities[i].dir = Direction.LEFT;
									if(!Game.blockedfrommoving(i)) Game.startmove("move_left");
								}else if(Controls.lastpressed == "right"){
									Obj.entities[i].animated = 5;
									Obj.entities[i].dir = Direction.RIGHT;
									if(!Game.blockedfrommoving(i)) Game.startmove("move_right");
								}else if(Controls.lastpressed == "up"){
									Obj.entities[i].animated = 5;
									Obj.entities[i].dir = Direction.UP;
									if(!Game.blockedfrommoving(i)) Game.startmove("move_up");
								}else if(Controls.lastpressed == "down"){
									Obj.entities[i].animated = 5;
									Obj.entities[i].dir = Direction.DOWN;
									if(!Game.blockedfrommoving(i)) Game.startmove("move_down");
								}
							}
						}
					}
				}
			}
		}
		
		if (Input.justpressed(Key.R) && !PopUp.windowactive) {
			Modern.restartfadeout();
			Sound.play("restart");
		}
	}
	
	public static function logic() {
		PopUp.logic();
		Game.updatetimersandanimations();
		
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
									while(j < Obj.entities[i].possibleactions.length) {
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
										if (canmoveagain) j = Obj.entities[i].possibleactions.length;
									}
									if (canmoveagain) {
										//trace("*** LET'S TRY AGAIN! ***");	
										Game.turn = "figureoutmove";
									}else {
										//trace("*** CAN'T DO ANYTHING, GIVING UP ***");								
										Obj.entities[i].action = "nothing";
										Obj.entities[i].actionset = true;
										Obj.entities[i].possibleactions = [];
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
						if (S.getroot(Obj.entities[i].action, "_") == "move") {
							if (Obj.entities[i].action == "move_up") { 
								if(Obj.entities[i].canturn) Obj.entities[i].dir = Direction.UP;
								Obj.entities[i].yp--;
								
								Obj.entities[i].animy = 12;
								Obj.entities[i].animyrate = 4;
							}else if (Obj.entities[i].action == "move_down") { 
								if(Obj.entities[i].canturn) Obj.entities[i].dir = Direction.DOWN;
								Obj.entities[i].yp++;
								
								Obj.entities[i].animy = -12;
								Obj.entities[i].animyrate = 4;
							}else if (Obj.entities[i].action == "move_left") { 
								if (Obj.entities[i].canturn) {
									Obj.entities[i].dir = Direction.LEFT;
									Obj.entities[i].dogdir = Direction.LEFT;
								}
								Obj.entities[i].xp--;
								
								Obj.entities[i].animx = 12;
								Obj.entities[i].animxrate = 4;
							}else if (Obj.entities[i].action == "move_right") { 
								if (Obj.entities[i].canturn) {
									Obj.entities[i].dir = Direction.RIGHT;
									Obj.entities[i].dogdir = Direction.RIGHT;
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
		
		Game.updatestatuseffects();
		
		//Burn everything that's on fire
		if (Localworld.onfire) Localworld.incinerate();
		
		//Bring in new reinforcements (depends on location, etc)
		if (Game.timestop <= 0) {
			Game.updatereinforcements();
		}
		
		if (Glitch.glitchmode && !AIDirector.outside) {
		  Glitch.glitch();
		}
		
		if (AIDirector.outside) {
		  var zone:Int = Std.int(Math.max(Math.abs(Modern.worldx - 50), Math.abs(Modern.worldy - 50)));
			if (zone >= 4) {
				Glitch.glitchoutside(zone);
			}
		}
		
		if (Modern.playerjustteleported) Modern.playerjustteleported = false;
		
		//If you walk off the map, load the new one
		Modern.checkfortowerexit();	
	}
	
	public static function render() {
		Draw.drawbackground();
		Draw.drawmap();
		Draw.drawentities();
		
		if (Modern.endlevelanimationstate > 0) {
			var player:Int = Obj.getplayer();
			
			var playerx:Int = Obj.entities[player].xp;
			var playery:Int = Obj.entities[player].yp;
			
			Fade.draw_topoint(playerx, playery, Std.int(Math.max(Draw.screentileheight - playery, playery)) - Modern.endlevelanimationstate);
		}else if (Modern.endlevelanimationstate < 0) {
			Fade.draw_topoint(Modern.endlevelanimationx, Modern.endlevelanimationy, -Modern.endlevelanimationstate);
		}
		if (Game.timestop > 0) {
			Draw.grayscale();
			Obj.templates[Obj.entindex.get(Obj.entities[Obj.getplayer()].rule)].drawentity(Obj.getplayer());
		}
		
		Draw.setboldtext();
		MessageBox.drawentitymessages();
		Draw.setnormaltext();
		
		texty = Gfx.screenheight - 13;
		
		if (Game.messagedelay != 0) {
			Gfx.imagecolor = MessageBox.messagecolback(Game.messagecol);
		}else {
			Gfx.imagecolor = Game.backgroundcolour;
		}
		Gfx.drawimage(0, Gfx.screenheight - 29, "guibar");
		Gfx.resetcolor();
		
		if (Game.messagedelay != 0) {
			Draw.setboldtext();
			if(Game.messagecol == "kludge") Draw.setnormaltext();
			//Gfx.fillbox(0, Gfx.screenheight - 12, Gfx.screenwidth, 12, Draw.messagecolback(Game.messagecol));
			Text.align = Text.CENTER;
			Text.display((Gfx.screenwidth - (Inventory.inventoryslots * 26)) / 2, texty, Game.message, MessageBox.messagecol(Game.messagecol));
			Text.align = Text.LEFT;
			Draw.setnormaltext();
		}else {
			Draw.setnormaltext();
			//Gfx.fillbox(0, Gfx.screenheight - 12, Gfx.screenwidth, 12, Game.backgroundcolour);
			
			if (AIDirector.outside) {
				Text.display(floortextx, texty, "???", Col.rgb(196, 196, 196));
			}else if (AIDirector.floor == 16) {
				Text.display(floortextx, texty, "ROOFTOP", Col.rgb(196, 196, 196));
			}else{
				Text.display(floortextx, texty, "FLOOR " + AIDirector.floor + "/" + 15, Col.rgb(196, 196, 196));
			}
			
			Draw.setnormaltext();
			
			if (Modern.hpflash == 0) {
				Text.display(hptextx, texty, "HP", Col.rgb(255, 64, 64));
				for (i in 0 ... 3) {
					//Gfx.imagecolor(Col.rgb(180, 64, 64));
					Draw.precoloured_drawtile(hptextx + 14 + (i * 12), texty + 1, 19);
					//Gfx.resetcolor();
				}
				for (i in 0 ... Game.health) {
					//Gfx.imagecolor(Col.rgb(255, 64, 64));
					Draw.precoloured_drawtile(hptextx + 14 + (i * 12), texty + 1, 3);
					//Gfx.resetcolor();
				}
			}else {
				var hpflashamount:Int = Col.rgb(Std.int(Math.min(220 + Modern.hpflash * 5, 255)), 
																				Std.int(Math.min(64 + Modern.hpflash * 5, 255)), 
																				Std.int(Math.min(64 + Modern.hpflash * 5, 255)));
				Text.display(hptextx, texty, "HP", hpflashamount);
				for (i in 0 ... 3) {
					Gfx.imagecolor = Col.rgb(180, 64, 64);
					Gfx.drawtile(hptextx + 14 + (i * 12), texty + 1, "terminal", 19);
					Gfx.resetcolor();
				}
				for (i in 0 ... Game.health) {
					Gfx.imagecolor = hpflashamount;
					Gfx.drawtile(hptextx + 14 + (i * 12), texty + 1, "terminal", 3);
					Gfx.resetcolor();
				}
				Modern.hpflash--;
			}
			
			if (Game.keys > 0) {
				if (Modern.keyflash == 0) {
					Gfx.imagecolor = Col.rgb(128, 255, 128);
					Gfx.drawtile(keytextx, texty + 1, "terminal", 12);
					Gfx.resetcolor();
					Text.display(keytextx + 12, texty, "x" + Std.string(Game.keys), Col.rgb(128, 255, 128));
				}else {
					var keyflashcol:Int = Col.rgb(Std.int(Math.min(128 + Modern.keyflash * 8, 255)), 
																				Std.int(Math.min(255 + Modern.keyflash * 8, 255)), 
																				Std.int(Math.min(128 + Modern.keyflash * 8, 255)));
					Gfx.imagecolor = keyflashcol;
					Gfx.drawtile(keytextx, texty + 1, "terminal", 12);
					Gfx.resetcolor();
					Text.display(keytextx + 12, texty, "x" + Std.string(Game.keys), keyflashcol);
					Modern.keyflash--;	
				}
			}
			
			if (Game.gems > 0) {
				if(Modern.gemflash == 0){
					Gfx.imagecolor = Col.rgb(255, 255, 128);
					Gfx.drawtile(gemtextx, texty + 1, "terminal", "$".charCodeAt(0));
					Gfx.resetcolor();
					Text.display(gemtextx + 12, texty, "x" + Std.string(Game.gems), Col.rgb(255, 255, 128));
				}else {
					var gemflashcol:Int = Col.rgb(Std.int(Math.min(255 + Modern.gemflash * 8, 255)), 
																				Std.int(Math.min(255 + Modern.gemflash * 8, 255)), 
																				Std.int(Math.min(128 + Modern.gemflash * 8, 255)));
					Gfx.imagecolor = gemflashcol;
					Gfx.drawtile(gemtextx, texty + 1, "terminal", "$".charCodeAt(0));
					Gfx.resetcolor();
					Text.display(gemtextx + 12, texty, "x" + Std.string(Game.gems), Col.rgb(255, 255, 128));
					Modern.gemflash--;	
				}
			}
		}
		
		InventoryUi.showitems();
		
		if (PopUp.windowactive) {
			PopUp.render();
		}
	}
}