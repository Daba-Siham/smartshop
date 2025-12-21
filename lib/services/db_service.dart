import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


Future <Database> initDB() async{
  final path= join (await getDatabasesPath(), 'favorites.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      return db.execute(
        '''
        CREATE TABLE favorites(
          id INTEGER PRIMARY KEY,
          name TEXT,
          price REAL,
          imagePath TEXT
        )
        ''',
      );
    },
    version: 1,
  );

}

Future<int> addFavorise({required String name, required double price, required String imagePath}) async{
  final db = await initDB();
  return db.insert('favorites', {"name": name, "price": price, "imagePath": imagePath},
  );
}

Future<int> deleteFavoriteByName(String name) async{
  final db = await initDB();
  return db.delete('favorites', where: 'name = ?', whereArgs: [name],
  );
}
Future<List<Map<String, dynamic>>> getFavorites() async{
  final db = await initDB();
  return db.query('favorites', orderBy: 'id DESC',
  );
}
Future<bool> isFavorite(String name) async{
  final db = await initDB();
  final result = await db.query('favorites', where: 'name = ?', whereArgs: [name], limit: 1,
  );
  return result.isNotEmpty;
}