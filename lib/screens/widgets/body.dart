// import 'dart:typed_data';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:task_video_filter/screens/widgets/apply_function.dart';
// import 'package:task_video_filter/utils/util.dart';
// import 'package:video_player/video_player.dart';
//
// class BodyScreen extends StatelessWidget {
//   BodyScreen(
//       {Key? key,
//         required this.videoPlayercontroller,
//         required this.isLoading,
//         required this.matrix,
//         required this.selectedFilter,
//         required this.stream,
//         required this.selectedIndex,
//         required this.file})
//       : super(key: key);
//   XFile? file;
//   VideoPlayerController videoPlayercontroller;
//   ValueNotifier<bool> isLoading = ValueNotifier(false);
//   late String matrix;
//   List<double> selectedFilter = noFilter;
//   Stream<Uint8List>? stream;
//   num selectedIndex = -1;
//  
//   @override
//   Widget build(BuildContext context) {
//     if (videoPlayercontroller == null) {
//       return const Center(
//         child: Text(
//           'Please select any video',
//           textAlign: TextAlign.center,
//         ),
//       );
//     }
//     if (videoPlayercontroller?.value.isInitialized ?? false) {
//       return Stack(
//         children: [
//           SafeArea(
//             child: Column(
//               children: [
//                 GestureDetector(
//                   onTap: () async {
//                     if (videoPlayercontroller?.value.isPlaying ??
//                         false) {
//                       await videoPlayercontroller?.pause();
//                     } else {
//                       await videoPlayercontroller?.play();
//                     }
//                     setState(() {});
//                   },
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 20.0, vertical: 10),
//                         child: AspectRatio(
//                           aspectRatio: 1.0,
//                           child: ColorFiltered(
//                               colorFilter:
//                                   ColorFilter.matrix(selectedFilter),
//                               child: VideoPlayer(videoPlayercontroller)),
//                         ),
//                       ),
//                       Visibility(
//                         visible:
//                             !(videoPlayercontroller!.value.isPlaying),
//                         child: Container(
//                           width: 40,
//                           height: 40,
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                           ),
//                           child:
//                               const Icon(Icons.play_arrow, color: Colors.black),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 50),
//                 StreamBuilder(
//                   stream: stream,
//                   builder: (_, AsyncSnapshot<Uint8List> snapshot) {
//                     final data = snapshot.data;
//                     return snapshot.hasData
//                         ? SizedBox(
//                             height: 90,
//                             child: ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 10),
//                               itemCount: filterList.length,
//                               itemBuilder: (_, int index) {
//                                 return GestureDetector(
//                                   onTap: () {
//                                     selectedFilter = filterList[index];
//                                     selectedIndex = index;
//                                     List<double> tempList =
//                                         List.from(filterList[index]);
//
//                                     for (int i = filterList[index].length - 1;
//                                         i > 0;
//                                         i -= 5) {
//                                       tempList.removeAt(i);
//                                     }
//                                     debugPrint(
//                                         'tempList ==> ${tempList.length}');
//                                     matrix = tempList
//                                         .toString()
//                                         .replaceAll(',', ':');
//                                     matrix =
//                                         matrix.replaceAll(' ', '');
//                                     matrix =
//                                         matrix.replaceAll('[', '');
//                                     matrix =
//                                         matrix.replaceAll(']', '');
//                                     debugPrint('matrix ==> $matrix');
//                                     setState(() {});
//                                   },
//                                   child: Container(
//                                     margin: const EdgeInsets.only(right: 10.0),
//                                     decoration: BoxDecoration(
//                                         border: selectedIndex != index
//                                             ? Border.all(
//                                                 color: Colors.transparent,
//                                                 width: 3)
//                                             : Border.all(
//                                                 color: Colors.blue, width: 3)),
//                                     child: ColorFiltered(
//                                       colorFilter:
//                                           ColorFilter.matrix(filterList[index]),
//                                       child: Image(
//                                         image: MemoryImage(data!),
//                                         width: 80,
//                                         height: 40,
//                                         fit: BoxFit.fill,
//                                         alignment: Alignment.topLeft,
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           )
//                         : const SizedBox();
//                   },
//                 ),
//                 const SizedBox(
//                   height: 80,
//                 ),
//                 ValueListenableBuilder(
//                   valueListenable: isLoading,
//                   builder: (BuildContext context, value, Widget? child) {
//                     return isLoading.value
//                         ? Container(
//                             color: Colors.grey.withOpacity(0.2),
//                             child: const CircularProgressIndicator())
//                         : Container(
//                             height: 10,
//                           );
//                   },
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 ElevatedButton(
//                   style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(Colors.red),
//                       padding:
//                           MaterialStateProperty.all(const EdgeInsets.all(15)),
//                       textStyle: MaterialStateProperty.all(
//                           const TextStyle(fontSize: 16))),
//                   onPressed: applyFilter(
//                       videoPlayercontroller: videoPlayercontroller,
//                       isLoading: isLoading,
//                       matrix: matrix,
//                       selectedFilter: selectedFilter,
//                       stream: stream,
//                       selectedIndex: selectedIndex,
//                       file: file,
//                       context: context),
//                   child: const Text(
//                     'Apply Filter',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       );
//     } else {
//       return const Center(child: CircularProgressIndicator());
//     }
//   }
// }
