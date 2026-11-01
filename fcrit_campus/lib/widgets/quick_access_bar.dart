import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class QuickAccessItemData {
  final String title;
  final IconData icon;
  final Color activeColor;
  final Color backgroundColor;
  final String filterKey;

  const QuickAccessItemData({
    required this.title,
    required this.icon,
    required this.activeColor,
    required this.backgroundColor,
    required this.filterKey,
  });
}

class QuickAccessBar extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final VoidCallback? onSeeAllTap;

  const QuickAccessBar({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.onSeeAllTap,
  });

  static const List<QuickAccessItemData> items = [
    QuickAccessItemData(
      title: 'Notices',
      icon: Icons.notifications_none_rounded,
      activeColor: AppColors.primaryPurple,
      backgroundColor: AppColors.purpleLight,
      filterKey: 'Notices',
    ),
    QuickAccessItemData(
      title: 'Placements',
      icon: Icons.business_center_outlined,
      activeColor: AppColors.primaryPurple,
      backgroundColor: AppColors.purpleLight,
      filterKey: 'Placements',
    ),
    QuickAccessItemData(
      title: 'Clubs',
      icon: Icons.music_note_outlined,
      activeColor: AppColors.primaryPurple,
      backgroundColor: AppColors.purpleLight,
      filterKey: 'Clubs',
    ),
    QuickAccessItemData(
      title: 'Events',
      icon: Icons.calendar_today_outlined,
      activeColor: AppColors.primaryPurple,
      backgroundColor: AppColors.purpleLight,
      filterKey: 'Events',
    ),
    QuickAccessItemData(
      title: 'Academics',
      icon: Icons.menu_book_rounded,
      activeColor: AppColors.primaryPurple,
      backgroundColor: AppColors.purpleLight,
      filterKey: 'Academics',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and "See all" header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Quick Access',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            if (onSeeAllTap != null)
              TextButton(
                onPressed: onSeeAllTap,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'See all',
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
        // Item buttons row
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 420;
            if (isNarrow) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: items.map((item) {
                    final isSelected = selectedCategory.toLowerCase() == item.filterKey.toLowerCase();
                    return Padding(
                      padding: const EdgeInsets.only(right: 18),
                      child: _buildQuickAccessButton(item, isSelected),
                    );
                  }).toList(),
                ),
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: items.map((item) {
                final isSelected = selectedCategory.toLowerCase() == item.filterKey.toLowerCase();
                return _buildQuickAccessButton(item, isSelected);
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickAccessButton(QuickAccessItemData item, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => onCategorySelected(item.filterKey),
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: isSelected ? item.activeColor : item.backgroundColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: isSelected ? item.activeColor.withOpacity(0.22) : AppColors.borderLight),
            ),
            child: Icon(
              item.icon,
              color: isSelected ? Colors.white : item.activeColor,
              size: 26,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? item.activeColor : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        // Selection dot
        AnimatedOpacity(
          opacity: isSelected ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: item.activeColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
