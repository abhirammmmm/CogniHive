import 'package:cognihive_version1/screens/Login/login_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cognihive_version1/providers/firebaseGoogleSigninProvider.dart';

class MockFirebaseGoogleSigninProvider extends Mock implements FirebaseGoogleSigninProvider {}

void main() {
  testWidgets('Google Sign-In Test', (WidgetTester tester) async {
    // Mock Google Sign-In
    final MockFirebaseGoogleSigninProvider mockProvider = MockFirebaseGoogleSigninProvider();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: LoginUi(),
      ),
    );

    // Trigger Google Sign-In
    await tester.tap(find.byType(GoogleSignInButtonWidget));
    await tester.pump();

    // Verify that the user is signed in
    verify(mockProvider.signInWithGoogle(any));
  });
}
