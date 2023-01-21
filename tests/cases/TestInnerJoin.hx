package cases;

import sqlite.Database;
import utest.Assert;
import cases.util.DBCreator;
import utest.Async;
import utest.Test;

class TestInnerJoin extends Test {
    function setupClass(async:Async) {
        logging.LogManager.instance.addAdaptor(new logging.adaptors.ConsoleLogAdaptor({
            levels: [logging.LogLevel.Info, logging.LogLevel.Error]
        }));
        DBCreator.create().then(_ -> {
            async.done();
        });
    }

    function teardownClass(async:Async) {
        logging.LogManager.instance.clearAdaptors();
        DBCreator.delete();
        async.done();
    }

    function testBasicInnerJoin(async:Async) {
        var db = new Database("persons.db");
        db.open().then(_ -> {
            // note: sys.db throws exception when result has the same fields (fun!), so we have explicitly list them
            return db.all("SELECT Person.personId, Person.firstName, Person.lastName, Person.iconId, Icon.path FROM Person
                INNER JOIN Icon ON Person.iconId = Icon.iconId
            ");
        }).then(result -> {
            Assert.equals(4, result.data.length);

            Assert.equals(result.data[0].personId, 1);
            Assert.equals(result.data[0].firstName, "Ian");
            Assert.equals(result.data[0].lastName, "Harrigan");
            Assert.equals(result.data[0].iconId, 1);
            Assert.equals(result.data[0].path, "/somepath/icon1.png");
    
            Assert.equals(result.data[2].personId, 3);
            Assert.equals(result.data[2].firstName, "Tim");
            Assert.equals(result.data[2].lastName, "Mallot");
            Assert.equals(result.data[2].iconId, 2);
            Assert.equals(result.data[2].path, "/somepath/icon2.png");
    
            async.done();
        });
    }

    function testBasicInnerJoinWhere(async:Async) {
        var db = new Database("persons.db");
        db.open().then(_ -> {
            // note: sys.db throws exception when result has the same fields (fun!), so we have explicitly list them
            return db.all("SELECT Person.personId, Person.firstName, Person.lastName, Person.iconId, Icon.path FROM Person
                INNER JOIN Icon ON Person.iconId = Icon.iconId
            WHERE personId = 1");
        }).then(result -> {
            Assert.equals(1, result.data.length);

            Assert.equals(result.data[0].personId, 1);
            Assert.equals(result.data[0].firstName, "Ian");
            Assert.equals(result.data[0].lastName, "Harrigan");
            Assert.equals(result.data[0].iconId, 1);
            Assert.equals(result.data[0].path, "/somepath/icon1.png");
    
            async.done();
        });
    }

    function testBasicInnerJoinWhereOr(async:Async) {
        var db = new Database("persons.db");
        db.open().then(_ -> {
            // note: sys.db throws exception when result has the same fields (fun!), so we have explicitly list them
            return db.all("SELECT Person.personId, Person.firstName, Person.lastName, Person.iconId, Icon.path FROM Person
                INNER JOIN Icon ON Person.iconId = Icon.iconId
            WHERE personId = 1 OR personId = 4");
        }).then(result -> {
            Assert.equals(2, result.data.length);

            Assert.equals(result.data[0].personId, 1);
            Assert.equals(result.data[0].firstName, "Ian");
            Assert.equals(result.data[0].lastName, "Harrigan");
            Assert.equals(result.data[0].iconId, 1);
            Assert.equals(result.data[0].path, "/somepath/icon1.png");

            Assert.equals(result.data[1].personId, 4);
            Assert.equals(result.data[1].firstName, "Jim");
            Assert.equals(result.data[1].lastName, "Parker");
            Assert.equals(result.data[1].iconId, 1);
            Assert.equals(result.data[1].path, "/somepath/icon1.png");
            
            async.done();
        });
    }

    function testBasicInnerJoinWhereAnd(async:Async) {
        var db = new Database("persons.db");
        db.open().then(_ -> {
            // note: sys.db throws exception when result has the same fields (fun!), so we have explicitly list them
            return db.all("SELECT Person.personId, Person.firstName, Person.lastName, Person.iconId, Icon.path FROM Person
                INNER JOIN Icon ON Person.iconId = Icon.iconId
            WHERE personId = 1 AND firstName = 'Ian'");
        }).then(result -> {
            Assert.equals(1, result.data.length);

            Assert.equals(result.data[0].personId, 1);
            Assert.equals(result.data[0].firstName, "Ian");
            Assert.equals(result.data[0].lastName, "Harrigan");
            Assert.equals(result.data[0].iconId, 1);
            Assert.equals(result.data[0].path, "/somepath/icon1.png");
            
            async.done();
        });
    }
}