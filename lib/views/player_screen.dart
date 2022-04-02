import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_music_player/constants/constants.dart';
import 'package:my_music_player/controllers/db_controller.dart';
import 'package:my_music_player/controllers/favourite_controller.dart';
import 'package:my_music_player/controllers/functions_controller.dart';
import 'package:my_music_player/controllers/player_controller.dart';
import 'package:my_music_player/controllers/track_controller.dart';
import 'package:my_music_player/models/db_model_favourites.dart';
import 'package:my_music_player/models/db_model_playlist.dart';
import 'package:my_music_player/models/playlist_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';

class PlayerScreen extends StatelessWidget {
  DbController dbController = Get.find();
  FavouriteController favouriteController = Get.put(FavouriteController());
  FunctionsController functionsController = Get.put(FunctionsController());
  TracksScreenController tracksScreenController = Get.find();

  var favDb = FavouritesDatabaseConnect();
  var db = PlaylistDatabaseConnect();
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => PlayerScreenController());
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: AppBar(
            backgroundColor: kBackgroundColour,
            elevation: 0,
            leading: IconButton(
              iconSize: 21,
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                Get.find<PlayerScreenController>().player.stop();
                Get.back();
              },
            ),
          ),
        ),
        backgroundColor: kBackgroundColour,
        body: Center(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.80,
                height: MediaQuery.of(context).size.height * 0.45,
                child: Obx(
                  () => QueryArtworkWidget(
                    id: tracksScreenController
                        .songs[tracksScreenController.currentIndex.value].id,
                    type: ArtworkType.AUDIO,
                    artworkBorder: BorderRadius.circular(10),
                    nullArtworkWidget: Container(
                      child: const Icon(
                        Icons.music_note_rounded,
                        size: 250,
                        color: kBackgroundColour,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                            colors: [
                              kLightBlue,
                              kBackgroundColour,
                            ],
                            begin: FractionalOffset(0.0, 0.0),
                            end: FractionalOffset(1.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      width: MediaQuery.of(context).size.width * 0.80,
                      height: MediaQuery.of(context).size.height * 0.45,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 24.0, left: 24.0, top: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: Obx(
                    () => Text(
                      tracksScreenController
                          .songs[tracksScreenController.currentIndex.value]
                          .title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 161,
                child: Obx(
                  () => Text(
                    tracksScreenController
                        .songs[tracksScreenController.currentIndex.value]
                        .artist!,
                    // overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: kGrey,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 20,
                    onPressed: () {
                      showSliderDialog(
                        context: context,
                        title: 'Adjust volume',
                        divisions: 10,
                        min: 0.0,
                        max: 1.0,
                        value: Get.find<PlayerScreenController>().player.volume,
                        stream: Get.find<PlayerScreenController>()
                            .player
                            .volumeStream,
                        onChanged:
                            Get.find<PlayerScreenController>().player.setVolume,
                      );
                    },
                    icon: const Icon(Icons.volume_up),
                    color: Colors.white,
                  ),
                  StreamBuilder<LoopMode>(
                    stream: Get.find<PlayerScreenController>()
                        .player
                        .loopModeStream,
                    builder: (context, snapshot) {
                      final loopMode = snapshot.data ?? LoopMode.off;
                      const icons = [
                        Icon(Icons.repeat, color: Colors.white),
                        Icon(Icons.repeat, color: Colors.blue),
                        Icon(Icons.repeat_one, color: Colors.blue),
                      ];
                      const cycleModes = [
                        LoopMode.off,
                        LoopMode.all,
                        LoopMode.one,
                      ];
                      final index = cycleModes.indexOf(loopMode);
                      return IconButton(
                        icon: icons[index],
                        onPressed: () {
                          Get.find<PlayerScreenController>().player.setLoopMode(
                              cycleModes[(cycleModes.indexOf(loopMode) + 1) %
                                  cycleModes.length]);
                        },
                      );
                    },
                  ),
                  Obx(
                    () => IconButton(
                      iconSize: 20,
                      onPressed: () {
                        favouriteController.songTitle = tracksScreenController
                            .songs[tracksScreenController.currentIndex.value]
                            .title;
                        favouriteController.songId = tracksScreenController
                            .songs[tracksScreenController.currentIndex.value]
                            .id;
                        favouriteController.songLocation =
                            tracksScreenController
                                .songs[
                                    tracksScreenController.currentIndex.value]
                                .data;
                        if (favouriteController.fav.value == 0) {
                          dbController.addToFav(
                              favouriteController.songTitle,
                              favouriteController.songId,
                              favouriteController.songLocation);

                          favouriteController.fav.value = 1;
                          functionsController.showToast(
                              msge: 'Added to favourites');
                        } else {
                          favDb
                              .deleteFavouriteSongs(favouriteController.songId);
                          favouriteController.fav.value = 0;
                          functionsController.showToast(
                              msge: 'Removed from favourites');
                        }
                      },
                      icon: favouriteController.fav.value == 0
                          ? const Icon(Icons.favorite_border)
                          : const Icon(
                              Icons.favorite,
                              color: Colors.blue,
                            ),
                      color: Colors.white,
                    ),
                  ),
                  StreamBuilder<bool>(
                    stream: Get.find<PlayerScreenController>()
                        .player
                        .shuffleModeEnabledStream,
                    builder: (context, snapshot) {
                      final shuffleModeEnabled = snapshot.data ?? false;
                      return IconButton(
                        icon: shuffleModeEnabled
                            ? const Icon(Icons.shuffle, color: Colors.blue)
                            : const Icon(Icons.shuffle, color: Colors.white),
                        onPressed: () async {
                          final enable = !shuffleModeEnabled;
                          if (enable) {
                            await Get.find<PlayerScreenController>()
                                .player
                                .shuffle();
                          }
                          await Get.find<PlayerScreenController>()
                              .player
                              .setShuffleModeEnabled(enable);
                        },
                      );
                    },
                  ),
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
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton.icon(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Create new playlist',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Get.defaultDialog(
                                  title: "Create new playlist",
                                  backgroundColor: kLightBlue,
                                  titleStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18),
                                  middleTextStyle:
                                      const TextStyle(color: Colors.white),
                                  textConfirm: "Create",
                                  textCancel: "Cancel",
                                  onConfirm: () {
                                    if (dbController
                                        .titleController.text.isEmpty) {
                                      const SizedBox();
                                    } else {
                                      dbController.playlistTitle =
                                          dbController.titleController.text;
                                      dbController.createPlaylist(
                                          dbController.playlistTitle!);
                                      dbController.titleController.clear();
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
                                          controller:
                                              dbController.titleController,
                                          cursorColor: Colors.white,
                                          decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: kBackgroundColour),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: kBackgroundColour)),
                                            hintText: 'Title',
                                            hintStyle: TextStyle(
                                                color: kBackgroundColour),
                                          ),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Expanded(
                              child: FutureBuilder(
                                future: db.retrievePlaylists(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<Playlist>> snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        dbController.playlistId =
                                            snapshot.data![index].id;
                                        return GestureDetector(
                                          onTap: () {
                                            final songId =
                                                tracksScreenController
                                                    .songs[
                                                        tracksScreenController
                                                            .currentIndex.value]
                                                    .id;
                                            final songTitle =
                                                tracksScreenController
                                                    .songs[
                                                        tracksScreenController
                                                            .currentIndex.value]
                                                    .title;
                                            final songPath =
                                                tracksScreenController
                                                    .songs[
                                                        tracksScreenController
                                                            .currentIndex.value]
                                                    .data;
                                            dbController.addSongToPlaylist(
                                                songId,
                                                snapshot.data![index].id,
                                                songTitle,
                                                songPath);

                                            functionsController.showToast(
                                                msge:
                                                    'Added to ${snapshot.data![index].title}');
                                          },
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: kLightBlue),
                                                      // margin: const EdgeInsets.only(left: 18, top: 18, right: 18),
                                                      width: 60,
                                                      height: 60,
                                                      child: const Icon(
                                                        Icons.folder,
                                                        size: 50,
                                                        color:
                                                            kBackgroundColour,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 16,
                                                    ),
                                                    SizedBox(
                                                      width: 161,
                                                      child: Text(
                                                        snapshot
                                                            .data![index].title,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
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
                    color: Colors.white,
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 23.0),
                    child: Obx(
                      () => Text(
                        Get.find<PlayerScreenController>().currentTime.value,
                        style: const TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontSize: 13),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 30,
                      child: GetBuilder<PlayerScreenController>(
                          builder: (playerScreenController) {
                        return Slider(
                          activeColor: Colors.white,
                          inactiveColor: kLightBlue,
                          value: playerScreenController.currentValue,
                          min: playerScreenController.minimumValue,
                          max: playerScreenController.maximumValue,
                          onChanged: (value) {
                            playerScreenController.currentValue = value;

                            playerScreenController.player.seek(
                              Duration(
                                milliseconds:
                                    playerScreenController.currentValue.round(),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 23.0),
                    child: Obx(
                      () => Text(
                        Get.find<PlayerScreenController>().endTime.value,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: const Icon(Icons.skip_previous,
                          color: Colors.white, size: 40),
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Get.find<PlayerScreenController>().changeTrack(false);
                      },
                    ),
                    StreamBuilder<PlayerState>(
                      stream: Get.find<PlayerScreenController>()
                          .player
                          .playerStateStream,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;
                        final processingState = playerState?.processingState;
                        final playing = playerState?.playing;
                        if (playing != true) {
                          return IconButton(
                            icon: const Icon(Icons.play_arrow,
                                color: Colors.white),
                            iconSize: 64.0,
                            onPressed:
                                Get.find<PlayerScreenController>().player.play,
                          );
                        } else if (processingState !=
                            ProcessingState.completed) {
                          return IconButton(
                            icon: const Icon(Icons.pause, color: Colors.white),
                            iconSize: 64.0,
                            onPressed:
                                Get.find<PlayerScreenController>().player.pause,
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    GestureDetector(
                      child: const Icon(Icons.skip_next,
                          color: Colors.white, size: 40),
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Get.find<PlayerScreenController>().changeTrack(true);
                      },
                    ),
                  ],
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ),
      ),
    );
  }

  //METHOD FOR ADJUSTING VOLUME
  void showSliderDialog({
    required BuildContext context,
    required String title,
    required int divisions,
    required double min,
    required double max,
    String valueSuffix = '',
    required double value,
    required Stream<double> stream,
    required ValueChanged<double> onChanged,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        backgroundColor: kLightBlue,
        title: Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17.0)),
        content: StreamBuilder<double>(
          stream: stream,
          builder: (context, snapshot) => SizedBox(
            height: 85.0,
            child: Column(
              children: [
                Text(
                  '${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 19.0),
                ),
                Slider(
                  inactiveColor: kGrey,
                  activeColor: Colors.white,
                  divisions: divisions,
                  min: min,
                  max: max,
                  value: snapshot.data ?? value,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
