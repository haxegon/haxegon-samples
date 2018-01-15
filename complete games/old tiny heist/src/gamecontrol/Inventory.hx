package gamecontrol;

import haxegon.*;

class Inventory {
	public static var USEABLE:Int = 0;
	public static var WEAPON:Int = 1;
	public static var GADGET:Int = 2;
	public static var TREASURE:Int = 3;
	public static var LETTER:Int = 4;
	public static var MAP:Int = 5;
	
	public static function init():Void {
		//Initilise inventory
		totalitems = 100;
		for (i in 0 ... totalitems) {
			itemlist.push(new Itemclass(i));
			inventory.push(0);
			inventory_count.push(0);
		}
		
		numitems = 0;
		
	  changedequippedweapon = false;
	  changedequippedgadget = false;
	  changedequippedarmor = false;
		
		/*
		giveitem("first aid kit", 3);
		giveitem(Item.LIGHTBULB, 3);
		giveitem("drill", 3);
		giveitem("dagger");
		giveitem("stick");
		giveitem("club");
		giveitem("nightstick");
		giveitem("tazer", 10);
		giveitem("tranquilizer", 5);
		giveitem("sniper rifle", 5);
		giveitem("pistol", 6);
		giveitem("knockout gas", 5);
		giveitem("tetter from terry");
		giveitem("valuable art");
		*/
	}
	
	//There are two item lists:
	//Itemlist means the master list of items, where all the items and thier stats are stored.
	//Inventory is an array of ints, containing numbers of items you currently hold. 
	
	/** Given the name of an item, find the itemlist number for it. */
	public static function getinventorynum(t:String):Int {
		t = t.toLowerCase();
		for (i in 0 ... numitems) {
			if (itemlist[inventory[i]].name.toLowerCase() == t) {
				return inventory[i];
			}
		}
		return -1;
	}
	
	/** Given the name of an item, find the item number for it from the COMPLETE item list. */
	public static function getitemlistnum(t:String):Int {
		t = t.toLowerCase();
		for (i in 0 ... totalitems) {
			if (itemlist[i].name.toLowerCase() == t) {
				return i;
			}
		}
		return -1;
	}
	
	/** Given the lettername of an item, find the item number for it from the COMPLETE item list. */
	public static function getitemlistnumfromletter(t:String):Int {
		t = t.toLowerCase();
		for (i in 0 ... totalitems) {
			if (itemlist[i].letter.toLowerCase() == t) {
				return i;
			}
		}
		return -1;
	}
	
	/** Given the name of an item, get its character */
	public static function getitemlistcharacter(t:String):String {
		var i:Int = getitemlistnum(t);
		if (i > -1) return itemlist[i].character;
		return "?";
	}
	
	/** Given the name of an item, get the amount of ammo it typically drops */
	public static function getitemlistamount(t:String):Int{
		var i:Int = getitemlistnum(t);
		if (i > -1) return itemlist[i].typical;
		return 1;
	}
	
	public static function sortinventory():Void {
		//Sort array order by item type (bubble)
		var changed:Bool = false;
		while (!changed){
			changed = true;
			for (j in 0 ... numitems - 1) {
				if (itemlist[inventory[j]].type > itemlist[inventory[j + 1]].type){
					var tmp:Int = inventory[j];
					inventory[j] = inventory[j + 1];
					inventory[j + 1] = tmp;
					
					tmp = inventory_count[j];
					inventory_count[j] = inventory_count[j + 1];
					inventory_count[j + 1] = tmp;
					
					changed = false;
				}
			}
		}
	}
	
	public static function setequippedweapon(t:String, showalert:Bool = true):Void {
		t = t.toLowerCase();
		oldequippedweapon = equippedweapon;
		equippedweapon = -1;
		if (t == "none") {
			equippedweapon = -1;
		}
		for (i in 0 ... numitems) {
			if (itemlist[inventory[i]].name.toLowerCase() == t) equippedweapon = inventory[i];
		}
		
		if (equippedweapon != -1 && equippedweapon != oldequippedweapon && showalert) changedequippedweapon = true;
	}
	
