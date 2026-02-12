import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart'; // for debugPrint

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // [Fix] Windows/Web 환경에서 필요한 Client ID (google-services.json의 client_type 3)
    clientId:
        '96977680678-tj9jh52ueio14233jf1ttgeetvr12qt9.apps.googleusercontent.com',
  );

  // Google 로그인
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. 구글 로그인 흐름 시작 (계정 선택 창)
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // 사용자가 로그인 창을 닫았거나 취소한 경우
      if (googleUser == null) {
        debugPrint("Google Sign-In aborted by user.");
        return null;
      }

      // 2. 구글 인증 정보 구하기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Firebase용 자격 증명 생성
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Firebase에 로그인
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      debugPrint("Google Sign-In successful: ${userCredential.user?.email}");
      return userCredential;
    } catch (e) {
      debugPrint("Error during Google Sign-In: $e");
      // 필요하다면 커스텀 예외를 던지거나 null 반환
      // 여기서는 null 반환하여 UI에서 처리
      return null;
    }
  }

  // 로그아웃 (선택 사항, 추후 필요 시 사용)
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
