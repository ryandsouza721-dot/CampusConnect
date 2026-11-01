import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fcrit_campus/main.dart';
import 'package:fcrit_campus/state/app_state.dart';

void main() {
  testWidgets('Verify bottom navigation does NOT contain Notices', (WidgetTester tester) async {
    // Set small screen size to test mobile layout
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppState()),
        ],
        child: const FcritCampusApp(),
      ),
    );

    // Verify 4 items in BottomNavigationBar: Home, Events, You, Profile
    final bottomNavBarFinder = find.byType(BottomNavigationBar);
    expect(bottomNavBarFinder, findsOneWidget);

    final BottomNavigationBar navBar = tester.widget(bottomNavBarFinder);
    expect(navBar.items.length, 4);

    // Check that 'Notices' is NOT an item in BottomNavigationBar
    final hasNoticesTab = navBar.items.any((item) => item.label == 'Notices');
    expect(hasNoticesTab, isFalse);

    // Check that remaining destinations are present
    expect(navBar.items[0].label, 'Home');
    expect(navBar.items[1].label, 'Events');
    expect(navBar.items[2].label, 'You');
    expect(navBar.items[3].label, 'Profile');
  });

  testWidgets('Verify Home page preserves Important Notice, Quick Access, and Latest Notices', (WidgetTester tester) async {
    // Desktop size
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppState()),
        ],
        child: const FcritCampusApp(),
      ),
    );

    // Verify Important Notice banner exists
    expect(find.text('IMPORTANT NOTICE'), findsOneWidget);
    expect(find.text('ESE Timetable for May 2026 Released'), findsOneWidget);

    // Verify Quick Access exists with Notices shortcut
    expect(find.text('Quick Access'), findsOneWidget);
    expect(find.text('Notices'), findsOneWidget);

    // Verify Latest Notices exists
    expect(find.text('Latest Notices'), findsAtLeastNWidgets(1));
  });
}
