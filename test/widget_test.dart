import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:v_green_media_admin/admin_app.dart';

void main() {
  testWidgets('admin sign-in opens the enquiries dashboard', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TribeGreenAdminApp());
    expect(find.text('Welcome back'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('admin_email')),
      'admin@tribegreen.com',
    );
    await tester.enterText(
      find.byKey(const Key('admin_password')),
      'demo-password',
    );
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Good morning, team'), findsOneWidget);
    expect(find.text('Total enquiries'), findsOneWidget);
    expect(find.text('Aarav Mehta'), findsOneWidget);
    expect(find.text('Mobile app'), findsWidgets);
    expect(find.text('Enquiry activity'), findsNothing);
    expect(find.text('Popular occasions'), findsNothing);
  });

  testWidgets('enquiry search filters the list', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TribeGreenAdminApp());
    await tester.enterText(
      find.byKey(const Key('admin_email')),
      'admin@tribegreen.com',
    );
    await tester.enterText(
      find.byKey(const Key('admin_password')),
      'demo-password',
    );
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enquiries').first);
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('enquiry_search')), 'Juniper');
    await tester.pumpAndSettle();

    expect(find.text('Mira Shah'), findsOneWidget);
    expect(find.text('Aarav Mehta'), findsNothing);
    expect(find.text('1 of 8 enquiries'), findsOneWidget);
  });

  testWidgets('dashboard renders at a mobile viewport', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TribeGreenAdminApp());
    await tester.enterText(
      find.byKey(const Key('admin_email')),
      'admin@tribegreen.com',
    );
    await tester.enterText(
      find.byKey(const Key('admin_password')),
      'demo-password',
    );
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Good morning, team'), findsOneWidget);
    expect(find.text('Total enquiries'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
