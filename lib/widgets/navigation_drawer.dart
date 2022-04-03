import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_music_player/constants/constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
          children: [
            const SizedBox(
              height: 25,
            ),
            Image.asset(
              'assets/images/music-notee.png',
              width: 90,
              height: 90,
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Melophile',
              style: TextStyle(
                fontSize: 21,
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
            ListTile(
              onTap: () {
                Share.share(kPrivacyPolicyUrl);
              },
              leading: const Icon(
                Icons.share,
                color: Colors.white,
              ),
              title: const Text(
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
            ListTile(
              onTap: () async {
                if (await canLaunch(kPrivacyPolicyUrl)) {
                  await launch(kPrivacyPolicyUrl);
                }
              },
              leading: const Icon(
                Icons.lock,
                color: Colors.white,
              ),
              title: const Text(
                'Privacy and Policy',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Row(
                      children: [
                        Image.asset(
                          'assets/images/music-notee.png',
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Melophile 1.0.0',
                          style: TextStyle(
                              color: kBackgroundColour,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                      ],
                    ),
                    content: const Padding(
                      padding: EdgeInsets.only(left: 10.0),
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
