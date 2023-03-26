package cases;

import sqlite.Database;
import utest.Assert;
import cases.util.DBCreator;
import utest.Async;
import utest.Test;

class TestQuery extends Test {
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
    
    function testBasicSelect(async:Async) {
        var db = new Database(DBCreator.filename);
        db.open().then(_ -> {
            return db.all("SELECT * FROM Person");
        }).then(result -> {
            Assert.equals(4, result.data.length);

            Assert.equals(result.data[0].personId, 1);
            Assert.equals(result.data[0].firstName, "Ian");
            Assert.equals(result.data[0].lastName, "Harrigan");
            Assert.equals(result.data[0].iconId, 1);
    
            Assert.equals(result.data[2].personId, 3);
            Assert.equals(result.data[2].firstName, "Tim");
            Assert.equals(result.data[2].lastName, "Mallot");
            Assert.equals(result.data[2].iconId, 2);
    
            db.close();
            async.done();
        }, error -> {
            trace("error", error);
        });
    }

    function testBasicSelectOne(async:Async) {
        var db = new Database(DBCreator.filename);
        db.open().then(_ -> {
            return db.get("SELECT * FROM Person");
        }).then(result -> {
            Assert.equals(result.data.personId, 1);
            Assert.equals(result.data.firstName, "Ian");
            Assert.equals(result.data.lastName, "Harrigan");
            Assert.equals(result.data.iconId, 1);
    
            db.close();
            async.done();
        }, error -> {
            trace("error", error);
        });
    }

    function testBasicSelectWhere(async:Async) {
        var db = new Database(DBCreator.filename);
        db.open().then(_ -> {
            return db.all("SELECT * FROM Person WHERE personId = 1");
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

    function testBasicSelectWhereOr(async:Async) {
        var db = new Database(DBCreator.filename);
        db.open().then(_ -> {
            return db.all("SELECT * FROM Person WHERE personId = 1 OR personId = 4");
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
            return db.all("SELECT * FROM Person WHERE personId = 1 AND firstName = 'Ian'");
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