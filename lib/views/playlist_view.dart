import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_music_player/constants/constants.dart';
import 'package:my_music_player/controllers/db_controller.dart';
import 'package:my_music_player/controllers/track_controller.dart';
import 'package:my_music_player/models/db_model_playlist.dart';
import 'package:my_music_player/models/playlist_model.dart';
import 'package:my_music_player/views/player_screen.dart';
import 'package:my_music_player/widgets/track_card.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistView extends StatelessWidget {
  TracksScreenController tracksScreenController = Get.find();
  var db = PlaylistDatabaseConnect();

  DbController dbController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GetBuilder<DbController>(
          builder: (controller) {
            return FutureBuilder(
              future: controller.db.retrieveSongs(dbController.playlistId),
              builder: (BuildContext context,
                  AsyncSnapshot<List<PlaylistSong>> snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Dismissible(
                              key: UniqueKey(),
                              onDismissed: (DismissDirection direction) {
                                db.deleteSong(snapshot.data![index].id!);
                                // snapshot.data!.remove(snapshot.data![index]);
                              },
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: const Icon(Icons.delete),
                              ),
                              child: TrackCard(
                                subtitle: snapshot.data![index].songTitle,
                                title: snapshot.data![index].songTitle,
                                iconOnTap: () {
                                  for (int i = 0;
                                      i < tracksScreenController.songs.length;
                                      i++) {
                                    if (tracksScreenController.songs[i].id ==
                                        snapshot.data![index].songId) {
                                      tracksScreenController
                                          .currentIndex.value = i;
                                      break;
                                    }
                                  }
                                  Get.to(()=>PlayerScreen());
                                },
                                onTap: () {
                                  for (int i = 0;
                                      i < tracksScreenController.songs.length;
                                      i++) {
                                    if (tracksScreenController.songs[i].id ==
                                        snapshot.data![index].songId) {
                                      tracksScreenController
                                          .currentIndex.value = i;
                                      break;
                                    }
                                  }
                                  Get.to(()=>PlayerScreen());
                                },
                                thumbnail: QueryArtworkWidget(
                                  artworkWidth: 60,
                                  artworkHeight: 60,
                                  artworkBorder: BorderRadius.circular(10),
                                  id: snapshot.data![index].songId,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: Container(
                                    child: const Icon(
                                      Icons.music_note_rounded,
                                      size: 40,
                                      color: kBackgroundColour,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: kLightBlue,
                                    ),
                                    width: 60,
                                    height: 60,
                                  ),
                                  artworkFit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      'No songs',
                      style: TextStyle(color: Colors.grey, fontSize: 20), 
                    ),
                  );
                }
              },
            );
          },
        ),
        backgroundColor: kBackgroundColour,
        appBar: AppBar(
          backgroundColor: kBackgroundColour,
          elevation: 0,
          title: Text(
            Get.arguments,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: kBackgroundColour,
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) => Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Select songs',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: tracksScreenController.songs.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (tracksScreenController.songs.length != 0) {
                              return Column(
                                children: [
                                  ListTile(
                                    leading: QueryArtworkWidget(
                                      artworkBorder: BorderRadius.circular(10),
                                      id: tracksScreenController
                                          .songs[index].id,
                                      type: ArtworkType.AUDIO,
                                      nullArtworkWidget: Container(
                                        child: const Icon(
                                          Icons.music_note_rounded,
                                          size: 40,
                                          color: kBackgroundColour,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: kLightBlue,
                                        ),
                                        width: 54,
                                        height: 54,
                                      ),
                                      artworkFit: BoxFit.cover,
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        final songId = tracksScreenController
                                            .songs[index].id;
                                        final songTitle = tracksScreenController
                                            .songs[index].title;
                                        final songPath = tracksScreenController
                                            .songs[index].data;
                                        dbController.addSongToPlaylist(
                                            songId,
                                            dbController.playlistId,
                                            songTitle,
                                            songPath);
                                        dbController.update();
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(
                                      tracksScreenController
                                          .songs[index].title!,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      tracksScreenController
                                          .songs[index].artist!,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          color: kGrey, fontSize: 11),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return const Center(
                                child: Text(
                                  'No Songs',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
