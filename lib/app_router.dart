import 'package:go_router/go_router.dart';

import 'views/main_layout.dart'; // [New] MainLayout
import 'views/add_book_view.dart';
import 'views/book_detail_view.dart';
import 'views/report/report_view.dart';
import 'models/book_model.dart';
// HomeView import removed (MainLayout handles it)

import 'features/auth/presentation/login_screen.dart'; // [New] LoginScreen

final routerConfig = GoRouter(
  initialLocation: '/login', // [Modified] Start with Login Screen
  routes: [
    // 0. 로그인 화면
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    // 1. 홈 화면 (메인 레이아웃: 서재/앨범/리포트/설정 탭 포함)
    GoRoute(path: '/', builder: (context, state) => const MainLayout()),
    // 2. 책 추가 화면
    GoRoute(path: '/add', builder: (context, state) => const AddBookView()),
    // 3. 책 상세 화면 (Book 객체 전달 필요)
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        // extra로 전달된 Book 객체를 받음
        final book = state.extra as Book;
        return BookDetailView(book: book);
      },
    ),
    GoRoute(path: '/report', builder: (context, state) => const ReportView()),
  ],
);
