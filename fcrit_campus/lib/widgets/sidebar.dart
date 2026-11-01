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
      width: 260,
      decoration: const BoxDecoration(
        color: AppColors.navyHeader,
        border: Border(
          right: BorderSide(color: AppColors.navyBorder, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Brand Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
            child: Row(
              children: [
                // FC Avatar
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    gradient: AppColors.purpleGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'FC',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FCRIT Campus',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      Text(
                        'Student Portal',
                        style: TextStyle(
                          color: AppColors.textLightSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: AppColors.navyBorder, height: 1),
          const SizedBox(height: 16),

          // Primary Navigation Items
          // (CRITICAL: Notice tab is excluded, keeping Home, Events, Messages/You, Profile)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 12, bottom: 8),
                  child: Text(
                    'MAIN MENU',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                _buildNavItem(
                  context,
                  index: 0,
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isSelected: state.currentNavIndex == 0,
                ),
                const SizedBox(height: 4),
                _buildNavItem(
                  context,
                  index: 1,
                  icon: Icons.calendar_month_rounded,
                  label: 'Events',
                  isSelected: state.currentNavIndex == 1,
                ),
                const SizedBox(height: 4),
                _buildNavItem(
                  context,
                  index: 2,
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Messages',
                  badgeCount: state.unreadMessagesCount,
                  isSelected: state.currentNavIndex == 2,
                ),
                const SizedBox(height: 4),
                _buildNavItem(
                  context,
                  index: 3,
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  isSelected: state.currentNavIndex == 3,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Quick Filter Shortcuts
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 12, bottom: 8),
                  child: Text(
                    'QUICK CHANNELS',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                _buildChannelItem(
                  icon: Icons.notifications_none_rounded,
                  label: 'Latest Notices',
                  color: AppColors.primaryPurple,
                  onTap: () {
                    state.setNavIndex(0);
                    state.setNoticeFilter('Notices');
                  },
                ),
                _buildChannelItem(
                  icon: Icons.business_center_outlined,
                  label: 'Placements Drive',
                  color: AppColors.placements,
                  onTap: () {
                    state.setNavIndex(0);
                    state.setNoticeFilter('Placements');
                  },
                ),
                _buildChannelItem(
                  icon: Icons.music_note_outlined,
                  label: 'Clubs & Cultural',
                  color: AppColors.clubs,
                  onTap: () {
                    state.setNavIndex(0);
                    state.setNoticeFilter('Clubs');
                  },
                ),
                _buildChannelItem(
                  icon: Icons.menu_book_rounded,
                  label: 'Academics Portal',
                  color: AppColors.cultural,
                  onTap: () {
                    state.setNavIndex(0);
                    state.setNoticeFilter('Academics');
                  },
                ),
              ],
            ),
          ),

          const Spacer(),

          // User info footer card
          Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.navySurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.navyBorder),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primaryPurple,
                  child: Text(
                    state.userProfile.name.isNotEmpty
                        ? state.userProfile.name[0].toUpperCase()
                        : 'D',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.userProfile.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${state.userProfile.department} • ${state.userProfile.yearOfStudy} Year',
                        style: const TextStyle(
                          color: AppColors.textLightSecondary,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: AppColors.textLightSecondary,
                    size: 18,
                  ),
                  onPressed: () => state.setNavIndex(3),
                  tooltip: 'Profile Settings',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
    int badgeCount = 0,
  }) {
    final state = context.read<AppState>();

    return InkWell(
      onTap: () => state.setNavIndex(index),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPurple.withOpacity(0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: AppColors.primaryPurple.withOpacity(0.5), width: 1)
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : AppColors.textLightSecondary,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textLightSecondary,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (badgeCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.urgentRed,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              icon,
              size: 16,
              color: AppColors.textLightSecondary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.textLightSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
