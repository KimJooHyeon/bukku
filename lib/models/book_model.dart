// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'book_model.freezed.dart';
part 'book_model.g.dart';

@freezed
abstract class Book with _$Book {
  const factory Book({
    // Firestore ID는 JSON에서 오지 않으므로 기본값 처리 후 fromDocument에서 주입
    @JsonKey(includeToJson: false) @Default('') String id,
    required String title,
    required String author,
    @JsonKey(name: 'cover_url') required String coverUrl,
    @JsonKey(name: 'unit_type') required String unitType,
    @JsonKey(name: 'total_unit') required int totalUnit,
    @JsonKey(name: 'current_unit') required int currentUnit,
    required String status,
    @JsonKey(name: 'started_at') @TimestampConverter() DateTime? startedAt,
    @JsonKey(name: 'finished_at') @TimestampConverter() DateTime? finishedAt,
    // [New] 평점 (0.5 단위 지원을 위해 double 변경)
    double? rating,
    // [New] 메모
    String? memo,
  }) = _Book;

  factory Book.fromJson(Map<String, Object?> json) => _$BookFromJson(json);

  factory Book.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Book.fromJson(data).copyWith(id: doc.id);
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
