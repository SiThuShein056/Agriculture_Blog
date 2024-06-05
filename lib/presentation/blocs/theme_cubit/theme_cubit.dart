part of 'theme_cubit_import.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(super.initialState);

  final SharedPreferences _shf = Injection<SharedPreferences>();
  void toggleTheme() {
    var isDarkTheme = state == ThemeMode.dark;
    _shf.setBool("current_theme", !isDarkTheme);
    emit(isDarkTheme ? ThemeMode.light : ThemeMode.dark);
  }
}
