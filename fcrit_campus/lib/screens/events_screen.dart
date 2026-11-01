import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event_model.dart';
import '../services/api_service.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/event_card.dart';

class EventsScreen extends StatelessWidget {
  final bool isDesktop;

  const EventsScreen({
    super.key,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final events = state.filteredEvents;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateEventDialog(context),
        backgroundColor: AppColors.primaryPurple,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
      body: SingleChildScrollView(
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
                // Top Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Events',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    // Search bar
                    SizedBox(
                      width: isDesktop ? 280 : 180,
                      height: 42,
                      child: TextField(
                        onChanged: (val) => state.setEventSearchQuery(val),
                        decoration: const InputDecoration(
                          hintText: 'Search events...',
                          hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
                          prefixIcon: Icon(Icons.search_rounded, size: 18, color: AppColors.textMuted),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Segmented control: Upcoming, Ongoing (with green dot), Past
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    mainAxisSize: isDesktop ? MainAxisSize.min : MainAxisSize.max,
                    children: [
                      _buildSegmentButton(
                        context,
                        title: 'Upcoming',
                        status: EventStatus.upcoming,
                        isSelected: state.selectedEventStatus == EventStatus.upcoming,
                      ),
                      _buildSegmentButton(
                        context,
                        title: 'Ongoing',
                        status: EventStatus.ongoing,
                        hasDot: true,
                        isSelected: state.selectedEventStatus == EventStatus.ongoing,
                      ),
                      _buildSegmentButton(
                        context,
                        title: 'Past',
                        status: EventStatus.past,
                        isSelected: state.selectedEventStatus == EventStatus.past,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Event Cards Grid
                if (events.isEmpty) ...[
                  _buildEmptyState(context, state),
                ] else ...[
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = constraints.maxWidth >= 1000
                          ? 3
                          : (constraints.maxWidth >= 640 ? 2 : 1);

                      if (crossAxisCount == 1) {
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: events.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 18),
                          itemBuilder: (context, index) {
                            final event = events[index];
                            return EventCard(
                              event: event,
                              onBookmarkToggle: () => state.toggleEventBookmark(event.id),
                              onRegisterToggle: () => _registerForEvent(context, state, event),
                            );
                          },
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                          mainAxisExtent: 310,
                        ),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return EventCard(
                            event: event,
                            onBookmarkToggle: () => state.toggleEventBookmark(event.id),
                            onRegisterToggle: () => _registerForEvent(context, state, event),
                          );
                        },
                      );
                    },
                  ),
                ],
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _registerForEvent(BuildContext context, AppState state, EventItem event) async {
    if (event.isRegistered) return;
    final result = await ApiService.registerForEvent(
      eventKey: event.id,
      title: event.title,
      location: event.location,
      eventDate: event.eventDate,
    );
    if (!context.mounted) return;
    if (result['success'] == true) {
      state.registerForEvent(event.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registered for ${event.title}. Check your email for confirmation.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] as String? ?? 'Could not register for this event.')),
      );
    }
  }

  Widget _buildSegmentButton(
    BuildContext context, {
    required String title,
    required EventStatus status,
    required bool isSelected,
    bool hasDot = false,
  }) {
    final state = context.read<AppState>();

    return InkWell(
      onTap: () => state.setEventStatus(status),
      borderRadius: BorderRadius.circular(26),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
            if (hasDot) ...[
              const SizedBox(width: 6),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
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
      child: Column(
        children: [
          const Icon(
            Icons.event_busy_rounded,
            size: 54,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 14),
          const Text(
            'No Events Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'There are no events matching your active filter or search keyword.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () {
              state.setEventSearchQuery('');
              state.setEventStatus(EventStatus.upcoming);
            },
            child: const Text('Reset Filter'),
          ),
        ],
      ),
    );
  }

  void _showCreateEventDialog(BuildContext context) {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Submit Campus Event'),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Event Title',
                  hintText: 'e.g. AI Workshop 2026',
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Student club leads can propose campus workshops, webinars, and competitions.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Event submitted for faculty approval.')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
