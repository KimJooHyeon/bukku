import 'package:flutter/material.dart';
import '../../models/book_model.dart';

class BookSpineWidget extends StatelessWidget {
  final Book book;
  final double width;
  final double height;
  final VoidCallback? onTap;
  final List<Color>? palette; // [New] Optional theme palette

  const BookSpineWidget({
    super.key,
    required this.book,
    this.width = 30, // Consolidated width
    this.height = 100, // Consolidated height
    this.onTap,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    // Default Pastel Colors Palette (Fallback)
    final defaultColors = [
      const Color(0xFFE57373), // Red 300
      const Color(0xFFF06292), // Pink 300
      const Color(0xFFBA68C8), // Purple 300
      const Color(0xFF9575CD), // Deep Purple 300
      const Color(0xFF7986CB), // Indigo 300
      const Color(0xFF64B5F6), // Blue 300
      const Color(0xFF4FC3F7), // Light Blue 300
      const Color(0xFF4DD0E1), // Cyan 300
      const Color(0xFF4DB6AC), // Teal 300
      const Color(0xFF81C784), // Green 300
      const Color(0xFFAED581), // Light Green 300
      const Color(0xFFFFD54F), // Amber 300
      const Color(0xFFFFB74D), // Orange 300
      const Color(0xFFFF8A65), // Deep Orange 300
      const Color(0xFFA1887F), // Brown 300
      const Color(0xFF90A4AE), // Blue Grey 300
    ];

    final colors = palette ?? defaultColors;
    final spineColor = colors[book.id.hashCode % colors.length];

    // [New] Contrast Logic
    final textColor =
        spineColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: spineColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2),
            bottomLeft: Radius.circular(2),
            topRight: Radius.circular(1),
            bottomRight: Radius.circular(1),
          ),
          // Subtle Flat Shadow
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(1, 0),
              blurRadius: 1,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Center(child: _buildSpineText(textColor)),
      ),
    );
  }

  Widget _buildSpineText(Color textColor) {
    // 3. Vertical Text Logic
    final isKorean = RegExp(r'[가-힣ㄱ-ㅎㅏ-ㅣ]').hasMatch(book.title);

    if (isKorean) {
      // Korean: Vertical stack of characters (Always vertical)
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              book.title.split('').take(8).map((char) {
                // Limit chars to fit
                return Text(
                  char,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                  ),
                );
              }).toList(),
        ),
      );
    } else {
      // English/Other: Rotated 90 degrees
      return RotatedBox(
        quarterTurns: 1,
        child: Text(
          book.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: textColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }
}
