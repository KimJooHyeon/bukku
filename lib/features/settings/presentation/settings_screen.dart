import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/presentation/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch current user state
    final user = ref.watch(currentUserProvider);
    final authService = ref.read(authServiceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: Text(
          "설정",
          style: GoogleFonts.nanumMyeongjo(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: const Color(0xFFFDFBF7),
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child:
            user == null
                ? const Center(child: Text("로그인 정보가 없습니다."))
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    // Profile Section
                    Center(
                      child: Column(
                        children: [
                          // Profile Image
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage:
                                user.photoURL != null
                                    ? NetworkImage(user.photoURL!)
                                    : null,
                            child:
                                user.photoURL == null
                                    ? const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    )
                                    : null,
                          ),
                          const SizedBox(height: 16),
                          // Name
                          Text(
                            user.displayName ?? "사용자",
                            style: GoogleFonts.nanumMyeongjo(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Email
                          Text(
                            user.email ?? "이메일 없음",
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),

                    // Logout Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: OutlinedButton(
                        onPressed: () async {
                          // 1. Sign Out Logic
                          await authService.signOut();

                          // 2. Navigation to Login Screen
                          if (context.mounted) {
                            context.go('/login');
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.red.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "로그아웃",
                          style: GoogleFonts.nanumMyeongjo(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade400,
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
