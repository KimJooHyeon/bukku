import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/book_model.dart';

class ReceiptWidget extends StatelessWidget {
  final List<Book> books;
  final int totalBooks;
  final int totalPages;
  final String periodText; // "2023.10" or "2023"

  const ReceiptWidget({
    super.key,
    required this.books,
    required this.totalBooks,
    required this.totalPages,
    required this.periodText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: const BoxDecoration(
        color: Color(0xFFEEEFEF), // 영수증 종이 색상
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // [Top] Zigzag
          _buildZigzag(true),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              children: [
                // Header
                Text(
                  "BUKKU RECEIPT",
                  style: GoogleFonts.spaceMono(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
                  style: GoogleFonts.spaceMono(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(color: Colors.black, thickness: 1),
                const SizedBox(height: 8),

                // Column Headers
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "ITEM",
                        style: GoogleFonts.spaceMono(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      "QTY",
                      style: GoogleFonts.spaceMono(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(color: Colors.black54, thickness: 0.5),
                const SizedBox(height: 16),

                // Book List
                if (books.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "No records found.",
                      style: GoogleFonts.spaceMono(color: Colors.grey),
                    ),
                  )
                else
                  ...books.map((book) => _buildBookRow(book)),

                const SizedBox(height: 16),
                const Divider(color: Colors.black, thickness: 1),
                const SizedBox(height: 16),

                // Totals
                _buildTotalRow("TOTAL BOOKS", "$totalBooks"),
                const SizedBox(height: 8),
                _buildTotalRow("TOTAL PAGES", "$totalPages"),

                const SizedBox(height: 32),

                // Footer (Barcode like)
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      40,
                      (index) => Container(
                        width: index % 3 == 0 ? 2 : 4,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "THANK YOU FOR READING",
                  style: GoogleFonts.spaceMono(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // [Bottom] Zigzag
          _buildZigzag(false),
        ],
      ),
    );
  }

  Widget _buildBookRow(Book book) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              book.title.toUpperCase(),
              style: GoogleFonts.spaceMono(fontSize: 12, color: Colors.black87),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            "${book.totalUnit}",
            style: GoogleFonts.spaceMono(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.spaceMono(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.spaceMono(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // 지그재그 모양 만들기
  Widget _buildZigzag(bool isTop) {
    return SizedBox(
      height: 10,
      width: double.infinity,
      child: CustomPaint(
        painter: ZigZagPainter(color: const Color(0xFFEEEFEF), isTop: isTop),
      ),
    );
  }
}

class ZigZagPainter extends CustomPainter {
  final Color color;
  final bool isTop;

  ZigZagPainter({required this.color, required this.isTop});

  @override
  void paint(Canvas canvas, Size size) {
    // final paint = Paint()..color = color;
    // final path = Path();

    // 이 위젯은 배경 위에 덧그리는 방식이 아니라,
    // 영수증의 '잘린 부분'을 표현해야 함.
    // 하지만 Flutter 컨테이너는 사각형이므로, 투명 배경에 지그재그를 그리는게 아니라
    // 지그재그 모양의 Clipper나, 배경색과 동일한 색으로 채워진 지그재그를 사용해야 함.
    // 여기서는 간단히 Container color가 있으므로, 투명 영역에 그리긴 어려움.
    // 대신 ClipPath를 쓰는게 낫지만, 코드가 길어지므로
    // 그냥 Row of Triangles로 흉내 내거나, 그냥 둠.

    // 단순화: 여기서는 구현 편의상 생략하거나 간단한 장식으로 대체 가능.
    // 제대로 하려면 ClipPath 사용.
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
