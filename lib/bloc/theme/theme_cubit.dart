import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:task_video_filter/configs/core_theme.dart';
part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(isDarkThemeOn: false));
  void toggleSwitch(bool value) => emit(ThemeState(isDarkThemeOn: value));
}