import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';

class DesktopSidebar extends StatelessWidget {
  const DesktopSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Container(
      width: 248,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AppColors.borderLight)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 26, 18, 24),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.purpleLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('F', style: TextStyle(color: AppColors.primaryPurple, fontSize: 20, fontWeight: FontWeight.w800)),
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FCRIT Campus', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                    SizedBox(height: 3),
                    Text('Student Portal', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.borderLight, height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 22, 14, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 12, bottom: 9),
                  child: Text('CAMPUS', style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
                ),
                _navItem(context, state, 0, Icons.home_outlined, 'Home'),
                _navItem(context, state, 1, Icons.calendar_month_outlined, 'Events'),
                _navItem(context, state, 2, Icons.chat_bubble_outline_rounded, 'Messages', badge: state.unreadMessagesCount),
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 18, 12, 8),
                  child: Text('QUICK ACCESS', style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
                ),
                _quickItem(context, state, Icons.notifications_none_rounded, 'Notices', 'Notices'),
                _quickItem(context, state, Icons.business_center_outlined, 'Placements', 'Placements'),
                _quickItem(context, state, Icons.groups_outlined, 'Clubs', 'Clubs'),
                _quickItem(context, state, Icons.event_outlined, 'Events', 'Events'),
                _quickItem(context, state, Icons.menu_book_outlined, 'Academics', 'Academics'),
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 18, 12, 8),
                  child: Text('ACCOUNT', style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.1)),
                ),
                _navItem(context, state, 3, Icons.person_outline_rounded, 'Profile'),
              ],
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.purpleLight,
                  child: Text(state.userProfile.avatarInitials, style: const TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.w700, fontSize: 13)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(state.userProfile.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
                      Text('${state.userProfile.department} · ${state.userProfile.yearOfStudy} year', style: const TextStyle(color: AppColors.textSecondary, fontSize: 10), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => state.setNavIndex(3),
                  tooltip: 'Edit profile',
                  icon: const Icon(Icons.settings_outlined, color: AppColors.textSecondary, size: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, AppState state, int index, IconData icon, String label, {int badge = 0}) {
    final selected = state.currentNavIndex == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: () => state.setNavIndex(index),
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
          decoration: BoxDecoration(
            color: selected ? AppColors.purpleLight : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, size: 19, color: selected ? AppColors.primaryPurple : AppColors.textSecondary),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: TextStyle(color: selected ? AppColors.primaryPurple : AppColors.textSecondary, fontSize: 13, fontWeight: selected ? FontWeight.w700 : FontWeight.w500))),
              if (badge > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.primaryPurple, borderRadius: BorderRadius.circular(10)),
                  child: Text('$badge', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickItem(BuildContext context, AppState state, IconData icon, String label, String filter) {
    final selected = state.currentNavIndex == 0 && state.selectedNoticeCategoryFilter.toLowerCase() == filter.toLowerCase();
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: InkWell(
        onTap: () {
          state.setNavIndex(0);
          state.setNoticeFilter(filter);
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          decoration: BoxDecoration(color: selected ? AppColors.purpleLight : Colors.transparent, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Icon(icon, size: 17, color: selected ? AppColors.primaryPurple : AppColors.textSecondary),
              const SizedBox(width: 12),
              Text(label, style: TextStyle(color: selected ? AppColors.primaryPurple : AppColors.textSecondary, fontSize: 12, fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
