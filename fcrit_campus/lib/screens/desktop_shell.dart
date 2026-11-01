import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/sidebar.dart';
import '../widgets/top_header.dart';
import 'home_screen.dart';
import 'events_screen.dart';
import 'inbox_screen.dart';
import 'profile_screen.dart';

class DesktopShell extends StatelessWidget {
  const DesktopShell({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Desktop breakpoint: >= 850px width
        final isDesktop = constraints.maxWidth >= 850;

        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: isDesktop
              ? _buildDesktopLayout(context)
              : _buildMobileLayout(context),
          bottomNavigationBar: isDesktop ? null : _buildMobileBottomNav(context),
        );
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final state = context.watch<AppState>();

    return Row(
      children: [
        // Persistent Left Navigation Sidebar
        const DesktopSidebar(),

        // Main Desktop Content Area
        Expanded(
          child: Column(
            children: [
              // Horizontal Top Header Bar
              const TopHeader(isDesktop: true),

              // Active Page Content Area
              Expanded(
                child: IndexedStack(
                  index: state.currentNavIndex,
                  children: const [
                    HomeScreen(isDesktop: true),
                    EventsScreen(isDesktop: true),
                    InboxScreen(isDesktop: true),
                    ProfileScreen(isDesktop: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final state = context.watch<AppState>();

    return Column(
      children: [
        // Mobile Header
        const TopHeader(isDesktop: false),

        // Active Mobile Page
        Expanded(
          child: IndexedStack(
            index: state.currentNavIndex,
            children: const [
              HomeScreen(isDesktop: false),
              EventsScreen(isDesktop: false),
              InboxScreen(isDesktop: false),
              ProfileScreen(isDesktop: false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileBottomNav(BuildContext context) {
    final state = context.watch<AppState>();

    // CRITICAL: Redundant "Notices" tab is removed as strictly specified in guipc.md!
    // Remaining tabs: Home (0), Events (1), You / Inbox (2), Profile (3)
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.borderLight, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: state.currentNavIndex,
        onTap: (index) => state.setNavIndex(index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryPurple,
        unselectedItemColor: AppColors.textMuted,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_month_rounded),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.chat_bubble_outline_rounded),
                if (state.unreadMessagesCount > 0)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.urgentRed,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${state.unreadMessagesCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            activeIcon: const Icon(Icons.chat_bubble_rounded),
            label: 'You',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
