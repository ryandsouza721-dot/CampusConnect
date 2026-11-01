import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';

class TopHeader extends StatelessWidget {
  final bool isDesktop;

  const TopHeader({
    super.key,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final profile = state.userProfile;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 32 : 18,
        vertical: isDesktop ? 20 : 16,
      ),
      decoration: const BoxDecoration(
        color: AppColors.navyHeader,
        border: Border(
          bottom: BorderSide(color: AppColors.navyBorder, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Greeting & Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Friday, August 8',
                  style: TextStyle(
                    color: AppColors.textLightSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Good morning, ${profile.name} 👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop ? 22 : 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Student info chips
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    // Branch & Year Chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primaryPurple.withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        '${profile.department} • ${profile.yearOfStudy} Year',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Division & Roll Chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Text(
                        '${profile.division} • Roll ${profile.rollNumber}',
                        style: const TextStyle(
                          color: Color(0xFFCBD5E1),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right actions (Desktop search, Notification bell, Profile avatar)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isDesktop) ...[
                // Search box
                Container(
                  width: 220,
                  height: 40,
                  margin: const EdgeInsets.only(right: 16),
                  child: TextField(
                    onChanged: (val) => state.setEventSearchQuery(val),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Search campus...',
                      hintStyle: const TextStyle(
                        color: AppColors.textLightSecondary,
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.textLightSecondary,
                        size: 18,
                      ),
                      filled: true,
                      fillColor: AppColors.navySurface,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: AppColors.navyBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: AppColors.navyBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: AppColors.primaryPurple),
                      ),
                    ),
                  ),
                ),
              ],

              // Notification bell with unread dot
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.navySurface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.navyBorder),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: () {
                        // Open notices / notifications list
                        state.setNavIndex(0);
                        state.setNoticeFilter('Notices');
                      },
                      tooltip: 'Notices & Alerts',
                    ),
                  ),
                  // Orange/red dot indicator
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF97316),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Profile Avatar button
              InkWell(
                onTap: () => state.setNavIndex(3),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    gradient: AppColors.purpleGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      profile.avatarInitials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
