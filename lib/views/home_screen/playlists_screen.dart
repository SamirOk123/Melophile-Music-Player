import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_music_player/constants/constants.dart';
import 'package:my_music_player/controllers/db_controller.dart';
import 'package:my_music_player/models/db_model_playlist.dart';
import 'package:my_music_player/models/playlist_model.dart';
import 'package:my_music_player/views/playlist_view.dart';

class PlaylistsScreen extends StatelessWidget {
  PlaylistsScreen({Key? key}) : super(key: key);

  DbController dbController = Get.find();
  var db = PlaylistDatabaseConnect();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _displayTextInputDialog(context);
          Get.defaultDialog(
            title: "Create new playlist",
            backgroundColor: kLightBlue,
            titleStyle: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            middleTextStyle: const TextStyle(color: Colors.white),
            textConfirm: "Create",
            textCancel: "Cancel",
            onConfirm: () {
              if (dbController.titleController.text.isEmpty) {
                const SizedBox();
              } else {
                dbController.playlistTitle = dbController.titleController.text;
                dbController.createPlaylist(dbController.playlistTitle!);
                dbController.titleController.clear();
                dbController.update();
                Get.back();
              }
            },
            cancelTextColor: Colors.white,
            confirmTextColor: Colors.white,
            buttonColor: kBackgroundColour,
            barrierDismissible: false,
            radius: 15,
            content: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    autofocus: true,
                    controller: dbController.titleController,
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kBackgroundColour),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kBackgroundColour),
                      ),
                      hintText: 'Title',
                      hintStyle: TextStyle(color: kBackgroundColour),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
        backgroundColor: kLightBlue,
      ),
      backgroundColor: kBackgroundColour,
      body: GetBuilder<DbController>(builder: (dbController) {
        return FutureBuilder(
          future: dbController.db.retrievePlaylists(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Playlist>> snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        dbController.playlistId = snapshot.data![index].id;

                        Get.to(() => PlaylistView(),
                            arguments: snapshot.data![index].title!);
                      },
                      child: Dismissible(
                        key:
                            UniqueKey(), //ValueKey<int>(snapshot.data![index].id),
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
                                  "Do you want to delete this playlist?",
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
                        onDismissed: (DismissDirection direction) {
                          dbController.db
                              .deletePlaylist(snapshot.data![index].id);
                        },
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: const Icon(Icons.delete),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: kLightBlue),
                                    // margin: const EdgeInsets.only(left: 18, top: 18, right: 18),
                                    width: 60,
                                    height: 60,
                                    child: const Icon(
                                      Icons.folder,
                                      size: 50,
                                      color: kBackgroundColour,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  SizedBox(
                                    width: 161,
                                    child: Text(
                                      snapshot.data![index].title!,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
          },
        );
      }),
    );
  }
}
