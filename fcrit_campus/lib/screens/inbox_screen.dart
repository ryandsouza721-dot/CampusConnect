import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/message_model.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/message_card.dart';

class InboxScreen extends StatelessWidget {
  final bool isDesktop;

  const InboxScreen({
    super.key,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final profile = state.userProfile;
    final messages = state.filteredMessages;

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
              // Top Title + Audience Tags + Unread Badges
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Inbox',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${profile.department} • ${profile.yearOfStudy} Year • ${profile.clubs.join(', ')}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badges: unread count + verified shield
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.urgentBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${state.unreadMessagesCount} unread',
                          style: const TextStyle(
                            color: AppColors.urgentText,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.academicsBg,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified_user_outlined,
                          size: 18,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Stat chips: 3 messages, 1 high priority
              Row(
                children: [
                  _buildStatChip(
                    icon: Icons.visibility_outlined,
                    label: '${state.messages.length} messages',
                  ),
                  const SizedBox(width: 10),
                  _buildStatChip(
                    icon: Icons.priority_high_rounded,
                    label: '${state.highPriorityCount} high priority',
                    isPriority: true,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Filters: All, Unread, High Priority
              Row(
                children: ['All', 'Unread', 'High Priority'].map((filter) {
                  final isSelected = state.messageFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () => state.setMessageFilter(filter),
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryPurple : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryPurple : AppColors.borderLight,
                          ),
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Desktop: Two-pane layout / Mobile: Single list
              if (messages.isEmpty) ...[
                _buildEmptyState(context, state),
              ] else if (isDesktop) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left list pane
                    SizedBox(
                      width: 460,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: messages.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final isSelected = state.selectedMessage?.id == msg.id;
                          return MessageCard(
                            message: msg,
                            isSelected: isSelected,
                            onTap: () => state.selectMessage(msg),
                            onToggleRead: () => state.toggleMessageRead(msg.id),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Right detail pane
                    Expanded(
                      child: _buildDetailPane(context, state.selectedMessage),
                    ),
                  ],
                ),
              ] else ...[
                // Mobile single list
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: messages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return MessageCard(
                      message: msg,
                      onTap: () {
                        state.selectMessage(msg);
                        _showMobileMessageSheet(context, msg);
                      },
                      onToggleRead: () => state.toggleMessageRead(msg.id),
                    );
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

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    bool isPriority = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPriority ? const Color(0xFFFEF2F2) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPriority ? const Color(0xFFFECACA) : const Color(0xFFCBD5E1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isPriority ? AppColors.urgentRed : AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isPriority ? AppColors.urgentRed : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailPane(BuildContext context, InboxMessage? message) {
    if (message == null) {
      return Container(
        height: 350,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: const Center(
          child: Text('Select a message to view details'),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header of selected message
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: message.avatarColor,
                child: Text(
                  message.avatarInitials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.senderName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${message.senderRole} • ${message.timeAgo}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (message.isUrgent) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.urgentBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'HIGH PRIORITY',
                    style: TextStyle(
                      color: AppColors.urgentText,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 20),
          const Divider(color: AppColors.borderLight, height: 1),
          const SizedBox(height: 20),

          // Subject
          Text(
            message.subject,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 14),

          // Audience tags
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: message.audienceTags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.academicsBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.academicsText,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Body text
          Text(
            message.fullBody,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.65,
            ),
          ),

          const SizedBox(height: 32),

          // Action buttons
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reply draft created.')),
                  );
                },
                icon: const Icon(Icons.reply_rounded, size: 18),
                label: const Text('Reply'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Message archived.')),
                  );
                },
                icon: const Icon(Icons.archive_outlined, size: 18),
                label: const Text('Archive'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMobileMessageSheet(BuildContext context, InboxMessage message) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      message.senderName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  message.subject,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                Text(
                  message.fullBody,
                  style: const TextStyle(fontSize: 14, height: 1.6),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, AppState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: const Center(
        child: Text(
          'No messages in this filter',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
