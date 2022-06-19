import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_video_filter/bloc/network/network_cubit.dart';
import 'package:task_video_filter/constants.dart';
import 'package:task_video_filter/screens/apply_filter_screen.dart';
import 'package:task_video_filter/utils/custom_snackbaar.dart';
import 'package:task_video_filter/utils/internet_error.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext buildContext) {
    return  BlocConsumer<NetworkCubit, NetworkState>(
      listener: (context, state) {
        if (state == NetworkState.initial) {
          CustomSnackBar.snackBar(
              context: buildContext, data: TX_OFFLINE, color: Colors.red);
        }
        else if (state == NetworkState.gained) {
          CustomSnackBar.snackBar(
              context: buildContext, data: TX_ONLINE, color: Colors.green);
        } else if (state == NetworkState.lost) {
          CustomSnackBar.snackBar(
              context: buildContext, data: TX_OFFLINE, color: Colors.red);
        }
        else {
          CustomSnackBar.snackBar(
              context: buildContext, data: 'error', color: Colors.red);
        }
      },
      builder: (context, state) {
        if (state == NetworkState.initial) {
          return InternetError(text: TX_CHECK_INTERNET);
        } else if (state == NetworkState.gained) {
          return ApplyFilterScreen();
        } else if (state == NetworkState.lost) {
          return InternetError(text: TX_LOST_INTERNET);
        } else
          return InternetError(text: 'error');
      },
    );
  }
}
