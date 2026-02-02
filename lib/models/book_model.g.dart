// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Book _$BookFromJson(Map<String, dynamic> json) => _Book(
  id: json['id'] as String? ?? '',
  title: json['title'] as String,
  author: json['author'] as String,
  coverUrl: json['cover_url'] as String,
  unitType: json['unit_type'] as String,
  totalUnit: (json['total_unit'] as num).toInt(),
  currentUnit: (json['current_unit'] as num).toInt(),
  status: json['status'] as String,
  startedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['started_at'],
    const TimestampConverter().fromJson,
  ),
  finishedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['finished_at'],
    const TimestampConverter().fromJson,
  ),
  rating: (json['rating'] as num?)?.toDouble(),
  memo: json['memo'] as String?,
);

Map<String, dynamic> _$BookToJson(_Book instance) => <String, dynamic>{
  'title': instance.title,
  'author': instance.author,
  'cover_url': instance.coverUrl,
  'unit_type': instance.unitType,
  'total_unit': instance.totalUnit,
  'current_unit': instance.currentUnit,
  'status': instance.status,
  'started_at': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.startedAt,
    const TimestampConverter().toJson,
  ),
  'finished_at': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.finishedAt,
    const TimestampConverter().toJson,
  ),
  'rating': instance.rating,
  'memo': instance.memo,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
