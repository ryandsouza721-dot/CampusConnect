import 'package:flutter/material.dart';
import '../models/notice_model.dart';
import '../theme/app_colors.dart';
import 'category_chip.dart';

class NoticeCard extends StatelessWidget {
  final Notice notice;
  final VoidCallback? onBookmarkToggle;
  final VoidCallback? onTap;

  const NoticeCard({
    super.key,
    required this.notice,
    this.onBookmarkToggle,
    this.onTap,
  });

  Color _getCategoryColor(NoticeCategory category) {
    switch (category) {
      case NoticeCategory.academics:
        return AppColors.academics;
      case NoticeCategory.placements:
        return AppColors.placements;
      case NoticeCategory.clubs:
        return AppColors.clubs;
      case NoticeCategory.events:
        return AppColors.events;
      case NoticeCategory.cultural:
        return AppColors.cultural;
    }
  }

  Color _getCategoryBg(NoticeCategory category) {
    switch (category) {
      case NoticeCategory.academics:
        return AppColors.academicsBg;
      case NoticeCategory.placements:
        return AppColors.placementsBg;
      case NoticeCategory.clubs:
        return AppColors.clubsBg;
      case NoticeCategory.events:
        return AppColors.eventsBg;
      case NoticeCategory.cultural:
        return AppColors.culturalBg;
    }
  }

  IconData _getCategoryIcon(NoticeCategory category) {
    switch (category) {
      case NoticeCategory.academics:
        return Icons.menu_book_rounded;
      case NoticeCategory.placements:
        return Icons.business_center_outlined;
      case NoticeCategory.clubs:
        return Icons.music_note_outlined;
      case NoticeCategory.events:
        return Icons.star_border_rounded;
      case NoticeCategory.cultural:
        return Icons.theater_comedy_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final catColor = _getCategoryColor(notice.category);
    final catBg = _getCategoryBg(notice.category);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top accent color bar
            Container(
              height: 4,
              color: catColor,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category icon container
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: catBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getCategoryIcon(notice.category),
                      color: catColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category pills & bookmark icon
                        Row(
                          children: [
                            CategoryChip.fromNoticeCategory(notice.category),
                            if (notice.isNew) ...[
                              const SizedBox(width: 8),
                              const NewBadge(),
                            ],
                            const Spacer(),
                            // Bookmark button
                            InkWell(
                              onTap: onBookmarkToggle,
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  notice.isBookmarked
                                      ? Icons.bookmark_rounded
                                      : Icons.bookmark_border_rounded,
                                  color: notice.isBookmarked
                                      ? catColor
                                      : AppColors.textMuted,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Notice Title
                        InkWell(
                          onTap: onTap ?? () => _showNoticeDetails(context),
                          child: Text(
                            notice.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              height: 1.35,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Publisher, Date, and Views
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${notice.publisher} • ${notice.date}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.visibility_outlined,
                                  size: 14,
                                  color: AppColors.textMuted,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${notice.views}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMuted,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNoticeDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            CategoryChip.fromNoticeCategory(notice.category),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notice.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Issued by ${notice.publisher} on ${notice.date}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                notice.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notice marked as read / saved.'),
                  backgroundColor: AppColors.primaryPurple,
                ),
              );
            },
            icon: const Icon(Icons.check_rounded, size: 18),
            label: const Text('Acknowledge'),
          ),
        ],
      ),
    );
  }
}
