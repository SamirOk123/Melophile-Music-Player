import 'package:my_music_player/models/song_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class FavouritesDatabaseConnect {
  Database? _database;
  Future<Database> get database async {
    final dbPath = await getDatabasesPath();
    const dbName = 'favourites.db';
    final path = p.join(dbPath, dbName);

    _database = await openDatabase(path, version: 1, onCreate: _createDb);
    return _database!;
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE favourites( id INTEGER PRIMARY KEY, title TEXT, location TEXT )');
  }

  Future<int> addToFavourites(List<Song> favourites) async {
    int result = 0;
    final db = await database;
    for (var favourite in favourites) {
      result = await db.insert('favourites', favourite.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return result;
  }
  
  Future<List<Song>> getFavouriteSongs() async {
    final db = await database;
    final List<Map<String, Object?>> favouriteSongs =
        await db.query('favourites');
    return favouriteSongs.map((e) => Song.fromMap(e)).toList();
  }

  Future deleteFavouriteSongs(int id) async {
    final db = await database;
    await db.delete('favourites', where: 'id = ?', whereArgs: [id]);
  }
}
