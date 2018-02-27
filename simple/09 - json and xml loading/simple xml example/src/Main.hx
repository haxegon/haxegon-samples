import haxegon.*;

class Main {
	var xmlfile:Dynamic;
	
	function new(){
		Gfx.resizescreen(0, 0);
		Text.setfont("opensans", 32);
		
		//Data.loadxml loads an xml file into a Dynamic object
		xmlfile = Data.loadxml("note");
	}
	
	function update() {
		Text.display(0, 0, "Contents of note.xml:");
		
		//The fields of the object are populated with the fields of the xml file, like this:
		//<to>Tove</to>
		//<from>Jani</from>
		Text.display(20, 60, "To: " + xmlfile.note.to);
		Text.display(20, 100, "From: " + xmlfile.note.from);
		
		//Parameters in xml tags are loaded like this
		//<heading subject="Reminder" date="27/02/2018"></heading>
		Text.display(20, 180, "Heading:Date: " + xmlfile.note.heading.date);
		Text.display(20, 220, "Heading:Subject: " + xmlfile.note.heading.subject);
		
		//Sometimes, in XML files, you get both parameters and text:
    //<body font="Arial">Don't forget me this weekend!</body>
		Text.display(20, 300, "Body: " + xmlfile.note.body);
		
		//In those cases, you can access the contents of the tag with the _text variable.
		Text.display(20, 380, "Body:Font: " + xmlfile.note.body.font);
		Text.display(20, 420, "Body (contents): " + xmlfile.note.body._text);
	}
}
