package modernversion;
	
import gamecontrol.Itemclass;

class Itemstats {
	public static function init() {
		itemindex = new Map<String, Int>();
		for (i in 0 ... 100) {
			encountered.push(0);
			itemlist.push(new Itemclass(i));
			itemindex.set(itemlist[i].name.toLowerCase(), i);
		}
	}
	
	public static function get(item:String):Itemclass {
	  return itemlist[itemindex.get(item.toLowerCase())];
	}
	
	public static function isthisnew(item:String):Bool {
		if (encountered[itemindex.get(item.toLowerCase())] == 0) {
		  return true;
		}
		return false;
	}
	
	public static function markseen(item:String) {
		encountered[itemindex.get(item.toLowerCase())] = 1;
	}
	
	public static var itemindex:Map<String, Int>;
	public static var itemlist:Array<Itemclass> = [];
	
	public static var encountered:Array<Int> = [];
}	