package sqlite.impl.sys;

import haxe.io.Bytes;
import promises.Promise;
import sys.db.Connection;
using StringTools;

class SqliteDatabase extends DatabaseBase {
    private var _connection:Connection;

    public override function open():Promise<SqliteResult<Bool>> {
        return new Promise((resolve, reject) -> {
            _connection = sys.db.Sqlite.open(this.filename);
            resolve(new SqliteResult(this, true));
        });
    }

    public override function exec(sql:String):Promise<SqliteResult<Bool>> {
        return new Promise((resolve, reject) -> {
            try {
                sql = prepareSQL(sql);
                var rs = _connection.request(sql);
                var result = new SqliteResult(this, true);
                if (rs != null) {
                    result.lastID = _connection.lastInsertId();
                    result.changes = rs.length;
                }
                resolve(result);
            } catch (e:Dynamic) {
                reject(new SqliteError("Error", "SQLITE_ERROR: " + e));
            }
        });
    }

    public override function get(sql:String, ?param:Dynamic):Promise<SqliteResult<Dynamic>> {
        return new Promise((resolve, reject) -> {
            try {
                sql = prepareSQL(sql, param);
                var rs = _connection.request(sql);
                if (rs.length == 0) {
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
                sql = prepareSQL(sql, param);
                var rs = _connection.request(sql);
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
                sql = prepareSQL(sql, param);
                var rs = _connection.request(sql);
                var data = null;
                if (sql.indexOf("INSERT ") != -1) {
                    var lastInsertedId = _connection.lastInsertId();
                    data = {
                        lastID: lastInsertedId
                    }
                }
                var result = new SqliteResult(this, data);
                if (rs != null) {
                    result.lastID = _connection.lastInsertId();
                    result.changes = rs.length;
                }
                resolve(result);
            } catch (e:Dynamic) {
                reject(new SqliteError("Error", "SQLITE_ERROR: " + e));
            }
        });
    }

    private function prepareSQL(sql:String, param:Dynamic = null):String {
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
        sql = r.map(sql, f -> {
            var p:Dynamic = params.shift();
            var v:Any = switch (Type.typeof(p)) {
                case TClass(String):
                    _connection.quote(p);
                case TBool:
                    p == true ? "1" : "0";
                case TFloat:
                    Std.string(p);
                case TInt:
                    Std.string(p);
                case TNull:
                    "NULL";
                case TClass(haxe.io.Bytes):                    
                    var bytes:Bytes = cast p;
                    "X'" + bytes.toHex() + "'";
                case _:
                    trace("UKNONWN:", Type.typeof(p));
                    p;
            }
            return v;
        });
        sql = sql.trim();
        if (!sql.endsWith(";")) {
            sql += ";";
        }
        return sql;
    }

    private var _closed:Bool = false;
    public override function close():Promise<SqliteResult<Bool>> {
        return new Promise((resolve, reject) -> {
            if (!_closed) {
                _connection.close();
                _closed = true;
            }
            resolve(new SqliteResult(this, true));
        });
    }
}