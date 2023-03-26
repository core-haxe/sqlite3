<a href="https://github.com/core-haxe/sqlite3/actions/workflows/nodejs.yaml"><img src="https://github.com/core-haxe/sqlite3/actions/workflows/nodejs.yaml/badge.svg">
<a href="https://github.com/core-haxe/sqlite3/actions/workflows/hl.yaml"><img src="https://github.com/core-haxe/sqlite3/actions/workflows/hl.yaml/badge.svg">
<a href="https://github.com/core-haxe/sqlite3/actions/workflows/hxcpp.yaml"><img src="https://github.com/core-haxe/sqlite3/actions/workflows/hxcpp.yaml/badge.svg">
<a href="https://github.com/core-haxe/sqlite3/actions/workflows/neko.yaml"><img src="https://github.com/core-haxe/sqlite3/actions/workflows/neko.yaml/badge.svg">

# sqlite3
sqlite3 for all relevant haxe targets

# basic usage

```haxe
var db = new Database("somedb.db");
db.open().then(result -> {
    return db.exec("CREATE TABLE Persons (PersonID int, LastName varchar(50), FirstName varchar(50));");
}).then(result -> {
    return db.exec("INSERT INTO Persons (PersonID, LastName, FirstName) VALUES (1, 'Ian', 'Harrigan');");
}).then(result -> {
    return db.all("SELECT * FROM Persons;");
}).then(result -> {
    for (person in result.data) {
        trace(person.FirstName, person.LastName);
    }
    return db.get("SELECT * FROM Persons WHERE PersonID = ?", [1]); // use prepared statement
}).then(result -> {
    trace(result.data.FirstName, result.data.LastName);
}, (error:SqliteError) -> {
    // error
});
```

# dependencies 

* nodejs - [__sqlite3__](https://www.npmjs.com/package/sqlite3) (`npm install sqlite3`)
* hxcpp - [__libsqlite3__](https://github.com/core-haxe/libsqlite3) (better than haxe's internal sqlite)
* sys - haxe's internal sqlite
