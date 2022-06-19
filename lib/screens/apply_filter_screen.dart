import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_video_filter/bloc/theme/theme_cubit.dart';
import 'package:task_video_filter/constants.dart';
import 'package:task_video_filter/screens/filtered_video_screen.dart';
import 'package:task_video_filter/screens/widgets/apply_function.dart';
import 'package:task_video_filter/utils/util.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/return_code.dart';
import 'package:ffmpeg_kit_flutter_min_gpl/session.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class ApplyFilterScreen extends StatefulWidget {
  const ApplyFilterScreen({Key? key}) : super(key: key);

  @override
  _ApplyFilterScreenState createState() => _ApplyFilterScreenState();
}

class _ApplyFilterScreenState extends State<ApplyFilterScreen> {
  final ImagePicker _picker = ImagePicker();

  XFile?
  file; // It wraps the bytes of a selected file, and its (platform-dependant) path.

  // Controls a platform video player, and provides updates when the state is changing.
  // Instances must be initialized with initialize.
  VideoPlayerController? _videoPlayercontroller;

  Stream<Uint8List>?
  _stream; //prefer using Uint8List for bytes . A fixed-length list of 8-bit unsigned integers.
  num selectedIndex = -1;

  // ValueNotifier is a special type of class that extends Changenotifier, which can hold a single value
  // and notifies the widgets which are listening to it whenever its holding value gets change.
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  late String matrix;
  List<double> selectedFilter = noFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _displayVideo(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () async {
          file = await _picker.pickVideo(source: ImageSource.gallery);
          if (file != null) {
            _videoPlayercontroller =
                VideoPlayerController.file(File(file!.path));
            await _videoPlayercontroller?.initialize();
            _stream = getVideoThumbnails(file);
            await _videoPlayercontroller?.pause();
            setState(() {});
          }
        },
        tooltip: 'Pick Video',
        child: const Icon(Icons.video_library),
      ),
    );
  }

  Widget _displayVideo() {
    if (_videoPlayercontroller == null) {
      return const Center(
        child: Text(
          TX_SELECT_VIDEO,
          textAlign: TextAlign.center,
        ),
      );
    }
    if (_videoPlayercontroller?.value.isInitialized ?? false) {
      return Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    return Switch(
                      value: state.isDarkThemeOn,
                      onChanged: (newValue) {
                        context.read<ThemeCubit>().toggleSwitch(newValue);
                      },
                    );
                  },
                ),
                GestureDetector(
                  onTap: () async {
                    if (_videoPlayercontroller?.value.isPlaying ?? false) {
                      await _videoPlayercontroller?.pause();
                    } else {
                      await _videoPlayercontroller?.play();
                    }
                    setState(() {});
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: ColorFiltered(
                              colorFilter: ColorFilter.matrix(selectedFilter),
                              child: VideoPlayer(_videoPlayercontroller!)),
                        ),
                      ),
                      Visibility(
                        visible: !(_videoPlayercontroller!.value.isPlaying),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child:
                          const Icon(Icons.play_arrow, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                StreamBuilder(
                  stream: _stream,
                  builder: (_, AsyncSnapshot<Uint8List> snapshot) {
                    final data = snapshot.data;
                    return snapshot.hasData
                        ? SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: filterList.length,
                        itemBuilder: (_, int index) {
                          return GestureDetector(
                            onTap: () {
                              selectedFilter = filterList[index];
                              selectedIndex = index;
                              List<double> tempList =
                              List.from(filterList[index]);

                              for (int i = filterList[index].length - 1;
                              i > 0;
                              i -= 5) {
                                tempList.removeAt(i);
                              }
                              debugPrint(
                                  'tempList ==> ${tempList.length}');
                              matrix = tempList
                                  .toString()
                                  .replaceAll(',', ':');
                              matrix = matrix.replaceAll(' ', '');
                              matrix = matrix.replaceAll('[', '');
                              matrix = matrix.replaceAll(']', '');
                              debugPrint('matrix ==> $matrix');
                              setState(() {});
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10.0),
                              decoration: BoxDecoration(
                                  border: selectedIndex != index
                                      ? Border.all(
                                      color: Colors.transparent,
                                      width: 3)
                                      : Border.all(
                                      color: Colors.blue, width: 3)),
                              child: ColorFiltered(
                                colorFilter:
                                ColorFilter.matrix(filterList[index]),
                                child: Image(
                                  image: MemoryImage(data!),
                                  width: 80,
                                  height: 40,
                                  fit: BoxFit.fill,
                                  alignment: Alignment.topLeft,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                        : const SizedBox();
                  },
                ),
                const SizedBox(
                  height: 80,
                ),
                ValueListenableBuilder(
                  valueListenable: isLoading,
                  builder: (BuildContext context, value, Widget? child) {
                    return isLoading.value
                        ? Container(
                        color: Colors.grey.withOpacity(0.2),
                        child: const CircularProgressIndicator())
                        : Container(
                      height: 10,
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      padding:
                      MaterialStateProperty.all(const EdgeInsets.all(15)),
                      textStyle: MaterialStateProperty.all(
                          const TextStyle(fontSize: 16))),
                  onPressed: applyFilter,
                  child: const Text(
                    TX_BUTON_APPLY_FILTER,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }


  void applyFilter() async {
    try {
      _videoPlayercontroller?.pause();
      isLoading.value = true;
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String outputPath = appDocPath + "/output${DateTime.now().microsecondsSinceEpoch}.mp4";
      String _command =
          "-i ${file!.path} -vf colorchannelmixer=$matrix -preset superfast -pix_fmt yuv420p -y $outputPath";
      await FFmpegKit.executeAsync(
        _command,
        (Session session) async {
          final returnCode = await session.getReturnCode();
          if (ReturnCode.isSuccess(returnCode)) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FilteredVideoScreen(
                          file: File(outputPath),
                        )));
            isLoading.value = false;
          } else {
            isLoading.value = false;
            debugPrint("failed.");
          }
        },
      );
    } catch (e) {
      isLoading.value = true;
      debugPrint('Error ===> $e');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    FFmpegKit.cancel();
    _videoPlayercontroller?.dispose();
    super.dispose();
  }
}
