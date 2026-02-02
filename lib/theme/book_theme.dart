import 'package:flutter/material.dart';

enum BookThemeType { pink, sunset, yellow, forest, midnight, purple, gray }

class BookTheme {
  // Theme state is now managed by ThemeViewModel (Riverpod)

  static List<Color> getPalette(BookThemeType type) {
    switch (type) {
      case BookThemeType.pink: // Lovely Pink
        return const [
          Color(0xFFFFF5F6), // 딸기 우유 거품
          Color(0xFFFFEBF0), // 연한 파스텔 핑크
          Color(0xFFFFCDD2), // 베이비 핑크
          Color(0xFFF8BBD0), // 소프트 핑크
          Color(0xFFF06292), // 화사한 산호 핑크
        ];
      case BookThemeType.sunset: // Bright Orange Gradient
        return const [
          Color(0xFFFFF3E0), // 크림
          Color(0xFFFFE0B2), // 살구
          Color(0xFFFFCC80), // 오렌지 필
          Color(0xFFFFB74D), // 망고
          Color(0xFFFFA726), // 밝은 오렌지
        ];
      case BookThemeType.yellow: // Lemon Yellow
        return const [
          Color(0xFFFFFBFA), // 웜 화이트
          Color(0xFFFFF9C4), // 연한 버터
          Color(0xFFFFF59D), // 파스텔 옐로우
          Color(0xFFFFF176), // 해바라기
          Color(0xFFFFD54F), // 골든 옐로우
        ];
      case BookThemeType.forest: // Eye Comfort Green
        return const [
          Color(0xFFF1F8E9), // 연한 라임
          Color(0xFFDCEDC8), // 세이지 그린
          Color(0xFFAED581), // 올리브
          Color(0xFF7CB342), // 리프 그린
          Color(0xFF33691E), // 딥 포레스트
        ];
      case BookThemeType.midnight: // Dawn to Deep Sea
        return const [
          Color(0xFFECEFF1), // 미스트 그레이
          Color(0xFFCFD8DC), // 블루 그레이
          Color(0xFF90A4AE), // 스톤 블루
          Color(0xFF546E7A), // 슬레이트
          Color(0xFF37474F), // 차콜 네이비
        ];
      case BookThemeType.purple: // Dreamy Lavender
        return const [
          Color(0xFFFAFAFF), // 라벤더 화이트
          Color(0xFFF3E5F5), // 연한 라일락
          Color(0xFFE1BEE7), // 파스텔 보라
          Color(0xFFCE93D8), // 부드러운 오키드
          Color(0xFFBA68C8), // 밝은 라벤더
        ];
      case BookThemeType.gray: // Urban Gray
        return const [
          Color(0xFFFAFAFA), // 거의 흰색
          Color(0xFFF5F5F5), // 라이트 그레이
          Color(0xFFE0E0E0), // 실버
          Color(0xFFBDBDBD), // 미디엄 그레이
          Color(0xFF757575), // 스틸 그레이
        ];
    }
  }

  static String getName(BookThemeType type) {
    switch (type) {
      case BookThemeType.pink:
        return "Lovely Pink 💗";
      case BookThemeType.sunset:
        return "Sunset Orange 🍊";
      case BookThemeType.yellow:
        return "Lemon Yellow 🍋";
      case BookThemeType.forest:
        return "Forest Shadow 🌳";
      case BookThemeType.midnight:
        return "Midnight Blue 🌌";
      case BookThemeType.purple:
        return "Dreamy Lavender 🦄";
      case BookThemeType.gray:
        return "Urban Gray 🌫️";
    }
  }
}
