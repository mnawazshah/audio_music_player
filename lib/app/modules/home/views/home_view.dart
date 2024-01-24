import 'package:audio_music_player/app/modules/home/models/position_data_model.dart';
import 'package:audio_music_player/app/theme/app_colors.dart';
import 'package:audio_music_player/app/widgets/audio_bar.dart';
import 'package:audio_music_player/app/widgets/controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rx;

// import 'package:sliding_sheet/sliding_sheet.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  var audioPlayer = AudioPlayer();

  Stream<PositionData> get _positionDataStream =>
      rx.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position: position,
              bufferedPosition: bufferedPosition,
              duration: duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          'Available Nasheeds',
          style: TextStyle(color: whiteColor),
        ),
        centerTitle: true,
        backgroundColor: transparent,
      ),
      body: FutureBuilder(
        future: controller.fetchAudioFiles(),
        // initialData: InitialData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: controller.audioFileURLs.length,
              itemBuilder: (BuildContext context, int index) {
                int startIndex =
                    controller.audioFileURLs[index].indexOf("/o/") +
                        3; // Adding 3 to skip "/o/"
                int endIndex = controller.audioFileURLs[index].indexOf(".mp3");
                String nasheedTitle = controller.audioFileURLs[index]
                    .substring(startIndex, endIndex);
                nasheedTitle = nasheedTitle.replaceAll("-", " ").capitalize!;

                return GestureDetector(
                  onTap: () async {
                    // controller.playNasheed(
                    //     controller.audioFileURLs[index], index);
                    // Get.to(
                    //   () => const SongDetailView(),
                    //   arguments: {
                    //     "url": controller.audioFileURLs[index],
                    //     "index": index
                    //   },
                    // );
                    controller.playNasheed(index);
                    await audioPlayer.setLoopMode(LoopMode.all);
                    await audioPlayer.setAudioSource(controller.playList,
                        initialIndex: index);
                    audioPlayer.play();

                    Get.isBottomSheetOpen != null
                        ? Get.bottomSheet(
                            Container(
                                decoration: BoxDecoration(gradient: playerBG),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        nasheedTitle,
                                        style: TextStyle(
                                            color: whiteColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      StreamBuilder<PositionData>(
                                        stream: _positionDataStream,
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          final positionData = snapshot.data;

                                          return audioBar(
                                              positionData: positionData,
                                              audioPlayer: audioPlayer);
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Controls(
                                        player: audioPlayer,
                                        index: index,
                                      )
                                    ],
                                  ),
                                )),
                          )
                        : null;

                    // showPlayer(context);
                  },
                  child: Obx(() => ListTile(
                        title: Text(
                          nasheedTitle,
                          style: TextStyle(
                              color: controller.playIndex.value == index &&
                                      controller.isPlaying.value
                                  ? greenColor
                                  : whiteColor),
                        ),
                        leading:
                            const CircleAvatar(child: Icon(Icons.music_note)),
                        trailing: controller.playIndex.value == index &&
                                controller.isPlaying.value
                            ? const Icon(Icons.play_arrow)
                            : null,
                      )),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
        },
      ),
    );
  }

  // Future showPlayer(context) => showSlidingBottomSheet(
  //       context,
  //       builder: (context) => SlidingSheetDialog(
  //         // color: ,
  //         color: playerColor,
  //         snapSpec: const SnapSpec(
  //           initialSnap: 1,
  //           snappings: [0.3, 1],
  //         ),
  //         builder: (context, state) => Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Flexible(
  //                 child: SizedBox(
  //               height: MediaQuery.of(context).size.height / 2,
  //               // color: Colors.red,
  //               child: const CircleAvatar(
  //                 child: Icon(Icons.music_note),
  //               ),
  //             )),
  //             const SizedBox(
  //               height: 14,
  //             ),
  //             Flexible(
  //                 // flex: 5,
  //                 child: Container(
  //               color: Colors.white,
  //               height: MediaQuery.of(context).size.height / 2,
  //             ))
  //             // Expanded(
  //             //     child: Container(
  //             //       height: 300,
  //             //   color: Colors.green,
  //             // )),
  //           ],
  //         ),
  //       ),
  //     );
}
