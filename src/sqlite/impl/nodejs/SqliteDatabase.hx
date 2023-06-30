package sqlite.impl.nodejs;

import haxe.io.Bytes;
import js.Node;
import js.Syntax;
import js.node.Buffer;
import js.node.console.Console;
import logging.Logger;
import promises.Promise;
import sqlite.externs.nodejs.Database as NativeDatabase;
import sqlite.externs.nodejs.Sqlite3;

class SqliteDatabase extends DatabaseBase {
    private var log:Logger = new Logger(SqliteDatabase);

    private var _nativeDB:NativeDatabase = null;

    public override function open():Promise<SqliteResult<Bool>> {
        return new Promise((resolve, reject) -> {
            // TODO: mode
            _nativeDB = new NativeDatabase(this.filename, Sqlite3.OPEN_READWRITE, error -> {
                if (error != null) {
                    reject(new SqliteError(error.name, error.message));
                    return;
                }
                _nativeDB.run("PRAGMA journal_mode = WAL;");
                resolve(new SqliteResult(this, true));
            });
        });
    }

    public override function exec(sql:String):Promise<SqliteResult<Bool>> {
        return new Promise((resolve, reject) -> {
            log.debug(sql);

            _nativeDB.exec(sql, error -> {
                if (error != null) {
                    reject(new SqliteError(error.name, error.message));
                    return;
                }
                resolve(new SqliteResult(this, true));
            });
        });
    }

    public override function get(sql:String, ?param:Dynamic):Promise<SqliteResult<Dynamic>> {
        return new Promise((resolve, reject) -> {
            log.debug(sql, 'params=${param}');

            if (param != null) {
                param = convertParamsBytesToBuffers(param);
            }
            _nativeDB.get(sql, param, (error, row) -> {
                if (error != null) {
                    reject(new SqliteError(error.name, error.message));
                    return;
                }
                // we want to convert any js.node.Buffer's into haxe.io.Bytes
                convertNativeBuffersToBytes(row);
                resolve(new SqliteResult(this, row));
            });
        });
    }

    public override function run(sql:String, ?param:Dynamic):Promise<SqliteResult<Dynamic>> {
        return new Promise((resolve, reject) -> {
            log.debug(sql, 'params=${param}');

            if (param != null) {
                param = convertParamsBytesToBuffers(param);
            }
            _nativeDB.run(sql, param, (error) -> {
                var insertData = Syntax.code("this");
                if (error != null) {
                    reject(new SqliteError(error.name, error.message));
                    return;
                }
                resolve(new SqliteResult(this, insertData));
            });
        });
    }

    public override function all(sql:String, ?param:Dynamic):Promise<SqliteResult<Array<Dynamic>>> {
        return new Promise((resolve, reject) -> {
            log.debug(sql, 'params=${param}');
            
            if (param != null) {
                param = convertParamsBytesToBuffers(param);
            }
            _nativeDB.all(sql, param, (error, rows) -> {
                if (error != null) {
                    reject(new SqliteError(error.name, error.message));
                    return;
                }
                for (row in rows) {
                    // we want to convert any js.node.Buffer's into haxe.io.Bytes
                    convertNativeBuffersToBytes(row);
                }
                resolve(new SqliteResult(this, rows));
            });
        });
    }

    private var _closed:Bool = false;
    public override function close():Promise<SqliteResult<Bool>> {
        return new Promise((resolve, reject) -> {
            if (!_closed) {
                _nativeDB.close();
                _closed = true;
            }
            resolve(new SqliteResult(this, true));
        });
    }

    private function convertNativeBuffersToBytes(row:Dynamic) {
        for (column in Reflect.fields(row)) {
            var value = Reflect.field(row, column);
            if ((value is Buffer)) {
                var buffer:Buffer = cast value;
                Reflect.setField(row, column, buffer.hxToBytes());
            }
        }
    }

    private function convertParamsBytesToBuffers(param:Dynamic) {
        if (param == null) {
            return null;
        }

        if (param is Array) {
            var params:Array<Dynamic> = param;
            var n = 0;
            for (p in params) {
                if ((p is Bytes)) {
                    var buffer:Buffer = Buffer.hxFromBytes(cast p);
                    params[n] = buffer;
                }
                n++;
            }
        } else if ((param is Bytes)) {
            param = Buffer.hxFromBytes(cast param);
        }

        return param;
    }
}