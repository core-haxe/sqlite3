package cases.util;

import promises.PromiseUtils;
import sqlite.Database;
import sys.io.File;
import promises.Promise;

class DBCreator {
    public static function create(createDummyData:Bool = true):Promise<Bool> {
        return new Promise((resolve, reject) -> {
            File.saveContent("persons.db", "");
            var db = new Database("persons.db");
            db.open().then(_ -> {
                return db.exec("CREATE TABLE Person (
                    personId INTEGER PRIMARY KEY AUTOINCREMENT,
                    lastName varchar(50),
                    firstName varchar(50),
                    iconId int
                );");
            }).then(_ -> {
                return db.exec("CREATE TABLE Icon (
                    iconId int,
                    path varchar(50)
                );");
            }).then(_ -> {
                return db.exec("CREATE TABLE Organization (
                    organizationId int,
                    name varchar(50),
                    iconId int
                );");
            }).then(_ -> {
                return db.exec("CREATE TABLE Person_Organization (
                    Person_personId int,
                    Organization_organizationId int
                );");
            }).then(_ -> {
                if (createDummyData) {
                    addDummyData().then(_ -> {
                        resolve(true);
                    });
                } else {
                    resolve(true);
                }
            }, error -> {
                trace("error", error);
            });
        });
    }

    public static function addDummyData():Promise<Bool> {
        return new Promise((resolve, reject) -> {
            var db = new Database("persons.db");
            db.open().then(_ -> {
                var inserts = [];
                inserts.push(db.exec.bind("INSERT INTO Icon (iconId, path) VALUES (1, '/somepath/icon1.png');"));
                inserts.push(db.exec.bind("INSERT INTO Icon (iconId, path) VALUES (2, '/somepath/icon2.png');"));
                inserts.push(db.exec.bind("INSERT INTO Icon (iconId, path) VALUES (3, '/somepath/icon3.png');"));

                inserts.push(db.exec.bind("INSERT INTO Person (personId, firstName, lastName, iconId) VALUES (1, 'Ian', 'Harrigan', 1);"));
                inserts.push(db.exec.bind("INSERT INTO Person (personId, firstName, lastName, iconId) VALUES (2, 'Bob', 'Barker', 3);"));
                inserts.push(db.exec.bind("INSERT INTO Person (personId, firstName, lastName, iconId) VALUES (3, 'Tim', 'Mallot', 2);"));
                inserts.push(db.exec.bind("INSERT INTO Person (personId, firstName, lastName, iconId) VALUES (4, 'Jim', 'Parker', 1);"));

                inserts.push(db.exec.bind("INSERT INTO Organization (organizationId, name, iconId) VALUES (1, 'ACME Inc', 2);"));
                inserts.push(db.exec.bind("INSERT INTO Organization (organizationId, name, iconId) VALUES (2, 'Haxe LLC', 1);"));
                inserts.push(db.exec.bind("INSERT INTO Organization (organizationId, name, iconId) VALUES (3, 'PASX Ltd', 3);"));

                inserts.push(db.exec.bind("INSERT INTO Person_Organization (Person_personId, Organization_organizationId) VALUES (1, 1);"));
                inserts.push(db.exec.bind("INSERT INTO Person_Organization (Person_personId, Organization_organizationId) VALUES (2, 1);"));
                inserts.push(db.exec.bind("INSERT INTO Person_Organization (Person_personId, Organization_organizationId) VALUES (3, 1);"));
                inserts.push(db.exec.bind("INSERT INTO Person_Organization (Person_personId, Organization_organizationId) VALUES (2, 2);"));
                inserts.push(db.exec.bind("INSERT INTO Person_Organization (Person_personId, Organization_organizationId) VALUES (4, 2);"));
                inserts.push(db.exec.bind("INSERT INTO Person_Organization (Person_personId, Organization_organizationId) VALUES (1, 3);"));
                inserts.push(db.exec.bind("INSERT INTO Person_Organization (Person_personId, Organization_organizationId) VALUES (4, 3);"));
                return PromiseUtils.runAll(inserts);
            }).then(_ -> {
                resolve(true);
            });
        });
    }

    public static function delete() {
        //FileSystem.deleteFile("persons.db");
    }
}