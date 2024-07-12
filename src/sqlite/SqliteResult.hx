package sqlite;

class SqliteResult<T> {
    public var database:Database;
    public var data:T;
    public var lastID:Null<Int> = null;
    public var changes:Null<Int> = null;

    public function new(database:Database, data:T) {
        this.database = database;
        this.data = data;
    }
}