//
//
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_min_gpl/return_code.dart';
// import 'package:ffmpeg_kit_flutter_min_gpl/session.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:task_video_filter/screens/filtered_video_screen.dart';
//
//
// applyFilter({
//   required videoPlayercontroller,
//   required isLoading,
//   required matrix,
//   required selectedFilter,
//   required stream,required selectedIndex,required file,required context}) async {
//     try {
//       videoPlayercontroller?.pause();
//       isLoading.value = true;
//       Directory appDocDir = await getApplicationDocumentsDirectory();
//       String appDocPath = appDocDir.path;
//       String outputPath = appDocPath + "/output${DateTime.now().microsecondsSinceEpoch}.mp4";
//       String _command =
//           "-i ${file!.path} -vf colorchannelmixer=$matrix -preset superfast -pix_fmt yuv420p -y $outputPath";
//       await FFmpegKit.executeAsync(
//         _command,
//             (Session session) async {
//           final returnCode = await session.getReturnCode();
//           if (ReturnCode.isSuccess(returnCode)) {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => FilteredVideoScreen(
//                       file: File(outputPath),
//                     )));
//             isLoading.value = false;
//           } else {
//             isLoading.value = false;
//             debugPrint("failed.");
//           }
//         },
//       );
//     } catch (e) {
//       isLoading.value = true;
//       debugPrint('Error ===> $e');
//     }
//   }
