package visuals;

import gamecontrol.Game;
import haxegon.Gfx;
import haxegon.Text;
import haxegon.Col;
import modernversion.Modern;
import world.Localworld;
import visuals.MessageBox;
import visuals.Draw;
import GameData.ItemData;

class InventoryUi{
	public static var guibackingcolour:Int;
	
	public static function showitems() {
		var tx:Int = Gfx.screenwidth - (Inventory.inventoryslots * 28);
		var ty:Int = Gfx.screenheight - 25;
		
		guibackingcolour = Game.backgroundcolour;
		if (Game.messagedelay != 0) {
			guibackingcolour = MessageBox.messagecolback(Game.messagecol);
		}
		
		for (i in 0 ... Inventory.inventory.length) {
			if (Inventory.inventory[i] != "") {
				//Use brighter colours and draw a border
				Draw.roundfillrect(tx + (i * 28) - 2, ty - 1, 24 + 2, 24, Localworld.worldblock[Localworld.WALL].front_fog);
			}
			
			var currentitem:ItemData = GameData.getitem(Inventory.inventory[i]);
			
			if(currentitem != null){
				//trying out only getting 1 of everything, so disabling ammo display
				Draw.drawbubble(tx + (i * 28), ty, 22, 22, Draw.shade(currentitem.col, 0.8), Col.BLACK, Col.BLACK);
				Gfx.imagecolor = currentitem.col;
				Gfx.drawtile(tx + (i * 28) + 5, ty + 5, "terminal", currentitem.sprite);
				Gfx.resetcolor();
				
				if(currentitem.hasmultipleshots == true){
					Gfx.fillbox(tx + (i * 28) + 14 - 1, ty - 3 - 1, Text.width("x" + Inventory.inventory_num[i]) + 4, 10 + 2, Col.BLACK);
					Gfx.fillbox(tx + (i * 28) + 14, ty - 3, Text.width("x" + Inventory.inventory_num[i]) + 2, 10, Draw.shade(currentitem.col, 0.8));
					Text.display(tx + (i * 28) + 15, ty - 5, "x" + Inventory.inventory_num[i], Col.BLACK);
				}
			}else{
				Draw.drawbubble(tx + (i * 28), ty, 22, 22, 0x444444, Col.BLACK, Col.BLACK);
			}
			
			Text.display(tx + (i * 28) + 18, ty + 12, (i + 1) + "", 0xFFFFFF);
		}
		
		if (Game.messagedelay == 0) {
			Text.align = Text.RIGHT;
			var waitcol:Int = Col.rgb(220, 220, 220);
			if (Modern.waitflash > 0) {
				var waitflashamount:Int = Std.int(Math.min(220 + Modern.waitflash * 5, 255));
			  waitcol = Col.rgb(waitflashamount, waitflashamount, waitflashamount);
				Modern.waitflash--;
			}
			Text.display(Gfx.screenwidth - (Inventory.inventoryslots * 26) - 18, Gfx.screenheight - 14, "Z - Wait", waitcol);
			Text.align = Text.LEFT;
		}
	}
}