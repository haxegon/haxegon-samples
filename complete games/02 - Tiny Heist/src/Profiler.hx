import haxegon.*;

@:access(haxegon.Core)
@:access(haxegon.Gfx)
class Profiler {
	public static var active:Bool = false;
	public static function init() {
	  active = true;
		starttime = now();
		
		framesthissecond = 0;
		fps = -1;
		lastframes = [];
		averageframetime = [];
		maxframetime = [];
		minframetime = [];
		frametime = [];
		
		for(i in 0 ... 3) {
			lastframes.push([]);	
			averageframetime.push(-1);
			maxframetime.push(-1);
			minframetime.push(-1);
			frametime.push(0);
		}
		
		started = 2;
		
		Core.showstats = true;
		Core.extend_startframe(startframefunction);
	}
	
	public static function startframefunction() {
		Profiler.startframe(Profiler.PROFILE_MAIN);	
	}
	
	public static function callafterframe() {
		Profiler.update();
		Profiler.framesthissecond++;
		Profiler.endframe(Profiler.PROFILE_MAIN);
	}
	
	inline public static function now():Int {
		return flash.Lib.getTimer();
	}
	
	public static function startframe(f:Int) {
	  if (!active) return;
		
		frametime[f] = now();
	}
	
	public static function endframe(f:Int) {
	  if (!active) return;
		
		frametime[f] = now() - frametime[f];
		
		if (lastframes[f].length < 30) {
		  lastframes[f].push(frametime[f]);	
		}else {
			lastframes[f].push(frametime[f]);
			maxframetime[f] = -1;
			minframetime[f] = 99999999;
			for (i in 0 ... 30) {
				frametime[f] = lastframes[f][lastframes[f].length - 1 - i];
			  averageframetime[f] += frametime[f];
				if (frametime[f] > maxframetime[f]) maxframetime[f] = frametime[f];
				if (frametime[f] < minframetime[f]) minframetime[f] = frametime[f];
			}
			averageframetime[f] = Std.int(averageframetime[f] / 30);
		}
	}
	
	public static function update() {
	  if (!active) return;
		
		Text.align(Text.LEFT);
		if (started == 0){
			if (now() - starttime > 1000) {
				fps = framesthissecond;
				framesthissecond = 0;
				starttime = now();
			}
			
			ypos = 134;
			Gfx.fillbox(0, ypos, graphwidth, 240 - ypos, Col.BLACK);
			
			if (averageframetime[PROFILE_MAIN] > -1) {
			  //Draw graph!
				Gfx.drawline(0, ypos + 24, graphwidth, ypos + 24, 0xCCCCCC);
				Gfx.drawline(0, ypos + 40, graphwidth, ypos + 40, 0xCCCCCC);
				for (j in 0 ... graphwidth) {
				  if (lastframes[PROFILE_MAIN].length - graphwidth + j >= 0) {
						graphy = Std.int(lastframes[PROFILE_MAIN][lastframes[PROFILE_MAIN].length - graphwidth + j] / 2);
						if (graphy > 40) {
							Gfx.fillbox(j, ypos, 1, 1, Col.YELLOW);
						}else {
							Gfx.fillbox(j, ypos + 40 - graphy, 1, 1, Col.YELLOW);
						}
				  }
				}
			}
			ypos += 44;
			if(fps != -1){
				Text.display(5, ypos, "FPS: " + fps, (fps <= 28)?Col.ORANGE:0xFFFFFF);
				if(averageframetime[PROFILE_MAIN] > -1){
					ypos += 12;
					if (averageframetime[PROFILE_MAIN] <= 1) {
						Text.display(5, ypos, "<1ms per frame", 0xCCCCCC);
					}else{
						Text.display(5, ypos, averageframetime[PROFILE_MAIN] + "ms per frame", (averageframetime[PROFILE_MAIN] >= 32)?Col.ORANGE:0xCCCCCC);
					}
					ypos += 12;
					Text.display(5, ypos, "min: " + minframetime[PROFILE_MAIN] + ", max: " + maxframetime[PROFILE_MAIN], 0xCCCCCC);
				}
				if(averageframetime[PROFILE_LOGIC] > -1){
					ypos += 12;
					if (averageframetime[PROFILE_LOGIC] <= 1) {
						Text.display(5, ypos, "logic: <1ms, (" + minframetime[PROFILE_LOGIC] + "ms - " +  maxframetime[PROFILE_LOGIC] + "ms)", 0x888888);
					}else{
						Text.display(5, ypos, "logic: " + averageframetime[PROFILE_LOGIC] + "ms, (" + minframetime[PROFILE_LOGIC] + "ms - " +  maxframetime[PROFILE_LOGIC] + "ms)", (averageframetime[PROFILE_LOGIC] >= 32)?Col.ORANGE:0x888888);
					}
				}
				if(averageframetime[PROFILE_RENDER] > -1){
					ypos += 12;
					if (averageframetime[PROFILE_RENDER] <= 1) {
						Text.display(5, ypos, "draw: <1ms, (" + minframetime[PROFILE_RENDER] + "ms - " +  maxframetime[PROFILE_RENDER] + "ms)", 0x888888);
					}else{
						Text.display(5, ypos, "draw: " + averageframetime[PROFILE_RENDER] + "ms, (" + minframetime[PROFILE_RENDER] + "ms - " +  maxframetime[PROFILE_RENDER] + "ms)", (averageframetime[PROFILE_RENDER] >= 32)?Col.ORANGE:0x888888);
					}
				}
			}
		}else if (started == 2) {
		  if (now() - starttime > 5000) {
				started = 1;
				framesthissecond = 0;
				starttime = now();
			}
			Gfx.fillbox(0, 225, graphwidth, 30, Col.BLACK);
			Text.display(5, 226, "starting profiler...", 0xCCCCCC);
		}else if (started == 1) {
			if (now() - starttime > 1000) {
				fps = framesthissecond;
				framesthissecond = 0;
				starttime = now();
				started = 0;
			}
			
			Gfx.fillbox(0, 225, graphwidth, 30, Col.BLACK);
			Text.display(5, 226, "starting profiler...", 0xCCCCCC);
		}
	}
	
	public static var PROFILE_MAIN:Int = 0;
	public static var PROFILE_RENDER:Int = 1;
	public static var PROFILE_LOGIC:Int = 2;
	
	public static var started:Int;
	
	public static var fps:Int;
	public static var framesthissecond:Int;
	
	public static var frametime:Array<Int>;
	public static var averageframetime:Array<Int>;
	public static var maxframetime:Array<Int>;
	public static var minframetime:Array<Int>;
	public static var lastframes:Array<Array<Int>>;
	
	public static var graphwidth:Int = 120;
	public static var graphy:Int;
	public static var ypos:Int;
	
	public static var starttime:Int;
}	