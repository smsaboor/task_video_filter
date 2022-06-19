import 'package:flutter/material.dart';
import 'package:task_video_filter/constants.dart';

class CustomSnackBar{
  static snackBar({required BuildContext context, required String data, required Color color}){
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar( content: Padding(
          padding: EdgeInsets.only(left: 130.0),
          child: Text(data)
      ),
        backgroundColor: color,
        behavior: SnackBarBehavior.fixed));
  }
}
