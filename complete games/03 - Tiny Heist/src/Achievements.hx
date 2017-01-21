import haxegon.*;

/* A lightweight wrapper for site specific API stuff (kongregate/newgrounds) */
class Achievements {
	public static var alloweddomain:String = "terrycavanaghgames.com";
	public static var splashscreen:Bool = false;
	
	public static function sitelockpassed():Bool {
		var siteok:Bool = false;
		
		var domain:String = flash.Lib.current.stage.loaderInfo.url;
		var domain_parts:Array<String> = domain.split("://");
		var domain_first:Array<String> = domain_parts.length > 1 ? domain_parts[1].split("/") : domain_parts[0].split("/");
		var domain:String = domain_first[0];
		siteok = (domain.indexOf(alloweddomain) == domain.length - alloweddomain.length);
		#if !flash
			siteok = true;
		#end
		siteok = true;
		
		return siteok;
	}
	
  public static function init() {
		//Don't care about this unless we're on Kongregate or Newgrounds
	}
	
	//Recognised labels:
	//"exittower" - 1 if we leave the tower
	//"glitch" - 1 if we enter the glitch tower
	//"floor" - 1-16 for the floor we've just reached
	//"win" - 0-5 for our ending rank (higher ranks aren't recognised)
	public static function award(label:String, value:Int) {
		//Don't care about this unless we're on Kongregate or Newgrounds
		//trace("Achievements.award(\"" + label + "\", " + value + ");");
	}
}