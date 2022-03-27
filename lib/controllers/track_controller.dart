import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class TracksScreenController extends GetxController {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  RxInt currentIndex = 0.obs;
  List songs = [].obs;

  @override
  void onInit() {
    requestPermission();

    super.onInit();
  }

  requestPermission() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }
    update();
  }
}
