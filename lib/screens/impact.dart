// lib/screens/impact.dart
// Live ImpactSection — reads from Firestore impact_section

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agreenect/utils/responsivenes.dart';

class ImpactSection extends StatelessWidget {
  const ImpactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('sections')
          .doc('impact_section')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: isMobile ? 60 : 80),
            color: const Color(0xFFF0F7F4),
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFF4A9B6A)),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) return const SizedBox.shrink();
        final data = snapshot.data!.data() as Map<String, dynamic>;
        if (data['visible'] == false) return const SizedBox.shrink();

        final String title          = data['title']    ?? 'Creating Real Impact';
        final String subtitle       = data['subtitle'] ?? '';
        final List<dynamic> stories = data['stories']  ?? [];

        return _ImpactLayout(
          title: title,
          subtitle: subtitle,
          stories: stories,
          isMobile: isMobile,
        );
      },
    );
  }
}

// =============================================================================
// LAYOUT SHELL
// =============================================================================
class _ImpactLayout extends StatelessWidget {
  final String title, subtitle;
  final List<dynamic> stories;
  final bool isMobile;

  const _ImpactLayout({
    required this.title,
    required this.subtitle,
    required this.stories,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F7F4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Dark header banner ──────────────────────────────────────────
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
                // Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A9B6A).withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF7FD17A).withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    size: 34,
                    color: Color(0xFF7FD17A),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
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
                  const SizedBox(height: 14),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 580),
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        color: Colors.white.withOpacity(0.65),
                        height: 1.6,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 18),

                // Count pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A9B6A).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF7FD17A).withOpacity(0.4),
                    ),
                  ),
                  child: Text(
                    stories.isNotEmpty
                        ? '${stories.length} Farmer ${stories.length == 1 ? 'Story' : 'Stories'}'
                        : '4 Impact Areas',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7FD17A),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Content area ──────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 40 : 60,
              horizontal: isMobile ? 20 : 80,
            ),
            child: stories.isNotEmpty
                ? _StoriesGrid(stories: stories, isMobile: isMobile)
                : _FallbackGrid(isMobile: isMobile),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// STORIES GRID
// =============================================================================
class _StoriesGrid extends StatelessWidget {
  final List<dynamic> stories;
  final bool isMobile;
  const _StoriesGrid({required this.stories, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveUtils.isTablet(context);
    final cols     = isMobile ? 1 : (isTablet ? 2 : 3);
    const spacing  = 24.0;
    final totalW   = MediaQuery.of(context).size.width - (isMobile ? 40.0 : 160.0);
    final cardW    = ((totalW - spacing * (cols - 1)) / cols).clamp(260.0, 420.0);

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      alignment: WrapAlignment.center,
      children: stories
          .map((s) => SizedBox(width: cardW, child: _StoryCard(story: s)))
          .toList(),
    );
  }
}

// =============================================================================
// STORY CARD
// =============================================================================
class _StoryCard extends StatefulWidget {
  final dynamic story;
  const _StoryCard({required this.story});
  @override
  State<_StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<_StoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final farmer   = (widget.story['farmer']   ?? '').toString();
    final location = (widget.story['location'] ?? '').toString();
    final text     = (widget.story['story']    ?? '').toString();
    final imgUrl   = (widget.story['image']    ?? '').toString();
    final initial  = farmer.isNotEmpty ? farmer.trim()[0].toUpperCase() : 'F';

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? const Color(0xFF4A9B6A).withOpacity(0.3)
                : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_hovered ? 0.12 : 0.06),
              blurRadius: _hovered ? 28 : 16,
              offset: Offset(0, _hovered ? 10 : 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Photo / placeholder ─────────────────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: imgUrl.isNotEmpty
                  ? Image.network(
                      imgUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _photoPlaceholder(initial),
                    )
                  : _photoPlaceholder(initial),
            ),

            // ── Opening quote mark ──────────────────────────────────────
            if (text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 16),
                child: Text(
                  '\u201C',
                  style: TextStyle(
                    fontSize: 48,
                    height: 0.6,
                    color: const Color(0xFF4A9B6A).withOpacity(0.25),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

            // ── Text content ────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(20, text.isNotEmpty ? 6 : 20, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (text.isNotEmpty) ...[
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.65,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: Color(0xFFEEF2ED)),
                    const SizedBox(height: 14),
                  ],

                  // Farmer row
                  Row(
                    children: [
                      // Square avatar
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2D5A3D), Color(0xFF4A9B6A)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            initial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Name + location
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              farmer,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1C2A1E),
                              ),
                            ),
                            if (location.isNotEmpty) ...[
                              const SizedBox(height: 3),
                              Row(children: [
                                Icon(Icons.location_on_rounded,
                                    size: 12, color: Colors.green[500]),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                    location,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.green[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ]),
                            ],
                          ],
                        ),
                      ),

                      // Farmer tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A9B6A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Farmer',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4A9B6A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _photoPlaceholder(String initial) => Container(
    height: 200,
    width: double.infinity,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF1A3A2A), Color(0xFF2D5A3D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: -20, right: -20,
          child: Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),
        Positioned(
          bottom: -30, left: -10,
          child: Container(
            width: 120, height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// =============================================================================
// FALLBACK GRID (no stories in Firestore yet)
// =============================================================================
class _FallbackGrid extends StatelessWidget {
  final bool isMobile;
  const _FallbackGrid({required this.isMobile});

  static const _items = [
    (Icons.eco_rounded,               'Climate-Smart\nPractices', Color(0xFF4A9B6A)),
    (Icons.landscape_rounded,         'Land\nRestoration',        Color(0xFF8B6914)),
    (Icons.device_thermostat_rounded, 'Climate\nResilience',      Color(0xFFF5A623)),
    (Icons.trending_up_rounded,       'Market\nAccess',           Color(0xFF4A9FD4)),
  ];

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: _items.sublist(0, 2).map((i) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _ImpactTile(icon: i.$1, title: i.$2, color: i.$3),
              ),
            )).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: _items.sublist(2).map((i) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _ImpactTile(icon: i.$1, title: i.$2, color: i.$3),
              ),
            )).toList(),
          ),
        ],
      );
    }
    return Wrap(
      spacing: 24, runSpacing: 24, alignment: WrapAlignment.center,
      children: _items
          .map((i) => _ImpactTile(icon: i.$1, title: i.$2, color: i.$3))
          .toList(),
    );
  }
}

class _ImpactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  const _ImpactTile({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    return Container(
      width: isMobile ? null : 220,
      height: isMobile ? 130 : 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: isMobile ? 28 : 36, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 13 : 15,
              fontWeight: FontWeight.w700,
              color: color,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}