import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/api_service.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';

class ProfileSetupScreen extends StatefulWidget {
  final VoidCallback? onComplete;
  const ProfileSetupScreen({super.key, this.onComplete});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _divisionController;
  late final TextEditingController _rollController;
  late String _department;
  late String _year;
  late List<String> _clubs;
  bool _saving = false;

  static const _departments = ['Not set', 'CSE', 'Mechanical', 'Civil', 'EXTC'];
  static const _years = ['Not set', '1st', '2nd', '3rd', '4th'];
  static const _availableClubs = ['AI/ML', 'Coding', 'E-Cell', 'Sports', 'Cultural'];

  @override
  void initState() {
    super.initState();
    final profile = context.read<AppState>().userProfile;
    _nameController = TextEditingController(text: profile.name);
    _divisionController = TextEditingController(text: profile.division);
    _rollController = TextEditingController(text: profile.rollNumber);
    _department = profile.department;
    _year = profile.yearOfStudy;
    _clubs = List.of(profile.clubs);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _divisionController.dispose();
    _rollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 760),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 18),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(color: AppColors.purpleLight, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.manage_accounts_outlined, color: AppColors.primaryPurple),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Edit profile', style: TextStyle(color: AppColors.textPrimary, fontSize: 19, fontWeight: FontWeight.w700)),
                        SizedBox(height: 3),
                        Text('Keep your campus details up to date.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), tooltip: 'Close', icon: const Icon(Icons.close, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.borderLight),
            Flexible(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    _sectionTitle('Personal details'),
                    const SizedBox(height: 14),
                    _label('Full name'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: _decoration('Your name', Icons.person_outline_rounded),
                      validator: (value) => value == null || value.trim().isEmpty ? 'Enter your name' : null,
                    ),
                    const SizedBox(height: 14),
                    _label('College email'),
                    const SizedBox(height: 6),
                    TextFormField(
                      initialValue: context.read<AppState>().userProfile.email,
                      readOnly: true,
                      decoration: _decoration('Email address', Icons.mail_outline_rounded),
                    ),
                    const SizedBox(height: 24),
                    _sectionTitle('Academic details'),
                    const SizedBox(height: 14),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final stacked = constraints.maxWidth < 440;
                        final department = _dropdown<String>(
                          label: 'Department',
                          value: _department,
                          items: _departments,
                          onChanged: (value) => setState(() => _department = value!),
                        );
                        final year = _dropdown<String>(
                          label: 'Year of study',
                          value: _year,
                          items: _years,
                          onChanged: (value) => setState(() => _year = value!),
                        );
                        if (stacked) return Column(children: [department, const SizedBox(height: 12), year]);
                        return Row(children: [Expanded(child: department), const SizedBox(width: 12), Expanded(child: year)]);
                      },
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(child: _textField(label: 'Division', controller: _divisionController, hint: 'e.g. Div B')),
                        const SizedBox(width: 12),
                        Expanded(child: _textField(label: 'Roll number', controller: _rollController, hint: 'e.g. 42')),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _sectionTitle('Clubs and groups'),
                    const SizedBox(height: 4),
                    const Text('Choose the groups you are part of.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableClubs.map((club) {
                        final selected = _clubs.contains(club);
                        return FilterChip(
                          label: Text(club),
                          selected: selected,
                          onSelected: (value) => setState(() => value ? _clubs.add(club) : _clubs.remove(club)),
                          showCheckmark: true,
                          selectedColor: AppColors.purpleLight,
                          checkmarkColor: AppColors.primaryPurple,
                          side: BorderSide(color: selected ? AppColors.primaryPurple.withOpacity(0.3) : AppColors.borderLight),
                          labelStyle: TextStyle(color: selected ? AppColors.purpleText : AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 26),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: _saving ? null : _save,
                          icon: const Icon(Icons.check_rounded, size: 18),
                          label: Text(_saving ? 'Saving…' : 'Save changes'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(text, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700));
  Widget _label(String text) => Text(text, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600));

  Widget _textField({required String label, required TextEditingController controller, required String hint}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          const SizedBox(height: 6),
          TextFormField(controller: controller, decoration: _decoration(hint, null)),
        ],
      );

  Widget _dropdown<T>({required String label, required T value, required List<T> items, required ValueChanged<T?> onChanged}) => DropdownButtonFormField<T>(
        value: value,
        decoration: _decoration(label, null),
        items: items.map((item) => DropdownMenuItem<T>(value: item, child: Text('$item'))).toList(),
        onChanged: onChanged,
      );

  InputDecoration _decoration(String hint, IconData? icon) => InputDecoration(
        hintText: hint,
        prefixIcon: icon == null ? null : Icon(icon, size: 19, color: AppColors.textMuted),
        filled: true,
        fillColor: const Color(0xFFFAFBFD),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primaryPurple, width: 1.5)),
      );

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameController.text.trim();
    setState(() => _saving = true);
    final result = await ApiService.updateProfile(
      name: name,
      department: _department,
      yearOfStudy: _year,
      division: _divisionController.text.trim().isEmpty ? '—' : _divisionController.text.trim(),
      rollNumber: _rollController.text.trim().isEmpty ? '—' : _rollController.text.trim(),
      clubs: _clubs,
    );
    if (!mounted) return;
    if (result['success'] != true) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] as String? ?? 'Could not update profile.')));
      return;
    }
    context.read<AppState>().updateProfile(
          name: name,
          department: _department,
          yearOfStudy: _year,
          division: _divisionController.text.trim().isEmpty ? '—' : _divisionController.text.trim(),
          rollNumber: _rollController.text.trim().isEmpty ? '—' : _rollController.text.trim(),
          clubs: _clubs,
        );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
    widget.onComplete?.call();
  }
}
