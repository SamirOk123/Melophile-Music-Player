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
            // bottomNavigationBar: InkWell(
            //   onTap: () {
            //     Get.to(PlayerScreen());
            //   },
            //   child: Container(
            //     decoration: const BoxDecoration(
            //       gradient: LinearGradient(
            //         begin: Alignment.topLeft,
            //         end: Alignment.bottomRight,
            //         colors: [kBackgroundColour, kLightBlue],
            //       ),
            //     ),
            //     width: MediaQuery.of(context).size.width,
            //     height: 83,
            //     child: Padding(
            //       padding: const EdgeInsets.only(
            //         left: 18.0,
            //       ),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Row(children: [
            //             Container(
            //               child: Icon(
            //                 Icons.music_note_rounded,
            //                 size: 50,
            //                 color: kBackgroundColour,
            //               ),
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(10),
            //                 color: kLightBlue,
            //               ),
            //               width: 60,
            //               height: 60,
            //             ),
            //             SizedBox(
            //               width: 18,
            //             ),
            //             Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Text(
            //                   'Thee minnal..',
            //                   style:
            //                       TextStyle(color: Colors.white, fontSize: 15),
            //                 ),
            //                 Text(
            //                   'Marthyan',
            //                   style:
            //                       TextStyle(color: Colors.white, fontSize: 15),
            //                 ),
            //               ],
            //             ),
            //           ]),
            //           Row(
            //             children: [
            //               IconButton(
            //                 iconSize: 27,
            //                 onPressed: () {},
            //                 icon: Icon(
            //                   Icons.skip_previous,
            //                 ),
            //                 color: Colors.white,
            //               ),
            //               IconButton(
            //                 iconSize: 27,
            //                 onPressed: () {},
            //                 icon: Icon(
            //                   Icons.play_arrow,
            //                 ),
            //                 color: Colors.white,
            //               ),
            //               IconButton(
            //                 iconSize: 27,
            //                 onPressed: () {},
            //                 icon: Icon(
            //                   Icons.skip_next,
            //                 ),
            //                 color: Colors.white,
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
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
