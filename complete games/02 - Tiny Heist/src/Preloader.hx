package;

import openfl.display.*;
import openfl.geom.*;
import openfl.events.*;
import openfl.net.*;
/*Adding assets to a preloader:
After the imports add this line to your file:
@:bitmap("assets/img/background.png") class BackgroundBD extends BitmapData {}

Afterwards add the bitmapdata to the preloader as you would any other bitmap data.
var bg:Bitmap = new Bitmap(new BackgroundBD(800, 600));
addChildAt(bg, 0);
*/

class Preloader extends NMEPreloader{
	override public function new(){
		super();
		//Set game parameters here:
		//----------------
		// GRAPHICS :
		//----------------
		screenwidth = 384; screenheight = 240;    // Size of the screen for preloader
		stagewidth = 768; stageheight = 480;      // Size of the screen for stage
		backcol = RGB(0, 0, 0);
		frontcol = RGB(128, 128, 128);
		loadercol = RGB(196, 196, 196); 
		loadingbarwidth = 250;
		//----------------
		
		ct = new ColorTransform(0, 0, 0, 1, 255, 255, 255, 1); //Set to white			
		temprect = new Rectangle();
		
		tl = new Point(0, 0); tpoint = new Point(0, 0);
		
		backbuffer = new BitmapData(screenwidth, screenheight, false, 0x000000);
		screenbuffer = new BitmapData(screenwidth, screenheight, false, 0x000000);
		screen = new Bitmap(screenbuffer);
		screen.width = stagewidth;
		screen.height = stageheight;
		
		addChild(screen);  
		
		startgame = false;
	}
	
	public function RGB(red:Int, green:Int, blue:Int):Int {
		return (blue | (green << 8) | (red << 16));
	}
	
	override public function onLoaded() {
		if (contains(screen)) removeChild(screen);
		dispatchEvent(new Event(Event.COMPLETE));
	}

	public function fillrect(x:Int, y:Int, w:Int, h:Int, col:Int):Void {
		temprect.x = x; temprect.y = y; temprect.width = w; temprect.height = h;
		backbuffer.fillRect(temprect, col);
	}
	
	override public function onUpdate(bytesLoaded:Int, bytesTotal:Int){
		var p:Float = bytesLoaded / bytesTotal;	
		if (p >= 1) startgame = true;
		backbuffer.fillRect(backbuffer.rect, backcol);
		
		fillrect(Std.int((screenwidth/2) - (loadingbarwidth/2) - 2), Std.int((screenheight / 2) - 23), loadingbarwidth+4, 42, frontcol);
		fillrect(Std.int((screenwidth/2) - (loadingbarwidth/2)), Std.int((screenheight / 2) - 21), loadingbarwidth, 38, backcol);
		fillrect(Std.int((screenwidth/2) - (loadingbarwidth/2)) + 1, Std.int((screenheight / 2) - 21)+1, Std.int(p * (loadingbarwidth))-2, 38-2, loadercol);
		
		//Render
		screenbuffer.lock();
		screenbuffer.copyPixels(backbuffer, backbuffer.rect, tl, null, null, false);
		screenbuffer.unlock();
		
		backbuffer.lock();
		backbuffer.fillRect(backbuffer.rect, 0x000000);
		backbuffer.unlock();
		
		if (startgame) onLoaded();
	}
	
	public var screenwidth:Int;
	public var screenheight:Int;
	public var stagewidth:Int; 
	public var stageheight:Int;
	public var backcol:Int;
	public var frontcol:Int;
	public var loadercol:Int;
	public var loadingbarwidth:Int;
	
	public var buffer:BitmapData;
	public var backbuffer:BitmapData;
	public var screenbuffer:BitmapData;
	public var screen:Bitmap;
	
	public var temprect:Rectangle;
	
	public var startgame:Bool;
	
	public var tl:Point;
	public var tpoint:Point;
	public var ct:ColorTransform;
}