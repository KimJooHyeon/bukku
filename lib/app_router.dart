import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'views/main_layout.dart'; // [New] MainLayout
import 'views/add_book_view.dart';
import 'views/book_detail_view.dart';
import 'views/report/report_view.dart';
import 'models/book_model.dart';
// HomeView import removed (MainLayout handles it)

import 'features/auth/presentation/login_screen.dart'; // [New] LoginScreen
import 'features/auth/presentation/providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login', // [Modified] Start with Login Screen
    redirect: (context, state) {
      // 1. Auth State Check
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.uri.toString() == '/login';

      // 2. Loading State Handling (Optional: Show Splash)
      if (authState.isLoading) return null;

      // 3. Redirect Logic
      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/';

      return null;
    },
    routes: [
      // 0. 로그인 화면
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      // 1. 홈 화면 (메인 레이아웃: 서재/앨범/리포트/설정 탭 포함)
      GoRoute(path: '/', builder: (context, state) => const MainLayout()),
      // 2. 책 추가 화면
      GoRoute(path: '/add', builder: (context, state) => const AddBookView()),
      // 3. 책 상세 화면 (Book 객체 전달 필요)
      // 3. 책 상세 화면 (ID 필수, 객체 선택)
      GoRoute(
        path: '/detail/:bookId',
        builder: (context, state) {
          final bookId = state.pathParameters['bookId']!;
          final book = state.extra as Book?;
          return BookDetailView(bookId: bookId, book: book);
        },
      ),
      GoRoute(path: '/report', builder: (context, state) => const ReportView()),
    ],
  );
});
