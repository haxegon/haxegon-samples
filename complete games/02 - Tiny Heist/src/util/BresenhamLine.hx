package util;
	
class BresenhamLine {
	public static function init():Void {
		for(i in 0 ... 360){
			x.push(0);
			y.push(0);
			swap.push(0);
		}
		
		size = 0;
	}
	
	public static function traceline(x0:Int, y0:Int, x1:Int, y1:Int):Void {
		var startx1:Int = x1;
		var starty1:Int = y1;
		size = 0;
		var swapXY = Math.abs(y1 - y0) > Math.abs(x1 - x0);
		var tmp:Int;
		
		if (swapXY) {
			// swap x and y
			tmp = x0; x0 = y0; y0 = tmp; // swap x0 and y0
			tmp = x1; x1 = y1; y1 = tmp; // swap x1 and y1
		}
		
		if(x0 > x1) {
			// make sure x0 < x1
			tmp = x0; x0 = x1; x1 = tmp; // swap x0 and x1
			tmp = y0; y0 = y1; y1 = tmp; // swap y0 and y1
		}
		
		var deltax = x1 - x0;
		var deltay = Std.int( Math.abs(y1 - y0));
		var error = Std.int( deltax / 2 );
		var j = y0;
		var ystep = if ( y0 < y1 ) 1 else -1;
		
		if (swapXY) {
			// Y / X
			for (i in x0 ... x1 + 1 ) {
				x[size] = j;
				y[size] = i;
				size++;
				error -= deltay;
				if ( error < 0 ) {
					j = j + ystep;
					error = error + deltax;
				}
			}
		}else {
			// X / Y
			for ( i in x0 ... x1 + 1 ) {
				x[size] = i;
				y[size] = j;
				size++;
				
				error -= deltay;
				if ( error < 0 ) {
					j = j + ystep;
					error = error + deltax;
				}
			}
		}
		
		if (startx1 == x[0] && starty1 == y[0]) {
			for (i in 0 ... size) {
				swap[i] = x[i];
			}
			
			for (i in 0 ... size) {
				x[i] = swap[size-i - 1];
			}
			
			for (i in 0 ... size) {
				swap[i] = y[i];
			}
			
			for (i in 0 ... size) {
				y[i] = swap[size-i - 1];
			}
		}
	}
	
	public static function torad(a:Float):Float {
		//Convert angle a to rad
		return (((Math.PI * 2) - ((a * (Math.PI * 2)) / 360))) % (Math.PI * 2);
	}
	
	public static var x:Array<Int> = [];
	public static var y:Array<Int> = [];
	public static var swap:Array<Int> = [];
	public static var size:Int;
}