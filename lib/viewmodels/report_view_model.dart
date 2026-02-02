import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book_model.dart';
import 'book_view_model.dart';
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

class ReportStats {
  final ReportFilterState filter;
  final int totalBooks;
  final int totalPages;
  final List<Book> readBooks;

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
  final booksAsync = ref.watch(bookViewModelProvider);
  final filter = ref.watch(reportViewModelProvider);

  return booksAsync.whenData((books) {
    // 1. '완독' 상태인 책만 필터링
    var doneBooks = books.where((b) => b.status == 'DONE').toList();

    // 2. 기간 필터링
    doneBooks =
        doneBooks.where((b) {
          if (b.finishedAt == null) return false;
          final date = b.finishedAt!;

          switch (filter.type) {
            case ReportFilterType.monthly:
              return date.year == filter.selectedDate!.year &&
                  date.month == filter.selectedDate!.month;
            case ReportFilterType.yearly:
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
    final totalBooks = doneBooks.length;
    final totalPages = doneBooks.fold<int>(
      0,
      (sum, book) => sum + book.totalUnit,
    );

    return ReportStats(
      filter: filter,
      totalBooks: totalBooks,
      totalPages: totalPages,
      readBooks: doneBooks,
    );
  });
});
