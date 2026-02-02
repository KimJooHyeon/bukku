import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart'; // [New]
import '../models/book_model.dart';
import '../viewmodels/book_view_model.dart';

class AlbumView extends ConsumerWidget {
  const AlbumView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsyncValue = ref.watch(bookViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Album",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: const Color(0xFFFDFBF7),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(PhosphorIcons.magnifyingGlass(), color: Colors.black),
          ),
        ],
      ),
      body: booksAsyncValue.when(
        data: (books) {
          if (books.isEmpty) {
            return Center(
              child: Text(
                "등록된 책이 없습니다.",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 24,
            ),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return GestureDetector(
                onTap: () {
                  context.push('/detail', extra: book);
                },
                child: _buildCoverItem(book),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('오류 발생: $error')),
      ),
    );
  }

  Widget _buildCoverItem(Book book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(51),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Center(
              child:
                  book.coverUrl.isEmpty
                      ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          book.title,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12),
                        ),
                      )
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          book.coverUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          book.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }
}
