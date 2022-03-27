import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_music_player/constants/constants.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          buildHeader(context),
          buildMenuItems(context),
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
        color: kLightBlue,
        child: Column(
          children: const [
            Icon(
              Icons.music_note_rounded,
              size: 90,
              color: kBackgroundColour,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Melophile',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        padding: EdgeInsets.only(
            top: 24 + MediaQuery.of(context).padding.top, bottom: 24),
      );
  Widget buildMenuItems(BuildContext context) => Container(
        color: kLightBlue,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(18),
        child: Wrap(
          runSpacing: 10,
          children: [
            const ListTile(
              leading: Icon(
                Icons.share,
                color: Colors.white,
              ),
              title: Text(
                'Share this App',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const ListTile(
              leading: Icon(
                Icons.star,
                color: Colors.white,
              ),
              title: Text(
                'Rate this App',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text(
                      "Contact",
                      style: TextStyle(color: kBackgroundColour),
                    ),
                    content: const Text(
                      "samirdq9769@gmail.com",
                      style: TextStyle(color: kBackgroundColour),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text("DONE"),
                      ),
                    ],
                  ),
                );
              },
              leading: const Icon(
                Icons.headset_mic_rounded,
                color: Colors.white,
              ),
              title: const Text(
                'Help and Support',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const ListTile(
              leading: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              title: Text(
                'Privacy and Security',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Row(
                      children: const [
                        Icon(
                          Icons.music_note_rounded,
                          size: 55,
                          color: kBackgroundColour,
                        ),
                        Text(
                          'Melophile 1.0.0',
                          style: TextStyle(
                              color: kBackgroundColour,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                      ],
                    ),
                    content: const Padding(
                      padding: EdgeInsets.only(left: 13.0),
                      child: Text(
                        "Offline music player",
                        style: TextStyle(color: kBackgroundColour),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {},
                        child: const Text("VIEW LICENSES"),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("CLOSE"),
                      ),
                    ],
                  ),
                );
              },
              leading: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              title: const Text(
                'About',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
}
