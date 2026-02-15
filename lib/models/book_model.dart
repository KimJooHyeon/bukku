// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'book_model.freezed.dart';
part 'book_model.g.dart';

@JsonEnum(alwaysCreate: true)
enum BookStatus { wish, reading, done }

@freezed
abstract class ReadingRecord with _$ReadingRecord {
  const factory ReadingRecord({
    @Default(1) int readCount,
    @JsonKey(name: 'started_at') @TimestampConverter() DateTime? startedAt,
    @JsonKey(name: 'finished_at') @TimestampConverter() DateTime? finishedAt,
    double? rating,
    String? review,
  }) = _ReadingRecord;

  factory ReadingRecord.fromJson(Map<String, Object?> json) =>
      _$ReadingRecordFromJson(json);
}

@freezed
abstract class Book with _$Book {
  const Book._(); // Added for custom getters

  const factory Book({
    // Firestore ID
    @JsonKey(includeToJson: false) @Default('') String id,
    required String title,
    @Default('') String author,
    @JsonKey(name: 'cover_url') @Default('') String coverUrl,

    // Status
    @Default(BookStatus.wish) BookStatus status,

    // 페이지 관리 (책의 물리적 속성 및 현재 상태)
    @JsonKey(name: 'total_unit') @Default(0) int totalUnit,
    @JsonKey(name: 'current_unit') @Default(0) int currentUnit,

    // 데이터 생성일
    @JsonKey(name: 'created_at') @TimestampConverter() DateTime? createdAt,

    // 모든 독서 기록 (현재 진행 중인 기록 포함)
    @Default([]) List<ReadingRecord> records,
  }) = _Book;

  factory Book.fromJson(Map<String, Object?> json) => _$BookFromJson(json);

  factory Book.fromDocument(DocumentSnapshot doc) {
    if (doc.data() == null) throw Exception("Document data is null");
    // [Fix] Ensure data map is mutable
    final data = Map<String, dynamic>.from(doc.data() as Map<String, dynamic>);

    // [Migration] 기존 데이터 구조 호환 처리
    // records가 없고 구버전 필드(started_at 등)가 있다면 records로 변환
    if (data['records'] == null) {
      final records = <Map<String, dynamic>>[];

      // 1. 기존 history 처리
      if (data['history'] != null) {
        final historyList = data['history'] as List;
        for (var i = 0; i < historyList.length; i++) {
          // [Fix] Ensure history item map is mutable
          final h = Map<String, dynamic>.from(
            historyList[i] as Map<String, dynamic>,
          );
          h['readCount'] = i + 1; // 1회독부터 시작
          h['review'] = h['memo']; // memo -> review
          records.add(h);
        }
      }

      // 2. 현재 상태(Book root 필드) 처리
      if (data['started_at'] != null ||
          data['status'] == 'reading' ||
          data['status'] == 'done') {
        records.add({
          'readCount': records.length + 1,
          'started_at': data['started_at'],
          'finished_at': data['finished_at'],
          'rating': data['rating'],
          'review': data['memo'],
        });
      }

      data['records'] = records;
    }

    return Book.fromJson(data).copyWith(id: doc.id);
  }

  factory Book.empty() => const Book(title: '', author: '');

  // Helpers
  ReadingRecord? get currentRecord => records.isNotEmpty ? records.last : null;
  int get readCount => records.length;
  Duration? get readingDuration {
    final start = currentRecord?.startedAt;
    if (start == null) return null;
    final end = currentRecord?.finishedAt ?? DateTime.now();
    return end.difference(start);
  }
}

// Firestore Timestamp <-> DateTime 변환기
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}
