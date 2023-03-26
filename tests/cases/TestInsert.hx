package cases;

import utest.Assert;
import sqlite.Database;
import utest.Async;
import cases.util.DBCreator;
import utest.Test;

class TestInsert extends Test {
    function setup(async:Async) {
        logging.LogManager.instance.addAdaptor(new logging.adaptors.ConsoleLogAdaptor({
            levels: [logging.LogLevel.Info, logging.LogLevel.Error]
        }));
        DBCreator.create().then(_ -> {
            async.done();
        });
    }

    function teardown(async:Async) {
        logging.LogManager.instance.clearAdaptors();
        DBCreator.delete();
        async.done();
    }
    
    function testBasicInsert(async:Async) {
        var db = new Database(DBCreator.filename);
        db.open().then(_ -> {
            return db.run("INSERT INTO Person (lastName, firstName, iconId) VALUES ('new last name', 'new first name', 1)");
        }).then(result -> {
            Assert.notNull(result);
            Assert.notNull(result.data);
            Assert.equals(5, result.data.lastID);
            db.close();
            async.done();
        }, error -> {
            trace("error", error);
        });
    }
}