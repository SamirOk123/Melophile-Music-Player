

import 'playlist_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class PlaylistDatabaseConnect{
  Database? _database;
  Future<Database> get database async {
    final dbPath = await getDatabasesPath();
    const dbName = 'playlists.db';
    final path = p.join(dbPath, dbName);
    

    _database = await openDatabase(path, version: 1,
        onCreate: (database, version) async {
      await database.execute(
          'CREATE TABLE playlists( id INTEGER PRIMARY KEY, title TEXT )');
      await database.execute(
          'CREATE TABLE songs( id INTEGER PRIMARY KEY, playlistId INTEGER, songId INTEGER, songTitle TEXT, songPath TEXT)');
    });
    return _database!;
  }

// This function creating table in database.
  // Future<void> _createDb(Database db, int version) async {
  //   await db.execute(
  //       'CREATE TABLE playlists( id INTEGER PRIMARY KEY, title TEXT )');
  // }

  Future<int> createPlaylist(List<Playlist> playlists) async {
    int result = 0;
    final db = await database;
    for (var playlist in playlists) {
      result = await db.insert('playlists', playlist.toMap());
    }
    return result;
  }

  Future<int> addSongs(List<PlaylistSong> songs) async {
    int result = 0;
    final db = await database;
    for (var song in songs) {
      result = await db.insert('songs', song.toMap(),);
    }
    return result;
  }

  Future<List<Playlist>> retrievePlaylists() async {
    final db = await database;
    final List<Map<String, Object?>> playlists = await db.query('playlists');
    return playlists.map((e) => Playlist.fromMap(e)).toList();
    
  }

  // Future<List<PlaylistSong>> retrieveSongs() async {
  //   final db = await database;
  //   final List<Map<String, Object?>> songs = await db.query('songs');
  //   return songs.map((e) => PlaylistSong.fromMap(e)).toList();
  // }

  Future<List<PlaylistSong>> retrieveSongs(playlistId) async {
    final db = await database;
    final List<Map<String, Object?>> songs =
        await db.query('songs', where: 'playlistId == $playlistId');
       
    return songs.map((e) => PlaylistSong.fromMap(e)).toList();
    
  }

  Future<void> deletePlaylist(int id) async {
    final db = await database;
    await db.delete('playlists', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteSong(int id) async {
    final db = await database;
    await db.delete('songs', where: 'id = ?', whereArgs: [id]);
  }
  // Future<List<Playlist>> getPlaylists() async {
  //   final db = await database;

  //   List<Map<String, dynamic>> playlists =
  //       await db.query('playlists', orderBy: 'id DESC');

  //   return List.generate(
  //     playlists.length,
  //     (index) => Playlist(
  //       id: playlists[index]['id'],
  //       title: playlists[index]['title'],
  //     ),
  //   );
  // }

  // //Update
  // Future<void> updateSong(Song song) async {
  //   final db = await database;
  //   await db.update('songs', song.toMap(),
  //       where: 'id == ?', whereArgs: [song.id]);
  // }

  // Future<void> deletePlaylist(Playlist playlist) async {
  //   final db = await database;
  //   await db.delete('playlists', where: 'id == ?', whereArgs: [playlist.id]);
  // }
}
