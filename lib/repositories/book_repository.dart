import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart'; // [New] XFile
import '../models/book_model.dart';

// Riverpod Provider
final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return BookRepository(FirebaseFirestore.instance, FirebaseStorage.instance);
});

class BookRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  BookRepository(this._firestore, this._storage);

  // Firestore Collection Reference
  CollectionReference<Map<String, dynamic>> get _booksRef =>
      _firestore.collection('books');

  // [Upload] 책 표지 업로드
  Future<String> uploadBookCover(XFile imageFile, String userId) async {
    try {
      // 파일명: covers/{userId}/{timestamp}.jpg
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = _storage.ref().child('covers/$userId/$fileName');

      // 메타데이터 설정
      final metadata = SettableMetadata(contentType: 'image/jpeg');

      // 웹/모바일 공용: 데이터(Bytes)로 업로드
      final data = await imageFile.readAsBytes();
      await ref.putData(data, metadata);

      // 다운로드 URL 반환
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  // [READ] 책 목록 스트림 (필터링 지원)
  Stream<List<Book>> getBooksStream({String? status}) {
    Query<Map<String, dynamic>> query = _booksRef;

    // 필터 조건: status가 'ALL'이 아니거나 null이 아닐 때
    if (status != null && status != 'ALL') {
      query = query.where('status', isEqualTo: status);
    }

    // 정렬: 시작일 내림차순 (최신순)
    return query.orderBy('started_at', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) => Book.fromDocument(doc)).toList();
    });
  }

  // [CREATE] 책 추가
  Future<void> addBook(Book book) async {
    await _booksRef.add(book.toJson());
  }

  // [UPDATE] 책 정보 수정
  Future<void> updateBook(Book book) async {
    if (book.id.isEmpty) {
      throw Exception('Book ID is empty');
    }
    await _booksRef.doc(book.id).update(book.toJson());
  }

  // [DELETE] 책 삭제
  Future<void> deleteBook(String bookId) async {
    await _booksRef.doc(bookId).delete();
  }
}
