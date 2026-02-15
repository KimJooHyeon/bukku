import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/book_repository.dart';
import '../models/book_model.dart';
import '../features/auth/presentation/providers/auth_provider.dart';

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return BookRepository();
});

final bookListProvider = StreamProvider<List<Book>>((ref) {
  // 인증 상태 변화 감지 (로그인/로그아웃 시 스트림 재구독)
  final userAsync = ref.watch(authStateProvider);

  // 로딩 중이거나 에러가 있거나, 유저가 없는 경우 처리
  return userAsync.when(
    data: (user) {
      if (user == null) return Stream.value([]);
      final repository = ref.watch(bookRepositoryProvider);
      return repository.getBooksStream();
    },
    loading: () => Stream.value([]), // 로딩 중에는 빈 리스트 (또는 로딩 상태 유지)
    error: (_, __) => Stream.value([]),
  );
});
