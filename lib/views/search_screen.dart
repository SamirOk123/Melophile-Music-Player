import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_music_player/constants/constants.dart';
import 'package:my_music_player/controllers/search_controller.dart';
import 'package:my_music_player/controllers/track_controller.dart';
import 'package:my_music_player/views/player_screen.dart';
import 'package:my_music_player/widgets/track_card.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  TracksScreenController tracksScreenController = Get.find();
  SearchController searchController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColour,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          iconSize: 21,
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Search'),
        backgroundColor: kBackgroundColour,
      ),
      body: Column(
        children: [
          Container(
            margin:
                const EdgeInsets.only(right: 20, left: 20, bottom: 20, top: 13),
            width: MediaQuery.of(context).size.width - 30,
            height: 45,
            decoration: BoxDecoration(boxShadow: const [
              BoxShadow(
                color: Color(0xFF000000),
                offset: Offset(
                  5.0,
                  5.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
            ], color: kLightBlue, borderRadius: BorderRadius.circular(15)),
            child: TextField(
              controller: searchController.searchController,
              onChanged: searchController.searchSong,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search songs',
                errorBorder: InputBorder.none,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    searchController.searchController.clear();
                  },
                  icon: const Icon(
                    Icons.close,
                  ),
                  splashRadius: 2,
                ),
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: GetBuilder<SearchController>(
                builder: (searchController) {
                  return searchController.searchController.text.isNotEmpty &&
                          searchController.songsListOnSearch.isEmpty
                      ? const Center(
                          child: Text(
                            'No results',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount:
                              searchController.searchController.text.isNotEmpty
                                  ? searchController.songsListOnSearch.length
                                  : tracksScreenController.songs.length,
                          itemBuilder: (context, index) {
                            return TrackCard(
                              iconOnTap: () {
                                for (int i = 0;
                                    i < tracksScreenController.songs.length;
                                    i++) {
                                  if (tracksScreenController.songs[i].id ==
                                      searchController
                                          .songsListOnSearch[index].id) {
                                    tracksScreenController.currentIndex.value =
                                        i;
                                    break;
                                  }
                                }
                                Get.to(PlayerScreen());
                              },
                              title: searchController
                                      .searchController.text.isNotEmpty
                                  ? searchController
                                      .songsListOnSearch[index].title!
                                  : tracksScreenController.songs[index].title!,
                              subtitle: searchController
                                      .searchController.text.isNotEmpty
                                  ? searchController
                                      .songsListOnSearch[index].artist!
                                  : tracksScreenController.songs[index].artist!,
                              thumbnail: QueryArtworkWidget(
                                id: searchController
                                        .searchController.text.isNotEmpty
                                    ? searchController
                                        .songsListOnSearch[index].id!
                                    : tracksScreenController.songs[index].id,
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
                                if (searchController
                                    .songsListOnSearch.isEmpty) {
                                  Get.to(PlayerScreen());
                                } else {
                                  for (int i = 0;
                                      i < tracksScreenController.songs.length;
                                      i++) {
                                    if (tracksScreenController.songs[i].id ==
                                        searchController
                                            .songsListOnSearch[index].id) {
                                      tracksScreenController
                                          .currentIndex.value = i;
                                      break;
                                    }
                                  }
                                  Get.to(PlayerScreen());
                                }
                              },
                            );
                          },
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
