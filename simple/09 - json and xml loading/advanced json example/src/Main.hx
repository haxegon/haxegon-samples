import haxegon.*;

class Main {
	var jsonfile:Dynamic;
	
	function new(){
		Gfx.resizescreen(0, 0);
		Text.setfont("opensans", 32);
		
		//Ok, this time, let's load in a json file with some tricky aspects to it
		jsonfile = Data.loadjson("trickyfruit");
		
		//Sometimes json files have variables with matching names. In those cases,
		//an array is created. See the advanced xml example for an example of this.
	}
	
	function update() {
		Text.display(0, 0, "Contents of trickyfruit.json:");
		
		//We can use the generated "_fields" property to get a list of all variables: 
		var ypos:Int = 60;
		Text.display(40, ypos, "Getting a list of fields from jsonfile.fruits:", 0x8888CC); ypos += 40;
		Text.display(40, ypos, jsonfile.fruits._fields); ypos += 40;
		//Since _fields is an array, so we can loop over it like this:
		for (i in 0 ... jsonfile.fruits._fields.length){
			Text.display(60, ypos, jsonfile.fruits._fields[i]); ypos += 40;
		}
		
		//If we don't know the name of a field, we can use Haxe's "Reflect" class to check
		//the values of fields with any given string name.
		
		//For example, say we didn't know that "jsonfile.fruits" had a field "apple".
		//We could check if that field exists:
		ypos += 40;
		Text.display(40, ypos, "Checking if jsonfile.fruits has a field 'apple':", 0x8888CC); ypos += 40;
		if (Reflect.hasField(jsonfile.fruits, "apple")){
			//And if it does, we can read values from it like this:
			var size:String = Reflect.getProperty(jsonfile.fruits, "apple").size;
			//Or like this!
			var color:String = Reflect.getProperty(jsonfile.fruits.apple, "color");
			
			Text.display(60, ypos, "Apple: " + size + ", " + color); ypos += 40;
		}
		
		//This is also useful to read fields with invalid names. For example, trickyfruit.json
		//contains a field with the name "4". We can't call a variable 4 in Haxe, but we can
		//read that field name like so:
		ypos += 40;
		Text.display(40, ypos, "Reading a field with an invalid name, jsonfile.4:", 0x8888CC); ypos += 40;
		Text.display(40, ypos, Reflect.getProperty(jsonfile, "4")); ypos += 40;
		
		//We can also use this to read fields with other invalid characters, like
		//"node:data-text" - variable names in haxe can't contain : or - characters.
		ypos += 40;
		Text.display(40, ypos, "Reading a field with an invalid name, jsonfile.node:data-text:", 0x8888CC); ypos += 40;
		Text.display(40, ypos, Reflect.getProperty(jsonfile, "node:data-text")); ypos += 40;
		
		//However, Haxegon will actually create a copy of this variable with a sanitized name:
		//Invalid characters are replaced with underscores.
		ypos += 40;
		Text.display(40, ypos, "Reading a field with a sanitized invalid name, jsonfile.node_data_text:", 0x8888CC); ypos += 40;
		Text.display(40, ypos, jsonfile.node_data_text); ypos += 40;
	}
}
