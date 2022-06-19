
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FilteredVideoScreen extends StatefulWidget {
  const FilteredVideoScreen({Key? key, required this.file}) : super(key: key);
  final File file;
  @override
  _FilteredVideoScreenState createState() => _FilteredVideoScreenState();
}

class _FilteredVideoScreenState extends State<FilteredVideoScreen> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    init();
    super.initState();
  }
  init() async {
    _controller = VideoPlayerController.file(widget.file);
    await _controller.initialize();
    await _controller.pause();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: playNpause,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: AspectRatio(
                  aspectRatio: 0.8,
                  child: _controller != null && _controller.value.isInitialized
                      ? VideoPlayer(_controller)
                      : Container(),
                ),
              ),
              Visibility(
                visible: !_controller.value.isPlaying,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  playNpause() async {
    if (_controller.value.isPlaying) {
      await _controller.pause();
    } else {
      await _controller.play();
    }
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
}
