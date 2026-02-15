// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReadingRecord {

 int get readCount;@JsonKey(name: 'started_at')@TimestampConverter() DateTime? get startedAt;@JsonKey(name: 'finished_at')@TimestampConverter() DateTime? get finishedAt; double? get rating; String? get review;
/// Create a copy of ReadingRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReadingRecordCopyWith<ReadingRecord> get copyWith => _$ReadingRecordCopyWithImpl<ReadingRecord>(this as ReadingRecord, _$identity);

  /// Serializes this ReadingRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReadingRecord&&(identical(other.readCount, readCount) || other.readCount == readCount)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.review, review) || other.review == review));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,readCount,startedAt,finishedAt,rating,review);

@override
String toString() {
  return 'ReadingRecord(readCount: $readCount, startedAt: $startedAt, finishedAt: $finishedAt, rating: $rating, review: $review)';
}


}

/// @nodoc
abstract mixin class $ReadingRecordCopyWith<$Res>  {
  factory $ReadingRecordCopyWith(ReadingRecord value, $Res Function(ReadingRecord) _then) = _$ReadingRecordCopyWithImpl;
@useResult
$Res call({
 int readCount,@JsonKey(name: 'started_at')@TimestampConverter() DateTime? startedAt,@JsonKey(name: 'finished_at')@TimestampConverter() DateTime? finishedAt, double? rating, String? review
});




}
/// @nodoc
class _$ReadingRecordCopyWithImpl<$Res>
    implements $ReadingRecordCopyWith<$Res> {
  _$ReadingRecordCopyWithImpl(this._self, this._then);

  final ReadingRecord _self;
  final $Res Function(ReadingRecord) _then;

/// Create a copy of ReadingRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? readCount = null,Object? startedAt = freezed,Object? finishedAt = freezed,Object? rating = freezed,Object? review = freezed,}) {
  return _then(_self.copyWith(
readCount: null == readCount ? _self.readCount : readCount // ignore: cast_nullable_to_non_nullable
as int,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,review: freezed == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReadingRecord].
extension ReadingRecordPatterns on ReadingRecord {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReadingRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReadingRecord() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReadingRecord value)  $default,){
final _that = this;
switch (_that) {
case _ReadingRecord():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReadingRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ReadingRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int readCount, @JsonKey(name: 'started_at')@TimestampConverter()  DateTime? startedAt, @JsonKey(name: 'finished_at')@TimestampConverter()  DateTime? finishedAt,  double? rating,  String? review)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReadingRecord() when $default != null:
return $default(_that.readCount,_that.startedAt,_that.finishedAt,_that.rating,_that.review);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int readCount, @JsonKey(name: 'started_at')@TimestampConverter()  DateTime? startedAt, @JsonKey(name: 'finished_at')@TimestampConverter()  DateTime? finishedAt,  double? rating,  String? review)  $default,) {final _that = this;
switch (_that) {
case _ReadingRecord():
return $default(_that.readCount,_that.startedAt,_that.finishedAt,_that.rating,_that.review);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int readCount, @JsonKey(name: 'started_at')@TimestampConverter()  DateTime? startedAt, @JsonKey(name: 'finished_at')@TimestampConverter()  DateTime? finishedAt,  double? rating,  String? review)?  $default,) {final _that = this;
switch (_that) {
case _ReadingRecord() when $default != null:
return $default(_that.readCount,_that.startedAt,_that.finishedAt,_that.rating,_that.review);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReadingRecord implements ReadingRecord {
  const _ReadingRecord({this.readCount = 1, @JsonKey(name: 'started_at')@TimestampConverter() this.startedAt, @JsonKey(name: 'finished_at')@TimestampConverter() this.finishedAt, this.rating, this.review});
  factory _ReadingRecord.fromJson(Map<String, dynamic> json) => _$ReadingRecordFromJson(json);

@override@JsonKey() final  int readCount;
@override@JsonKey(name: 'started_at')@TimestampConverter() final  DateTime? startedAt;
@override@JsonKey(name: 'finished_at')@TimestampConverter() final  DateTime? finishedAt;
@override final  double? rating;
@override final  String? review;

/// Create a copy of ReadingRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadingRecordCopyWith<_ReadingRecord> get copyWith => __$ReadingRecordCopyWithImpl<_ReadingRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReadingRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReadingRecord&&(identical(other.readCount, readCount) || other.readCount == readCount)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.review, review) || other.review == review));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,readCount,startedAt,finishedAt,rating,review);

@override
String toString() {
  return 'ReadingRecord(readCount: $readCount, startedAt: $startedAt, finishedAt: $finishedAt, rating: $rating, review: $review)';
}


}

/// @nodoc
abstract mixin class _$ReadingRecordCopyWith<$Res> implements $ReadingRecordCopyWith<$Res> {
  factory _$ReadingRecordCopyWith(_ReadingRecord value, $Res Function(_ReadingRecord) _then) = __$ReadingRecordCopyWithImpl;
@override @useResult
$Res call({
 int readCount,@JsonKey(name: 'started_at')@TimestampConverter() DateTime? startedAt,@JsonKey(name: 'finished_at')@TimestampConverter() DateTime? finishedAt, double? rating, String? review
});




}
/// @nodoc
class __$ReadingRecordCopyWithImpl<$Res>
    implements _$ReadingRecordCopyWith<$Res> {
  __$ReadingRecordCopyWithImpl(this._self, this._then);

  final _ReadingRecord _self;
  final $Res Function(_ReadingRecord) _then;

/// Create a copy of ReadingRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? readCount = null,Object? startedAt = freezed,Object? finishedAt = freezed,Object? rating = freezed,Object? review = freezed,}) {
  return _then(_ReadingRecord(
readCount: null == readCount ? _self.readCount : readCount // ignore: cast_nullable_to_non_nullable
as int,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,review: freezed == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Book {

// Firestore ID
@JsonKey(includeToJson: false) String get id; String get title; String get author;@JsonKey(name: 'cover_url') String get coverUrl;// Status
 BookStatus get status;// 페이지 관리 (책의 물리적 속성 및 현재 상태)
@JsonKey(name: 'total_unit') int get totalUnit;@JsonKey(name: 'current_unit') int get currentUnit;// 데이터 생성일
@JsonKey(name: 'created_at')@TimestampConverter() DateTime? get createdAt;// 모든 독서 기록 (현재 진행 중인 기록 포함)
 List<ReadingRecord> get records;
/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookCopyWith<Book> get copyWith => _$BookCopyWithImpl<Book>(this as Book, _$identity);

  /// Serializes this Book to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Book&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalUnit, totalUnit) || other.totalUnit == totalUnit)&&(identical(other.currentUnit, currentUnit) || other.currentUnit == currentUnit)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.records, records));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,author,coverUrl,status,totalUnit,currentUnit,createdAt,const DeepCollectionEquality().hash(records));

@override
String toString() {
  return 'Book(id: $id, title: $title, author: $author, coverUrl: $coverUrl, status: $status, totalUnit: $totalUnit, currentUnit: $currentUnit, createdAt: $createdAt, records: $records)';
}


}

/// @nodoc
abstract mixin class $BookCopyWith<$Res>  {
  factory $BookCopyWith(Book value, $Res Function(Book) _then) = _$BookCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String title, String author,@JsonKey(name: 'cover_url') String coverUrl, BookStatus status,@JsonKey(name: 'total_unit') int totalUnit,@JsonKey(name: 'current_unit') int currentUnit,@JsonKey(name: 'created_at')@TimestampConverter() DateTime? createdAt, List<ReadingRecord> records
});




}
/// @nodoc
class _$BookCopyWithImpl<$Res>
    implements $BookCopyWith<$Res> {
  _$BookCopyWithImpl(this._self, this._then);

  final Book _self;
  final $Res Function(Book) _then;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? author = null,Object? coverUrl = null,Object? status = null,Object? totalUnit = null,Object? currentUnit = null,Object? createdAt = freezed,Object? records = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,coverUrl: null == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookStatus,totalUnit: null == totalUnit ? _self.totalUnit : totalUnit // ignore: cast_nullable_to_non_nullable
as int,currentUnit: null == currentUnit ? _self.currentUnit : currentUnit // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,records: null == records ? _self.records : records // ignore: cast_nullable_to_non_nullable
as List<ReadingRecord>,
  ));
}

}


