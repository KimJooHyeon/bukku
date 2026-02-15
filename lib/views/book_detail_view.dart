import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'dart:io';

import '../models/book_model.dart';
import '../providers/book_provider.dart';
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
      // ViewModel -> Repository 직접 호출로 변경
      await ref.read(bookRepositoryProvider).updateBook(_editingBook);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('수정되었습니다')));
        context.pop(); // 상세 화면 닫기
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("저장 실패"),
                content: Text("오류가 발생했습니다.\n$e"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("확인"),
                  ),
                ],
              ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // [N회독] 다음 회독 시작
  Future<void> _startNextReading() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${_editingBook.readCount + 1}회독 시작"),
          content: const Text(
            "현재 독서 기록(완독일, 별점, 메모)을 저장하고\n"
            "새로운 마음으로 다시 읽기를 시작하시겠습니까?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("취소", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("시작하기", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    setState(() {
      // 1. 새로운 기록 추가 (N+1회독)
      final newRecord = ReadingRecord(
        readCount: _editingBook.readCount + 1, // Getter uses records.length
        startedAt: DateTime.now(),
        rating: null,
        review: null,
      );

      // 2. 리스트 갱신
      // 기존 records에 새 record 추가
      final updatedRecords = [..._editingBook.records, newRecord];

      // 3. 새로운 상태로 갱신
      _editingBook = _editingBook.copyWith(
        status: BookStatus.reading,
        currentUnit: 0,
        records: updatedRecords,
      );
    });

    // 바로 저장하지 않고, 편집 상태로 변경함 (사용자가 '변경사항 저장' 눌러야 함)
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("새로운 독서를 시작합니다. '변경사항 저장'을 눌러주세요.")),
      );
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
      // ViewModel -> Repository 직접 호출로 변경
      await ref.read(bookRepositoryProvider).deleteBook(_editingBook.id);

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
          // Enum 비교로 변경
          if (_editingBook.status == BookStatus.done)
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

            // 2. 제목 및 작가
            if (_editingBook.readCount > 1)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${_editingBook.readCount}회독 중 📚",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
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

            // 3. 독서 상태 변경 (DropdownButtonFormField<BookStatus>)
            DropdownButtonFormField<BookStatus>(
              value: _editingBook.status,
              decoration: const InputDecoration(
                labelText: '독서 상태',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              items: const [
                DropdownMenuItem(
                  value: BookStatus.reading,
                  child: Text('읽는 중'),
                ),
                DropdownMenuItem(value: BookStatus.done, child: Text('완독')),
                DropdownMenuItem(value: BookStatus.wish, child: Text('찜')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    // [Fix] 상태 변경 시 완독일(finishedAt) 자동 처리 (현재 기록 업데이트)
                    final now = DateTime.now();

                    // 현재 기록 복사 및 수정
                    ReadingRecord? currentRecord = _editingBook.currentRecord;
                    if (currentRecord != null) {
                      if (value == BookStatus.done) {
                        currentRecord = currentRecord.copyWith(
                          finishedAt: currentRecord.finishedAt ?? now,
                        );
                      } else {
                        currentRecord = currentRecord.copyWith(
                          finishedAt: null,
                        );
                      }
                    }

                    // 레코드 리스트 업데이트
                    List<ReadingRecord> records = [..._editingBook.records];
                    if (records.isNotEmpty && currentRecord != null) {
                      records.last = currentRecord;
                    }

                    _editingBook = _editingBook.copyWith(
                      status: value,
                      records: records, // 업데이트된 레코드 반영
                    );
                  });
                }
              },
            ),
            const SizedBox(height: 24),

            // 4. 진행률 (읽는 중일 때만 표시)
            if (_editingBook.status == BookStatus.reading) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "진행률 (${_editingBook.currentUnit} / ${_editingBook.totalUnit} p)",
                  ),
                  Text(
                    "${_editingBook.totalUnit > 0 ? ((_editingBook.currentUnit / _editingBook.totalUnit) * 100).toInt() : 0}%",
                  ),
                ],
              ),
              Slider(
                value: _editingBook.currentUnit.toDouble().clamp(
                  0.0,
                  _editingBook.totalUnit.toDouble(),
                ),
                min: 0,
                max:
                    _editingBook.totalUnit.toDouble() > 0
                        ? _editingBook.totalUnit.toDouble()
                        : 1.0,
                activeColor: Colors.black,
                inactiveColor: Colors.grey[300],
                onChanged: (value) {
                  final isCompleted = value >= _editingBook.totalUnit;
                  setState(() {
                    // [UX] 100% 도달 시 자동으로 '완독' 처리
                    if (isCompleted) {
                      // 현재 기록 완독 처리
                      final now = DateTime.now();
                      List<ReadingRecord> records = [..._editingBook.records];
                      if (records.isNotEmpty) {
                        records.last = records.last.copyWith(finishedAt: now);
                      }

                      _editingBook = _editingBook.copyWith(
                        currentUnit: value.toInt(),
                        status: BookStatus.done,
                        records: records,
                      );
                    } else {
                      _editingBook = _editingBook.copyWith(
                        currentUnit: value.toInt(),
                      );
                    }
                  });
                },
              ),
              const SizedBox(height: 24),
            ] else if (_editingBook.status == BookStatus.done) ...[
              // 완독 상태일 때: 완독 날짜 표시 및 되돌리기
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "완독함! 🎉",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _editingBook.currentRecord?.finishedAt != null
                              ? "완독일: ${_editingBook.currentRecord?.finishedAt.toString().split(' ')[0]}"
                              : "날짜 정보 없음",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          // 취소 시 완독일 제거
                          List<ReadingRecord> records = [
                            ..._editingBook.records,
                          ];
                          if (records.isNotEmpty) {
                            records.last = records.last.copyWith(
                              finishedAt: null,
                            );
                          }

                          _editingBook = _editingBook.copyWith(
                            status: BookStatus.reading,
                            records: records,
                          );
                        });
                      },
                      icon: const Icon(Icons.undo, size: 16),
                      label: const Text("취소"),
                      style: TextButton.styleFrom(foregroundColor: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // [N회독] 다음 회독 시작 버튼
              if (widget.book.status == BookStatus.done)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _startNextReading,
                    icon: const Icon(Icons.auto_stories, size: 18),
                    label: Text("${_editingBook.readCount + 1}회독 시작하기"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 32),
            ],

            // 5. 별점 및 메모 (완독일 때만 표시)
            if (_editingBook.status == BookStatus.done) ...[
              const Text(
                "나의 평가",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // [RatingBar]
              Center(
                child: RatingBar.builder(
                  initialRating: _editingBook.currentRecord?.rating ?? 0.0,
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
                      List<ReadingRecord> records = [..._editingBook.records];
                      if (records.isNotEmpty) {
                        records.last = records.last.copyWith(rating: rating);
                      }
                      _editingBook = _editingBook.copyWith(records: records);
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              // [Memo/Review]
              TextFormField(
                initialValue: _editingBook.currentRecord?.review,
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
                  setState(() {
                    List<ReadingRecord> records = [..._editingBook.records];
                    if (records.isNotEmpty) {
                      records.last = records.last.copyWith(review: value);
                    }
                    _editingBook = _editingBook.copyWith(records: records);
                  });
                },
              ),
            ],

            // 6. 독서 히스토리 (2회독 이상일 때 또는 기록이 있을 때 표시)
            if (_editingBook.records.length > 1 ||
                (_editingBook.records.isNotEmpty &&
                    _editingBook.records.first.finishedAt != null)) ...[
              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 20),
              const Text(
                "독서 히스토리",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _editingBook.records.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  // 역순 표시 (최신순)
                  final recordIndex = _editingBook.records.length - 1 - index;
                  final record = _editingBook.records[recordIndex];

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${record.readCount}회독",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (record.rating != null)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${record.rating}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${record.startedAt?.toString().split(' ')[0] ?? '?'} ~ ${record.finishedAt?.toString().split(' ')[0] ?? '읽는 중'}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        if (record.review != null &&
                            record.review!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            record.review!,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ],

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
