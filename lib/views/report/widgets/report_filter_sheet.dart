import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../viewmodels/report_view_model.dart';
import 'custom_date_range_picker.dart';

class ReportFilterSheet extends StatefulWidget {
  final ReportFilterState initialFilter;
  final Function(ReportFilterState) onApply;

  const ReportFilterSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  @override
  State<ReportFilterSheet> createState() => _ReportFilterSheetState();
}

class _ReportFilterSheetState extends State<ReportFilterSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Internal State
  late ReportFilterType _selectedType;
  late DateTime _tempDate; // For Monthly/Yearly
  late DateTimeRange _tempRange; // For Custom

  // Custom Tab Focus
  bool _isStartFocus = true;

  @override
  void initState() {
    super.initState();
    // Initialize state from initialFilter
    _selectedType = widget.initialFilter.type;
    _tempDate = widget.initialFilter.selectedDate ?? DateTime.now();

    final now = DateTime.now();
    _tempRange =
        widget.initialFilter.customRange ??
        DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: DateTime(now.year, now.month + 1, 0),
        );

    // Initial Tab Index
    int initialIndex = 0;
    if (_selectedType == ReportFilterType.monthly) initialIndex = 0;
    if (_selectedType == ReportFilterType.yearly) initialIndex = 1;
    if (_selectedType == ReportFilterType.custom) initialIndex = 2;
    // If 'all', default to Monthly tab but don't select it?
    // Actually if 'all', we can default to monthly tab visually.

    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: initialIndex,
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          // Update selected type based on tab
          if (_tabController.index == 0)
            _selectedType = ReportFilterType.monthly;
          if (_tabController.index == 1)
            _selectedType = ReportFilterType.yearly;
          if (_tabController.index == 2)
            _selectedType = ReportFilterType.custom;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- Actions ---

  void _onApply() {
    ReportFilterState newState;
    if (_tabController.index == 0) {
      newState = ReportFilterState(
        type: ReportFilterType.monthly,
        selectedDate: _tempDate,
      );
    } else if (_tabController.index == 1) {
      newState = ReportFilterState(
        type: ReportFilterType.yearly,
        selectedDate: _tempDate,
      );
    } else {
      newState = ReportFilterState(
        type: ReportFilterType.custom,
        customRange: _tempRange,
      );
    }
    widget.onApply(newState);
  }

  void _onResetAll() {
    widget.onApply(const ReportFilterState(type: ReportFilterType.all));
  }

  // --- UI Builders ---

  @override
  Widget build(BuildContext context) {
    return Material(
      // [Fix] Material 위젯 추가 (ListTile, TabBar 등 지원)
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min, // [Fix] 내용물 크기에 맞춤
        children: [
          // 1. Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 48), // Spacer
                const Text(
                  "기간 설정",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // 2. Tab Bar
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            onTap: (index) {
              setState(() {}); // 탭 클릭 시 즉시 리빌드
            },
            tabs: const [Tab(text: "월별"), Tab(text: "연도별"), Tab(text: "직접 입력")],
          ),

          // 3. Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMonthlyTab(),
                _buildYearlyTab(),
                _buildCustomTab(),
              ],
            ),
          ),

          // 4. Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                TextButton(
                  onPressed: _onResetAll,
                  child: const Text(
                    "전체 기간 보기",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const Spacer(),
                // [Fix] 직접 입력(Custom, Index 2)일 때만 적용 버튼 표시
                if (_tabController.index == 2)
                  ElevatedButton(
                    onPressed: _onApply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "적용하기",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tab 1: Monthly
  Widget _buildMonthlyTab() {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Year Selector
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed:
                  () => setState(() {
                    _tempDate = DateTime(_tempDate.year - 1, _tempDate.month);
                  }),
            ),
            Text(
              "${_tempDate.year}년",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed:
                  () => setState(() {
                    _tempDate = DateTime(_tempDate.year + 1, _tempDate.month);
                  }),
            ),
          ],
        ),
        const Spacer(), // [Fix] 그리드 상단 여백
        // Month Grid
        GridView.builder(
          shrinkWrap: true, // [Fix] 내용물 크기만큼만 차지
          physics: const NeverScrollableScrollPhysics(), // 스크롤 금지
          padding: const EdgeInsets.symmetric(horizontal: 24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 4열 배치
            childAspectRatio: 2.2, // 슬림한 직사각형
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            final month = index + 1;
            final isSelected = month == _tempDate.month;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _tempDate = DateTime(_tempDate.year, month);
                });
                _onApply(); // [Fix] 월 선택 시 즉시 적용
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey.shade300,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "$month월",
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
        const Spacer(), // [Fix] 그리드 하단 여백
      ],
    );
  }

  // Tab 2: Yearly
  Widget _buildYearlyTab() {
    return ListView.builder(
      shrinkWrap: true, // [Fix] 높이 자동 조절
      physics: const ClampingScrollPhysics(), // 스크롤 가능 (내용이 길면)
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: 11, // 2020 ~ 2030 (Example)
      itemBuilder: (context, index) {
        final year = 2020 + index;
        final isSelected = year == _tempDate.year;
        return ListTile(
          onTap: () {
            setState(() {
              _tempDate = DateTime(year, _tempDate.month);
            });
            _onApply(); // [Fix] 연도 선택 시 즉시 적용
          },
          title: Center(
            child: Text(
              "$year년",
              style: TextStyle(
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.grey[600],
              ),
            ),
          ),
        );
      },
    );
  }

  // Tab 3: Custom
  Widget _buildCustomTab() {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Range Display
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(child: _buildDateBox(true, _tempRange.start)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_right_alt, color: Colors.grey),
              ),
              Expanded(child: _buildDateBox(false, _tempRange.end)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Divider(),
        // Custom Calendar
        Expanded(
          child: CustomDateRangePicker(
            initialRange: _tempRange,
            onRangeChanged: (newRange) {
              setState(() {
                _tempRange = newRange;
                // [Fix] 날짜 선택 시 포커스를 '종료일'로 이동 (시작일 선택 직후 -> 종료일 대기 표현)
                _isStartFocus = false;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateBox(bool isStart, DateTime date) {
    final isFocused = _isStartFocus == isStart;
    return GestureDetector(
      onTap: () => setState(() => _isStartFocus = isStart),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isFocused ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isFocused ? Colors.black : Colors.grey.shade300,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          DateFormat('yyyy.MM.dd').format(date),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isFocused ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
