import 'package:flutter/material.dart';
import '../models/notice_model.dart';
import '../models/event_model.dart';
import '../models/message_model.dart';
import '../models/user_profile_model.dart';

class MockData {
  static UserProfile get initialProfile => UserProfile(
        id: 'user_darvin_1',
        name: 'Darvin',
        email: 'darvin@fcrit.ac.in',
        department: 'CSE',
        yearOfStudy: '2nd',
        division: 'Div B',
        rollNumber: '42',
        clubs: ['Coding'],
        avatarInitials: 'FC',
        isProfileComplete: true,
      );

  static Notice get importantNotice => Notice(
        id: 'notif_imp_1',
        title: 'ESE Timetable for May 2026 Released',
        description: 'Download from Academic portal by Aug 10',
        category: NoticeCategory.academics,
        isNew: true,
        publisher: 'Academic Office',
        date: 'Aug 8, 2026',
        views: 842,
        isImportant: true,
      );

  static List<Notice> get initialNotices => [
        Notice(
          id: 'notice_1',
          title: 'End Semester Examination Timetable – May 2026',
          description:
              'The detailed schedule for the upcoming End Semester Examinations (ESE) has been published on the student portal. Students are advised to verify course codes and seating arrangements before Aug 12.',
          category: NoticeCategory.academics,
          isNew: true,
          publisher: 'Academic Office',
          date: 'Aug 6, 2026',
          views: 312,
          isBookmarked: false,
        ),
        Notice(
          id: 'notice_2',
          title: 'Campus Recruitment Drive – TCS NQT Registration Open',
          description:
              'Tata Consultancy Services (TCS) invites applications for the National Qualifier Test (NQT) for the batch of 2026. Eligible branches: CSE, IT, EXTC. Register through the TPO portal.',
          category: NoticeCategory.placements,
          isNew: true,
          publisher: 'Training & Placement Cell',
          date: 'Aug 5, 2026',
          views: 489,
          isBookmarked: true,
        ),
        Notice(
          id: 'notice_3',
          title: "Annual Cultural Fest 'Euphoria 2026' – Volunteer Registration",
          description:
              'Registrations are open for student coordinators and volunteers across Event Management, Logistics, Hospitality, and Creative Media teams for Euphoria 2026.',
          category: NoticeCategory.clubs,
          isNew: false,
          publisher: 'Cultural Committee',
          date: 'Aug 4, 2026',
          views: 201,
          isBookmarked: false,
        ),
        Notice(
          id: 'notice_4',
          title: 'Guest Lecture: AI Ethics & Responsible ML',
          description:
              'Distinguished speaker Dr. Aris Thorne from DeepMind will address ethical considerations, fairness metrics, and governance in real-world ML deployments.',
          category: NoticeCategory.events,
          isNew: false,
          publisher: 'CSE Department',
          date: 'Aug 3, 2026',
          views: 167,
          isBookmarked: false,
        ),
        Notice(
          id: 'notice_5',
          title: 'Inter-College Hackathon Code Odyssey 2026 Briefing',
          description:
              'Track themes, evaluation rubric, and submission requirements for the upcoming 24-hour hackathon. Teams of up to 4 members may register.',
          category: NoticeCategory.academics,
          isNew: false,
          publisher: 'Coding Club & CSE Dept',
          date: 'Aug 2, 2026',
          views: 395,
          isBookmarked: false,
        ),
        Notice(
          id: 'notice_6',
          title: 'Placement Preparation BootCamp: DSA & System Design',
          description:
              'A 6-week intensive cohort focused on LeetCode patterns, scalable system design architectures, and mock technical interviews with alumni.',
          category: NoticeCategory.placements,
          isNew: false,
          publisher: 'Training & Placement Cell',
          date: 'Jul 30, 2026',
          views: 610,
          isBookmarked: false,
        ),
      ];

