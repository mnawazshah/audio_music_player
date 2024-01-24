import 'package:audio_music_player/app/class/audio_meta_data_class.dart';

class AudioCompleteDataClass {
  final String audioUrl;
  final AudioMetadataInfoClass audioMetadataInfo;
  // AudioPlayerState playerState;
  bool deleted;

  AudioCompleteDataClass(this.audioUrl, this.audioMetadataInfo, this.deleted);
}
