import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart'; // [New] for XFile

import '../models/book_model.dart';
import '../repositories/book_repository.dart';

// ... class definition ...

// ... (BookViewModel class definition start)

class BookViewModel extends StreamNotifier<List<Book>> {
  // 현재 필터 상태 (private default)
  String _filter = 'ALL';
  // [Search] 검색어 상태
  String _searchQuery = '';

  @override
  Stream<List<Book>> build() {
    // Repository의 Stream을 구독.
    final repository = ref.watch(bookRepositoryProvider);

    return repository.getBooksStream(status: _filter).map((books) {
      if (_searchQuery.isEmpty) return books;

      // 검색어로 필터링 (제목 or 작가)
      return books.where((book) {
        final query = _searchQuery.toLowerCase();
        final title = book.title.toLowerCase();
        final author = book.author.toLowerCase();
        return title.contains(query) || author.contains(query);
      }).toList();
    });
  }

  // 필터 변경 메서드
  void setFilter(String status) {
    if (_filter == status) return;
    _filter = status;
    // build()를 재실행시켜 새로운 Stream을 구독하게 함
    ref.invalidateSelf();
  }

  // [Search] 검색어 설정
  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    // 검색어가 바뀌면 필터링 다시 수행 (invalidate)
    ref.invalidateSelf();
  }

  // [Actions] CRUD 메서드들
  // UI는 ViewModel을 통해 Repository에 접근
  Future<void> addBook(Book book, {XFile? coverImage}) async {
    final repository = ref.read(bookRepositoryProvider);
    String coverUrl = '';

    // 이미지가 있으면 업로드
    if (coverImage != null) {
      // 임시 UserId (로그인 기능이 없으므로 device id나 fixed string 사용)
      const userId = 'guest_user';
      coverUrl = await repository.uploadBookCover(coverImage, userId);
    }

    // 업로드된 URL을 Book 객체에 적용
    final newBook = book.copyWith(coverUrl: coverUrl);

    await repository.addBook(newBook);
  }

  Future<void> updateBook(Book book) async {
    final repository = ref.read(bookRepositoryProvider);
    await repository.updateBook(book);
  }

  Future<void> deleteBook(String bookId) async {
    final repository = ref.read(bookRepositoryProvider);
    await repository.deleteBook(bookId);
  }
}

// [Provider Definition]
final bookViewModelProvider = StreamNotifierProvider<BookViewModel, List<Book>>(
  BookViewModel.new,
);
