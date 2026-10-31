import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:v_green_media_admin/admin_app.dart';

void main() {
  test('Firestore enquiry documents map to the dashboard model', () {
    final enquiry = Enquiry.fromFirestore('enquiry-id', {
      'budget_per_unit': 70,
      'company': 'Mahasos',
      'customisation_needed': ['Logo printing', 'Laser engraving'],
      'delivery_date': Timestamp.fromDate(DateTime(2026, 11, 6)),
      'email': 'customer@example.com',
      'enquiry_from': 'mobile',
      'message': 'early delivery',
      'name': 'Charvani',
      'number_of_units': 7,
      'occasion': 'Employee Onboarding',
      'other_info': 'na',
      'phone': '8688883112',
      'products_selected': ['Plantable Seed Cards', 'Everyday Canvas Tote'],
    });

    expect(enquiry.id, 'enquiry-id');
    expect(enquiry.name, 'Charvani');
    expect(enquiry.company, 'Mahasos');
    expect(enquiry.budget, '₹70');
    expect(enquiry.quantity, 7);
    expect(enquiry.deliveryDate, '6 Nov 2026');
    expect(enquiry.source, 'Mobile app');
    expect(enquiry.productsSelected, [
      'Plantable Seed Cards',
      'Everyday Canvas Tote',
    ]);
    expect(enquiry.customisations, ['Logo printing', 'Laser engraving']);
    expect(enquiry.status, EnquiryStatus.newEnquiry);
  });

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
