import 'package:shared_preferences/shared_preferences.dart';
import '../theme/book_theme.dart';

class ThemeRepository {
  final SharedPreferences _prefs;
  static const String _themeKey = 'selected_theme';

  ThemeRepository(this._prefs);

  // 현재 저장된 테마 불러오기 (없으면 null 반환)
  BookThemeType? loadTheme() {
    final String? themeString = _prefs.getString(_themeKey);
    if (themeString == null) return null;

    try {
      // "BookThemeType.gray" -> "gray" 매칭
      return BookThemeType.values.firstWhere(
        (e) => e.name == themeString,
        orElse: () => BookThemeType.gray,
      );
    } catch (_) {
      return null;
    }
  }

  // 테마 저장하기
  Future<void> saveTheme(BookThemeType theme) async {
    await _prefs.setString(_themeKey, theme.name);
  }
}
