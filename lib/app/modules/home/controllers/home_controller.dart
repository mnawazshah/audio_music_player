// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class HomeController extends GetxController {
  RxList<String> audioFileURLs = <String>[].obs;
  final audioPlayer = AudioPlayer();
  var playIndex = 0.obs;
  var isPlaying = false.obs;
  var playList;

  Future<void> fetchAudioFiles() async {
    try {
      // await Firebase.initializeApp();
      Reference storageReference = FirebaseStorage.instance.ref();
      ListResult result = await storageReference.listAll();

      List<String> urls = [];
      List<AudioSource> sources = [];

      for (Reference ref in result.items) {
        String downloadURL = await ref.getDownloadURL();
        urls.add(downloadURL);
      }
      int id = 0;
      audioFileURLs.assignAll(urls);

      for (var source in audioFileURLs) {
        int startIndex =
            audioFileURLs[id].indexOf("/o/") + 3; // Adding 3 to skip "/o/"
        int endIndex = audioFileURLs[id].indexOf(".mp3");
        String nasheedTitle = audioFileURLs[id].substring(startIndex, endIndex);
        nasheedTitle = nasheedTitle.replaceAll("-", " ").capitalize!;
        id++;

        sources.add(AudioSource.uri(Uri.parse(source),
            tag: MediaItem(id: "$id", title: nasheedTitle)));
      }

      playList = ConcatenatingAudioSource(children: sources);
    } catch (error) {
      print('Error fetching audio files: $error');
    }
  }

  playNasheed(index) {
    playIndex.value = index;
    try {
      // audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri)));
      // audioPlayer.play();
      isPlaying(true);
    } catch (e) {
      print(e);
    }
  }
}
