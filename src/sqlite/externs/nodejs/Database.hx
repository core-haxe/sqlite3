package sqlite.externs.nodejs;

import haxe.extern.Rest;
import js.lib.Error;

@:jsRequire("sqlite3", "Database")
extern class Database {
    public static inline var MEMORY = ":memory:";
    public static inline var ANONYMOUS = "";

    public function new(filename:String, ?mode:Int, ?callback:Error->Void);

	/**
		Runs the SQL query with the specified parameters and calls the callback afterwards.
	**/
	@:overload(function(sql:String, ?param:Rest<Dynamic>, ?callback:Error->Void):Database {})
	@:overload(function(sql:String, ?param:Array<Dynamic>, ?callback:Error->Void):Database {})
        public function run(sql:String, ?param:Dynamic, ?callback:Error->Void):Database;

	/**
		Runs the SQL query with the specified parameters and calls the callback with the first result row afterwards.
	**/
	public function get(sql:String, ?param:Dynamic, ?callback:Error->Dynamic->Void):Database;

	/**
		Runs the SQL query with the specified parameters and calls the callback with all result rows afterwards.
	**/
	public function all(sql:String, ?param:Dynamic, ?callback:Error->Array<Dynamic>->Void):Database;

	/**
		Runs the SQL query with the specified parameters and calls the callback once for each result row.
	**/
    public function each(sql:String, ?param:Dynamic, ?callback:Error->Dynamic->Void, ?complete:Error->Int->Void):Database;

	/**
		Runs all SQL queries in the supplied string.
		No result rows are retrieved.
	**/
	public function exec(sql:String, ?callback:Error->Void ):Database;

	/**
		Prepares the SQL statement and optionally binds the specified parameters and calls the callback when done.
	**/
	public function prepare(sql:String, ?param:Dynamic, ?callback:Error->Void ):Statement;

}