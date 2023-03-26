package sqlite.impl.cpp;

import promises.Promise;
import sqlite.Sqlite;
import sqlite.SqliteDatabase as NativeDatabase;
import sqlite.SqliteStatement as NativeStatement;

class SqliteDatabase extends DatabaseBase {
    private var _nativeDB:NativeDatabase = null;

    public override function open():Promise<SqliteResult<Bool>> {
        return new Promise((resolve, reject) -> {
            _nativeDB = Sqlite.open(this.filename);
            resolve(new SqliteResult(this, true));
        });
    }

    public override function exec(sql:String):Promise<SqliteResult<Bool>> {
        return new Promise((resolve, reject) -> {
            try {
                if (_nativeDB == null) {
                    reject(new SqliteError("Error", "Database not open"));
                    return;
                }
                var stmt = prepareStatement(sql);
                stmt.executeStatement();
                resolve(new SqliteResult(this, true));
            } catch (e:Dynamic) {
                reject(new SqliteError("Error", "SQLITE_ERROR: " + e));
            }
        });
    }

    public override function get(sql:String, ?param:Dynamic):Promise<SqliteResult<Dynamic>> {
        return new Promise((resolve, reject) -> {
            try {
                if (_nativeDB == null) {
                    reject(new SqliteError("Error", "Database not open"));
                    return;
                }
                var stmt = prepareStatement(sql, param);
                var rs = stmt.executeQuery();
                if (!rs.hasNext()) {
                    resolve(new SqliteResult(this, null));
                    return;
                }

                resolve(new SqliteResult(this, rs.next()));
            } catch (e:Dynamic) {
                reject(new SqliteError("Error", "SQLITE_ERROR: " + e));
            }
        });
    }

    public override function all(sql:String, ?param:Dynamic):Promise<SqliteResult<Array<Dynamic>>> {
        return new Promise((resolve, reject) -> {
            try {
                if (_nativeDB == null) {
                    reject(new SqliteError("Error", "Database not open"));
                    return;
                }
                var stmt = prepareStatement(sql, param);
                var rs = stmt.executeQuery();
                var records:Array<Dynamic> = [];
                while (rs.hasNext()) {
                    records.push(rs.next());
                }
                resolve(new SqliteResult(this, records));
            } catch (e:Dynamic) {
                reject(new SqliteError("Error", "SQLITE_ERROR: " + e));
            }
        });
    }

    public override function run(sql:String, ?param:Dynamic):Promise<SqliteResult<Dynamic>> {
        return new Promise((resolve, reject) -> {
            try {
                if (_nativeDB == null) {
                    reject(new SqliteError("Error", "Database not open"));
                    return;
                }
                var stmt = prepareStatement(sql, param);
                stmt.executeStatement();
                if (sql.indexOf("INSERT ") != -1) {
                    var lastInsertedId = _nativeDB.lastInsertRowId();
                    resolve(new SqliteResult(this, {
                        lastID: lastInsertedId
                    }));
                } else {
                    resolve(new SqliteResult(this, null));
                }
            } catch (e:Dynamic) {
                reject(new SqliteError("Error", "SQLITE_ERROR: " + e));
            }
        });
    }

    private function prepareStatement(sql:String, param:Dynamic = null):NativeStatement {
        var stmt = _nativeDB.prepare(sql);

        var params = [];
        if (param != null) {
            params = switch (Type.typeof(param)) {
                case TClass(Array):
                    param;
                case _:
                    [param];
            }
        }

        var r = ~/\?/gm;
        var index = 1; // index is 1-based, nice... :/
        r.map(sql, f -> {
            var p:Any = params.shift();
            switch (Type.typeof(p)) {
                case TClass(String):
                    stmt.bindString(index, p);
                case TBool:
                    stmt.bindInt(index, p == true ? 1 : 0);
                case TFloat:
                    stmt.bindFloat(index, p);
                case TInt:
                    stmt.bindInt(index, p);
                case _:
                    trace("UKNONWN:", Type.typeof(p));
            }
            index++;
            return null;
        });

        return stmt;
    }

    public override function close():Promise<SqliteResult<Bool>> {
        return new Promise((resolve, reject) -> {
            _nativeDB.close();
            resolve(new SqliteResult(this, true));
        });
    }
}