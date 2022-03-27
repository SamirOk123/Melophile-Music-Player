import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_music_player/constants/constants.dart';
import 'package:my_music_player/controllers/track_controller.dart';
import 'package:my_music_player/models/db_model_favourites.dart';
import 'package:my_music_player/models/song_model.dart';
import 'package:my_music_player/views/player_screen.dart';
import 'package:my_music_player/widgets/track_card.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavouritesScreen extends StatelessWidget {
   FavouritesScreen({Key? key}) : super(key: key);
  TracksScreenController tracksScreenController = Get.find();

  var favDb = FavouritesDatabaseConnect();

  @override
  Widget build(BuildContext context) {
    //  Get.lazyPut(() => PlayerScreenController());
    return Scaffold(
      backgroundColor: kBackgroundColour,
      body: FutureBuilder(
        future: favDb.getFavouriteSongs(),
        builder: (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: UniqueKey(), //ValueKey<int>(snapshot.data![index].id)
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            backgroundColor: kLightBlue,
                            content: const Text(
                              "Do you want to delete this song from favourites?",
                              style: TextStyle(color: Colors.white),
                            ),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text("Delete")),
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text("Cancel"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (DismissDirection direction) async {
                      await favDb
                          .deleteFavouriteSongs(snapshot.data![index].id);
                      // snapshot.data!.remove(snapshot.data![index].id);
                    },
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: const Icon(Icons.delete),
                    ),
                    child: TrackCard(
                        iconOnTap: () {
                          for (int i = 0;
                              i < tracksScreenController.songs.length;
                              i++) {
                            if (tracksScreenController.songs[i].id ==
                                snapshot.data![index].id) {
                              tracksScreenController.currentIndex.value = i;
                              break;
                            }
                          }
                          Get.to(PlayerScreen());
                        },
                        title: snapshot.data![index].title,
                        subtitle: snapshot.data![index].title,
                        thumbnail: QueryArtworkWidget(
                          id: snapshot.data![index].id,
                          type: ArtworkType.AUDIO,
                          artworkBorder: BorderRadius.circular(10),
                          nullArtworkWidget: Container(
                            child: const Icon(
                              Icons.music_note_rounded,
                              size: 50,
                              color: kBackgroundColour,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kLightBlue,
                            ),
                            width: 80,
                            height: 80,
                          ),
                        ),
                        onTap: () {
                          for (int i = 0;
                              i < tracksScreenController.songs.length;
                              i++) {
                            if (tracksScreenController.songs[i].id ==
                                snapshot.data![index].id) {
                              tracksScreenController.currentIndex.value = i;
                              break;
                            }
                          }
                          //  tracksScreenController.songs[
                          //         tracksScreenController.currentIndex.value];
                          Get.to(PlayerScreen());
                          // Get.find<PlayerScreenController>().setSong(
                          //     tracksScreenController.songs[
                          //         tracksScreenController.currentIndex.value]);
                          //         Get.to(PlayerScreen());

                          //  Get.find<PlayerScreenController>().setSong(snapshot.data![index]);
                        }),
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: Text(
                'No favourites',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            );
          }
        },
      ),
    );
  }
}
