import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillbridge/main.dart';
import 'package:skillbridge/services/storage_service.dart';
import 'package:skillbridge/utils/validators.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
  });

  group('Validators', () {
    test('email validator rejects invalid addresses', () {
      expect(Validators.email('not-an-email'), isNotNull);
      expect(Validators.email('person@example.com'), isNull);
    });

    test('password validator enforces minimum length', () {
      expect(Validators.password('123'), isNotNull);
      expect(Validators.password('123456'), isNull);
    });

    test('required validator catches empty fields', () {
      expect(Validators.required('', 'Title'), 'Title is required');
      expect(Validators.required('Guitar Lessons', 'Title'), isNull);
    });
  });

  testWidgets('App boots and shows the splash screen first', (tester) async {
    await tester.pumpWidget(const SkillBridgeApp());

    // The splash screen should be visible immediately after launch.
    expect(find.text('SkillBridge'), findsOneWidget);

    // Let the splash screen's bootstrap Future resolve.
    await tester.pump(const Duration(milliseconds: 1300));
  });
}
