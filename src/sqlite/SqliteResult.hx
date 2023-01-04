package sqlite;

class SqliteResult<T> {
    public var database:Database;
    public var data:T;

    public function new(database:Database, data:T) {
        this.database = database;
        this.data = data;
    }
}