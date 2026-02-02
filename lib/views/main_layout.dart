import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'library_view.dart'; // [New]
import 'album_view.dart'; // [New]
import 'report/report_view.dart';

// [State] 현재 탭 인덱스 관리 Provider
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class MainLayout extends ConsumerWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    // [Body] 탭에 따른 화면 반환
    Widget getBody() {
      switch (currentIndex) {
        case 0:
          // 1. 서재 (Realistic/Graphic Theme)
          return const LibraryView();
        case 1:
          // 2. 앨범 (Cover Grid)
          return const AlbumView();
        case 2:
          // 3. 리포트
          return const ReportView();
        case 3:
          // 4. 설정 (준비중)
          return const Center(child: Text("설정 화면 (준비중)"));
        default:
          return const LibraryView();
      }
    }

    return Scaffold(
      // [Body] 현재 인덱스에 맞는 화면 표시
      body: getBody(),

      // [BottomNavigationBar]
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            ref.read(bottomNavIndexProvider.notifier).state = index;
          },
          type: BottomNavigationBarType.fixed, // 4개 이상이므로 fixed 필수
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black, // 선택된 아이템: 검정
          unselectedItemColor: Colors.grey, // 선택 안됨: 회색
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.shelves), // or local_library
              label: '서재',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: '앨범'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '리포트'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
          ],
        ),
      ),
    );
  }
}
