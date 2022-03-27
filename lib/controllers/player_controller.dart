import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_music_player/controllers/favourite_controller.dart';
import 'package:my_music_player/controllers/track_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerScreenController extends GetxController {
  TracksScreenController tracksScreenController = Get.find();
  FavouriteController favouriteController = Get.put(FavouriteController());
  var player = AudioPlayer();

  double minimumValue = 0.0;
  double maximumValue = 0.0;
  double currentValue = 0.0;
  RxString currentTime = '00:00'.obs;
  RxString endTime = '00:00'.obs;
  bool isPlaying = false;

  @override
  void onInit() {
    setSong(tracksScreenController
        .songs[tracksScreenController.currentIndex.value]);

    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    player.dispose();
    favouriteController.fav.value = 0;
  }

  void autoPlayNextSong() {
    if (currentValue >= maximumValue) {
      changeTrack(true);
    }
  }

  changeTrack(bool isNext) {
    if (isNext == true) {
      if (tracksScreenController.currentIndex.value !=
          tracksScreenController.songs.length - 1) {
        tracksScreenController.currentIndex++;
        favouriteController.fav.value = 0;
      }
    } else {
      if (tracksScreenController.currentIndex.value!= 0) {
        tracksScreenController.currentIndex--;
       favouriteController.fav.value = 0;
      }
    }
    setSong(tracksScreenController
        .songs[tracksScreenController.currentIndex.value]);
  }

  void setSong(SongModel songModel) async {
    tracksScreenController.songs[tracksScreenController.currentIndex.value] =
        songModel;
    await player.setUrl(tracksScreenController
        .songs[tracksScreenController.currentIndex.value].uri!);

    currentValue = minimumValue;
    maximumValue = player.duration!.inMilliseconds.toDouble();
    // if (currentValue>=maximumValue){
    //   changeTrack(true);
    // }
    currentTime.value = getDuration(currentValue);
    endTime.value = getDuration(maximumValue);

    isPlaying = false;
    changeStatus();
    player.positionStream.listen((duration) {
      currentValue = duration.inMilliseconds.toDouble();
      //autoPlayNextSong();

      currentTime.value = getDuration(currentValue);
      if (currentValue >= maximumValue) {
        changeTrack(true);
      }
      update();
    });
  }

  //PLAY-PAUSE METHOD
  void changeStatus() {
    isPlaying = !isPlaying;
    update();
    if (isPlaying) {
      player.play();
    } else {
      player.pause();
    }
  }

  //METHOD FOR GETTING DURATION
  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());
    return [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }
}
