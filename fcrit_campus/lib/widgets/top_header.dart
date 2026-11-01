import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';

class TopHeader extends StatelessWidget {
  final bool isDesktop;
  const TopHeader({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final profile = state.userProfile;
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 30 : 18, vertical: isDesktop ? 15 : 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(DateFormat('EEEE, d MMMM').format(DateTime.now()), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
                const SizedBox(height: 3),
                Text('$greeting, ${profile.name}', style: TextStyle(color: AppColors.textPrimary, fontSize: isDesktop ? 20 : 17, fontWeight: FontWeight.w700, letterSpacing: -0.2), overflow: TextOverflow.ellipsis),
                if (isDesktop) ...[
                  const SizedBox(height: 6),
                  Text('${profile.department} · ${profile.yearOfStudy} year  |  ${profile.division} · Roll ${profile.rollNumber}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11), overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
          if (isDesktop)
            Container(
              width: 225,
              height: 38,
              margin: const EdgeInsets.only(right: 12),
              child: TextField(
                onChanged: state.setEventSearchQuery,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'Search events',
                  hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 18),
                  filled: true,
                  fillColor: AppColors.backgroundLight,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
            ),
          IconButton(
            tooltip: 'Notices and updates',
            onPressed: () { state.setNavIndex(0); state.setNoticeFilter('Notices'); },
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: () => state.setNavIndex(3),
            borderRadius: BorderRadius.circular(20),
            child: CircleAvatar(
              radius: 19,
              backgroundColor: AppColors.purpleLight,
              child: Text(profile.avatarInitials, style: const TextStyle(color: AppColors.primaryPurple, fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
