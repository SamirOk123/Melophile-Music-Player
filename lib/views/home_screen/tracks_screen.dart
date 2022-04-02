import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_music_player/constants/constants.dart';
import 'package:my_music_player/controllers/track_controller.dart';
import 'package:my_music_player/views/player_screen.dart';
import 'package:my_music_player/widgets/track_card.dart';
import 'package:on_audio_query/on_audio_query.dart';

class TracksScreen extends StatelessWidget {
  const TracksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TracksScreenController tracksScreenController = Get.find();
    return Scaffold(
      backgroundColor: kBackgroundColour,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetBuilder<TracksScreenController>(
          builder: (trackScreenController) {
            return FutureBuilder<List<SongModel>>(
              future: OnAudioQuery().querySongs(
                  sortType: SongSortType.DATE_ADDED,
                  orderType: OrderType.ASC_OR_SMALLER,
                  uriType: UriType.EXTERNAL,
                  ignoreCase: false),
              builder: (context, item) {
                if (item.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  );
                }

                if (item.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Songs!',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  );
                }
                tracksScreenController.songs = item.data!;

                return ListView.builder(
                  itemCount: tracksScreenController.songs.length,
                  itemBuilder: (context, index) {
                    return TrackCard(
                      iconOnTap: () {
                        tracksScreenController.currentIndex.value = index;

                        Get.to(PlayerScreen());
                      },
                      title: tracksScreenController.songs[index].title!,
                      subtitle: tracksScreenController.songs[index].artist!,
                      thumbnail: QueryArtworkWidget(
                        id: tracksScreenController.songs[index].id,
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
                        tracksScreenController.currentIndex.value = index;

                        Get.to(PlayerScreen());
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
