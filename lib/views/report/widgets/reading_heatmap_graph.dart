import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../theme/book_theme.dart';
import '../../../viewmodels/theme_view_model.dart';

class ReadingHeatmapGraph extends ConsumerStatefulWidget {
  final int yearInView;

  const ReadingHeatmapGraph({super.key, required this.yearInView});

  @override
  ConsumerState<ReadingHeatmapGraph> createState() =>
      _ReadingHeatmapGraphState();
}

class _ReadingHeatmapGraphState extends ConsumerState<ReadingHeatmapGraph> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Use WidgetsBinding to wait for layout, then scroll if this year
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.yearInView == DateTime.now().year) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant ReadingHeatmapGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.yearInView != widget.yearInView) {
      if (widget.yearInView == DateTime.now().year) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(
              _scrollController.position.maxScrollExtent,
            );
          }
        });
      } else {
        // Go to start for past years
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(0);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Theme Data
    final themeType = ref.watch(themeViewModelProvider);
    final palette = BookTheme.getPalette(themeType);

    // 2. Date Setup (Full Year Logic)
    final year = widget.yearInView;
    final firstDayOfYear = DateTime(year, 1, 1);
    final lastDayOfYear = DateTime(year, 12, 31);

    // Align start date to previous Sunday if Jan 1 is not Sunday
    final startDate = firstDayOfYear.subtract(
      Duration(days: firstDayOfYear.weekday % 7),
    );
    // Align end date to finish the week if needed?
    // Usually standard to just run until Dec 31, but grid needs complete columns?
    // Let's just run enough days to cover Dec 31.
    final totalDays = lastDayOfYear.difference(startDate).inDays + 1;

    // 3. Dummy Data (Update to use the year)
    final datasets = _generateDummyData(year);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 12),
          child: Text(
            "$year년 독서 지도 🌱",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          elevation: 0,
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            height: 240,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Day Labels (Sun, Mon, Tue...)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20), // Spacing for Month label
                    _buildDayLabel("일"),
                    _buildDayLabel("월"),
                    _buildDayLabel("화"),
                    _buildDayLabel("수"),
                    _buildDayLabel("목"),
                    _buildDayLabel("금"),
                    _buildDayLabel("토"),
                  ],
                ),
                const SizedBox(width: 8),
                // 2. Heatmap Grid
                Flexible(
                  fit: FlexFit.loose,
                  child: SingleChildScrollView(
                    controller: _scrollController, // [Fix] Attached Controller
                    scrollDirection: Axis.horizontal,
                    reverse: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Month Labels Row
                        SizedBox(
                          height: 20,
                          child: _buildMonthLabels(startDate, totalDays),
                        ),
                        // The Grid
                        SizedBox(
                          height: 18 * 7 + 6 * 2.0,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 7,
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2,
                                  childAspectRatio: 1.0,
                                ),
                            itemCount: totalDays,
                            itemBuilder: (context, index) {
                              final currentDate = startDate.add(
                                Duration(days: index),
                              );
                              // We might exceed Dec 31 due to column fill, handle click safely
                              final isWithinYear = currentDate.year == year;

                              // Check if we should render blank for future/past year overshoot?
                              // Or simply render everything. Let's render everything for consistent grid.

                              final normalizedDate = DateTime(
                                currentDate.year,
                                currentDate.month,
                                currentDate.day,
                              );

                              final count = datasets[normalizedDate] ?? 0;
                              final color = _getColor(count, palette);

                              // Optional: grey out days not in this year?
                              final effectiveColor =
                                  isWithinYear ? color : color.withOpacity(0.3);

                              return Tooltip(
                                message:
                                    "${DateFormat('yyyy.MM.dd').format(currentDate)}: $count권",
                                child: InkWell(
                                  onTap: () {
                                    ScaffoldMessenger.of(
                                      context,
                                    ).hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "${DateFormat('MM월 dd일').format(currentDate)}: $count권 읽음 📚",
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: effectiveColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayLabel(String text) {
    return SizedBox(
      height: 18 + 2,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildMonthLabels(DateTime startDate, int totalDays) {
    List<Widget> labels = [];
    for (int i = 0; i < totalDays; i += 7) {
      final currentColumnDate = startDate.add(Duration(days: i));

      // Simple logic: always label first week of month
      if (i == 0 || currentColumnDate.day <= 7) {
        labels.add(
          Container(
            width: 20.0,
            alignment: Alignment.centerLeft,
            child: Text(
              "${currentColumnDate.month}월",
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              softWrap: false,
              overflow: TextOverflow.visible,
            ),
          ),
        );
      } else {
        labels.add(const SizedBox(width: 20));
      }
    }
    return Row(children: labels);
  }

  Color _getColor(int count, List<Color> palette) {
    if (count == 0) return Colors.grey[200]!;
    if (count == 1) return palette[0];
    if (count == 2) return palette[1];
    if (count == 3) return palette[2];
    if (count == 4) return palette[3];
    return palette[4];
  }

  Map<DateTime, int> _generateDummyData(int year) {
    final Map<DateTime, int> data = {};
    final random = Random();

    // Fill random data for the specified year
    final start = DateTime(year, 1, 1);
    final isCurrentYear = DateTime.now().year == year;
    // If current year, fill only up to today?
    // Or fill whole year purely random?
    // Let's fill up to today if current year, otherwise full year.
    final limitDate = isCurrentYear ? DateTime.now() : DateTime(year, 12, 31);

    int days = limitDate.difference(start).inDays + 1;

    for (int i = 0; i < days; i++) {
      final date = start.add(Duration(days: i));
      if (random.nextDouble() < 0.3) {
        // 30% chance of reading
        data[date] = random.nextInt(5) + 1;
      }
    }
    return data;
  }
}