	public static function setequippedgadget(t:String, showalert:Bool = true):Void {
		t = t.toLowerCase();
		oldequippedgadget = equippedgadget;
		equippedgadget = -1;
		if (t == "none") {
			equippedgadget = -1;
		}
		for (i in 0 ... numitems) {
			if (itemlist[inventory[i]].name.toLowerCase() == t) equippedgadget = inventory[i];
		}
		
		if (equippedgadget != -1 && equippedgadget != oldequippedgadget && showalert) changedequippedgadget = true;
	}
	
	/** Destroy the letter with the name t */
	public static function destroyinventoryletter(t:String):Void {
		for (i in 0 ... numitems) {
			if (itemlist[inventory[i]].letter == t) {
				removeitemfrominventory(i);
			}
		}
	}
		
	/** Use item numbered t in the inventory! If it's a weapon on gadget, don't delete. */
	public static function useinventoryitem(t:Int):Void {
		for (i in 0 ... numitems) {
			if (inventory[i] == t) {
				inventory_count[i]--;
				if (itemlist[inventory[i]].type == Inventory.USEABLE ||
						itemlist[inventory[i]].type == Inventory.GADGET) {
					if (inventory_count[i] <= 0) {
						removeitemfrominventory(i);
					}
				}
			}
		}
	}
	
	/** Remove an item from an index location, pushing everything else back. */
	public static function removeitemfrominventory(index:Int):Void {
		for (i in index ... numitems) {
			inventory[i] = inventory[i + 1];
			inventory_count[i] = inventory_count[i + 1];
		}
		numitems--;
	}
	
	/** Give item named t from itemlist to inventory. Returns true if you already have some! */
	public static function giveitem(t:String, num:Int = 1):Bool {
		var found:Int = 0;
		t = t.toLowerCase();
		//Give player item number t
		if (numitems < totalitems) {
			for (i in 0 ... totalitems) {
				if (itemlist[i].name.toLowerCase() == t) {
					for (j in 0 ... numitems) {
						if (inventory[j] == i) {
							inventory_count[j]+=num;
							found = 1;
						}
					}
					if (found == 0) {
						inventory[numitems] = i;
						inventory_count[numitems] = num;
						numitems++;
					}
				}
			}
			
			sortinventory();
			if (found == 1) return true;
			return false;
		}
		return false;
	}
	
	/** Recreate the inventory menu, keeping your selection in place */
	public static function reloadinventory():Void {
		var oldmenulocation:Int = Menu.currentmenu;
		Menu.createmenu("inventory");
		Menu.currentmenu = oldmenulocation;
	}
	
	/** How much ammo/uses do you have left in your inventory for itemlist item t? */
	public static function getammo(t:Int):Int {
		for (i in 0 ... numitems) {
			if (inventory[i] == t) {
				return inventory_count[i];
			}
		}
		return 0;
	}
	
	
	//Inventory Stuff
	public static var itemlist:Array<Itemclass> = new Array<Itemclass>();
	public static var inventory:Array<Int> = new Array<Int>();
	public static var inventory_count:Array<Int> = new Array<Int>();
	public static var numitems:Int;
	public static var totalitems:Int;
	public static var oldequippedweapon:Int;
	public static var oldequippedarmor:Int;
	public static var oldequippedgadget:Int;
	public static var equippedweapon:Int;
	public static var equippedarmor:Int;
	public static var equippedgadget:Int;
	public static var currentletter:String;
	public static var changedequippedweapon:Bool;
	public static var changedequippedgadget:Bool;
	public static var changedequippedarmor:Bool;
	
	public static var useitemcountdown:Int = 0;
	public static var itemtouse:Int = 0;
}