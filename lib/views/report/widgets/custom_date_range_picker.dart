import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateRangePicker extends StatefulWidget {
  final DateTimeRange? initialRange;
  final Function(DateTimeRange) onRangeChanged;

  const CustomDateRangePicker({
    super.key,
    this.initialRange,
    required this.onRangeChanged,
  });

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  late DateTime _displayedMonth;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSelectingEnd = false; // [Fix] 선택 모드 상태 추가

  // Selection Mode: True = selecting start date, False = selecting end date
  // Actually, standard behavior:
  // Tap 1: Start Date (End cleared)
  // Tap 2: End Date (Range formed)
  // Tap 3: Restart (Start Date)
  // BUT the user has explicit "Start Box" and "End Box" in the parent UI.
  // The parent passes which one is focused?
  // User said: "When clicking the second box... start date should also be marked"
  // This implies the picker should ALWAYS show the range if exists.
  // And the parent handles the "focus" logic primarily for the text display,
  // BUT for the calendar interaction, maybe it's better to just let the calendar handle range picking logic naturally?
  // "Clicking the second box" -> user wants to modify END date?
  // If so, we need to know which "edge" is being modified.
  // However, simpler is: Tap a date.
  // If Start focused: Set Start. If End < Start, clear End.
  // If End focused: Set End. If End < Start, switch to Start?
  // Let's stick to a sophisticated "Range Picker" behavior internally,
  // and update the parent.
  // Parent has `_isStartFocus`. Maybe we should pass this in?
  // If we pass `isStartFocus`, then:
  // Tap on date -> Updates Start or End based on focus.

  // Let's add `isStartFocus` to widget.

  @override
  void initState() {
    super.initState();
    if (widget.initialRange != null) {
      _startDate = DateUtils.dateOnly(widget.initialRange!.start);
      _endDate = DateUtils.dateOnly(widget.initialRange!.end);
    }
    _displayedMonth = _startDate ?? DateTime.now();
    // Normalize to 1st of month
    _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
  }

  @override
  void didUpdateWidget(covariant CustomDateRangePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialRange != oldWidget.initialRange) {
      if (widget.initialRange != null) {
        _startDate = DateUtils.dateOnly(widget.initialRange!.start);
        _endDate = DateUtils.dateOnly(widget.initialRange!.end);
        // [Fix] 범위가 완성된 상태로 외부에서 업데이트되면 선택 모드 해제
        if (!DateUtils.isSameDay(_startDate, _endDate)) {
          _isSelectingEnd = false;
        }
      } else {
        _startDate = null;
        _endDate = null;
        _isSelectingEnd = false;
      }
    }
  }

  void _onDateTap(DateTime date) {
    // Normalize input date just in case
    date = DateUtils.dateOnly(date);

    setState(() {
      // [Fix] 상태 기반 로직: 종료일 선택 모드인가?
      if (!_isSelectingEnd) {
        // 새로운 범위 시작
        _startDate = date;
        _endDate = null;
        _isSelectingEnd = true;
      } else {
        // 종료일 선택 중 (혹은 이미 범위가 있는 상태에서 로직 분기)
        if (date.isBefore(_startDate!)) {
          // [Fix] 현재 시작일보다 이전 날짜 선택 시 -> 새로운 시작일로 설정 및 종료일 초기화
          _startDate = date;
          _endDate = null;
          _isSelectingEnd = true; // 다시 종료일 선택 대기 상태로
        } else {
          // 종료일 확정 (범위 완성)
          _endDate = date;
          _isSelectingEnd = false;
        }
      }
    });

    if (_startDate != null) {
      if (_endDate != null) {
        // Ensure range is strictly valid (start <= end) by normalization just to be safe
        widget.onRangeChanged(
          DateTimeRange(start: _startDate!, end: _endDate!),
        );
      } else {
        // Pass visual partial range? Parent expects valid range.
        // Pass start-start matches visual.
        widget.onRangeChanged(
          DateTimeRange(start: _startDate!, end: _startDate!),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildWeekDays(),
        Expanded(child: _buildDaysGrid()),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _displayedMonth = DateTime(
                  _displayedMonth.year,
                  _displayedMonth.month - 1,
                );
              });
            },
          ),
          Text(
            DateFormat('yyyy년 MM월').format(_displayedMonth),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _displayedMonth = DateTime(
                  _displayedMonth.year,
                  _displayedMonth.month + 1,
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDays() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            ["일", "월", "화", "수", "목", "금", "토"].map((day) {
              return SizedBox(
                width: 32,
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildDaysGrid() {
    final daysInMonth = DateUtils.getDaysInMonth(
      _displayedMonth.year,
      _displayedMonth.month,
    );
    final firstDayOffset =
        DateTime(_displayedMonth.year, _displayedMonth.month, 1).weekday % 7;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.5, // [Fix] 세로 높이 더 줄임
      ),
      itemCount: daysInMonth + firstDayOffset,
      itemBuilder: (context, index) {
        if (index < firstDayOffset) return const SizedBox();

        final day = index - firstDayOffset + 1;
        final date = DateTime(_displayedMonth.year, _displayedMonth.month, day);

        return _buildDayItem(date);
      },
    );
  }

  Widget _buildDayItem(DateTime date) {
    bool isSelected = false;
    bool isRange = false;
    bool isStart = false;
    bool isEnd = false;

    if (_startDate != null) {
      if (DateUtils.isSameDay(date, _startDate!)) {
        isSelected = true;
        isStart = true;
      }
      if (_endDate != null) {
        if (DateUtils.isSameDay(date, _endDate!)) {
          isSelected = true;
          isEnd = true;
        }
        if (date.isAfter(_startDate!) && date.isBefore(_endDate!)) {
          isRange = true;
        }
      }
    }

    // For handling "Just Start Selected" -> Treat as single dot
    // If range is same day, it's start and end.

    return GestureDetector(
      onTap: () => _onDateTap(date),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Range Highlight (Left/Right/Middle)
          if (isRange || isStart || isEnd)
            Positioned.fill(
              child: Center(
                child: SizedBox(
                  height: 28, // [Fix] 높이를 제한하여 형광펜(Strip) 효과
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          color:
                              (isRange || isEnd) &&
                                      (_endDate != null) &&
                                      !isStart
                                  ? Colors.black.withOpacity(0.1)
                                  : Colors.transparent,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color:
                              (isRange || isStart) &&
                                      (_endDate != null) &&
                                      !isEnd
                                  ? Colors.black.withOpacity(0.1)
                                  : Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Selection Circle
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: (isStart || isEnd) ? Colors.black : Colors.transparent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              "${date.day}",
              style: TextStyle(
                color: (isStart || isEnd) ? Colors.white : Colors.black,
                fontWeight:
                    (isStart || isEnd) ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
