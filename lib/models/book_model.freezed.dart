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
mixin _$Book {

// Firestore ID는 JSON에서 오지 않으므로 기본값 처리 후 fromDocument에서 주입
@JsonKey(includeToJson: false) String get id; String get title; String get author;@JsonKey(name: 'cover_url') String get coverUrl;@JsonKey(name: 'unit_type') String get unitType;@JsonKey(name: 'total_unit') int get totalUnit;@JsonKey(name: 'current_unit') int get currentUnit; String get status;@JsonKey(name: 'started_at')@TimestampConverter() DateTime? get startedAt;@JsonKey(name: 'finished_at')@TimestampConverter() DateTime? get finishedAt;// [New] 평점 (0.5 단위 지원을 위해 double 변경)
 double? get rating;// [New] 메모
 String? get memo;
/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookCopyWith<Book> get copyWith => _$BookCopyWithImpl<Book>(this as Book, _$identity);

  /// Serializes this Book to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Book&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&(identical(other.totalUnit, totalUnit) || other.totalUnit == totalUnit)&&(identical(other.currentUnit, currentUnit) || other.currentUnit == currentUnit)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.memo, memo) || other.memo == memo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,author,coverUrl,unitType,totalUnit,currentUnit,status,startedAt,finishedAt,rating,memo);

@override
String toString() {
  return 'Book(id: $id, title: $title, author: $author, coverUrl: $coverUrl, unitType: $unitType, totalUnit: $totalUnit, currentUnit: $currentUnit, status: $status, startedAt: $startedAt, finishedAt: $finishedAt, rating: $rating, memo: $memo)';
}


}

