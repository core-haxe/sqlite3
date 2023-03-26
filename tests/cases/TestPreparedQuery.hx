package cases;

import sqlite.Database;
import utest.Assert;
import cases.util.DBCreator;
import utest.Async;
import utest.Test;

class TestPreparedQuery extends Test {
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
    
    function testBasicSelectWhere(async:Async) {
        var db = new Database(DBCreator.filename);
        db.open().then(_ -> {
            return db.all("SELECT * FROM Person WHERE personId = ?", 1);
        }).then(result -> {
            Assert.equals(1, result.data.length);

            Assert.equals(result.data[0].personId, 1);
            Assert.equals(result.data[0].firstName, "Ian");
            Assert.equals(result.data[0].lastName, "Harrigan");
            Assert.equals(result.data[0].iconId, 1);
    
            db.close();
            async.done();
        }, error -> {
            trace(error);
        });
    }

    function testBasicSelectWhereOr(async:Async) {
        var db = new Database(DBCreator.filename);
        db.open().then(_ -> {
            return db.all("SELECT * FROM Person WHERE personId = ? OR personId = ?", [1, 4]);
        }).then(result -> {
            Assert.equals(2, result.data.length);

            Assert.equals(result.data[0].personId, 1);
            Assert.equals(result.data[0].firstName, "Ian");
            Assert.equals(result.data[0].lastName, "Harrigan");
            Assert.equals(result.data[0].iconId, 1);
    
            Assert.equals(result.data[1].personId, 4);
            Assert.equals(result.data[1].firstName, "Jim");
            Assert.equals(result.data[1].lastName, "Parker");
            Assert.equals(result.data[1].iconId, 1);
        
            db.close();
            async.done();
        }, error -> {
            trace("error", error);
        });
    }

    function testBasicSelectWhereAnd(async:Async) {
        var db = new Database(DBCreator.filename);
        db.open().then(_ -> {
            return db.all("SELECT * FROM Person WHERE personId = ? AND firstName = ?", [1, "Ian"]);
        }).then(result -> {
            Assert.equals(1, result.data.length);

            Assert.equals(result.data[0].personId, 1);
            Assert.equals(result.data[0].firstName, "Ian");
            Assert.equals(result.data[0].lastName, "Harrigan");
            Assert.equals(result.data[0].iconId, 1);
        
            db.close();
            async.done();
        }, error -> {
            trace("error", error);
        });
    }
}