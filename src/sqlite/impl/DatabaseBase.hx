package sqlite.impl;

import promises.Promise;

class DatabaseBase {
    public var filename:String;
    public var openMode:Null<SqliteOpenMode>;

    public function new(filename:String, ?openMode:SqliteOpenMode) {
        this.filename = filename;
        this.openMode = openMode;
    }

    public function open():Promise<SqliteResult<Bool>> {
        return new Promise((resolve, reject) -> {
            reject(new SqliteError("not implemented", 'function "${Type.getClassName(Type.getClass(this))}::open" not implemented'));
        });
    }

    public function exec(sql:String):Promise<SqliteResult<Bool>> {
        return new Promise((resolve, reject) -> {
            reject(new SqliteError("not implemented", 'function "${Type.getClassName(Type.getClass(this))}::exec" not implemented'));
        });
    }

    public function get(sql:String, ?param:Dynamic):Promise<SqliteResult<Dynamic>> {
        return new Promise((resolve, reject) -> {
            reject(new SqliteError("not implemented", 'function "${Type.getClassName(Type.getClass(this))}::get" not implemented'));
        });
    }

    public function run(sql:String, ?param:Dynamic):Promise<SqliteResult<Dynamic>> {
        return new Promise((resolve, reject) -> {
            reject(new SqliteError("not implemented", 'function "${Type.getClassName(Type.getClass(this))}::run" not implemented'));
        });
    }

    public function all(sql:String, ?param:Dynamic):Promise<SqliteResult<Array<Dynamic>>> {
        return new Promise((resolve, reject) -> {
            reject(new SqliteError("not implemented", 'function "${Type.getClassName(Type.getClass(this))}::all" not implemented'));
        });
    }

    public function close():Promise<SqliteResult<Bool>> {
        return new Promise((resolve, reject) -> {
            reject(new SqliteError("not implemented", 'function "${Type.getClassName(Type.getClass(this))}::close" not implemented'));
        });
    }
}