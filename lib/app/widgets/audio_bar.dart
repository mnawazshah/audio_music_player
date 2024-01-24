import 'package:audio_music_player/app/theme/app_colors.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class audioBar extends StatelessWidget {
  const audioBar({
    super.key,
    required this.positionData,
    required this.audioPlayer,
  });

  final positionData;
  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return ProgressBar(
      progress: positionData?.position ?? Duration.zero,
      total: positionData?.duration ?? Duration.zero,
      buffered: positionData?.bufferedPosition ?? Duration.zero,
      onSeek: audioPlayer.seek,
      baseBarColor: whiteColor,
      bufferedBarColor: Colors.grey,
      progressBarColor: greenColor,
      thumbColor: greenColor,
      timeLabelTextStyle: TextStyle(color: whiteColor),
    );
  }
}
