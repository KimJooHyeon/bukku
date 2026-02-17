import 'package:flutter/material.dart';
import '../../models/book_model.dart';

class BookCoverWidget extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;

  const BookCoverWidget({super.key, required this.book, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                6,
              ), // Slightly rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child:
                book.coverUrl.isNotEmpty
                    ? Image.network(
                      book.coverUrl,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => _buildPlaceholder(),
                    )
                    : _buildPlaceholder(),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[300],
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: Text(
        book.title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
