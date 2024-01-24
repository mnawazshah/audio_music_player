import 'package:audio_music_player/app/modules/home/controllers/home_controller.dart';
import 'package:audio_music_player/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class Controls extends StatelessWidget {
  const Controls({super.key, required this.player, required this.index});

  final AudioPlayer player;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              player.seekToPrevious();
              Get.find<HomeController>().playNasheed(index);
            },
            icon: Icon(
              Icons.skip_previous,
              color: whiteColor,
              size: 60,
            )),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          // initialData: initialData,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (!(playing ?? false)) {
              return IconButton(
                  onPressed: player.play,
                  icon: Icon(
                    Icons.play_arrow,
                    color: whiteColor,
                    size: 80,
                  ));
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                  onPressed: player.pause,
                  icon: Icon(
                    Icons.pause,
                    size: 80,
                    color: whiteColor,
                  ));
            } else {
              return Icon(
                Icons.play_arrow,
                color: whiteColor,
                size: 80,
              );
            }
          },
        ),
        IconButton(
            onPressed: () {
              player.seekToNext();
              Get.find<HomeController>().playNasheed(index);
            },
            icon: Icon(
              Icons.skip_next,
              color: whiteColor,
              size: 60,
            )),
      ],
    );
  }
}
