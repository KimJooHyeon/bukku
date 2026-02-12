import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart'; // [New] for context.go

import '../../../../viewmodels/theme_view_model.dart';
import '../../../../theme/book_theme.dart';
import '../../../../services/auth_service.dart'; // [New] AuthService import

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleGoogleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await _authService.signInWithGoogle();

      if (userCredential != null) {
        // 로그인 성공 -> 홈 화면으로 이동
        if (mounted) {
          context.go('/'); // Replace current route with Home
        }
      } else {
        // 로그인 실패 또는 취소
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("로그인이 취소되었거나 실패했습니다.")));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("오류 발생: $e")));
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
    final themeType = ref.watch(themeViewModelProvider);
    // Use the last color (strongest) as the point color
    final pointColor = BookTheme.getPalette(themeType).last;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7), // Ivory / Paper texture feel
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2), // Gives more abundance to the top
              // [Branding Section]
              Center(
                child: Column(
                  children: [
                    Text(
                      "BUKKU",
                      style: GoogleFonts.merriweather(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: pointColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "당신의 독서가 쌓이는 공간",
                      style: GoogleFonts.nanumMyeongjo(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              // [Login Button Section]
              // Minimal Google Login Button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap:
                        _isLoading
                            ? null
                            : _handleGoogleLogin, // [New] Connect handler
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isLoading) ...[
                            // [New] Loading Indicator
                            const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.grey,
                              ),
                            ),
                          ] else ...[
                            // Google Icon Replacement (Simple 'G' text)
                            ShaderMask(
                              shaderCallback:
                                  (bounds) => const LinearGradient(
                                    colors: [
                                      Colors.blue,
                                      Colors.red,
                                      Colors.yellow,
                                      Colors.green,
                                    ],
                                  ).createShader(bounds),
                              child: const Text(
                                'G',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Colors.white, // Required for ShaderMask
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(width: 12),
                          Text(
                            _isLoading
                                ? "로그인 중..."
                                : "Google로 시작하기", // [New] Text change
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Optional: Version or Footer info
              Center(
                child: Text(
                  "v1.0.0",
                  style: GoogleFonts.spaceMono(
                    fontSize: 10,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
