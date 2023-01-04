package sqlite.externs.nodejs;

@:jsRequire("sqlite3")
extern class Sqlite3 {
	public static var OPEN_READONLY(default,never):Int;
	public static var OPEN_READWRITE(default,never):Int;
	public static var OPEN_CREATE(default,never):Int;
    public static function verbose():Sqlite3;
}