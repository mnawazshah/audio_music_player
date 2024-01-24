// import 'package:flutter/material.dart';

// class MyDraggableSheet extends StatefulWidget {
//   const MyDraggableSheet({super.key});

//   @override
//   State<MyDraggableSheet> createState() => _MyDraggableSheetState();
// }

// // it's a stateful widget!
// class _MyDraggableSheetState extends State<MyDraggableSheet> {
//   final _sheet = GlobalKey();
//   final _controller = DraggableScrollableController();
//   var smallPlayer = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _controller.addListener(_onChanged);
//   }

//   void _onChanged() {
//     final currentSize = _controller.size;
//     if (currentSize <= 0.05) _collapse();
//     if (currentSize <= 0.25) {
//       _anchor();
//       smallPlayer = 0.25;
//     }
//   }

//   void _collapse() => _animateSheet(sheet.snapSizes!.first);

//   void _anchor() => _animateSheet(sheet.snapSizes!.last);

//   void _expand() => _animateSheet(sheet.maxChildSize);

//   void _hide() => _animateSheet(sheet.minChildSize);

//   void _animateSheet(double size) {
//     _controller.animateTo(
//       size,
//       duration: const Duration(milliseconds: 50),
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }

//   DraggableScrollableSheet get sheet =>
//       (_sheet.currentWidget as DraggableScrollableSheet);

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       return DraggableScrollableSheet(
//         key: _sheet,
//         initialChildSize: 1,
//         maxChildSize: 1,
//         minChildSize: 0,
//         expand: true,
//         snap: true,
//         snapSizes: const [
//           0.25,
//           1,
//         ],
//         controller: _controller,
//         builder: (BuildContext context, ScrollController scrollController) {
//           return smallPlayer == 0.25
//               ? DecoratedBox(
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(12),
//                       topRight: Radius.circular(12),
//                     ),
//                   ),
//                   child: CustomScrollView(
//                     controller: scrollController,
//                     slivers: [
//                       const SliverToBoxAdapter(
//                         child: Text('I am short'),
//                       ),
//                       SliverList.list(
//                         children: const [
//                           Text('I am at 0.25'),
//                         ],
//                       ),
//                     ],
//                   ),
//                 )
//               : DecoratedBox(
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(12),
//                       topRight: Radius.circular(12),
//                     ),
//                   ),
//                   child: CustomScrollView(
//                     controller: scrollController,
//                     slivers: [
//                       const SliverToBoxAdapter(
//                         child: Text('Title'),
//                       ),
//                       SliverList.list(
//                         children: const [
//                           Text('Content'),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//         },
//       );
//     });
//   }
// }

import 'package:audio_music_player/app/modules/home/controllers/home_controller.dart';
import 'package:audio_music_player/app/modules/home/models/position_data_model.dart';
import 'package:audio_music_player/app/theme/app_colors.dart';
import 'package:audio_music_player/app/widgets/audio_bar.dart';
import 'package:audio_music_player/app/widgets/controls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getX;
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class SongDetailView extends StatefulWidget {
  const SongDetailView({super.key});

  @override
  State<SongDetailView> createState() => _SongDetailViewState();
}

class _SongDetailViewState extends State<SongDetailView> {
  AudioPlayer audioPlayer = AudioPlayer();
  var url = getX.Get.arguments["url"];
  var index = getX.Get.arguments["index"];
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position: position,
              bufferedPosition: bufferedPosition,
              duration: duration ?? Duration.zero));

  @override
  void initState() {
    super.initState();
    // audioPlayer = AudioPlayer();
    init();
    // ..setAudioSource(AudioSource.uri(Uri.parse(uri)));
  }

  Future<void> init() async {
    await audioPlayer.setLoopMode(LoopMode.all);
    await audioPlayer.setAudioSource(Get.find<HomeController>().playList,
        initialIndex: index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: transparent,
          elevation: 0,
        ),
        body: Container(
            decoration: BoxDecoration(gradient: playerBG),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      final positionData = snapshot.data;

                      return audioBar(
                          positionData: positionData, audioPlayer: audioPlayer);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Controls(player: audioPlayer,index: index,)
                ],
              ),
            )),
            );
  }
}