/// Adds pattern-matching-related methods to [Book].
extension BookPatterns on Book {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Book value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Book() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Book value)  $default,){
final _that = this;
switch (_that) {
case _Book():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Book value)?  $default,){
final _that = this;
switch (_that) {
case _Book() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String title,  String author, @JsonKey(name: 'cover_url')  String coverUrl,  BookStatus status, @JsonKey(name: 'total_unit')  int totalUnit, @JsonKey(name: 'current_unit')  int currentUnit, @JsonKey(name: 'created_at')@TimestampConverter()  DateTime? createdAt,  List<ReadingRecord> records)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Book() when $default != null:
return $default(_that.id,_that.title,_that.author,_that.coverUrl,_that.status,_that.totalUnit,_that.currentUnit,_that.createdAt,_that.records);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String title,  String author, @JsonKey(name: 'cover_url')  String coverUrl,  BookStatus status, @JsonKey(name: 'total_unit')  int totalUnit, @JsonKey(name: 'current_unit')  int currentUnit, @JsonKey(name: 'created_at')@TimestampConverter()  DateTime? createdAt,  List<ReadingRecord> records)  $default,) {final _that = this;
switch (_that) {
case _Book():
return $default(_that.id,_that.title,_that.author,_that.coverUrl,_that.status,_that.totalUnit,_that.currentUnit,_that.createdAt,_that.records);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String title,  String author, @JsonKey(name: 'cover_url')  String coverUrl,  BookStatus status, @JsonKey(name: 'total_unit')  int totalUnit, @JsonKey(name: 'current_unit')  int currentUnit, @JsonKey(name: 'created_at')@TimestampConverter()  DateTime? createdAt,  List<ReadingRecord> records)?  $default,) {final _that = this;
switch (_that) {
case _Book() when $default != null:
return $default(_that.id,_that.title,_that.author,_that.coverUrl,_that.status,_that.totalUnit,_that.currentUnit,_that.createdAt,_that.records);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Book extends Book {
  const _Book({@JsonKey(includeToJson: false) this.id = '', required this.title, this.author = '', @JsonKey(name: 'cover_url') this.coverUrl = '', this.status = BookStatus.wish, @JsonKey(name: 'total_unit') this.totalUnit = 0, @JsonKey(name: 'current_unit') this.currentUnit = 0, @JsonKey(name: 'created_at')@TimestampConverter() this.createdAt, final  List<ReadingRecord> records = const []}): _records = records,super._();
  factory _Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

// Firestore ID
@override@JsonKey(includeToJson: false) final  String id;
@override final  String title;
@override@JsonKey() final  String author;
@override@JsonKey(name: 'cover_url') final  String coverUrl;
// Status
@override@JsonKey() final  BookStatus status;
// 페이지 관리 (책의 물리적 속성 및 현재 상태)
@override@JsonKey(name: 'total_unit') final  int totalUnit;
@override@JsonKey(name: 'current_unit') final  int currentUnit;
// 데이터 생성일
@override@JsonKey(name: 'created_at')@TimestampConverter() final  DateTime? createdAt;
// 모든 독서 기록 (현재 진행 중인 기록 포함)
 final  List<ReadingRecord> _records;
// 모든 독서 기록 (현재 진행 중인 기록 포함)
@override@JsonKey() List<ReadingRecord> get records {
  if (_records is EqualUnmodifiableListView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_records);
}


/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookCopyWith<_Book> get copyWith => __$BookCopyWithImpl<_Book>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Book&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalUnit, totalUnit) || other.totalUnit == totalUnit)&&(identical(other.currentUnit, currentUnit) || other.currentUnit == currentUnit)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._records, _records));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,author,coverUrl,status,totalUnit,currentUnit,createdAt,const DeepCollectionEquality().hash(_records));

