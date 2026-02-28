// lib/screens/works.dart
// Live OurWorksSection — reads from Firestore works_section
// Falls back to local assets if no Firestore projects exist yet

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agreenect/utils/responsivenes.dart';

class OurWorksSection extends StatelessWidget {
  const OurWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('sections')
          .doc('works_section')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: isMobile ? 60 : 80),
            color: Colors.grey[50],
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFF4A9B6A)),
            ),
          );
        }

        // If Firestore doc missing or section hidden, show fallback assets
        final hasData = snapshot.hasData && snapshot.data!.exists;
        final data    = hasData ? snapshot.data!.data() as Map<String, dynamic> : <String, dynamic>{};
        if (data['visible'] == false) return const SizedBox.shrink();

        final String title    = data['title']    ?? 'Our Works in Action';
        final String subtitle = data['subtitle'] ?? 'See how we are making a difference in communities across Zambia through our digital agriculture initiatives with the help of our partners';
        final List<dynamic> projects = data['projects'] ?? [];

        return _WorksLayout(
          title: title,
          subtitle: subtitle,
          projects: projects,
          isMobile: isMobile,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LAYOUT SHELL
// ─────────────────────────────────────────────────────────────────────────────
class _WorksLayout extends StatelessWidget {
  final String title, subtitle;
  final List<dynamic> projects;
  final bool isMobile;

  const _WorksLayout({
    required this.title,
    required this.subtitle,
    required this.projects,
    required this.isMobile,
  });

  // Fallback local asset projects
  static const _fallback = [
    {
      'title': 'Farmer Training Session',
      'description': 'Empowering local farmers with digital tools',
      'category': 'Training',
      'image': null,
      'asset': 'assets/works/WhatsApp Image 2025-09-20 at 13.34.07 (1).jpeg',
    },
    {
      'title': 'Mobile App Demo',
      'description': 'Teaching smartphone-based farming solutions',
      'category': 'Technology',
      'image': null,
      'asset': 'assets/works/WhatsApp Image 2025-11-15 at 15.52.18.jpeg',
    },
    {
      'title': 'Youth Engagement',
      'description': 'Involving young people in smart farming practices',
      'category': 'Community',
      'image': null,
      'asset': 'assets/works/WhatsApp Image 2025-09-19 at 21.50.41 (1).jpeg',
    },
    {
      'title': 'Sustainable Farming',
      'description': 'Promoting eco-friendly agricultural methods',
      'category': 'Sustainability',
      'image': null,
      'asset': 'assets/works/WhatsApp Image 2025-09-20 at 13.34.08.jpeg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isTablet  = ResponsiveUtils.isTablet(context);
    final items     = projects.isNotEmpty
        ? projects.map((p) => Map<String, dynamic>.from(p as Map)).toList()
        : _fallback.map((p) => Map<String, dynamic>.from(p)).toList();

    return Container(
      color: Colors.grey[50],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Dark header banner ──────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 48 : 60,
              horizontal: isMobile ? 24 : 80,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A3A2A), Color(0xFF2D5A3D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7FD17A).withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF7FD17A).withOpacity(0.35),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.work_outline_rounded,
                    size: 34,
                    color: Color(0xFF7FD17A),
                  ),
                ),
                const SizedBox(height: 18),
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
                const SizedBox(height: 14),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
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
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7FD17A).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF7FD17A).withOpacity(0.35)),
                  ),
                  child: Text(
                    '${items.length} Project${items.length != 1 ? 's' : ''}',
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

          // ── Grid ────────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 32 : 48,
              horizontal: isMobile ? 20 : 40,
            ),
            child: isMobile
                ? _MobileGrid(items: items)
                : isTablet
                    ? _TabletGrid(items: items)
                    : _DesktopGrid(items: items),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RESPONSIVE GRID LAYOUTS
// ─────────────────────────────────────────────────────────────────────────────

// Mobile: 2-col pairs
class _MobileGrid extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const _MobileGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    final rows = <List<Map<String, dynamic>>>[];
    for (var i = 0; i < items.length; i += 2) {
      rows.add(items.sublist(i, (i + 2).clamp(0, items.length)));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows.asMap().entries.map((e) => Padding(
        padding: EdgeInsets.only(top: e.key == 0 ? 0 : 16),
        child: Row(
          children: [
            for (var j = 0; j < e.value.length; j++) ...[
              if (j > 0) const SizedBox(width: 14),
              Expanded(child: _WorkCard(project: e.value[j], aspectRatio: 4 / 3)),
            ],
            if (e.value.length == 1) const Expanded(child: SizedBox()),
          ],
        ),
      )).toList(),
    );
  }
}

