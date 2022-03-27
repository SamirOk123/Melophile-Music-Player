import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_music_player/controllers/track_controller.dart';

class SearchController extends GetxController {
  TracksScreenController tracksScreenController = Get.find();

  TextEditingController searchController = TextEditingController();
  List songsListOnSearch = [];

  @override
  void onClose() {
    searchController.clear();
    super.onClose();
  }

  void searchSong(String query) {
    songsListOnSearch = tracksScreenController.songs
        .where((element) =>
            element.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    update();
  }
}
