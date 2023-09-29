import haxegon.Sound;
import haxegon.Gfx;
import haxegon.Text;
import haxegon.Col;
import gamecontrol.Game;
import entities.Obj;
import modernversion.Modern;
import visuals.Draw;
import visuals.MessageBox;
import world.Localworld;
import util.Lerp;
import GameData.ItemData;

enum PopUpType{
	SHOPKEEPER_KEYS;
	SHOPKEEPER_ITEM;
	SHOPKEEPER_SOLDOUT;
	PICKUP;
	PICKUP_AND_DROP;
}

class PopUp{
	public static var windowactive:Bool = false;
	
	static var menuselection:Int = 0;
	static var mode:PopUpType;
	static var state:Int = 0;
	static var lerp:Int = 0;
	static var item:ItemData;
	static var speed:Int = 20;
	static var animationtype_appear:String = "back_out";
	static var animationtype_disappear:String = "back_out";
	
	public static function create(_mode:PopUpType, _item:ItemData = null) {
		windowactive = true;
		mode = _mode;
		lerp = 0;
		state = 0;
		item = _item;
		
		menuselection = 0;
	}
	
	public static function input() {
		if (mode == PopUpType.SHOPKEEPER_ITEM) {
			if (state == 1) {
				if (Controls.justpressed("left") || Controls.justpressed("up")) {
					menuselection = 0;
				}
				if (Controls.justpressed("down") || Controls.justpressed("right")) {
					menuselection = 1;
				}
				
				if (Controls.justpressed("action")) {
					if (Game.gems < 3 || Inventory.slotsfree() == 0) {
						state = 3;
						Sound.play("lockeddoor");
					}else	if(menuselection == 1){
						state = 2;	
						Sound.play("lockeddoor");
					}else {
						if (Game.gems >= 3) {
							Game.gems -= 3;
							Modern.gemflash = Modern.flashtime;
							
							Inventory.giveitem(item.name);
							Game.keys++;
							Modern.keyflash = Modern.flashtime;
							
							Obj.entities[Obj.getplayer()].setmessage("Bought " + item.name.toUpperCase(), "player", 90);
							Sound.play("collectitem");
							state = 2;
							
							Obj.entities[Modern.currentshopkeeper].name = "sold out";
						}else {
							Sound.play("lockeddoor");
						}
					}
				}
			}
		}else if (mode == PopUpType.SHOPKEEPER_KEYS) {
			if (state == 1) {
				if (Controls.justpressed("left") || Controls.justpressed("up")) {
					menuselection = 0;
				}
				if (Controls.justpressed("down") || Controls.justpressed("right")) {
					menuselection = 1;
				}
				
				if (Controls.justpressed("action")) {
					if ( Modern.keygemrate > Game.gems) {
						state = 3;
						Sound.play("lockeddoor");
					}else	if(menuselection == 1){
						state = 2;	
						Sound.play("lockeddoor");
					}else {
						if (Game.gems >= Modern.keygemrate) {
							Game.gems -= Modern.keygemrate;
							Modern.gemflash = Modern.flashtime;
							Modern.keygemratelevel++;
							
							Game.keys++;
							Modern.keyflash = Modern.flashtime;
							
							Obj.entities[Obj.getplayer()].setmessage("Bought a KEY", "key", 90);
							Sound.play("collectkey");
							state = 2;
						}else {
							Sound.play("lockeddoor");
						}
					}
				}
			}
		}else if (mode == PopUpType.SHOPKEEPER_SOLDOUT) {
			if (state == 1) {
				if (Controls.justpressed("action")) {
					state = 2;	
				}
			}
		}else if (mode == PopUpType.PICKUP) {
			if (state == 1) {
				if (Controls.justpressed("action")) {
					state = 2;	
				}
			}
		}else if (mode == PopUpType.PICKUP_AND_DROP) {
			if (state < 2) {
				if (Controls.delaypressed("left", 8)) {
					Inventory.currentslot = (Inventory.currentslot + (Inventory.inventory.length - 1)) % Inventory.inventory.length;
				}
				if (Controls.delaypressed("right", 8)) {
					Inventory.currentslot = (Inventory.currentslot + 1) % Inventory.inventory.length;
				}
			}
			if (state == 1) {
				if (Controls.justpressed("action")) {
					state = 2;
				}
			}
		}	
	}
	
