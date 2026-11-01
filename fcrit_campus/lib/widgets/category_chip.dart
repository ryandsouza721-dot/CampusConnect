import 'package:flutter/material.dart';
import '../models/notice_model.dart';
import '../models/event_model.dart';
import '../theme/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.isSelected = false,
    this.onTap,
  });

  factory CategoryChip.fromNoticeCategory(NoticeCategory category) {
    switch (category) {
      case NoticeCategory.academics:
        return const CategoryChip(
          label: 'ACADEMICS',
          backgroundColor: AppColors.academicsBg,
          textColor: AppColors.academicsText,
        );
      case NoticeCategory.placements:
        return const CategoryChip(
          label: 'PLACEMENTS',
          backgroundColor: AppColors.placementsBg,
          textColor: AppColors.placementsText,
        );
      case NoticeCategory.clubs:
        return const CategoryChip(
          label: 'CLUBS',
          backgroundColor: AppColors.clubsBg,
          textColor: AppColors.clubsText,
        );
      case NoticeCategory.events:
        return const CategoryChip(
          label: 'EVENTS',
          backgroundColor: AppColors.eventsBg,
          textColor: AppColors.eventsText,
        );
      case NoticeCategory.cultural:
        return const CategoryChip(
          label: 'CULTURAL',
          backgroundColor: AppColors.culturalBg,
          textColor: AppColors.culturalText,
        );
    }
  }

  factory CategoryChip.fromEventCategory(EventCategory category) {
    switch (category) {
      case EventCategory.academics:
        return const CategoryChip(
          label: 'ACADEMICS',
          backgroundColor: AppColors.academicsBg,
          textColor: AppColors.academicsText,
        );
      case EventCategory.placements:
        return const CategoryChip(
          label: 'PLACEMENTS',
          backgroundColor: AppColors.placementsBg,
          textColor: AppColors.placementsText,
        );
      case EventCategory.clubs:
        return const CategoryChip(
          label: 'CLUBS',
          backgroundColor: AppColors.clubsBg,
          textColor: AppColors.clubsText,
        );
      case EventCategory.cultural:
        return const CategoryChip(
          label: 'CULTURAL',
          backgroundColor: AppColors.culturalBg,
          textColor: AppColors.culturalText,
        );
      case EventCategory.sports:
        return const CategoryChip(
          label: 'SPORTS',
          backgroundColor: AppColors.eventsBg,
          textColor: AppColors.eventsText,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: isSelected ? Border.all(color: textColor, width: 1.5) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: chip,
      );
    }
    return chip;
  }
}

class NewBadge extends StatelessWidget {
  const NewBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.academicsBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        'NEW',
        style: TextStyle(
          color: AppColors.academicsText,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
