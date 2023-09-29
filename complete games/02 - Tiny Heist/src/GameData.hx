import openfl.Assets;

typedef ItemData = {
	var name:String;
	var description:String;
	var numuses:Int;
	var hasmultipleshots:Bool;
	var sprite:Int;
	var col:Int;
}

class GameData{
		public static function init(){
			loaditemdata();
    }
		
		public static function loaditemdata(){
			itemlist = [];
			
			itemlist.push({
					name: "First Aid Kit",
					description: "Restores some of your health.",
					hasmultipleshots: false, numuses: 1,
					sprite: 6, col: 0x80e180
			});
			
			itemlist.push({
					name: "Time Stopper",
					description: "Stops time.\n\nIf you attack someone or use a gadget while\ntime is stopped, time will start again!",
					hasmultipleshots: false, numuses: 1,
					sprite: 13, col: 0x8080ff
			});
			
			itemlist.push({
					name: "Pistol",
					description: "Multiple uses. Very noisy, but effective!\n\nDestroys whatever it aims at, but alerts\neverything on the current floor to you.",
					hasmultipleshots: true, numuses: 4,
					sprite: 21, col: 0xe18080
			});
			
			itemlist.push({
					name: "Signal Jammer",
					description: "Temporarily disable nearby cameras and sentinels.",
					hasmultipleshots: false, numuses: 1,
					sprite: 5, col: 0x8c8cff 
			});
			
			itemlist.push({
					name: "Cardboard Box",
					description: "Hide from enemies! You might not be able to\nsee where you're going when you wear it, though.",
					hasmultipleshots: false, numuses: 1,
					sprite: 8, col: 0xc0c0c0
			});
			
			itemlist.push({
					name: "Skateboard",
					description: "Skate forward until you bump into something!",
					hasmultipleshots: true, numuses: 3,
					sprite: 100, col: 0x60ff60 
			});
			
			itemlist.push({
					name: "Lightbulb",
					description: "Switch on the lights so you can see properly!",
					hasmultipleshots: false, numuses: 1,
					sprite: 4, col: 0xffff18
			});
			
			itemlist.push({
					name: "Drill",
					description: "Make a hole in a wall big enough to walk through.\nDrills all the way through to the other side.",
					hasmultipleshots: false, numuses: 1,
					sprite: 7, col: 0xffffff 
			});
			
			itemlist.push({
					name: "Fire Extinguisher",
					description: "Puts out fires! Also stuns whatever\nit hits - cameras, robots, everything.",
					hasmultipleshots: true, numuses: 6,
					sprite: 41, col: 0xe18080
			});
			
			itemlist.push({
					name: "Matchstick",
					description: "Probably completely safe to use.",
					hasmultipleshots: false, numuses: 1,
					sprite: 37, col: 0xe6883c
			});
			
			itemlist.push({
					name: "Sword",
					description: "Deadly sword slices through enemies.\n\nWhen used, dash forwards until you hit a\nwall, and destroy everything in your path.",
					hasmultipleshots: false, numuses: 1,
					sprite: 14, col: 0xffffff
			});
			
			itemlist.push({
					name: "Leaf Blower",
					description: "Shoots a powerful gust of air that\nknocks back anything chasing you.",
					hasmultipleshots: false, numuses: 1,
					sprite: 16 , col: 0x60ff60
			});
			
			itemlist.push({
					name: "Teleporter",
					description: "Miniture teleporting device!\n\nTeleports you somewhere nearby.\nCan be used multiple times!",
					hasmultipleshots: true, numuses: 3,
					sprite: 162, col: 0x57f1ee
			});
			
			itemlist.push({
					name: "Portable Door",
					description: "Can be placed in walls.",
					hasmultipleshots: false, numuses: 1,
					sprite: 10, col: 0xa04c14
			});
			
			itemlist.push({
					name: "Banana",
					description: "Delicious Banana! Be careful to properly dispose\nof the banana peel afterwards, or pursuing\nguards may slip on it.",
					hasmultipleshots: false, numuses: 1,
					sprite: 160, col: 0xe9e573
			});
			
			itemlist.push({
					name: "Bomb",
					description: "Explodes, destroying everything up to three\nsquares away.\n\nAnything left after you use this is alerted!",
					hasmultipleshots: false, numuses: 1,
					sprite: 163, col: 0x7dc8f9
			});
			
			itemlist.push({
					name: "Helix Wing",
					description: "Summons a helicopter to immediately pick you up\nand bring you home. Can be used from anywhere.\n\nWorth 10 gems at the end if you don't use it...",
					hasmultipleshots: false, numuses: 1,
					sprite: 31, col: 0xe297f9
			});
			
			itemlist.push({
					name: "Error",
					description: "",
					hasmultipleshots: false, numuses: 1,
					sprite: 59, col: 0xe9e573
			});
		}
		
		public static function getitem(name:String):ItemData {
			for (item in itemlist){
				if (item.name.toLowerCase() == name.toLowerCase()) return item;
			}
			
			return null;
		}
		
		public static var itemlist:Array<ItemData>;
}