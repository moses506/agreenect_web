// lib/screens/achievements.dart
// Live DynamicAchievementsSection — reads from Firestore achievements_section

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agreenect/utils/responsivenes.dart';

class DynamicAchievementsSection extends StatelessWidget {
  const DynamicAchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('sections')
          .doc('achievements_section')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: isMobile ? 60 : 80),
            color: const Color(0xFFF5F7F2),
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFF4A9B6A)),
            ),
          );
        }

        if (snapshot.hasError ||
            !snapshot.hasData ||
            !snapshot.data!.exists) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        if (data['visible'] == false) return const SizedBox.shrink();

        final String title = data['title'] ?? 'Awards & Recognition';
        final String subtitle = (data['subtitle'] ?? '').toString();
        final List<dynamic> achievements = data['achievements'] ?? [];

        if (achievements.isEmpty) return const SizedBox.shrink();

        return Container(
          color: const Color(0xFFF5F7F2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Gradient header banner ──────────────────────────────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: isMobile ? 48 : 64,
                  horizontal: isMobile ? 24 : 80,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0F2419), Color(0xFF1A3A2A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Trophy icon
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5A623).withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFF5A623).withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.emoji_events_rounded,
                        size: 38,
                        color: Color(0xFFF5A623),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 28 : 38,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isMobile ? 15 : 17,
                          color: Colors.white.withOpacity(0.65),
                          height: 1.5,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    // Count pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5A623).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF5A623).withOpacity(0.35)),
                      ),
                      child: Text(
                        '${achievements.length} Achievement${achievements.length != 1 ? 's' : ''}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF5A623),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Timeline list ───────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: isMobile ? 40 : 60,
                  horizontal: isMobile ? 20 : 80,
                ),
                child: isMobile
                    ? _MobileTimeline(achievements: achievements)
                    : _DesktopTimeline(achievements: achievements),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DESKTOP — alternating left/right layout
// ─────────────────────────────────────────────────────────────────────────────
class _DesktopTimeline extends StatelessWidget {
  final List<dynamic> achievements;
  const _DesktopTimeline({required this.achievements});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: achievements.asMap().entries.map((e) {
        final isLeft = e.key.isEven;
        return Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: _DesktopRow(
            achievement: e.value,
            index: e.key,
            isLeft: isLeft,
            isLast: e.key == achievements.length - 1,
          ),
        );
      }).toList(),
    );
  }
}

class _DesktopRow extends StatelessWidget {
  final dynamic achievement;
  final int index;
  final bool isLeft, isLast;
  const _DesktopRow({
    required this.achievement,
    required this.index,
    required this.isLeft,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final card = _AchievementCard(achievement: achievement, index: index);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left card or spacer
          Expanded(
            child: isLeft
                ? Padding(padding: const EdgeInsets.only(right: 24, bottom: 48), child: card)
                : const SizedBox(),
          ),

          // Centre timeline spine
          _TimelineSpine(index: index, isLast: isLast),

          // Right card or spacer
          Expanded(
            child: !isLeft
                ? Padding(padding: const EdgeInsets.only(left: 24, bottom: 48), child: card)
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

class _TimelineSpine extends StatelessWidget {
  final int index; final bool isLast;
  const _TimelineSpine({required this.index, required this.isLast});

  static const _colors = [
    Color(0xFFF5A623), Color(0xFF4A9B6A), Color(0xFF4A9FD4),
    Color(0xFFE85D75), Color(0xFF7FD17A), Color(0xFF2D5A3D),
  ];

  @override
  Widget build(BuildContext context) {
    final color = _colors[index % _colors.length];
    return SizedBox(
      width: 56,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dot
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2.5),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ),
          ),
          // Line
          if (!isLast)
            Expanded(
              child: Container(
                width: 2,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.5), color.withOpacity(0.1)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MOBILE — vertical stacked with left line
// ─────────────────────────────────────────────────────────────────────────────
class _MobileTimeline extends StatelessWidget {
  final List<dynamic> achievements;
  const _MobileTimeline({required this.achievements});

  static const _colors = [
    Color(0xFFF5A623), Color(0xFF4A9B6A), Color(0xFF4A9FD4),
    Color(0xFFE85D75), Color(0xFF7FD17A), Color(0xFF2D5A3D),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: achievements.asMap().entries.map((e) {
        final color = _colors[e.key % _colors.length];
        final isLast = e.key == achievements.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left dot + line
              SizedBox(
                width: 40,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(color: color, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          '${e.key + 1}',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: color),
                        ),
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: color.withOpacity(0.2),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Card
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
                  child: _AchievementCard(achievement: e.value, index: e.key),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ACHIEVEMENT CARD
// ─────────────────────────────────────────────────────────────────────────────
class _AchievementCard extends StatelessWidget {
  final dynamic achievement;
  final int index;
  const _AchievementCard({required this.achievement, required this.index});

  static const _accentColors = [
    Color(0xFFF5A623), Color(0xFF4A9B6A), Color(0xFF4A9FD4),
    Color(0xFFE85D75), Color(0xFF7FD17A), Color(0xFF2D5A3D),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final year        = (achievement['year']        ?? '').toString();
    final title       = (achievement['title']       ?? '').toString();
    final description = (achievement['description'] ?? '').toString();
    final imgUrl      = (achievement['image']       ?? '').toString();
    final accent      = _accentColors[index % _accentColors.length];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: accent.withOpacity(0.15), width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top accent bar + optional image
          if (imgUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(17),
                topRight: Radius.circular(17),
              ),
              child: Image.network(
                imgUrl,
                height: isMobile ? 160 : 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _colorBar(accent),
              ),
            )
          else
            _colorBar(accent),

          // Content
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Year badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: accent.withOpacity(0.3)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.calendar_today_rounded, size: 11, color: accent),
                    const SizedBox(width: 5),
                    Text(
                      year,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: accent,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 14),

                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1C2A1E),
                    height: 1.3,
                  ),
                ),

                // Description
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.55,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorBar(Color color) => Container(
    height: 6,
    decoration: BoxDecoration(
      color: color,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(17),
        topRight: Radius.circular(17),
      ),
    ),
  );
}