@override
String toString() {
  return 'Book(id: $id, title: $title, author: $author, coverUrl: $coverUrl, status: $status, totalUnit: $totalUnit, currentUnit: $currentUnit, createdAt: $createdAt, records: $records)';
}


}

/// @nodoc
abstract mixin class _$BookCopyWith<$Res> implements $BookCopyWith<$Res> {
  factory _$BookCopyWith(_Book value, $Res Function(_Book) _then) = __$BookCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String title, String author,@JsonKey(name: 'cover_url') String coverUrl, BookStatus status,@JsonKey(name: 'total_unit') int totalUnit,@JsonKey(name: 'current_unit') int currentUnit,@JsonKey(name: 'created_at')@TimestampConverter() DateTime? createdAt, List<ReadingRecord> records
});




}
/// @nodoc
class __$BookCopyWithImpl<$Res>
    implements _$BookCopyWith<$Res> {
  __$BookCopyWithImpl(this._self, this._then);

  final _Book _self;
  final $Res Function(_Book) _then;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? author = null,Object? coverUrl = null,Object? status = null,Object? totalUnit = null,Object? currentUnit = null,Object? createdAt = freezed,Object? records = null,}) {
  return _then(_Book(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,coverUrl: null == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookStatus,totalUnit: null == totalUnit ? _self.totalUnit : totalUnit // ignore: cast_nullable_to_non_nullable
as int,currentUnit: null == currentUnit ? _self.currentUnit : currentUnit // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,records: null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as List<ReadingRecord>,
  ));
}


}

// dart format on