	public static function logic() {
		if (windowactive) {
		  if (mode == PopUpType.SHOPKEEPER_ITEM) {
				if (state == 0) {
					lerp++;
					if (lerp >= speed) {
					  state = 1;	
					}
				}else if (state >= 2) {
					lerp -= 2;
					if (lerp <= 0) {
					  windowactive = false;	
					}
				}
			}else if (mode == PopUpType.SHOPKEEPER_KEYS) {
				if (state == 0) {
					lerp++;
					if (lerp >= speed) {
					  state = 1;	
					}
				}else if (state >= 2) {
					lerp -= 2;
					if (lerp <= 0) {
					  windowactive = false;	
					}
				}
			}else if (mode == PopUpType.SHOPKEEPER_SOLDOUT) {
				if (state == 0) {
					lerp++;
					if (lerp >= speed) {
					  state = 1;	
					}
				}else if (state == 2) {
					lerp -= 2;
					if (lerp <= 0) {
					  windowactive = false;	
					}
				}
			}else if (mode == PopUpType.PICKUP) {
				if (state == 0) {
					lerp++;
					if (lerp >= speed) {
					  state = 1;	
					}
				}else if (state == 2) {
					lerp -= 2;
					if (lerp <= 0) {
					  windowactive = false;	
					}
				}
			}else if (mode == PopUpType.PICKUP_AND_DROP) {
				if (state == 0) {
					lerp++;
					if (lerp >= speed) {
					  state = 1;	
					}
				}else if (state == 2) {
					lerp -= 2;
					if (lerp <= 0) {
						if (Inventory.currentslot == Inventory.inventory.length - 1) {
						  //We're dropping the new pickup
							Inventory.inventory[Inventory.inventory.length - 1] = "";
							
							Inventory.currentslot = Inventory.oldcurrentslot;
						}else {
							//We're dropping an old thing!
							Inventory.inventory[Inventory.currentslot] = Inventory.inventory[Inventory.inventory.length - 1];
							Inventory.inventory_num[Inventory.currentslot] = Inventory.inventory_num[Inventory.inventory.length - 1];
							Inventory.inventory[Inventory.inventory.length - 1] = "";
							
							Inventory.currentslot = Inventory.oldcurrentslot;
						}
					  windowactive = false;	
					}
				}
			}
		}	
	}
	
