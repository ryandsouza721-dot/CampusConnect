import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';

class ProfileSetupScreen extends StatefulWidget {
  final VoidCallback? onComplete;

  const ProfileSetupScreen({
    super.key,
    this.onComplete,
  });

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  late String _selectedDepartment;
  late String _selectedYear;
  late List<String> _selectedClubs;

  final List<String> departments = ['CSE', 'Mechanical', 'Civil', 'EXTC'];
  final List<String> years = ['1st', '2nd', '3rd', '4th'];
  final List<String> availableClubs = ['AI/ML', 'Coding', 'E-Cell', 'Sports', 'Cultural'];

  @override
  void initState() {
    super.initState();
    final profile = context.read<AppState>().userProfile;
    _selectedDepartment = profile.department;
    _selectedYear = profile.yearOfStudy;
    _selectedClubs = List.from(profile.clubs);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: Container(
          width: 520,
          constraints: const BoxConstraints(maxHeight: 780),
          decoration: BoxDecoration(
            color: AppColors.navyHeader,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Dark Navy Header (Matches reference 01)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo Row
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                gradient: AppColors.purpleGradient,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  'FC',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'FCRIT Campus',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white70),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Welcome, ${context.read<AppState>().userProfile.name} 👋',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Set up your profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        // Gradient text
                        ShaderMask(
                          shaderCallback: (bounds) => AppColors.purpleGradient.createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                          child: const Text(
                            'to personalize your inbox',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Messages and updates will be filtered for you.',
                          style: TextStyle(
                            color: AppColors.textLightSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Light Content Surface Form
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card 1: Department
                        _buildFormCard(
                          icon: Icons.apartment_rounded,
                          title: 'Department',
                          isRequired: true,
                          content: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: departments.map((dept) {
                              final isSelected = _selectedDepartment == dept;
                              return _buildSelectableChip(
                                label: dept,
                                isSelected: isSelected,
                                onTap: () {
                                  setState(() => _selectedDepartment = dept);
                                },
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Card 2: Year of Study
                        _buildFormCard(
                          icon: Icons.school_rounded,
                          title: 'Year of Study',
                          isRequired: true,
                          content: Row(
                            children: years.map((yr) {
                              final isSelected = _selectedYear == yr;
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: _buildSelectableChip(
                                    label: yr,
                                    isSelected: isSelected,
                                    onTap: () {
                                      setState(() => _selectedYear = yr);
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Card 3: Clubs & Groups (Multi-select)
                        _buildFormCard(
                          icon: Icons.tag_rounded,
                          title: 'Clubs & Groups',
                          subtitle: 'Select clubs you are a member of to receive targeted messages.',
                          extraLabel: 'optional • multi-select',
                          content: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: availableClubs.map((club) {
                              final isSelected = _selectedClubs.contains(club);
                              return _buildSelectableChip(
                                label: isSelected ? '✓ $club' : club,
                                isSelected: isSelected,
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedClubs.remove(club);
                                    } else {
                                      _selectedClubs.add(club);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Info Notice Box (Matches reference 01 & 02)
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFBBF7D0)),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outline_rounded, color: Color(0xFF16A34A), size: 18),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'You can update your department, year, and clubs anytime from your Profile settings.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF15803D),
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // "Get Started ->" Button (Matches reference 02)
                        Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: AppColors.purpleGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryPurple.withOpacity(0.35),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _submitProfile,
                              borderRadius: BorderRadius.circular(16),
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Get Started',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard({
    required IconData icon,
    required String title,
    bool isRequired = false,
    String? subtitle,
    String? extraLabel,
    required Widget content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.academicsBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.primaryPurple, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (isRequired) ...[
                const SizedBox(width: 4),
                const Text('*', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
              const Spacer(),
              if (extraLabel != null)
                Text(
                  extraLabel,
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
          const SizedBox(height: 14),
          content,
        ],
      ),
    );
  }

  Widget _buildSelectableChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPurple : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryPurple.withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _submitProfile() {
    context.read<AppState>().updateProfile(
          department: _selectedDepartment,
          yearOfStudy: _selectedYear,
          clubs: _selectedClubs,
        );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile personalized successfully!'),
        backgroundColor: AppColors.primaryPurple,
      ),
    );

    widget.onComplete?.call();
  }
}
