import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../models/book_model.dart';
import '../providers/book_provider.dart';
import '../theme/book_theme.dart';
import '../viewmodels/theme_view_model.dart';

class LibraryView extends ConsumerStatefulWidget {
  const LibraryView({super.key});

  @override
  ConsumerState<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends ConsumerState<LibraryView> {
  // 테마 변경 바텀시트
  void _showThemePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final currentTheme = ref.watch(themeViewModelProvider);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      "Choose a Theme 🎨",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...BookThemeType.values.map((type) {
                    final isSelected = currentTheme == type;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: BookTheme.getPalette(type)[0],
                      ),
                      title: Text(
                        BookTheme.getName(type),
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing:
                          isSelected
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                      onTap: () {
                        ref
                            .read(themeViewModelProvider.notifier)
                            .setTheme(type);
                        Navigator.pop(context);
                      },
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // [Changed] bookViewModleProvider -> bookListProvider (Firestore)
    final booksAsyncValue = ref.watch(bookListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Library",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: const Color(0xFFFFFBFA), // 종이 질감 아이보리
        elevation: 0,
        actions: [
          // [Theme Picker] 테마 변경 버튼
          IconButton(
            onPressed: () => _showThemePicker(context),
            icon: const Icon(Icons.palette_outlined, color: Colors.black),
          ),
          IconButton(
            onPressed: () {}, // 검색
            icon: Icon(PhosphorIcons.magnifyingGlass(), color: Colors.black),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFFFFBFA),
        child: booksAsyncValue.when(
          data: (books) {
            if (books.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      PhosphorIcons.books(),
                      size: 64,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "첫 번째 책을 등록해보세요!",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: CustomPaint(
                painter: _ShelfPainter(), // 선반 라인 그리기
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40), // 마지막 선반 여유
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.start,
                    spacing: 4.0, // 책 사이 간격
                    runSpacing: 40.0, // 선반 위아래 간격 (책110 + 선반12 + 여유)
                    crossAxisAlignment: WrapCrossAlignment.end, // 바닥 정렬
                    children:
                        books.map((book) {
                          return GestureDetector(
                            onTap: () => context.push('/detail', extra: book),
                            child: _SolidSpineWidget(book: book),
                          );
                        }).toList(),
                  ),
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text("Error: $err")),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add'),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// [Painter] 나무 선반 그리기 (두께감 있는 받침대)
class _ShelfPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFFD7CCC8) // 연한 나무색
          ..style = PaintingStyle.fill;

    // 책 높이(110) + runSpacing(40) = 150 간격 예상
    // 선반은 책 바로 밑(110)에 위치. 두께 12.0
    const double bookHeight = 110.0;
    const double runSpacing = 40.0;
    const double shelfThickness = 12.0;

    // 첫 번째 줄부터 화면 끝까지 반복
    for (
      double y = bookHeight;
      y < size.height + 150;
      y += (bookHeight + runSpacing)
    ) {
      // 선반 직사각형 그리기
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, shelfThickness), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// [Theme 10] Solid Pastel Style (Grounded & Clean)
class _SolidSpineWidget extends ConsumerWidget {
  final Book book;

  const _SolidSpineWidget({required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. 랜덤 시드 및 해시
    final int seed =
        (book.id.isNotEmpty ? book.id.hashCode : book.title.hashCode);
    final int hash = seed ^ (book.totalUnit * 13) ^ (book.title.length * 7);

    // 2. 동적 테마 팔레트 (ThemeViewModel 사용)
    final currentTheme = ref.watch(themeViewModelProvider);
    final palette = BookTheme.getPalette(currentTheme);
    final int colorIndex = hash.abs() % palette.length;
    final baseColor = palette[colorIndex];

    // 텍스트 색상 결정 (어두운 배경에선 흰색, 밝은 배경에선 진한 잉크색)
    final textColor = colorIndex >= 3 ? Colors.white : const Color(0xFF2D2D2D);

    // 3. 크기 계산 (높이 고정)
    final double width = (book.totalUnit / 10).clamp(32.0, 55.0);
    const double height = 110.0;

    // 4. 제목 정제 (태그 제거)
    String cleanTitle = book.title.replaceAll(RegExp(r'\s*\(.*?\)'), '').trim();

    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(right: 0),
      decoration: BoxDecoration(
        color: baseColor,
        // 위는 둥글게, 아래는 평평하게 (선반에 안착된 느낌)
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(6.0),
          bottom: Radius.circular(1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                cleanTitle.split('').map((char) {
                  if (char == ' ') {
                    return const SizedBox(height: 4.0);
                  }
                  final isRotatedSymbol = [':', '-', '(', ')'].contains(char);

                  Widget textWidget = Text(
                    char,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 11.0,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                      fontFamily: 'sans-serif',
                    ),
                  );

                  if (isRotatedSymbol) {
                    return RotatedBox(quarterTurns: 1, child: textWidget);
                  }
                  return textWidget;
                }).toList(),
          ),
        ),
      ),
    );
  }
}