	public static function render(){
		if (mode == PopUpType.SHOPKEEPER_SOLDOUT) {
			var boxheight:Int = 70;
			var tx = Gfx.screenwidthmid - 120;
			var ty = Gfx.screenheightmid - Std.int(boxheight / 2) - Std.int(Lerp.to_value(boxheight * 2, 0, lerp, speed, ((state<2)?animationtype_appear:animationtype_disappear)));
			
			Draw.drawbubble(tx, ty, 240, boxheight, Draw.shade(Modern.shopkeepcol, 0.8), Col.BLACK, Col.BLACK);
			ty += 2;
			
			Text.align = Text.CENTER;
			Draw.setboldtext();
			Gfx.imagecolor = Modern.shopkeepcol;
			Gfx.drawtile(Gfx.screenwidthmid - 6 - 40, ty + 5, "terminal", 2);
			Gfx.resetcolor();
			Text.display(Gfx.screenwidthmid, ty + 5, "    Shopkeeper", MessageBox.messagecol("white"));	
			Draw.setnormaltext();
			Text.display(Gfx.screenwidthmid, ty + 22, "Sorry, I've got nothing else to sell!", MessageBox.messagecol("white"));	
			Text.align = Text.LEFT;
			
			Text.align = Text.CENTER;
			Text.display(Gfx.screenwidthmid, ty + 40, "> Oh, ok. <", MessageBox.messagecol("flashing"));	
			
			Text.align = Text.LEFT;
		}else if (mode == PopUpType.SHOPKEEPER_ITEM) {
			var boxheight:Int = 90;
			var tx = Gfx.screenwidthmid - 120;
			var ty = Gfx.screenheightmid - Std.int(boxheight / 2) - Std.int(Lerp.to_value(boxheight * 2, 0, lerp, speed, ((state<2)?animationtype_appear:animationtype_disappear)));
			
			Draw.drawbubble(tx, ty, 240, boxheight, Draw.shade(Modern.shopkeepcol, 0.8), Col.BLACK, Col.BLACK);
			ty += 2;
			
			Text.align = Text.CENTER;
			Draw.setboldtext();
			Gfx.imagecolor = Modern.shopkeepcol;
			Gfx.drawtile(Gfx.screenwidthmid - 6 - 40, ty + 5, "terminal", 2);
			Gfx.resetcolor();
			Text.display(Gfx.screenwidthmid, ty + 5, "    Shopkeeper", MessageBox.messagecol("white"));	
			Draw.setnormaltext();
			Text.align = Text.LEFT;
			var slen:Int = Std.int(Text.width("Can I interest you in this " + item.name + "?") + 24);
			var slen2:Int = Std.int(Text.width("Can I interest you in this "));
			Text.display(Gfx.screenwidthmid - Std.int(slen / 2) - 3, ty + 22, "Can I interest you in this ", MessageBox.messagecol("white"));	
			Draw.setboldtext();
			Text.display(Gfx.screenwidthmid - Std.int(slen / 2) - 3 + slen2 + 18, ty + 22, item.name + "?", item.col);	
			
			Gfx.imagecolor = item.col;
			Gfx.drawtile(Gfx.screenwidthmid - Std.int(slen / 2) - 3 + slen2 + 3, ty + 22, "terminal", item.sprite);
			Gfx.resetcolor();
			
			Draw.setnormaltext();
			
			Text.align = Text.LEFT;
			var slen:Int = Std.int(Text.width("It's yours for just 3 GEMS!"));
			Text.display(Gfx.screenwidthmid - Std.int(slen / 2), ty + 34, "It's yours for just ", MessageBox.messagecol("white"));	
			var slen2:Int = Std.int(Gfx.screenwidthmid - Std.int(slen / 2) + Text.width("It's yours for just "));
			Draw.setboldtext();
			Text.display(slen2 + 4, ty + 34, "3 GEMS!", MessageBox.messagecol("player"));	
			Draw.setnormaltext();
			
			Text.align = Text.CENTER;
			if (Inventory.slotsfree() == 0 && state != 2) {
				Text.display(Gfx.screenwidthmid, ty + 54 + 5, "> I don't have room for that! <", MessageBox.messagecol("flashing"));
			}else if (Game.gems < 3 && state != 2) {
				Text.display(Gfx.screenwidthmid, ty + 54 + 5, "> I can't afford that! <", MessageBox.messagecol("flashing"));	
			}else{
				if (menuselection == 0) {
					Text.display(Gfx.screenwidthmid, ty + 54, "> Great, I'll take one! (cost: 3 GEMS) <", MessageBox.messagecol("flashing"));	
				}else{
					Text.display(Gfx.screenwidthmid, ty + 54, "Great, I'll take one! (cost: 3 GEMS)", MessageBox.messagecol("grayedout"));	
				}
				
				if (menuselection == 1) {
					Text.display(Gfx.screenwidthmid, ty + 66, "> No way! <", MessageBox.messagecol("flashing"));	
				}else {
					Text.display(Gfx.screenwidthmid, ty + 66, "No way!", MessageBox.messagecol("grayedout"));	
				}
			}
			
			Text.align = Text.LEFT;
		}else	if (mode == PopUpType.SHOPKEEPER_KEYS) {
			var boxheight:Int = 90;
			var tx = Gfx.screenwidthmid - 120;
			var ty = Gfx.screenheightmid - Std.int(boxheight / 2) - Std.int(Lerp.to_value(boxheight * 2, 0, lerp, speed, ((state<2)?animationtype_appear:animationtype_disappear)));
			
			Draw.drawbubble(tx, ty, 240, boxheight, Draw.shade(Modern.shopkeepcol, 0.8), Col.BLACK, Col.BLACK);
			ty += 2;
			
			Text.align = Text.CENTER;
			Draw.setboldtext();
			Gfx.imagecolor = Modern.shopkeepcol;
			Gfx.drawtile(Gfx.screenwidthmid - 6 - 40, ty + 5, "terminal", 2);
			Gfx.resetcolor();
			Text.display(Gfx.screenwidthmid, ty + 5, "    Shopkeeper", MessageBox.messagecol("white"));	
			Draw.setnormaltext();
			Text.display(Gfx.screenwidthmid, ty + 22, "Hello! Want some keys? I can help!", MessageBox.messagecol("white"));	
			Text.align = Text.LEFT;
			var slen:Int = Std.int(Text.width("I sell keys for just " + Modern.keygemrate + " GEM" + (Modern.keygemrate>1?"S":"") + "!"));
			Text.display(Gfx.screenwidthmid - Std.int(slen / 2), ty + 34, "I sell keys for just ", MessageBox.messagecol("white"));	
			var slen2:Int = Std.int(Gfx.screenwidthmid - Std.int(slen / 2) + Text.width("I sell keys for just "));
			Draw.setboldtext();
			Text.display(slen2 + 3, ty + 34, Modern.keygemrate + " GEM" + (Modern.keygemrate>1?"S":"") + "!", MessageBox.messagecol("player"));	
			Draw.setnormaltext();
			
			Text.align = Text.CENTER;
			if (Modern.keygemrate > Game.gems && state != 2) {
				Text.display(Gfx.screenwidthmid, ty + 54 + 5, "> I can't afford that! <", MessageBox.messagecol("flashing"));	
			}else{
				if (menuselection == 0) {
					Text.display(Gfx.screenwidthmid, ty + 54, "> Great, I'll take one! (cost: " + Modern.keygemrate + " GEM" + (Modern.keygemrate>1?"S":"") + ") <", MessageBox.messagecol("flashing"));	
				}else{
					Text.display(Gfx.screenwidthmid, ty + 54, "Great, I'll take one! (cost: " + Modern.keygemrate + " GEM" + (Modern.keygemrate>1?"S":"") + ")", MessageBox.messagecol("grayedout"));	
				}
				
				if (menuselection == 1) {
					Text.display(Gfx.screenwidthmid, ty + 66, "> No way! <", MessageBox.messagecol("flashing"));	
				}else {
					Text.display(Gfx.screenwidthmid, ty + 66, "No way!", MessageBox.messagecol("grayedout"));	
				}
			}
			
			Text.align = Text.LEFT;
		}else	if (mode == PopUpType.PICKUP_AND_DROP || mode == PopUpType.PICKUP){
			var boxheight:Int = 68 + (getnumlines(item) * 10);
			var tx = Gfx.screenwidthmid - 120;
			var ty = Gfx.screenheightmid - Std.int(boxheight / 2) - Std.int(Lerp.to_value(boxheight * 2, 0, lerp, speed, ((state<2)?animationtype_appear:animationtype_disappear)));
			if (mode == PopUpType.PICKUP_AND_DROP) ty -= 15;
			
			Draw.drawbubble(tx, ty, 240, boxheight, Draw.shade(item.col, 0.8), Col.BLACK, Col.BLACK);
			Gfx.imagecolor = item.col;
				
			if(item.hasmultipleshots){
				Gfx.drawtile(Gfx.screenwidthmid - 6 - 8, ty + 25, "terminal", item.sprite);
				Gfx.resetcolor();
				
				Gfx.fillbox(Gfx.screenwidthmid - 6 + 6 - 1, ty + 26 - 1, Text.width("x" + item.numuses) + 4, 10 + 2, Col.BLACK);
				Gfx.fillbox(Gfx.screenwidthmid - 6 + 6, ty + 26, Text.width("x" + item.numuses) + 2, 10, Draw.shade(item.col, 0.8));
				Text.display(Gfx.screenwidthmid - 6 + 7, ty + 26 - 2, "x" + item.numuses, Col.BLACK);
			}else{
				Gfx.drawtile(Gfx.screenwidthmid - 6, ty + 25, "terminal", item.sprite);
				Gfx.resetcolor();
			}
			
			Draw.setnormaltext();
			Draw.drawbubble(tx - 10, ty - 5, 60, 18, Draw.shade(item.col, 0.8), Col.BLACK, Col.BLACK);
			Text.display(tx - 4, ty - 3, "NEW ITEM!", MessageBox.messagecol("shout"));
			
			Text.align = Text.CENTER;
			Draw.setboldtext();
			Text.display(Gfx.screenwidthmid, ty + 5, item.name, MessageBox.messagecol("shout"));
			
			Draw.setnormaltext();
			ty += 40;
			for (i in 0 ... getnumlines(item)) {
				Text.display(Gfx.screenwidthmid, ty, getline(item, i), MessageBox.messagecol("white"));	
				ty += 10;
			}
			
			ty = Gfx.screenheightmid - Std.int(boxheight / 2) - Std.int(Lerp.to_value(boxheight * 2, 0, lerp, speed, ((state<2)?animationtype_appear:animationtype_disappear)));
			ty = ty + boxheight - 18;
			if (mode == PopUpType.PICKUP_AND_DROP) {
				ty -= 15;
				Text.display(Gfx.screenwidthmid, ty, "[" + Controls.showfirstassigned("action") + ": drop item and return to game]", MessageBox.messagecol("whisper"));	
			}else{
				Text.display(Gfx.screenwidthmid, ty, "[" + Controls.showfirstassigned("action") + ": return to game]", MessageBox.messagecol("whisper"));	
			}
			
			if (mode == PopUpType.PICKUP_AND_DROP) {
				//Also show a popup to drop an item...
				tx = Gfx.screenwidth - 200;
				ty = Gfx.screenheight - 70;
				
				Draw.drawbubble(tx, ty, 200, 70, 0x888888, Col.BLACK, Col.BLACK);
				Draw.setnormaltext();
				Text.display(tx + 100, ty + 5, "You need to drop an item...", MessageBox.messagecol("white"));	
				
				ty += 25;
				var gap:Int = 32;
				tx = Gfx.screenwidth - 100 - 6 - Std.int((Inventory.inventory.length * gap) / 2) + Std.int((gap - 24) / 2);
				Text.align = Text.LEFT;
				for (i in 0 ... Inventory.inventory.length) {
					if (i == Inventory.inventory.length - 1) {
						tx += 12;
						Text.display(tx + (i * gap) - 15, ty + 2, "or", MessageBox.messagecol("white"));	
					}
					if (i == Inventory.currentslot) {
						//Use brighter colours and draw a border
						Draw.roundfillrect(tx + (i * gap) - 2, ty - 1, 24 + 2, 24, Localworld.worldblock[Localworld.WALL].front_fog);
					}
					var tempitem:ItemData = GameData.getitem(Inventory.inventory[i]);
					
					Draw.drawbubble(tx + (i * gap), ty, 22, 22, Draw.shade(tempitem.col, 0.8), Col.BLACK, Col.BLACK);
					Gfx.imagecolor = tempitem.col;
					Gfx.drawtile(tx + (i * gap) + 5, ty + 5, "terminal", tempitem.sprite);
					Gfx.resetcolor();
					
					if(tempitem.hasmultipleshots){
						Gfx.fillbox(tx + (i * gap) + 12 - 1, ty - 3 - 1, Text.width("x" + Inventory.inventory_num[i]) + 4, 10 + 2, Col.BLACK);
						Gfx.fillbox(tx + (i * gap) + 12, ty - 3, Text.width("x" + Inventory.inventory_num[i]) + 2, 10, Draw.shade(tempitem.col, 0.8));
						Text.display(tx + (i * gap) + 13, ty - 5, "x" + Inventory.inventory_num[i], Col.BLACK);
					}
				}
				
				var currentslotitem:ItemData = GameData.getitem(Inventory.inventory[Inventory.currentslot]);
				Text.align = Text.CENTER;
				if(currentslotitem.hasmultipleshots){
					Text.display(Gfx.screenwidth - 100, ty + 26, Inventory.inventory[Inventory.currentslot].toUpperCase() + " [x" + Inventory.inventory_num[Inventory.currentslot] +"]", currentslotitem.col);	
				}else {
					Text.display(Gfx.screenwidth - 100, ty + 26, Inventory.inventory[Inventory.currentslot].toUpperCase(), currentslotitem.col);		
				}
				
				Text.align = Text.LEFT;
			}
		}
		Text.align = Text.LEFT;
	}
	
	//Will eventually just remove these
	static function getline(_item:ItemData, n:Int):String{
		var desc:Array<String> = _item.description.split("\n");
		return desc[n];
	}
	
	static function getnumlines(_item:ItemData):Int {
		if (_item.description == "") return 0;
		var desc:Array<String> = _item.description.split("\n");
		return desc.length;
	}
}