import 'package:flutter/material.dart';
import 'package:my_music_player/constants/constants.dart';

class TrackCard extends StatelessWidget {
  const TrackCard(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.thumbnail,
      required this.onTap,
      required this.iconOnTap})
      : super(key: key);

  final String title;
  final String subtitle;
  final dynamic thumbnail;
  final dynamic onTap;
  final dynamic iconOnTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(11),
                width: 60,
                height: 60,
                child: thumbnail,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 161,
                      child: Text(
                        title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      width: 161,
                      child: Text(
                        subtitle,
                        style: const TextStyle(color: kGrey, fontSize: 11),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          GestureDetector(
              onTap: iconOnTap,
              child: const Icon(
                Icons.play_arrow_outlined,
                size: 50,
                color: kLightBlue,
              )),
        ],
      ),
    );
  }
}
