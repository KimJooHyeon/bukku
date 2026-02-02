import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/theme_repository.dart';
import '../theme/book_theme.dart';

// [Provider] SharedPreferences 인스턴스 (main.dart에서 override 필요)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

// [Repository Provider]
final themeRepositoryProvider = Provider<ThemeRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeRepository(prefs);
});

// [ViewModel Provider]
final themeViewModelProvider = NotifierProvider<ThemeViewModel, BookThemeType>(
  ThemeViewModel.new,
);

class ThemeViewModel extends Notifier<BookThemeType> {
  late final ThemeRepository _repository;

  @override
  BookThemeType build() {
    _repository = ref.watch(themeRepositoryProvider);
    // 초기값 로드
    return _repository.loadTheme() ?? BookThemeType.gray;
    // 저장된 값이 없으면 기본값 Gray
  }

  // 테마 변경 및 저장
  Future<void> setTheme(BookThemeType theme) async {
    state = theme; // 상태 업데이트 (UI 갱신)
    await _repository.saveTheme(theme); // 로컬 저장
  }
}
