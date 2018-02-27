import haxegon.*;

class Main {
	var jsonfile:Dynamic;
	
	function new(){
		Gfx.resizescreen(0, 0);
		Text.setfont("opensans", 32);
		
		//Data.loadjson loads a json file into a Dynamic object
		jsonfile = Data.loadjson("fruit");
	}
	
	function update() {
		Text.display(0, 0, "Contents of fruit.json:");
		
		//The fields of the object are populated with the fields
		//of the json file, like this:
		Text.display(40, 60, "Apple: " + jsonfile.fruits.apple);
		Text.display(60, 100, "Size: " + jsonfile.fruits.apple.size);
		Text.display(60, 140, "Color: " + jsonfile.fruits.apple.color);
		
		Text.display(40, 200, "Banana: " + jsonfile.fruits.banana);
		Text.display(60, 240, "Size: " + jsonfile.fruits.banana.size);
		Text.display(60, 280, "Color: " + jsonfile.fruits.banana.color);
		
		Text.display(40, 340, "Raspberry: " + jsonfile.fruits.raspberry);
		Text.display(60, 380, "Size: " + jsonfile.fruits.raspberry.size);
		Text.display(60, 420, "Color: " + jsonfile.fruits.raspberry.color);
		
		Text.display(40, 480, "Pineapple: " + jsonfile.fruits.pineapple);
		Text.display(60, 520, "Size: " + jsonfile.fruits.pineapple.size);
		Text.display(60, 560, "Color: " + jsonfile.fruits.pineapple.color);
	}
}
