enum EventStatus {
  upcoming,
  ongoing,
  past,
}

enum EventCategory {
  academics,
  placements,
  clubs,
  cultural,
  sports,
}

extension EventCategoryExtension on EventCategory {
  String get displayName {
    switch (this) {
      case EventCategory.academics:
        return 'ACADEMICS';
      case EventCategory.placements:
        return 'PLACEMENTS';
      case EventCategory.clubs:
        return 'CLUBS';
      case EventCategory.cultural:
        return 'CULTURAL';
      case EventCategory.sports:
        return 'SPORTS';
    }
  }
}

class EventItem {
  final String id;
  final String title;
  final EventCategory category;
  final EventStatus status;
  final String dateBadge; // e.g. "Saturday Aug 15" or "Ongoing Until Aug 14"
  final String time; // e.g. "9:00 AM – 9:00 PM" or "Open 24/7"
  final String location; // e.g. "Online – TPO Portal" or "Campus Auditorium"
  int registeredCount;
  bool isBookmarked;
  bool isRegistered;
  final String? ctaText;
  final String description;
  final DateTime eventDate;

  EventItem({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.dateBadge,
    required this.time,
    required this.location,
    required this.registeredCount,
    this.isBookmarked = false,
    this.isRegistered = false,
    this.ctaText,
    required this.description,
    required this.eventDate,
  });

  EventItem copyWith({
    String? id,
    String? title,
    EventCategory? category,
    EventStatus? status,
    String? dateBadge,
    String? time,
    String? location,
    int? registeredCount,
    bool? isBookmarked,
    bool? isRegistered,
    String? ctaText,
    String? description,
    DateTime? eventDate,
  }) {
    return EventItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      status: status ?? this.status,
      dateBadge: dateBadge ?? this.dateBadge,
      time: time ?? this.time,
      location: location ?? this.location,
      registeredCount: registeredCount ?? this.registeredCount,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isRegistered: isRegistered ?? this.isRegistered,
      ctaText: ctaText ?? this.ctaText,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
    );
  }
}
