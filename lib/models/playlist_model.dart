class Playlist {
  final id;
  final title;

  Playlist({this.id, this.title});

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
      };

  Playlist.fromMap(Map<String, dynamic> sam)
      : id = sam['id'],
        title = sam['title'];
}

// SONG MODEL FOR PLAYLIST
class PlaylistSong {
  int? id;
  int playlistId;
  int songId;
  String songTitle;
  String songPath;

  PlaylistSong(
      { this.id,
      required this.playlistId,
      required this.songId,
      required this.songPath,
      required this.songTitle});

  PlaylistSong.fromMap(Map<String, dynamic> sam)
      : id = sam['id'],
        songId = sam['songId'],
        playlistId = sam['playlistId'],
        songPath = sam['songPath'],
        songTitle = sam['songTitle'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'songId': songId,
      'playlistId': playlistId,
      'songPath': songPath,
      'songTitle': songTitle,
    };
  }
}
