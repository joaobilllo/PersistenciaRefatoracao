import 'package:flutter_test/flutter_test.dart';
import 'package:exemplo/main.dart';

void main() {
  testWidgets('PessoasApp widget can be instantiated', (
    WidgetTester tester,
  ) async {
    // Test that the app widget can be created without errors
    const app = PessoasApp();

    expect(app, isA<PessoasApp>());
    expect(app.runtimeType, equals(PessoasApp));
  });
}
