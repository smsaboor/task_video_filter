import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_video_filter/bloc/network/network_cubit.dart';
import 'package:task_video_filter/bloc/theme/theme_cubit.dart';
import 'package:task_video_filter/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await NetworkCubit.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (BuildContext context) => ThemeCubit(),
        ),
        BlocProvider<NetworkCubit>(
          create: (BuildContext context) => NetworkCubit.instence,
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Video Filter',
            debugShowCheckedModeBanner: false,
            color: Colors.blue,
            theme: themeState.currentTheme,
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                      textScaleFactor:
                      MediaQuery.of(context).textScaleFactor < 1
                          ? MediaQuery.of(context).textScaleFactor
                          : 1),

                  child: child!);
            },
           home: HomeScreen(),
          );
        },
      ),
    );
  }
}
