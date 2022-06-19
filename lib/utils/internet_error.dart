import 'package:flutter/material.dart';
import 'package:task_video_filter/bloc/network/network_cubit.dart';

class InternetError extends StatelessWidget {
  const InternetError({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text),
          SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 42, vertical: 12),
              ),
              onPressed: () {
                // NetworkCubit.init();
              },
              child: Text(
                'try again',
                style: TextStyle(fontSize: 15),
              ),
            ),
          )
        ],
      ),
    );
  }
}
