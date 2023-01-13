package sqlite.impl.nodejs;

import sqlite.externs.nodejs.Sqlite3;
import promises.Promise;
import logging.Logger;
import sqlite.externs.nodejs.Database as NativeDatabase;

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

            _nativeDB.get(sql, param, (error, row) -> {
                if (error != null) {
                    reject(new SqliteError(error.name, error.message));
                    return;
                }
                resolve(new SqliteResult(this, row));
            });
        });
    }

    public override function all(sql:String, ?param:Dynamic):Promise<SqliteResult<Array<Dynamic>>> {
        return new Promise((resolve, reject) -> {
            log.debug(sql, 'params=${param}');
            
            _nativeDB.all(sql, param, (error, rows) -> {
                if (error != null) {
                    reject(new SqliteError(error.name, error.message));
                    return;
                }
                resolve(new SqliteResult(this, rows));
            });
        });
    }
}