/// @nodoc
abstract mixin class $BookCopyWith<$Res>  {
  factory $BookCopyWith(Book value, $Res Function(Book) _then) = _$BookCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String title, String author,@JsonKey(name: 'cover_url') String coverUrl,@JsonKey(name: 'unit_type') String unitType,@JsonKey(name: 'total_unit') int totalUnit,@JsonKey(name: 'current_unit') int currentUnit, String status,@JsonKey(name: 'started_at')@TimestampConverter() DateTime? startedAt,@JsonKey(name: 'finished_at')@TimestampConverter() DateTime? finishedAt, double? rating, String? memo
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? author = null,Object? coverUrl = null,Object? unitType = null,Object? totalUnit = null,Object? currentUnit = null,Object? status = null,Object? startedAt = freezed,Object? finishedAt = freezed,Object? rating = freezed,Object? memo = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,coverUrl: null == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String,unitType: null == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as String,totalUnit: null == totalUnit ? _self.totalUnit : totalUnit // ignore: cast_nullable_to_non_nullable
as int,currentUnit: null == currentUnit ? _self.currentUnit : currentUnit // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,memo: freezed == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String title,  String author, @JsonKey(name: 'cover_url')  String coverUrl, @JsonKey(name: 'unit_type')  String unitType, @JsonKey(name: 'total_unit')  int totalUnit, @JsonKey(name: 'current_unit')  int currentUnit,  String status, @JsonKey(name: 'started_at')@TimestampConverter()  DateTime? startedAt, @JsonKey(name: 'finished_at')@TimestampConverter()  DateTime? finishedAt,  double? rating,  String? memo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Book() when $default != null:
return $default(_that.id,_that.title,_that.author,_that.coverUrl,_that.unitType,_that.totalUnit,_that.currentUnit,_that.status,_that.startedAt,_that.finishedAt,_that.rating,_that.memo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String title,  String author, @JsonKey(name: 'cover_url')  String coverUrl, @JsonKey(name: 'unit_type')  String unitType, @JsonKey(name: 'total_unit')  int totalUnit, @JsonKey(name: 'current_unit')  int currentUnit,  String status, @JsonKey(name: 'started_at')@TimestampConverter()  DateTime? startedAt, @JsonKey(name: 'finished_at')@TimestampConverter()  DateTime? finishedAt,  double? rating,  String? memo)  $default,) {final _that = this;
switch (_that) {
case _Book():
return $default(_that.id,_that.title,_that.author,_that.coverUrl,_that.unitType,_that.totalUnit,_that.currentUnit,_that.status,_that.startedAt,_that.finishedAt,_that.rating,_that.memo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String title,  String author, @JsonKey(name: 'cover_url')  String coverUrl, @JsonKey(name: 'unit_type')  String unitType, @JsonKey(name: 'total_unit')  int totalUnit, @JsonKey(name: 'current_unit')  int currentUnit,  String status, @JsonKey(name: 'started_at')@TimestampConverter()  DateTime? startedAt, @JsonKey(name: 'finished_at')@TimestampConverter()  DateTime? finishedAt,  double? rating,  String? memo)?  $default,) {final _that = this;
switch (_that) {
case _Book() when $default != null:
return $default(_that.id,_that.title,_that.author,_that.coverUrl,_that.unitType,_that.totalUnit,_that.currentUnit,_that.status,_that.startedAt,_that.finishedAt,_that.rating,_that.memo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Book implements Book {
  const _Book({@JsonKey(includeToJson: false) this.id = '', required this.title, required this.author, @JsonKey(name: 'cover_url') required this.coverUrl, @JsonKey(name: 'unit_type') required this.unitType, @JsonKey(name: 'total_unit') required this.totalUnit, @JsonKey(name: 'current_unit') required this.currentUnit, required this.status, @JsonKey(name: 'started_at')@TimestampConverter() this.startedAt, @JsonKey(name: 'finished_at')@TimestampConverter() this.finishedAt, this.rating, this.memo});
  factory _Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

// Firestore ID는 JSON에서 오지 않으므로 기본값 처리 후 fromDocument에서 주입
@override@JsonKey(includeToJson: false) final  String id;
@override final  String title;
@override final  String author;
@override@JsonKey(name: 'cover_url') final  String coverUrl;
@override@JsonKey(name: 'unit_type') final  String unitType;
@override@JsonKey(name: 'total_unit') final  int totalUnit;
@override@JsonKey(name: 'current_unit') final  int currentUnit;
@override final  String status;
@override@JsonKey(name: 'started_at')@TimestampConverter() final  DateTime? startedAt;
@override@JsonKey(name: 'finished_at')@TimestampConverter() final  DateTime? finishedAt;
// [New] 평점 (0.5 단위 지원을 위해 double 변경)
@override final  double? rating;
// [New] 메모
@override final  String? memo;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Book&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&(identical(other.totalUnit, totalUnit) || other.totalUnit == totalUnit)&&(identical(other.currentUnit, currentUnit) || other.currentUnit == currentUnit)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.memo, memo) || other.memo == memo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,author,coverUrl,unitType,totalUnit,currentUnit,status,startedAt,finishedAt,rating,memo);

@override
String toString() {
  return 'Book(id: $id, title: $title, author: $author, coverUrl: $coverUrl, unitType: $unitType, totalUnit: $totalUnit, currentUnit: $currentUnit, status: $status, startedAt: $startedAt, finishedAt: $finishedAt, rating: $rating, memo: $memo)';
}


}

/// @nodoc
abstract mixin class _$BookCopyWith<$Res> implements $BookCopyWith<$Res> {
  factory _$BookCopyWith(_Book value, $Res Function(_Book) _then) = __$BookCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String title, String author,@JsonKey(name: 'cover_url') String coverUrl,@JsonKey(name: 'unit_type') String unitType,@JsonKey(name: 'total_unit') int totalUnit,@JsonKey(name: 'current_unit') int currentUnit, String status,@JsonKey(name: 'started_at')@TimestampConverter() DateTime? startedAt,@JsonKey(name: 'finished_at')@TimestampConverter() DateTime? finishedAt, double? rating, String? memo
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? author = null,Object? coverUrl = null,Object? unitType = null,Object? totalUnit = null,Object? currentUnit = null,Object? status = null,Object? startedAt = freezed,Object? finishedAt = freezed,Object? rating = freezed,Object? memo = freezed,}) {
  return _then(_Book(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,coverUrl: null == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String,unitType: null == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as String,totalUnit: null == totalUnit ? _self.totalUnit : totalUnit // ignore: cast_nullable_to_non_nullable
as int,currentUnit: null == currentUnit ? _self.currentUnit : currentUnit // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,memo: freezed == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
