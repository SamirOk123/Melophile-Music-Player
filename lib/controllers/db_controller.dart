import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:my_music_player/models/db_model_favourites.dart';
import 'package:my_music_player/models/db_model_playlist.dart';
import 'package:my_music_player/models/playlist_model.dart';
import 'package:my_music_player/models/song_model.dart';

class DbController extends GetxController {
  var playlistId;
  String? playlistTitle;
  TextEditingController titleController = TextEditingController();
  var db = PlaylistDatabaseConnect();
  var favDb = FavouritesDatabaseConnect();

  // PLAYLIST
  Future<int> createPlaylist(String playlistName) async {
    final Playlist firstPlaylist = Playlist(title: playlistName);
    final List<Playlist> listOfPlaylists = [firstPlaylist];
    return await db.createPlaylist(listOfPlaylists);
  }

  Future<int> addSongToPlaylist(
      var songId, var playlistId, var songTitle, var songPath) async {
    final PlaylistSong firstSong = PlaylistSong(
        playlistId: playlistId,
        songId: songId,
        songPath: songPath,
        songTitle: songTitle);
    final List<PlaylistSong> listOfSongs = [firstSong];
    return await db.addSongs(listOfSongs);
  }

  // FAVOURITES
  Future<int> addToFav(String title, int id, String location) async {
    final Song firstFavourite = Song(id: id, title: title, location: location);
    final List<Song> favouriteList = [firstFavourite];
    return await favDb.addToFavourites(favouriteList);
  }
}
