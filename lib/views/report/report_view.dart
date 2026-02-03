import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb; // [New]
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../../models/book_model.dart';
import '../../viewmodels/report_view_model.dart';
import '../widgets/receipt_widget.dart';
import 'widgets/report_filter_sheet.dart'; // [New]
import 'widgets/reading_heatmap_graph.dart';

class ReportView extends ConsumerStatefulWidget {
  const ReportView({super.key});

  @override
  ConsumerState<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends ConsumerState<ReportView> {
  // [Action] 통합 필터 시트 표시
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7, // [Fix] 높이를 70%로 늘려 여유 확보
          child: ReportFilterSheet(
            initialFilter: ref.read(reportViewModelProvider),
            onApply: (newFilter) {
              ref.read(reportViewModelProvider.notifier).setFilter(newFilter);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  // ... (existing imports)

  // 통합 영수증 발급
  void _showSummaryReceipt(List<Book> books, int totalPages, int totalBooks) {
    if (books.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('기간 내 완독한 책이 없습니다.')));
      return;
    }

    final filter = ref.read(reportViewModelProvider);
    final periodTitle = filter.displayTitle.toUpperCase();
    final GlobalKey globalKey = GlobalKey(); // Capture Key

    showDialog(
      context: context,
      builder: (context) {
        bool isSharing = false; // Local loading state for dialog

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. Capture Target
                  RepaintBoundary(
                    key: globalKey,
                    child: ReceiptWidget(
                      books: books,
                      periodText: periodTitle,
                      totalBooks: totalBooks,
                      totalPages: totalPages,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: isSharing ? null : () => context.pop(),
                        icon: const Icon(Icons.close),
                        label: const Text("닫기"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Share Button with Loading State
                      ElevatedButton.icon(
                        onPressed:
                            isSharing
                                ? null
                                : () async {
                                  setState(() => isSharing = true);
                                  await _captureAndShareReceipt(
                                    globalKey,
                                    periodTitle,
                                  );
                                  // Check if mounted before updating state, though dialog might remain open
                                  if (context.mounted) {
                                    setState(() => isSharing = false);
                                  }
                                },
                        icon:
                            isSharing
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : const Icon(Icons.share),
                        label:
                            isSharing
                                ? const Text("저장 중...")
                                : const Text("공유하기"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _captureAndShareReceipt(GlobalKey key, String title) async {
    try {
      // 1. Capture RenderObject
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      // 2. Convert to Image
      final image = await boundary.toImage(pixelRatio: 3.0); // High resolution
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes == null) return;

      // 3. Share
      if (kIsWeb) {
        // [Web] Create XFile from data directly
        final xFile = XFile.fromData(
          pngBytes,
          mimeType: 'image/png',
          name: 'summary_receipt.png',
        );

        await Share.shareXFiles([xFile], text: '나의 독서 결산 - $title');
      } else {
        // [Mobile] Save to Temp File
        final directory = await getTemporaryDirectory();
        final imagePath =
            await File('${directory.path}/summary_receipt.png').create();
        await imagePath.writeAsBytes(pngBytes);

        await Share.shareXFiles([
          XFile(imagePath.path),
        ], text: '나의 독서 결산 - $title');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('공유 실패: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(reportViewModelProvider);
    final statsAsync = ref.watch(reportStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "독서 결산",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFDFBF7),
        elevation: 0,
      ),
      body: statsAsync.when(
        data: (stats) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // 1. 기간 선택 헤더 (Custom Filter)
                GestureDetector(
                  onTap: _showFilterSheet,
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          filterState.displayTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_drop_down, size: 24),
                      ],
                    ),
                  ),
                ),

                // 2. 통계 카드
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ), // [Fix] 높이 줄임 (all: 24 -> vertical: 16)
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem("완독 권수", "${stats.totalBooks} 권"),
                      Container(height: 40, width: 1, color: Colors.grey[300]),
                      _buildStatItem("읽은 페이지", "${stats.totalPages} P"),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 1.5. 독서 잔디 심기 (Heatmap)
                ReadingHeatmapGraph(
                  yearInView: _getYearFromFilter(filterState),
                ),
                const SizedBox(height: 24),

                // 3. 리스트 헤더
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "상세 리스트",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // 4. 책 리스트
                stats.readBooks.isEmpty
                    ? const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: Text(
                          "기간 내 완독한 책이 없습니다.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                    : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                      shrinkWrap: true, // [Fix] 전체 스크롤을 위해 shrinkWrap 적용
                      physics:
                          const NeverScrollableScrollPhysics(), // [Fix] 내부 스크롤 비활성화
                      itemCount: stats.readBooks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final book = stats.readBooks[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 60,
                              color: Colors.grey[200],
                              child:
                                  book.coverUrl.isNotEmpty
                                      ? Image.network(
                                        book.coverUrl,
                                        fit: BoxFit.cover,
                                      )
                                      : const Icon(
                                        Icons.book,
                                        color: Colors.grey,
                                      ),
                            ),
                            title: Text(
                              book.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "${book.author} | ${book.totalUnit}p\n완독: ${DateFormat('yyyy.MM.dd').format(book.finishedAt!)}",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            trailing:
                                book.rating != null
                                    ? Text(
                                      "★ ${book.rating}",
                                      style: const TextStyle(
                                        color: Colors.amber,
                                      ),
                                    )
                                    : null,
                          ),
                        );
                      },
                    ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),

      // 5. 통합 영수증 발급 버튼
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          statsAsync.whenData((stats) {
            _showSummaryReceipt(
              stats.readBooks,
              stats.totalPages,
              stats.totalBooks,
            );
          });
        },
        backgroundColor: Colors.black,
        icon: const Icon(Icons.receipt_long, color: Colors.white),
        label: const Text("통합 영수증 발급", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ],
    );
  }

  int _getYearFromFilter(ReportFilterState filter) {
    if (filter.selectedDate != null) {
      return filter.selectedDate!.year;
    }
    if (filter.customRange != null) {
      return filter.customRange!.start.year;
    }
    return DateTime.now().year;
  }
}