  static List<EventItem> get initialEvents => [
        // Upcoming
        EventItem(
          id: 'event_1',
          title: 'Hackathon: Code Odyssey 2026',
          category: EventCategory.academics,
          status: EventStatus.upcoming,
          dateBadge: 'Saturday\nAug 15',
          time: '9:00 AM – 9:00 PM',
          location: 'Lab 301 & Main Auditorium',
          registeredCount: 120,
          isBookmarked: false,
          description:
              'A flagship 12-hour sprint solving problems in AI, Web3, and HealthTech. Cash prizes, certificates, and direct internship fast-tracks for winners.',
          eventDate: DateTime(2027, 8, 15, 9),
        ),
        EventItem(
          id: 'event_2',
          title: 'Industry Talk: Career Paths in Product',
          category: EventCategory.placements,
          status: EventStatus.upcoming,
          dateBadge: 'Tuesday\nAug 18',
          time: '2:00 PM – 4:00 PM',
          location: 'Seminar Hall 2',
          registeredCount: 85,
          isBookmarked: false,
          description:
              'Explore how software engineering transitions into technical product management with guest leaders from Microsoft and Flipkart.',
          eventDate: DateTime(2027, 8, 18, 14),
        ),
        EventItem(
          id: 'event_3',
          title: 'Photography Club Open Shoot',
          category: EventCategory.clubs,
          status: EventStatus.upcoming,
          dateBadge: 'Saturday\nAug 22',
          time: '6:00 AM – 8:00 AM',
          location: 'Campus Botanical Gardens & Courtyard',
          registeredCount: 34,
          isBookmarked: false,
          description:
              'Golden hour photo-walk, framing workshop, and manual DSLR lens mastering. Beginners and phone cameras welcome!',
          eventDate: DateTime(2027, 8, 22, 6),
        ),
        // Ongoing
        EventItem(
          id: 'event_4',
          title: 'TCS NQT Registration Window',
          category: EventCategory.placements,
          status: EventStatus.ongoing,
          dateBadge: 'Ongoing\nUntil Aug 14',
          time: 'Open 24/7',
          location: 'Online – TPO Portal',
          registeredCount: 489,
          ctaText: 'Register Now',
          isBookmarked: false,
          description:
              'Official portal registration for the 2026 TCS recruitment drive. Complete profile verification and upload your resume.',
          eventDate: DateTime(2027, 8, 14, 23, 59),
        ),
        EventItem(
          id: 'event_5',
          title: 'Euphoria Volunteer Applications',
          category: EventCategory.clubs,
          status: EventStatus.ongoing,
          dateBadge: 'Ongoing\nUntil Aug 20',
          time: 'Open 24/7',
          location: 'Online Form',
          registeredCount: 62,
          ctaText: 'Register Now',
          isBookmarked: false,
          description:
              'Apply for team leadership and volunteer positions for the upcoming college cultural extravaganza Euphoria 2026.',
          eventDate: DateTime(2027, 8, 20, 23, 59),
        ),
        // Past
        EventItem(
          id: 'event_6',
          title: 'Orientation for 2nd Year CSE Students',
          category: EventCategory.academics,
          status: EventStatus.past,
          dateBadge: 'Monday\nJuly 21',
          time: '10:00 AM – 1:00 PM',
          location: 'Auditorium A',
          registeredCount: 140,
          description:
              'Introduction to specialized departmental electives, laboratory protocols, and academic mentor allocation.',
          eventDate: DateTime(2026, 7, 21, 10),
        ),
        EventItem(
          id: 'event_7',
          title: 'Annual Sports League Qualifiers',
          category: EventCategory.sports,
          status: EventStatus.past,
          dateBadge: 'Thursday\nJuly 17',
          time: '4:00 PM – 7:00 PM',
          location: 'College Sports Ground',
          registeredCount: 95,
          description:
              'Inter-departmental badminton, football, and cricket tournament trials.',
          eventDate: DateTime(2026, 7, 17, 16),
        ),
      ];

  static List<InboxMessage> get initialMessages => [
        InboxMessage(
          id: 'msg_1',
          senderName: 'Academic Office',
          senderRole: 'Administration',
          avatarInitials: 'AO',
          avatarColor: const Color(0xFFEF4444),
          timeAgo: '4h ago',
          isUrgent: true,
          isHighPriority: true,
          subject: 'URGENT: ESE Hall Ticket Distribution Tomorrow',
          previewBody:
              'Hall tickets for May 2026 ESE will be distributed by class representatives tomorrow at 10 AM sharp in respective...',
          fullBody:
              'Dear Students,\n\nHall tickets for the upcoming May 2026 End Semester Examination will be distributed by class representatives tomorrow at 10:00 AM sharp in your respective division lecture halls.\n\nPlease note:\n1. Bring your student identity card for verification.\n2. Verify all listed course codes and exam timing on the ticket.\n3. In case of any discrepancy or dues clearance issues, report to Academic Window 3 before 1:00 PM.\n\nRegards,\nAcademic Administration Office',
          audienceTags: ['@CSE', '@2nd Year'],
          views: 312,
          isRead: false,
        ),
        InboxMessage(
          id: 'msg_2',
          senderName: 'Rahul Sharma',
          senderRole: 'Coding Club Lead',
          avatarInitials: 'RS',
          avatarColor: const Color(0xFF7C3AED),
          timeAgo: '2h ago',
          isUrgent: false,
          isHighPriority: false,
          subject: 'Coding Club: Weekly Challenge — Graph Algorithms',
          previewBody:
              "Week 2 is live! Dijkstra's, BFS, DFS — three problems of increasing difficulty. Submit on GitHub by Sunday midnight.",
          fullBody:
              "Hello coders!\n\nThe Week 2 algorithm challenge is now published on our club GitHub repository. This week's focus is on graph traversals, shortest path computations, and cycle detection.\n\nRules:\n• All solutions must be tested against edge cases.\n• Top 5 performers receive exclusive club badges and interview preparation mentors.\n• Deadline: Sunday at 11:59 PM.\n\nHappy coding,\nRahul Sharma (Lead, Coding Club)",
          audienceTags: ['@CSE', '@2nd Year', '@Coding Club'],
          views: 47,
          isRead: false,
        ),
        InboxMessage(
          id: 'msg_3',
          senderName: 'Library Office',
          senderRole: 'Administrative',
          avatarInitials: 'LO',
          avatarColor: const Color(0xFF0284C7),
          timeAgo: '2 days ago',
          isUrgent: false,
          isHighPriority: false,
          subject: 'Library: Overdue Book Fee Waiver Until Aug 10',
          previewBody:
              'Return all overdue library books by August 10 to avail the one-time late fee waiver. Check your issued books on the...',
          fullBody:
              'Attention all Students & Faculty,\n\nThe Central Library is observing an Amnesty Week from August 1 to August 10, 2026. All overdue penalties and late fines will be 100% waived for books returned during this period.\n\nPlease check your borrower account on the OPAC portal and return any outstanding reference or curriculum books promptly.\n\nChief Librarian,\nCentral Library, FCRIT',
          audienceTags: ['@CSE', '@2nd Year'],
          views: 421,
          isRead: false,
        ),
      ];
}
