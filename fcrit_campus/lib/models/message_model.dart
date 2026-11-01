import 'package:flutter/material.dart';

class InboxMessage {
  final String id;
  final String senderName;
  final String senderRole;
  final String avatarInitials;
  final Color avatarColor;
  final String timeAgo;
  final bool isUrgent;
  final String subject;
  final String previewBody;
  final String fullBody;
  final List<String> audienceTags;
  final int views;
  bool isRead;
  bool isHighPriority;

  InboxMessage({
    required this.id,
    required this.senderName,
    required this.senderRole,
    required this.avatarInitials,
    required this.avatarColor,
    required this.timeAgo,
    this.isUrgent = false,
    required this.subject,
    required this.previewBody,
    required this.fullBody,
    required this.audienceTags,
    required this.views,
    this.isRead = false,
    this.isHighPriority = false,
  });

  InboxMessage copyWith({
    String? id,
    String? senderName,
    String? senderRole,
    String? avatarInitials,
    Color? avatarColor,
    String? timeAgo,
    bool? isUrgent,
    String? subject,
    String? previewBody,
    String? fullBody,
    List<String>? audienceTags,
    int? views,
    bool? isRead,
    bool? isHighPriority,
  }) {
    return InboxMessage(
      id: id ?? this.id,
      senderName: senderName ?? this.senderName,
      senderRole: senderRole ?? this.senderRole,
      avatarInitials: avatarInitials ?? this.avatarInitials,
      avatarColor: avatarColor ?? this.avatarColor,
      timeAgo: timeAgo ?? this.timeAgo,
      isUrgent: isUrgent ?? this.isUrgent,
      subject: subject ?? this.subject,
      previewBody: previewBody ?? this.previewBody,
      fullBody: fullBody ?? this.fullBody,
      audienceTags: audienceTags ?? this.audienceTags,
      views: views ?? this.views,
      isRead: isRead ?? this.isRead,
      isHighPriority: isHighPriority ?? this.isHighPriority,
    );
  }
}
