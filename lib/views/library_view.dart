import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/book_model.dart';
import '../../providers/book_provider.dart';
import 'widgets/book_cover_widget.dart';
import 'widgets/book_spine_widget.dart';

import '../../viewmodels/theme_view_model.dart';
import '../../theme/book_theme.dart';

class LibraryView extends ConsumerStatefulWidget {
  const LibraryView({super.key});

  @override
  ConsumerState<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends ConsumerState<LibraryView> {
  void _showThemePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "테마 선택",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children:
                        BookThemeType.values.map((type) {
                          final isSelected =
                              ref.read(themeViewModelProvider) == type;
                          return GestureDetector(
                            onTap: () {
                              ref
                                  .read(themeViewModelProvider.notifier)
                                  .setTheme(type);
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 80,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Colors.grey[200]
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? Colors.black
                                          : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        BookTheme.getPalette(type)[2],
                                    radius: 20,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    BookTheme.getName(
                                      type,
                                    ).split(' ')[0], // Simple name
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final booksAsync = ref.watch(bookListProvider);
    final theme = ref.watch(themeViewModelProvider);
    final palette = BookTheme.getPalette(theme);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7), // Warm paper-like background
      body: booksAsync.when(
        data: (books) {
          // Filter books by status
          final readingBooks =
              books.where((b) => b.status == BookStatus.reading).toList();
          final wishBooks =
              books.where((b) => b.status == BookStatus.wish).toList();
          final doneBooks =
              books.where((b) => b.status == BookStatus.done).toList();

          return CustomScrollView(
            slivers: [
              // 1. App Bar Area
              SliverAppBar(
                title: const Text(
                  "서재",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: const Color(0xFFFDFBF7),
                floating: true,
                pinned: true,
                elevation: 0,
                centerTitle: false,
                actions: [
                  IconButton(
                    onPressed: _showThemePicker,
                    icon: const Icon(
                      Icons.palette_outlined,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              // 2. Section 1: Reading Books (The Carousel)
              SliverToBoxAdapter(child: _buildSectionTitle("읽고 있는 책 📖")),
              SliverToBoxAdapter(child: _buildReadingSection(readingBooks)),

              // 3. Section 2: Wish Books (The Shelf)
              SliverToBoxAdapter(child: _buildSectionTitle("읽고 싶은 책 ✨")),
              SliverToBoxAdapter(child: _buildWishSection(wishBooks, palette)),

              // 4. Section 3: Finished Books (The Archive)
              SliverToBoxAdapter(child: _buildSectionTitle("명예의 전당 🏆")),
              SliverToBoxAdapter(child: _buildDoneSection(doneBooks, palette)),

              const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add'),
        label: const Text("책 추가"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  // Section 1: PageView for Reading Books
  Widget _buildReadingSection(List<Book> books) {
    if (books.isEmpty) {
      return Container(
        height: 280,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "독서를 시작해보세요",
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 320, // Cover (280) + Padding
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.6), // Tight formatting
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          // Scale effect for the current item can be added here if needed using a listener
          return BookCoverWidget(
            book: book,
            onTap: () => context.push('/detail/${book.id}', extra: book),
          );
        },
      ),
    );
  }

  // Section 2: Horizontal List with Shelf for Wish Books
  Widget _buildWishSection(List<Book> books, List<Color> palette) {
    return SizedBox(
      height: 160, // Spine (140) + Shelf (8) + Padding
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Shelf Line
          Positioned(
            bottom: 0,
            left: 20,
            right: 20,
            child: Container(
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 2),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          // Books
          if (books.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text("찜한 책이 없습니다", style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: books.length,
              separatorBuilder:
                  (_, __) => const SizedBox(width: 4), // Tight shelf look
              itemBuilder: (context, index) {
                final book = books[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BookSpineWidget(
                      book: book,
                      palette: palette,
                      // width: 28, // Removed for dynamic width
                      height:
                          120 +
                          (index % 3) *
                              10, // Slight height variation for realism
                      onTap:
                          () => context.push('/detail/${book.id}', extra: book),
                    ),
                    const SizedBox(height: 8), // Start from top of shelf
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  // Section 3: Done Books (Strict Grid: 5 Columns)
  Widget _buildDoneSection(List<Book> books, List<Color> palette) {
    return SizedBox(
      height: 160, // Spine (140) + Shelf (8) + Padding
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Shelf Line
          Positioned(
            bottom: 0,
            left: 20,
            right: 20,
            child: Container(
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 2),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          // Books
          if (books.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  "완독한 책이 없습니다",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: books.length,
              separatorBuilder:
                  (_, __) => const SizedBox(width: 4), // Tight shelf look
              itemBuilder: (context, index) {
                final book = books[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BookSpineWidget(
                      book: book,
                      palette: palette,
                      // width: 28, // Removed for dynamic width
                      height:
                          120 +
                          (index % 3) *
                              10, // Slight height variation for realism
                      onTap:
                          () => context.push('/detail/${book.id}', extra: book),
                    ),
                    const SizedBox(height: 8), // Start from top of shelf
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
