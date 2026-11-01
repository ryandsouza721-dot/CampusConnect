import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';
import 'profile_setup_screen.dart';

class ProfileScreen extends StatelessWidget {
  final bool isDesktop;
  const ProfileScreen({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final profile = state.userProfile;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 18, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your profile', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 5),
              const Text('Manage your personal and academic information.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final narrow = constraints.maxWidth < 540;
                    final identity = Row(
                      children: [
                        CircleAvatar(radius: 30, backgroundColor: AppColors.purpleLight, child: Text(profile.avatarInitials, style: const TextStyle(color: AppColors.primaryPurple, fontSize: 19, fontWeight: FontWeight.w700))),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(profile.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 19, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text(profile.email, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12), overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    );
                    final editButton = OutlinedButton.icon(
                      onPressed: () => _edit(context),
                      icon: const Icon(Icons.edit_outlined, size: 17),
                      label: const Text('Edit profile'),
                    );
                    if (narrow) return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [identity, const SizedBox(height: 16), editButton]);
                    return Row(children: [Expanded(child: identity), const SizedBox(width: 16), editButton]);
                  },
                ),
              ),
              const SizedBox(height: 16),
              _sectionCard(
                title: 'Academic details',
                icon: Icons.school_outlined,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth > 650 ? 4 : 2;
                    final details = [
                      _detail('Department', profile.department),
                      _detail('Year of study', profile.yearOfStudy),
                      _detail('Division', profile.division),
                      _detail('Roll number', profile.rollNumber),
                    ];
                    return Wrap(
                      spacing: 16,
                      runSpacing: 18,
                      children: details.map((detail) => SizedBox(width: (constraints.maxWidth - (columns - 1) * 16) / columns, child: detail)).toList(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              _sectionCard(
                title: 'Clubs and groups',
                icon: Icons.diversity_3_outlined,
                child: profile.clubs.isEmpty
                    ? const Text('No clubs added yet. Edit your profile to add your groups.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12))
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: profile.clubs.map((club) => Chip(
                              label: Text(club),
                              backgroundColor: AppColors.purpleLight,
                              side: BorderSide.none,
                              labelStyle: const TextStyle(color: AppColors.purpleText, fontSize: 12, fontWeight: FontWeight.w600),
                              visualDensity: VisualDensity.compact,
                            )).toList(),
                      ),
              ),
              const SizedBox(height: 16),
              _sectionCard(
                title: 'Campus activity',
                icon: Icons.insights_outlined,
                child: Row(
                  children: [
                    _stat(context, 'Saved notices', state.bookmarkedNoticesCount, Icons.bookmark_outline_rounded),
                    const SizedBox(width: 12),
                    _stat(context, 'Saved events', state.bookmarkedEventsCount, Icons.event_outlined),
                    const SizedBox(width: 12),
                    _stat(context, 'Unread messages', state.unreadMessagesCount, Icons.mark_email_unread_outlined),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _sectionCard(
                title: 'Account',
                icon: Icons.manage_accounts_outlined,
                child: Row(
                  children: [
                    const Icon(Icons.alternate_email_rounded, color: AppColors.textMuted, size: 18),
                    const SizedBox(width: 10),
                    Expanded(child: Text(profile.email, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13), overflow: TextOverflow.ellipsis)),
                    const Text('Login email', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required IconData icon, required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Icon(icon, color: AppColors.primaryPurple, size: 19), const SizedBox(width: 9), Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700))]),
          const SizedBox(height: 16),
          child,
        ]),
      );

  Widget _detail(String label, String value) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
      ]);

  Widget _stat(BuildContext context, String label, int value, IconData icon) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(12)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, color: AppColors.primaryPurple, size: 18),
            const SizedBox(height: 10),
            Text('$value', style: const TextStyle(color: AppColors.textPrimary, fontSize: 19, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10), maxLines: 2, overflow: TextOverflow.ellipsis),
          ]),
        ),
      );

  void _edit(BuildContext context) => showDialog<void>(context: context, builder: (_) => const ProfileSetupScreen());
}
