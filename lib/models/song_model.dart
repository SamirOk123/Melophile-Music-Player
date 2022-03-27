// FOR FAVOURITES
class Song {
  int id;
  String title;
  String location;

  Song({required this.id, required this.title, required this.location});

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'location': location,
      };

  Song.fromMap(Map<String, dynamic> sam)
      : id = sam['id'],
        title = sam['title'],
        location = sam['location'];
}
