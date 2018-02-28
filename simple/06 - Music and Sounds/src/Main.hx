import haxegon.*;

class Main {
	var soundlist:Array<String>;
	var musiclist:Array<String>;
	var currentsoundeffect:Int;
	var currentsong:Int;
	var songplaying:Bool;
	
	function init() {
		Text.font = "pixel";
		Text.size = 4;
		
		//Load in a background image
		Gfx.loadimage("dontlookback");
		
		//Make an array of all the sound effects
		soundlist = [];
		soundlist.push("baddie_hurt");
		soundlist.push("big1");
		soundlist.push("big2");
		soundlist.push("cdie");
		soundlist.push("cgrowl");
		soundlist.push("cgrowl2");
		soundlist.push("cgrowl3");
		soundlist.push("eurydie");
		soundlist.push("euryfind");
		soundlist.push("fireball");
		soundlist.push("gunshot");
		soundlist.push("hadesdie");
		soundlist.push("hadeshurt");
		soundlist.push("hadesintro");
		soundlist.push("land_echo");
		soundlist.push("land_hard");
		soundlist.push("land_soft");
		soundlist.push("land_veryhard");
		soundlist.push("ledge");
		soundlist.push("nogo");
		soundlist.push("restart");
		soundlist.push("roar");
		soundlist.push("run_echo");
		soundlist.push("run_hard");
		soundlist.push("run_soft");
		soundlist.push("snakedie");
		soundlist.push("snakehiss");
		soundlist.push("stalic");
		
		currentsoundeffect = 0;
		
		//Do the same for the music
		musiclist = [];
		musiclist.push("music/01_descent");
		musiclist.push("music/02_assonance");
		musiclist.push("music/03_cornered");
		musiclist.push("music/04_theascent");
		musiclist.push("music/05_ascentchiptune");
		
		//Let's play the first song:
		Music.play("music/01_descent");
		songplaying = true;
		currentsong = 0;
		
		//Let's use 1 second of crossfade time when changing songs
		Music.crossfade = 1;
	}
	
  function update() {
		//Change the current sound when you press left and right.
		if (Input.justpressed(Key.LEFT)) {
			currentsoundeffect--;
			if (currentsoundeffect < 0) {
				currentsoundeffect = currentsoundeffect + soundlist.length;
			}
		}else if (Input.justpressed(Key.RIGHT)) {
			currentsoundeffect++;
			if (currentsoundeffect >= soundlist.length) {
				currentsoundeffect = currentsoundeffect - soundlist.length;
			}
		}
		
		//Change the current music when you press up and down.
		if (Input.justpressed(Key.UP)) {
			currentsong--;
			if (currentsong < 0) {
				currentsong = currentsong + musiclist.length;
			}
			if(songplaying) Music.play(musiclist[currentsong]);
		}else if (Input.justpressed(Key.DOWN)) {
			currentsong++;
			if (currentsong >= musiclist.length) {
				currentsong = currentsong - musiclist.length;
			}
			if(songplaying) Music.play(musiclist[currentsong]);
		}
		
		//Play the current sound effect when you press space.
		if (Input.justpressed(Key.SPACE)) {
			Sound.play(soundlist[currentsoundeffect]);
		}
		
		//Stop and start the song when you press enter.
		if (Input.justpressed(Key.ENTER)) {
			if (songplaying) {
				Music.stop();
				songplaying = false;
			}else {
				Music.play(musiclist[currentsong]);
				songplaying = true;
			}
		}
		
		//Draw the background image
		Gfx.drawimage(0, 0, "dontlookback");
		
		//Display some text showing the song that's playing, and the current sound effect.
		Text.align = Text.RIGHT;
		if (songplaying) {
		  Text.display(Gfx.screenwidth - 10, 5, "[NOW PLAYING] " + (currentsong + 1) + ": \"" + musiclist[currentsong] + "\"", 0xf19599);	
			Text.display(Gfx.screenwidth - 10, 30, "Press UP and DOWN to change.", 0xf19599);
			Text.display(Gfx.screenwidth - 10, 55, "Press ENTER to stop.", 0xf19599);
		}else {
			Text.display(Gfx.screenwidth - 10, 5, "[STOPPED] " + (currentsong + 1) + ": \"" + musiclist[currentsong] + "\"", 0xf19599);
			Text.display(Gfx.screenwidth - 10, 30, "Press UP and DOWN to change.", 0xf19599);
			Text.display(Gfx.screenwidth - 10, 55, "Press ENTER to play.", 0xf19599);
		}
		
		Text.align = Text.LEFT;
		Text.display(10, 5, (currentsoundeffect + 1) + ": \"" + soundlist[currentsoundeffect]+ "\"", 0xf19599);	
		Text.display(10, 30, "Press LEFT and RIGHT to change.", 0xf19599);
		Text.display(10, 55, "Press SPACE to play.", 0xf19599);
  }
}