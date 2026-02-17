import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../models/book_model.dart';
import '../providers/book_provider.dart';

class AddBookView extends ConsumerStatefulWidget {
  const AddBookView({super.key});

  @override
  ConsumerState<AddBookView> createState() => _AddBookViewState();
}

class _AddBookViewState extends ConsumerState<AddBookView> {
  final _formKey = GlobalKey<FormState>();

  // 입력 컨트롤러
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _totalPageController = TextEditingController();
  final TextEditingController _reviewController =
      TextEditingController(); // [New]

  // 독서 상태 (Enum)
  BookStatus _status = BookStatus.reading;
  double _rating = 0.0; // [New]

  // [Image] 선택된 이미지 (Web/Mobile 호환)
  XFile? _selectedImage;
  Uint8List? _imageBytes; // 미리보기용 데이터

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _totalPageController.dispose();
    _reviewController.dispose(); // [New]
    super.dispose();
  }

  // [Image] 이미지 선택
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImage = pickedFile;
        _imageBytes = bytes;
      });
    }
  }

  // 저장 로직
  Future<void> _saveBook() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final repository = ref.read(bookRepositoryProvider);
      String coverUrl = '';

      // 1. 이미지 업로드
      if (_selectedImage != null) {
        coverUrl = await repository.uploadBookCover(_selectedImage!);
      }

      // 2. 책 객체 생성
      final newBook = Book(
        // id는 Firestore에 저장된 후 생성되므로 빈 값
        id: '',
        title: _titleController.text,
        author:
            _titleController.text.isNotEmpty
                ? _authorController.text
                : 'Unknown', // 작가 없을 경우 처리? validator가 있으므로 안심
        coverUrl: coverUrl,
        // unitType 제거됨 (기본값 사용)
        totalUnit: int.parse(_totalPageController.text),
        currentUnit: 0,
        status: _status,
        records: [
          ReadingRecord(
            readCount: 1,
            startedAt: DateTime.now(),
            finishedAt: _status == BookStatus.done ? DateTime.now() : null,
            rating: _status == BookStatus.done ? _rating : null, // [New]
            review:
                _status == BookStatus.done
                    ? _reviewController.text
                    : null, // [New]
          ),
        ],
      );

      // 3. Firestore 저장
      await repository.addBook(newBook);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('책이 추가되었습니다')));
        if (mounted) context.pop(); // [GoRouter] 뒤로가기
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('오류 발생: $e')));
        print("Add Book Error: $e"); // Debug log
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "책 추가",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: const Color(0xFFFDFBF7),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // [Image] 표지 이미지 선택 영역
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 120,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      // 이미지가 있으면 배경 이미지로 표시 (Memory Image 사용)
                      image:
                          _imageBytes != null
                              ? DecorationImage(
                                image: MemoryImage(_imageBytes!),
                                fit: BoxFit.cover,
                              )
                              : null,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child:
                        _imageBytes == null
                            ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  PhosphorIcons.camera(),
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "표지 추가",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                            : null,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 1. 책 제목
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '책 제목',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '책 제목을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 2. 작가
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(
                  labelText: '작가',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '작가를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. 전체 페이지 수
              TextFormField(
                controller: _totalPageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '전체 분량 (페이지 수)',
                  helperText: '숫자만 입력해주세요',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '전체 페이지 수를 입력해주세요';
                  }
                  if (int.tryParse(value) == null) {
                    return '숫자만 입력해주세요';
                  }
                  return null;
                },
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 24),

              // 4. 독서 상태 (행으로 배치)
              DropdownButtonFormField<BookStatus>(
                value: _status,
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
                  setState(() {
                    _status = value!;
                  });
                },
              ),
              const SizedBox(height: 24),

              // [Animation] 완독 시 추가 입력 필드 (별점, 한줄평)
              AnimatedCrossFade(
                firstChild: Container(),
                secondChild: Column(
                  children: [
                    const Text(
                      "나의 평가",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    // [RatingBar]
                    RatingBar.builder(
                      initialRating: _rating,
                      minRating: 0.5,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder:
                          (context, _) => Icon(
                            PhosphorIcons.star(PhosphorIconsStyle.fill),
                            color: Colors.amber,
                          ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    // [Review]
                    TextFormField(
                      controller: _reviewController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: '한줄평',
                        hintText: "이 책에 대한 생각이나 메모를 남겨주세요.",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
                crossFadeState:
                    _status == BookStatus.done
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
              const SizedBox(height: 32),

              // 5. 저장 버튼
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveBook,
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
                            '저장하기',
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
      ),
    );
  }
}
