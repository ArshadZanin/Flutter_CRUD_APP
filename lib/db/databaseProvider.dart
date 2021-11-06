import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class User {
  final int? id;
  final String? name;
  final String? age;
  final String? place;
  final String? email;

  User({this.id, this.name, this.age, this.place, this.email});

  User.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        age = res["age"].toString(),
        place = res["place"],
        email = res["email"];

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'age': age, 'place': place, 'email': email};
  }
}

class DatabaseHandler {
  Database? _database;

  Future<Database?> get database async {
    print("database getter called");

    if (_database != null) {
      return _database;
    }

    _database = await initializeDB();

    return _database;
  }

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'students.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, age TEXT NOT NULL, place TEXT NOT NULL, email TEXT NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertUser(List<User> users) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var user in users) {
      result = await db.insert('users', user.toMap());
    }
    return result;
  }

  Future<List<User>> retrieveUsers() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('users');
    return queryResult.map((e) => User.fromMap(e)).toList();
  }

  // Future<int> updateUser(List<User> users) async {
  //   final db = await database;
  //   int result = 0;
  //   User userid = User();
  //
  //   for (var user in users) {
  //     result = await db!.update(
  //       'users',
  //       user.toMap(),
  //       where: "id = ?",
  //       whereArgs: [userid.id],
  //     );
  //   }
  //   return result;
  // }

  Future<int> updateUser(int id, String name, String age, String place, String email) async {
    final db = await database;

    final data = {
      'name': name, 'age': age, 'place': place, 'email': email
    };

    final result = await db!.update('users', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  Future<void> deleteUser(int id) async {
    final db = await initializeDB();
    await db.delete(
      'users',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