// Tablet: 2-col
class _TabletGrid extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const _TabletGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    final rows = <List<Map<String, dynamic>>>[];
    for (var i = 0; i < items.length; i += 2) {
      rows.add(items.sublist(i, (i + 2).clamp(0, items.length)));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows.asMap().entries.map((e) => Padding(
        padding: EdgeInsets.only(top: e.key == 0 ? 0 : 20),
        child: Row(
          children: [
            for (var j = 0; j < e.value.length; j++) ...[
              if (j > 0) const SizedBox(width: 20),
              Expanded(child: _WorkCard(project: e.value[j], aspectRatio: 16 / 9)),
            ],
            if (e.value.length == 1) const Expanded(child: SizedBox()),
          ],
        ),
      )).toList(),
    );
  }
}

// Desktop: masonry-inspired — first item tall left, rest 2-col right
class _DesktopGrid extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const _DesktopGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox();

    if (items.length == 1) {
      return _WorkCard(project: items[0], aspectRatio: 16 / 7);
    }

    final featured = items[0];
    final rest     = items.sublist(1);

    // Right column: pairs of 2
    final rightRows = <List<Map<String, dynamic>>>[];
    for (var i = 0; i < rest.length; i += 2) {
      rightRows.add(rest.sublist(i, (i + 2).clamp(0, rest.length)));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Featured left card
        Expanded(
          child: _WorkCard(project: featured, aspectRatio: 3 / 4, featured: true),
        ),
        const SizedBox(width: 16),
        // Right grid
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: rightRows.asMap().entries.map((e) => Padding(
              padding: EdgeInsets.only(top: e.key == 0 ? 0 : 16),
              child: Row(
                children: [
                  for (var j = 0; j < e.value.length; j++) ...[
                    if (j > 0) const SizedBox(width: 16),
                    Expanded(child: _WorkCard(project: e.value[j], aspectRatio: 16 / 9)),
                  ],
                  if (e.value.length == 1) const Expanded(child: SizedBox()),
                ],
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WORK CARD
// ─────────────────────────────────────────────────────────────────────────────
class _WorkCard extends StatefulWidget {
  final Map<String, dynamic> project;
  final double aspectRatio;
  final bool featured;

  const _WorkCard({
    required this.project,
    required this.aspectRatio,
    this.featured = false,
  });

  @override
  State<_WorkCard> createState() => _WorkCardState();
}

class _WorkCardState extends State<_WorkCard> {
  bool _hovered = false;

  static const _categoryColors = {
    'training':      Color(0xFF4A9B6A),
    'technology':    Color(0xFF4A9FD4),
    'community':     Color(0xFFF5A623),
    'sustainability':Color(0xFF7FD17A),
    'innovation':    Color(0xFFE85D75),
  };

  Color _catColor(String cat) {
    final key = cat.toLowerCase();
    for (final k in _categoryColors.keys) {
      if (key.contains(k)) return _categoryColors[k]!;
    }
    return const Color(0xFF4A9B6A);
  }

  @override
  Widget build(BuildContext context) {
    final title    = (widget.project['title']       ?? '').toString();
    final desc     = (widget.project['description'] ?? '').toString();
    final category = (widget.project['category']    ?? '').toString();
    final imgUrl   = (widget.project['image']       ?? '').toString();
    final asset    = (widget.project['asset']       ?? '').toString();
    final catColor = _catColor(category);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_hovered ? 0.18 : 0.08),
              blurRadius: _hovered ? 28 : 14,
              offset: Offset(0, _hovered ? 10 : 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: AspectRatio(
            aspectRatio: widget.aspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ── Background image ──────────────────────────────────────
                _ImageBackground(imgUrl: imgUrl, asset: asset),

                // ── Gradient overlay ──────────────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(_hovered ? 0.75 : 0.55),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const [0.0, 0.65],
                    ),
                  ),
                ),

                // ── Content ───────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge top-left
                      if (category.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: catColor.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),

                      // Featured badge
                      if (widget.featured)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5A623).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.star_rounded, color: Colors.white, size: 12),
                            SizedBox(width: 5),
                            Text('Featured', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                          ]),
                        ),

                      // Bottom text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: widget.featured ? 20 : 16,
                              fontWeight: FontWeight.w800,
                              height: 1.3,
                            ),
                          ),
                          if (desc.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            AnimatedOpacity(
                              opacity: _hovered ? 1.0 : 0.75,
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                desc,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.88),
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                                maxLines: _hovered ? 3 : 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// IMAGE BACKGROUND — tries network URL, then local asset, then gradient
// ─────────────────────────────────────────────────────────────────────────────
class _ImageBackground extends StatelessWidget {
  final String imgUrl, asset;
  const _ImageBackground({required this.imgUrl, required this.asset});

  @override
  Widget build(BuildContext context) {
    if (imgUrl.isNotEmpty) {
      return Image.network(
        imgUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _assetOrGradient(),
      );
    }
    return _assetOrGradient();
  }

  Widget _assetOrGradient() {
    if (asset.isNotEmpty) {
      return Image.asset(
        asset,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _gradient(),
      );
    }
    return _gradient();
  }

  Widget _gradient() => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF1A3A2A), Color(0xFF2D5A3D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: const Center(
      child: Icon(Icons.work_outline_rounded, color: Colors.white24, size: 64),
    ),
  );
}