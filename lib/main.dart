import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_music_player/controllers/db_controller.dart';
import 'package:my_music_player/controllers/search_controller.dart';
import 'package:my_music_player/controllers/track_controller.dart';
import 'package:my_music_player/views/home_screen/home_screen.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  ); //
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SearchController());
    Get.lazyPut(() => TracksScreenController());
    Get.lazyPut(() => DbController());

    return GetMaterialApp(
      theme: ThemeData(fontFamily: 'Samir'),
      title: 'Melophile',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
