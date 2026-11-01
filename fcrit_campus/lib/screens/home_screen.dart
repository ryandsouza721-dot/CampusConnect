import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/important_notice_banner.dart';
import '../widgets/quick_access_bar.dart';
import '../widgets/notice_card.dart';

class HomeScreen extends StatelessWidget {
  final bool isDesktop;

  const HomeScreen({
    super.key,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final notices = state.filteredNotices;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 32 : 18,
        vertical: 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Important Notice banner (Matches reference 03)
              ImportantNoticeBanner(
                notice: state.importantNotice,
              ),

              const SizedBox(height: 28),

              // 2. Quick Access shortcuts (Matches reference 03, 05, 06, 07)
              QuickAccessBar(
                selectedCategory: state.selectedNoticeCategoryFilter,
                onCategorySelected: (category) {
                  state.setNoticeFilter(category);
                },
                onSeeAllTap: () {
                  state.setNoticeFilter('All');
                },
              ),

              const SizedBox(height: 32),

              // 3. Latest Notices header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Flexible(
                          child: Text(
                            'Latest Notices',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Count badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.academicsBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${notices.length}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.academicsText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showAllNoticesDialog(context);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'View all',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryPurple,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 4. Responsive Notice Cards Grid
              if (notices.isEmpty) ...[
                _buildEmptyState(context, state),
              ] else ...[
                LayoutBuilder(
                  builder: (context, constraints) {
                    // On wide screens (>= 900px content width), display in 2 columns
                    final useTwoColumns = constraints.maxWidth >= 720;
                    if (useTwoColumns) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                          mainAxisExtent: 180,
                        ),
                        itemCount: notices.length,
                        itemBuilder: (context, index) {
                          final notice = notices[index];
                          return NoticeCard(
                            notice: notice,
                            onBookmarkToggle: () => state.toggleNoticeBookmark(notice.id),
                          );
                        },
                      );
                    } else {
                      // Single column on narrow screens
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: notices.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final notice = notices[index];
                          return NoticeCard(
                            notice: notice,
                            onBookmarkToggle: () => state.toggleNoticeBookmark(notice.id),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.inbox_rounded,
            size: 48,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 12),
          Text(
            'No notices in "${state.selectedNoticeCategoryFilter}"',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try selecting another category or resetting the filter.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => state.setNoticeFilter('All'),
            child: const Text('Show All Notices'),
          ),
        ],
      ),
    );
  }

  void _showAllNoticesDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Consumer<AppState>(
          builder: (context, state, _) {
            final all = state.notices;
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'All Campus Notices',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Filter bar
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Academics', 'Placements', 'Clubs', 'Events'].map((cat) {
                        final isSel = state.selectedNoticeCategoryFilter.toLowerCase() == cat.toLowerCase();
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSel,
                            onSelected: (_) => state.setNoticeFilter(cat),
                            selectedColor: AppColors.primaryPurple,
                            labelStyle: TextStyle(
                              color: isSel ? Colors.white : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: all.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, i) {
                        return NoticeCard(
                          notice: all[i],
                          onBookmarkToggle: () => state.toggleNoticeBookmark(all[i].id),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
