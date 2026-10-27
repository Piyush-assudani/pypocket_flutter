import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pypocket_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pypocket_app/services/storage_service.dart';
import 'package:pypocket_app/services/admin_service.dart';

void main() {
  testWidgets('PyPocket smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();

    await tester.pumpWidget(const PyPocketApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('PYPOCKET'), findsOneWidget);
  });

  testWidgets('PyPocket onboarded user goes to MainNavScreen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
    await StorageService.setCompletedOnboarding(true);

    await tester.pumpWidget(const PyPocketApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Learn'), findsWidgets);
  });

  test('Founder Admin verification works accurately', () {
    expect(AdminService.isFounderAdmin('piyushassudani', ''), isTrue);
    expect(AdminService.isFounderAdmin('', 'piyushassudani96@gmail.com'), isTrue);
    expect(AdminService.isFounderAdmin('Piyush Assudani', 'piyush@test.com'), isTrue);
    expect(AdminService.isFounderAdmin('John Doe', 'john@gmail.com'), isFalse);
  });

  testWidgets('Responsive test on small Android screen (360x640)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
    await StorageService.setCompletedOnboarding(false);

    await tester.pumpWidget(const PyPocketApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('PYPOCKET'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Responsive test on iPhone SE screen (375x667)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
    await StorageService.setCompletedOnboarding(false);

    await tester.pumpWidget(const PyPocketApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('PYPOCKET'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Responsive test on modern large screen (412x915)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
    await StorageService.setCompletedOnboarding(false);

    await tester.pumpWidget(const PyPocketApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('PYPOCKET'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

