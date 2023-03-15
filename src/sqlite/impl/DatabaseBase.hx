package sqlite.impl;

import promises.Promise;

class DatabaseBase {
    public var filename:String;
    public var mode:Null<Int>;

    public function new(filename:String, ?mode:Int) {
        this.filename = filename;
        this.mode = mode;
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
}