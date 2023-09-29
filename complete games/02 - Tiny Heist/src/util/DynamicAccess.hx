//Written by Justo Delgado Baudí
package util;

// similar to haxe.DynamicAccess with a few differences
abstract DynamicAccess(Dynamic) from Dynamic to Dynamic {
	public inline function new()
		this = {};

	public inline function get<T>(key:String, ?def:T):Null<T> {
		var r = Reflect.field(this, key);
		return r == null ? def : r;
	}

	@:arrayAccess
	inline function get_arrayaccess(key:String):Null<Dynamic> {
		return get(key);
	}

	@:arrayAccess
	public inline function set<T>(key:String, value:T):T {
		Reflect.setField(this, key, value);
		return value;
	}

	public inline function exists(key:String):Bool
		return Reflect.hasField(this, key);

	public inline function remove(key:String):Bool
		return Reflect.deleteField(this, key);

	public inline function keys():Array<String>
		return Reflect.fields(this);
}
