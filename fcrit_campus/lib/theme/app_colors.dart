import 'package:flutter/material.dart';

class AppColors {
  // Brand Dark Navy
  static const Color navyBackground = Color(0xFFF5F8FC);
  static const Color navyHeader = Color(0xFFFFFFFF);
  static const Color navySurface = Color(0xFFF4F8FC);
  static const Color navyBorder = Color(0xFFE2EAF3);

  // Gradient Purples / Accents
  static const Color primaryPurple = Color(0xFF3478C9);
  static const Color primaryViolet = Color(0xFF2867B2);
  static const Color accentIndigo = Color(0xFF4F8FD6);
  static const Color purpleLight = Color(0xFFEAF3FC);
  static const Color purpleText = Color(0xFF285F9C);

  // Content Surfaces
  static const Color backgroundLight = Color(0xFFF5F8FC);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE2EAF3);
  static const Color borderSubtle = Color(0xFFF0F4F8);

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textLightSecondary = Color(0xFF94A3B8);

  // Category Colors
  // Academics
  static const Color academics = Color(0xFF7C3AED);
  static const Color academicsBg = Color(0xFFEDE9FE);
  static const Color academicsText = Color(0xFF6D28D9);

  // Placements
  static const Color placements = Color(0xFF10B981);
  static const Color placementsBg = Color(0xFFD1FAE5);
  static const Color placementsText = Color(0xFF065F46);

  // Clubs
  static const Color clubs = Color(0xFFF59E0B);
  static const Color clubsBg = Color(0xFFFEF3C7);
  static const Color clubsText = Color(0xFF92400E);

  // Events
  static const Color events = Color(0xFF0284C7);
  static const Color eventsBg = Color(0xFFE0F2FE);
  static const Color eventsText = Color(0xFF0369A1);

  // Cultural / Pink
  static const Color cultural = Color(0xFFEC4899);
  static const Color culturalBg = Color(0xFFFCE7F3);
  static const Color culturalText = Color(0xFF9D174D);

  // Status & Priority
  static const Color urgentRed = Color(0xFFEF4444);
  static const Color urgentBg = Color(0xFFFEE2E2);
  static const Color urgentText = Color(0xFFB91C1C);

  // Gradients
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF5A91D0), Color(0xFF3478C9), Color(0xFF2867B2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bannerGradient = LinearGradient(
    colors: [Color(0xFF4C88C8), Color(0xFF3478C9), Color(0xFF2867B2)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient cardHeaderGradient = LinearGradient(
    colors: [Color(0xFF4C88C8), Color(0xFF3478C9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient placementsGradient = LinearGradient(
    colors: [Color(0xFF059669), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient clubsGradient = LinearGradient(
    colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient eventsOngoingGradient = LinearGradient(
    colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient culturalGradient = LinearGradient(
    colors: [Color(0xFFDB2777), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
