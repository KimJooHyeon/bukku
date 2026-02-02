import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // [New]
import 'package:path_provider/path_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart'; // [New]
import 'dart:io';

import '../models/book_model.dart';
import '../viewmodels/book_view_model.dart';
import 'widgets/receipt_widget.dart';

class BookDetailView extends ConsumerStatefulWidget {
  final Book book;

  const BookDetailView({super.key, required this.book});

  @override
  ConsumerState<BookDetailView> createState() => _BookDetailViewState();
}

class _BookDetailViewState extends ConsumerState<BookDetailView> {
  // 수정 중인 책 상태를 로컬에서 관리 (불변 객체이므로 copyWith로 교체)
  late Book _editingBook;
  bool _isLoading = false;

  // [Receipt] 캡처를 위한 컨트롤러
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _editingBook = widget.book;
  }

  // [Receipt] 영수증 캡처 및 공유
  Future<void> _shareReceipt() async {
    try {
      // 1. 위젯 캡처 (Uint8List)
      final imageBytes = await _screenshotController.capture();
      if (imageBytes == null) return;

      // 2. 임시 파일로 저장
      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/receipt.png').create();
      await imagePath.writeAsBytes(imageBytes);

      // 3. 공유 (XFile 사용)
      await Share.shareXFiles([
        XFile(imagePath.path),
      ], text: '나의 독서 영수증 - ${_editingBook.title}');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('공유 실패: $e')));
      }
    }
  }

  // [Update] 책 정보 수정 저장
  Future<void> _updateBook() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(bookViewModelProvider.notifier).updateBook(_editingBook);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('수정되었습니다')));
        context.pop(); // 상세 화면 닫기
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('수정 실패: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // [Delete] 책 삭제 (다이얼로그 확인)
  Future<void> _deleteBook() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("책 삭제"),
          content: const Text("정말로 이 책을 삭제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("취소", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("삭제", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ref
          .read(bookViewModelProvider.notifier)
          .deleteBook(_editingBook.id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('삭제되었습니다')));
        context.pop(); // 상세 화면 닫기
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('삭제 실패: $e')));
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  // [Receipt] 영수증 다이얼로그 표시
  void _showReceiptDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 캡처 대상 위젯
              Screenshot(
                controller: _screenshotController,
                child: ReceiptWidget(
                  books: [_editingBook],
                  totalBooks: 1,
                  totalPages: _editingBook.totalUnit,
                  periodText: "BOOK LOG",
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => context.pop(),
                    icon: Icon(PhosphorIcons.x()),
                    label: const Text("닫기"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      _shareReceipt();
                    },
                    icon: Icon(PhosphorIcons.shareNetwork()),
                    label: const Text("공유하기"),
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
  }

  // ... (Logic same)

  @override
  Widget build(BuildContext context) {
    // 배경색: 약간 어두운 크림색
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: const Text("책 상세"),
        backgroundColor: const Color(0xFFFDFBF7),
        elevation: 0,
        actions: [
          // [Receipt] 영수증 버튼 (완독 시에만)
          if (_editingBook.status == 'DONE')
            IconButton(
              onPressed: _showReceiptDialog,
              icon: Icon(PhosphorIcons.receipt(), color: Colors.black),
              tooltip: "영수증 발급",
            ),
          IconButton(
            onPressed: _deleteBook,
            icon: Icon(PhosphorIcons.trash(), color: Colors.grey),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. 책 표지
            Center(
              child: Hero(
                tag: _editingBook.id,
                child: Container(
                  width: 140,
                  height: 210,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(4, 4),
                        blurRadius: 10,
                      ),
                    ],
                    image:
                        _editingBook.coverUrl.isNotEmpty
                            ? DecorationImage(
                              image: NetworkImage(_editingBook.coverUrl),
                              fit: BoxFit.cover,
                            )
                            : null,
                    color: Colors.grey[300],
                  ),
                  child:
                      _editingBook.coverUrl.isEmpty
                          ? const Icon(Icons.book, size: 50, color: Colors.grey)
                          : null,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 2. 제목 및 작가 (읽기 전용/수정 가능?) -> 일단 Text로 표시
            Text(
              _editingBook.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _editingBook.author,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // 3. 독서 상태 변경
            DropdownButtonFormField<String>(
              value: _editingBook.status,
              decoration: const InputDecoration(
                labelText: '독서 상태',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              items: const [
                DropdownMenuItem(value: 'READING', child: Text('읽는 중')),
                DropdownMenuItem(value: 'DONE', child: Text('완독')),
                DropdownMenuItem(value: 'WISH', child: Text('찜')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    // [Fix] 상태 변경 시 완독일(finishedAt) 자동 처리
                    final now = DateTime.now();
                    DateTime? newFinishedAt = _editingBook.finishedAt;

                    if (value == 'DONE') {
                      // 완독으로 변경 시, 날짜가 없으면 현재 시간 입력
                      newFinishedAt ??= now;
                    } else {
                      // 완독이 아니면 날짜 초기화
                      newFinishedAt = null;
                    }

                    _editingBook = _editingBook.copyWith(
                      status: value,
                      finishedAt: newFinishedAt,
                    );
                  });
                }
              },
            ),
            const SizedBox(height: 24),

            // 4. 진행률 (Slider + Text Input)
            if (_editingBook.unitType == 'PAGE') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "진행률 (${_editingBook.currentUnit} / ${_editingBook.totalUnit} p)",
                  ),
                  Text(
                    "${((_editingBook.currentUnit / _editingBook.totalUnit) * 100).toInt()}%",
                  ),
                ],
              ),
              Slider(
                value: _editingBook.currentUnit.toDouble(),
                min: 0,
                max: _editingBook.totalUnit.toDouble(),
                activeColor: Colors.black,
                inactiveColor: Colors.grey[300],
                onChanged: (value) {
                  setState(() {
                    _editingBook = _editingBook.copyWith(
                      currentUnit: value.toInt(),
                    );
                  });
                },
              ),
            ],

            // 5. 별점 및 메모
            const SizedBox(height: 24),
            const Text("나의 평가", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // [RatingBar]
            Center(
              child: RatingBar.builder(
                initialRating: _editingBook.rating ?? 0.0,
                minRating: 0.5,
                direction: Axis.horizontal,
                allowHalfRating: true, // 0.5 단위 지원
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder:
                    (context, _) => Icon(
                      PhosphorIcons.star(PhosphorIconsStyle.fill),
                      color: Colors.amber,
                    ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _editingBook = _editingBook.copyWith(rating: rating);
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // [Memo]
            TextFormField(
              initialValue: _editingBook.memo,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "이 책에 대한 한 줄 평이나 메모를 남겨보세요.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                // setState를 매번 호출하면 타이핑마다 렌더링되므로,
                // 값만 반영하거나 Debounce 처리 권장.
                // 하지만 여기선 구조상 setState로 로컬 상태 동기화 유지 (Form 필드가 아니므로)
                setState(() {
                  _editingBook = _editingBook.copyWith(memo: value);
                });
              },
            ),

            const SizedBox(height: 40),

            // 6. 저장 버튼
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          '변경사항 저장',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
