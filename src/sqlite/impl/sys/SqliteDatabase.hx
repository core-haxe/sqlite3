package sqlite.impl.sys;

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
                _connection.request(sql);
                resolve(new SqliteResult(this, true));
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
            var p = params.shift();
            var v:Any = switch (Type.typeof(p)) {
                case TClass(String):
                    _connection.quote(p);
                case TBool:
                    p == true ? "1" : "0";
                case TFloat:
                    Std.string(p);
                case TInt:
                    Std.string(p);
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
}