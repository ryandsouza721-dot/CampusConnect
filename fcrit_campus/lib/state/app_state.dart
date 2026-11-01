import 'package:flutter/material.dart';
import '../models/notice_model.dart';
import '../models/event_model.dart';
import '../models/message_model.dart';
import '../models/user_profile_model.dart';
import '../services/mock_data.dart';

class AppState extends ChangeNotifier {
  // Navigation: 0 = Home, 1 = Events, 2 = Inbox/You, 3 = Profile
  // (Notice: "Notices" has been safely removed from bottom/sidebar primary tabs)
  int _currentNavIndex = 0;
  int get currentNavIndex => _currentNavIndex;

  UserProfile _userProfile = MockData.initialProfile;
  UserProfile get userProfile => _userProfile;

  final Notice _importantNotice = MockData.importantNotice;
  Notice get importantNotice => _importantNotice;

  final List<Notice> _notices = MockData.initialNotices;
  List<Notice> get notices => _notices;

  // Quick Access filter on Home
  String _selectedNoticeCategoryFilter = 'All'; // 'All', 'Notices', 'Placements', 'Clubs', 'Events', 'Academics'
  String get selectedNoticeCategoryFilter => _selectedNoticeCategoryFilter;

  // Events state
  final List<EventItem> _events = MockData.initialEvents;
  List<EventItem> get events => _events;

  EventStatus _selectedEventStatus = EventStatus.upcoming;
  EventStatus get selectedEventStatus => _selectedEventStatus;

  String _eventSearchQuery = '';
  String get eventSearchQuery => _eventSearchQuery;

  // Inbox state
  final List<InboxMessage> _messages = MockData.initialMessages;
  List<InboxMessage> get messages => _messages;

  String _messageFilter = 'All'; // 'All', 'Unread', 'High Priority'
  String get messageFilter => _messageFilter;

  InboxMessage? _selectedMessage;
  InboxMessage? get selectedMessage => _selectedMessage ?? (_messages.isNotEmpty ? _messages.first : null);

  String _globalSearchQuery = '';
  String get globalSearchQuery => _globalSearchQuery;
  void setGlobalSearchQuery(String query) {
    _globalSearchQuery = query;
    notifyListeners();
  }

  // Navigation setter
  void setNavIndex(int index) {
    if (index >= 0 && index <= 3) {
      _currentNavIndex = index;
      notifyListeners();
    }
  }

  // Profile update
  void updateProfile({
    required String department,
    required String yearOfStudy,
    required List<String> clubs,
    String? name,
    String? division,
    String? rollNumber,
  }) {
    _userProfile = _userProfile.copyWith(
      department: department,
      yearOfStudy: yearOfStudy,
      clubs: clubs,
      name: name,
      division: division,
      rollNumber: rollNumber,
      isProfileComplete: true,
    );
    notifyListeners();
  }

  // Notices Actions
  void setNoticeFilter(String category) {
    _selectedNoticeCategoryFilter = category;
    notifyListeners();
  }

  void toggleNoticeBookmark(String noticeId) {
    final index = _notices.indexWhere((n) => n.id == noticeId);
    if (index != -1) {
      _notices[index] = _notices[index].copyWith(
        isBookmarked: !_notices[index].isBookmarked,
      );
      notifyListeners();
    }
  }

  List<Notice> get filteredNotices {
    if (_selectedNoticeCategoryFilter == 'All' || _selectedNoticeCategoryFilter == 'Notices') {
      return _notices;
    }
    final filterLower = _selectedNoticeCategoryFilter.toLowerCase();
    return _notices.where((n) {
      return n.category.name.toLowerCase() == filterLower;
    }).toList();
  }

  // Events Actions
  void setEventStatus(EventStatus status) {
    _selectedEventStatus = status;
    notifyListeners();
  }

  void setEventSearchQuery(String query) {
    _eventSearchQuery = query;
    notifyListeners();
  }

  void toggleEventBookmark(String eventId) {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      _events[index] = _events[index].copyWith(
        isBookmarked: !_events[index].isBookmarked,
      );
      notifyListeners();
    }
  }

  void registerForEvent(String eventId) {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      final isCurrentlyRegistered = _events[index].isRegistered;
      _events[index] = _events[index].copyWith(
        isRegistered: !isCurrentlyRegistered,
        registeredCount: isCurrentlyRegistered
            ? _events[index].registeredCount - 1
            : _events[index].registeredCount + 1,
      );
      notifyListeners();
    }
  }

  List<EventItem> get filteredEvents {
    return _events.where((e) {
      final matchesStatus = e.status == _selectedEventStatus;
      final matchesSearch = _eventSearchQuery.isEmpty ||
          e.title.toLowerCase().contains(_eventSearchQuery.toLowerCase()) ||
          e.category.displayName.toLowerCase().contains(_eventSearchQuery.toLowerCase());
      return matchesStatus && matchesSearch;
    }).toList();
  }

  // Inbox Actions
  void setMessageFilter(String filter) {
    _messageFilter = filter;
    notifyListeners();
  }

  void selectMessage(InboxMessage msg) {
    _selectedMessage = msg;
    // Mark as read when selected
    final index = _messages.indexWhere((m) => m.id == msg.id);
    if (index != -1 && !_messages[index].isRead) {
      _messages[index] = _messages[index].copyWith(isRead: true);
    }
    notifyListeners();
  }

  void toggleMessageRead(String messageId) {
    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      _messages[index] = _messages[index].copyWith(
        isRead: !_messages[index].isRead,
      );
      if (_selectedMessage?.id == messageId) {
        _selectedMessage = _messages[index];
      }
      notifyListeners();
    }
  }

  List<InboxMessage> get filteredMessages {
    switch (_messageFilter) {
      case 'Unread':
        return _messages.where((m) => !m.isRead).toList();
      case 'High Priority':
        return _messages.where((m) => m.isHighPriority || m.isUrgent).toList();
      case 'All':
      default:
        return _messages;
    }
  }

  int get unreadMessagesCount => _messages.where((m) => !m.isRead).length;
  int get highPriorityCount => _messages.where((m) => m.isHighPriority || m.isUrgent).length;
  int get bookmarkedNoticesCount => _notices.where((n) => n.isBookmarked).length;
  int get bookmarkedEventsCount => _events.where((e) => e.isBookmarked).length;
}
