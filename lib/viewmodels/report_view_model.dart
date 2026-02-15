import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book_model.dart';
import '../providers/book_provider.dart';
import 'package:intl/intl.dart';

enum ReportFilterType { monthly, yearly, custom, all }

@immutable
class ReportFilterState {
  final ReportFilterType type;
  final DateTime? selectedDate; // Monthly(yyyy-MM) or Yearly(yyyy)
  final DateTimeRange? customRange; // Custom(start~end)

  const ReportFilterState({
    required this.type,
    this.selectedDate,
    this.customRange,
  });

  // Display Title Getter
  String get displayTitle {
    switch (type) {
      case ReportFilterType.monthly:
        return DateFormat('yyyy년 M월').format(selectedDate!);
      case ReportFilterType.yearly:
        return "${selectedDate!.year}년";
      case ReportFilterType.custom:
        if (customRange == null) return "기간 선택";
        final start = DateFormat('yy.MM.dd').format(customRange!.start);
        final end = DateFormat('yy.MM.dd').format(customRange!.end);
        return "$start ~ $end";
      case ReportFilterType.all:
        return "전체 기간";
    }
  }
}

class ReportItem {
  final Book book;
  final ReadingRecord record;

  const ReportItem({required this.book, required this.record});
}

class ReportStats {
  final ReportFilterState filter;
  final int totalBooks;
  final int totalPages;
  final List<ReportItem> readBooks;

  const ReportStats({
    required this.filter,
    required this.totalBooks,
    required this.totalPages,
    required this.readBooks,
  });
}

// [State] 리포트 기간 관리
class ReportViewModel extends Notifier<ReportFilterState> {
  @override
  ReportFilterState build() {
    // Default: This Month
    return ReportFilterState(
      type: ReportFilterType.monthly,
      selectedDate: DateTime.now(),
    );
  }

  void setMonthly(DateTime date) {
    state = ReportFilterState(
      type: ReportFilterType.monthly,
      selectedDate: date,
    );
  }

  void setYearly(int year) {
    state = ReportFilterState(
      type: ReportFilterType.yearly,
      selectedDate: DateTime(year),
    );
  }

  void setCustomRange(DateTimeRange range) {
    state = ReportFilterState(
      type: ReportFilterType.custom,
      customRange: range,
    );
  }

  void setFilter(ReportFilterState filter) {
    state = filter;
  }

  void setAll() {
    state = const ReportFilterState(type: ReportFilterType.all);
  }
}

// [Provider] ViewModel
final reportViewModelProvider =
    NotifierProvider<ReportViewModel, ReportFilterState>(ReportViewModel.new);

// [Provider] 통계 계산 (Computed Data)
final reportStatsProvider = Provider<AsyncValue<ReportStats>>((ref) {
  final booksAsync = ref.watch(bookListProvider); // Changed provider
  final filter = ref.watch(reportViewModelProvider);

  return booksAsync.whenData((books) {
    // 1. 모든 독서 기록(완독된 것만)을 추출
    // Book과 Record를 짝지어서 리스트로 만듦
    final allRecords = <Map<String, dynamic>>[];

    for (var book in books) {
      for (var record in book.records) {
        if (record.finishedAt != null) {
          allRecords.add({
            'book': book,
            'record': record,
            'date': record.finishedAt!,
          });
        }
      }
    }

    // 2. 기간 필터링
    final filteredItems =
        allRecords.where((item) {
          final date = item['date'] as DateTime;

          // 필터 날짜 확인

          switch (filter.type) {
            case ReportFilterType.monthly:
              if (filter.selectedDate == null) return false;
              return date.year == filter.selectedDate!.year &&
                  date.month == filter.selectedDate!.month;
            case ReportFilterType.yearly:
              if (filter.selectedDate == null) return false;
              return date.year == filter.selectedDate!.year;
            case ReportFilterType.custom:
              if (filter.customRange == null) return true;
              return !date.isBefore(filter.customRange!.start) &&
                  !date.isAfter(
                    filter.customRange!.end.add(const Duration(days: 1)),
                  );
            case ReportFilterType.all:
              return true;
          }
        }).toList();

    // 3. 통계 계산
    final totalBooks = filteredItems.length; // 독서 횟수 기준
    final totalPages = filteredItems.fold<int>(
      0,
      (sum, item) => sum + (item['book'] as Book).totalUnit,
    );

    // 리포트용 아이템 리스트 생성
    final readBooks =
        filteredItems
            .map(
              (item) => ReportItem(
                book: item['book'] as Book,
                record: item['record'] as ReadingRecord,
              ),
            )
            .toList();

    // 최신순 정렬 (선택사항, 날짜 내림차순)
    readBooks.sort(
      (a, b) => b.record.finishedAt!.compareTo(a.record.finishedAt!),
    );

    return ReportStats(
      filter: filter,
      totalBooks: totalBooks,
      totalPages: totalPages,
      readBooks: readBooks,
    );
  });
});
