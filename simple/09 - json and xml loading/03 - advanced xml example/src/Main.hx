import haxegon.*;

class Main {
	var xmlfile:Dynamic;
	
	function init(){
		Gfx.resizescreen(0, 0);
		Text.setfont("opensans", 32);
		
		//Data.loadxml loads an xml file into a Dynamic object
		xmlfile = Data.loadxml("books");
		
		//Just like Data.loadjson, xml files occasionally have fields with names
		//that are not valid. See the advanced json example for an example of this.
	}
	
	function update() {
		Text.display(0, 0, "Some contents of books.xml:");
		Text.display(0, 40, "Press left and right to change book", 0xCC8888);
		
		//Because there are multiple "book" tags, an array is created.
		Text.display(20, 120, xmlfile.bookstore.book[booknum]._fields);
		Text.display(20, 160, xmlfile.bookstore.book[booknum].category);
		Text.display(20, 200, xmlfile.bookstore.book[booknum].title._text);
		Text.display(20, 240, xmlfile.bookstore.book[booknum].author);
		Text.display(20, 280, xmlfile.bookstore.book[booknum].year);
		Text.display(20, 320, xmlfile.bookstore.book[booknum].price);
		
		if (Input.justpressed(Key.LEFT)){
			booknum--;
		}else if (Input.justpressed(Key.RIGHT)){
			booknum++;
		}
		
		booknum = Std.int(Geom.clamp(booknum, 0, xmlfile.bookstore.book.length - 1));
	}
	
	var booknum:Int = 0;
}
