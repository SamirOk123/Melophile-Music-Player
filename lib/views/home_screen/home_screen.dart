import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_music_player/constants/constants.dart';
import 'package:my_music_player/views/home_screen/favourites_screen.dart';
import 'package:my_music_player/views/home_screen/playlists_screen.dart';
import 'package:my_music_player/views/home_screen/tracks_screen.dart';
import 'package:my_music_player/views/search_screen.dart';
import 'package:my_music_player/widgets/navigation_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                indicatorColor: Colors.white,
                tabs: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Tracks',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    'Playlists',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'Favourites',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
              ),
              backgroundColor: kBackgroundColour,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    Get.to(SearchScreen());
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
              title: const Text(
                'Melophile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: TabBarView(
              children: [
                const TracksScreen(),
                PlaylistsScreen(),
                FavouritesScreen(),
              ],
            ),
            drawer: const NavigationDrawer()),
      ),
    );
  }
}
