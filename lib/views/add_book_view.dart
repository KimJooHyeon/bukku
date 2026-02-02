import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart'; // [New]
import '../models/book_model.dart';
import '../viewmodels/book_view_model.dart';

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

  // 드롭다운 선택값
  String _unitType = 'PAGE'; // 기본값: 페이지
  String _status = 'READING'; // 기본값: 읽는중

  // [Image] 선택된 이미지 (Web/Mobile 호환)
  XFile? _selectedImage;
  Uint8List? _imageBytes; // 미리보기용 데이터

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _totalPageController.dispose();
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
      final newBook = Book(
        // id는 Firestore에 저장된 후 생성되므로 빈 값으로 둠 (excludeFromToJson 처리됨)
        id: '',
        title: _titleController.text,
        author: _authorController.text,
        coverUrl: '', // ViewModel 내부에서 처리됨 (upload 후 갱신)
        unitType: _unitType,
        totalUnit: int.parse(_totalPageController.text),
        currentUnit: 0,
        status: _status,
        startedAt: DateTime.now(),
        // [Fix] 완독 상태로 저장 시 완독일 자동 설정
        finishedAt: _status == 'DONE' ? DateTime.now() : null,
      );

      // [Riverpod] ViewModel을 통해 데이터 저장 (이미지 포함)
      await ref
          .read(bookViewModelProvider.notifier)
          .addBook(newBook, coverImage: _selectedImage);

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
                                  PhosphorIcons.camera(), // [Changed]
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
              ),
              const SizedBox(height: 24),

              // 4. 기록 단위 & 독서 상태 (행으로 배치)
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _unitType,
                      decoration: const InputDecoration(
                        labelText: '기록 단위',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: const [
                        DropdownMenuItem(value: 'PAGE', child: Text('페이지')),
                        DropdownMenuItem(
                          value: 'PERCENT',
                          child: Text('퍼센트 (%)'),
                        ),
                        DropdownMenuItem(
                          value: 'CHAPTER',
                          child: Text('챕터 (장)'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _unitType = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _status,
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
                        setState(() {
                          _status = value!;
                        });
                      },
                    ),
                  ),
                ],
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
