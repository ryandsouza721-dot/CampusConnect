enum NoticeCategory {
  academics,
  placements,
  clubs,
  events,
  cultural,
}

extension NoticeCategoryExtension on NoticeCategory {
  String get displayName {
    switch (this) {
      case NoticeCategory.academics:
        return 'ACADEMICS';
      case NoticeCategory.placements:
        return 'PLACEMENTS';
      case NoticeCategory.clubs:
        return 'CLUBS';
      case NoticeCategory.events:
        return 'EVENTS';
      case NoticeCategory.cultural:
        return 'CULTURAL';
    }
  }

  String get label {
    switch (this) {
      case NoticeCategory.academics:
        return 'Academics';
      case NoticeCategory.placements:
        return 'Placements';
      case NoticeCategory.clubs:
        return 'Clubs';
      case NoticeCategory.events:
        return 'Events';
      case NoticeCategory.cultural:
        return 'Cultural';
    }
  }
}

class Notice {
  final String id;
  final String title;
  final String description;
  final NoticeCategory category;
  final bool isNew;
  final String publisher;
  final String date;
  final int views;
  bool isBookmarked;
  bool isRead;
  final bool isImportant;

  Notice({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.isNew = false,
    required this.publisher,
    required this.date,
    required this.views,
    this.isBookmarked = false,
    this.isRead = false,
    this.isImportant = false,
  });

  Notice copyWith({
    String? id,
    String? title,
    String? description,
    NoticeCategory? category,
    bool? isNew,
    String? publisher,
    String? date,
    int? views,
    bool? isBookmarked,
    bool? isRead,
    bool? isImportant,
  }) {
    return Notice(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isNew: isNew ?? this.isNew,
      publisher: publisher ?? this.publisher,
      date: date ?? this.date,
      views: views ?? this.views,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isRead: isRead ?? this.isRead,
      isImportant: isImportant ?? this.isImportant,
    );
  }
}
