package cases;

import haxe.io.Bytes;
import utest.Assert;
import sqlite.Database;
import utest.Async;
import cases.util.DBCreator;
import utest.Test;

class TestBlob extends Test {
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
    
    function testBasicBlobGet(async:Async) {
        var db = new Database(DBCreator.filename);
        db.open().then(_ -> {
            return db.get("SELECT * FROM Person WHERE personId = 1");
        }).then(result -> {
            Assert.equals(result.data.personId, 1);
            Assert.equals(result.data.firstName, "Ian");
            Assert.equals(result.data.lastName, "Harrigan");
            Assert.equals(result.data.iconId, 1);
            Assert.isOfType(result.data.contractDocument, Bytes);
            Assert.equals(Bytes.ofString("this is ians contract document").toString(), result.data.contractDocument.toString());
            db.close();
            async.done();
        }, error -> {
            trace("error", error);
        });
    }
    
    function testBasicBlobAll(async:Async) {
        var db = new Database(DBCreator.filename);
        db.open().then(_ -> {
            return db.all("SELECT * FROM Person WHERE personId = 1");
        }).then(result -> {
            Assert.equals(result.data[0].personId, 1);
            Assert.equals(result.data[0].firstName, "Ian");
            Assert.equals(result.data[0].lastName, "Harrigan");
            Assert.equals(result.data[0].iconId, 1);
            Assert.isOfType(result.data[0].contractDocument, Bytes);
            Assert.equals(Bytes.ofString("this is ians contract document").toString(), result.data[0].contractDocument.toString());
            db.close();
            async.done();
        }, error -> {
            trace("error", error);
        });
    }
}