
part of 'theme_cubit.dart';

class ThemeState {
  final bool isDarkThemeOn;
  ThemeData? currentTheme;
  ThemeState({required this.isDarkThemeOn}) {
    if (isDarkThemeOn) {
      currentTheme = themeDark;
    } else {
      currentTheme = themeLight;
    }
  }
}