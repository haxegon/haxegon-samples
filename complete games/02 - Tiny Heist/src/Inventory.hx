import gamecontrol.Game;
import gamecontrol.Use;
import haxegon.Sound;
import entities.Obj;
import entities.Entclass;
import modernversion.Modern;
import modernversion.AIDirector;
import GameData.ItemData;
import PopUp.PopUpType;

class Inventory{
	public static var inventory:Array<String>;
	public static var inventory_num:Array<Int>;
	public static var inventoryslots:Int;
	
	public static var currentslot:Int = 0;
	public static var oldcurrentslot:Int = 0;
	
	static final initslots:Int = 3;
	
	public static function restart(){
		//Starting items
		inventory = [];
		inventory_num = [];
		inventoryslots = initslots;
		for (i in 0 ... inventoryslots + 1) {
		  inventory.push("");	
			inventory_num.push(0);
		}
		
		currentslot = 0;
		oldcurrentslot = 0;
	}
	
	public static function useitem(e:Entclass, itemname:String) {
		Use.useitem(Obj.entities.indexOf(e), itemname);
		inventory_num[currentslot]--;
		if (inventory_num[currentslot] <= 0) {
				inventory[currentslot] = "";
		}
		
		reorderinventory();
	}
	
	public static function swapinventory(a:Int, b:Int) {
		var temp:String = inventory[a];
		inventory[a] = inventory[b];
		inventory[b] = temp;
		
		var temp_amount:Int = inventory_num[a];
		inventory_num[a] = inventory_num[b];
		inventory_num[b] = temp_amount;
	}
	
	public static function reorderinventory() {
		//lazy bubble sort :3
	  if (inventory[2] != "" && inventory[1] == "") swapinventory(2, 1);
		if (inventory[1] != "" && inventory[0] == "") swapinventory(1, 0);
		if (inventory[2] != "" && inventory[1] == "") swapinventory(2, 1);
	}
	
	public static function slotsfree():Int {
	  var s:Int = 0;
		for (i in 0 ... inventoryslots) {
		  if (inventory[i] == "") s++;	
		}
		return s;
	}
	
	public static function giveitem(itemname:String) {
		//Check for outside world persistance
		if (AIDirector.outside) {
		  if (Modern.worldx - 50 == -1 && Modern.worldy - 50 == -1) {
				Modern.itemtopleft = "";
			}else if (Modern.worldx - 50 == 1 && Modern.worldy - 50 == -1) {
				Modern.itemtopright = "";
			}else if (Modern.worldx - 50 == -1 && Modern.worldy - 50 == 1) {
				Modern.itembottomleft = "";
			}else if (Modern.worldx - 50 == 1 && Modern.worldy - 50 == 1) {
				Modern.itembottomright = "";
			}
		}
		
		var freeslot:Int = -1;
		var emptyinventory:Bool = true;
		for (i in 0 ... inventoryslots) {
			if (inventory[i] != "") emptyinventory = false;
			if(freeslot == -1){
				if (inventory[i] == "")	{
					freeslot = i;
				}
			}
		}
		
		if (freeslot == -1) {
			//let's assume that bit just works for now
		  freeslot = inventoryslots;
			oldcurrentslot = currentslot;
		}
		
		var itemdata:ItemData = GameData.getitem(itemname);
		Sound.play("collectitem");	
		
		inventory[freeslot] = itemdata.name;
		//try out only getting 1 of everything
		if (itemdata.hasmultipleshots) {
			inventory_num[freeslot] = itemdata.numuses;
		}else{
			inventory_num[freeslot] = 1;
		}
		
		//If we had an empty inventory, choose the thing we just collected
		if (emptyinventory) currentslot = freeslot;
	  //trace("picked up " + e.name + ", " + e.para);	
		
		//Deal with full inventory here
		if (freeslot == inventoryslots) {
			PopUp.create(PopUpType.PICKUP_AND_DROP, itemdata);
		}else {
			PopUp.create(PopUpType.PICKUP, itemdata);
		}
	}
}