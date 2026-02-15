// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReadingRecord _$ReadingRecordFromJson(Map<String, dynamic> json) =>
    _ReadingRecord(
      readCount: (json['readCount'] as num?)?.toInt() ?? 1,
      startedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
        json['started_at'],
        const TimestampConverter().fromJson,
      ),
      finishedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
        json['finished_at'],
        const TimestampConverter().fromJson,
      ),
      rating: (json['rating'] as num?)?.toDouble(),
      review: json['review'] as String?,
    );

Map<String, dynamic> _$ReadingRecordToJson(_ReadingRecord instance) =>
    <String, dynamic>{
      'readCount': instance.readCount,
      'started_at': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.startedAt,
        const TimestampConverter().toJson,
      ),
      'finished_at': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.finishedAt,
        const TimestampConverter().toJson,
      ),
      'rating': instance.rating,
      'review': instance.review,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_Book _$BookFromJson(Map<String, dynamic> json) => _Book(
  id: json['id'] as String? ?? '',
  title: json['title'] as String,
  author: json['author'] as String? ?? '',
  coverUrl: json['cover_url'] as String? ?? '',
  status:
      $enumDecodeNullable(_$BookStatusEnumMap, json['status']) ??
      BookStatus.wish,
  totalUnit: (json['total_unit'] as num?)?.toInt() ?? 0,
  currentUnit: (json['current_unit'] as num?)?.toInt() ?? 0,
  createdAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['created_at'],
    const TimestampConverter().fromJson,
  ),
  records:
      (json['records'] as List<dynamic>?)
          ?.map((e) => ReadingRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$BookToJson(_Book instance) => <String, dynamic>{
  'title': instance.title,
  'author': instance.author,
  'cover_url': instance.coverUrl,
  'status': _$BookStatusEnumMap[instance.status]!,
  'total_unit': instance.totalUnit,
  'current_unit': instance.currentUnit,
  'created_at': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.createdAt,
    const TimestampConverter().toJson,
  ),
  'records': instance.records,
};

const _$BookStatusEnumMap = {
  BookStatus.wish: 'wish',
  BookStatus.reading: 'reading',
  BookStatus.done: 'done',
};
