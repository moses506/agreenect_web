// lib/screens/about_dynamic.dart
// Live DynamicAboutSection — reads from Firestore about_section

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agreenect/utils/responsivenes.dart';

class DynamicAboutSection extends StatelessWidget {
  const DynamicAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('sections')
          .doc('about_section')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: isMobile ? 60 : 80),
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFF4A9B6A)),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        if (data['visible'] == false) return const SizedBox.shrink();

        final String title       = data['title']   ?? 'About Agreenect';
        final String content     = data['content'] ?? '';
        final List<dynamic> stats  = data['stats']  ?? [];
        final List<dynamic> images = data['images'] ?? [];

        return _AboutLayout(
          title: title,
          content: content,
          stats: stats,
          images: images,
          isMobile: isMobile,
          isTablet: isTablet,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN LAYOUT
// ─────────────────────────────────────────────────────────────────────────────
class _AboutLayout extends StatelessWidget {
  final String title, content;
  final List<dynamic> stats, images;
  final bool isMobile, isTablet;

  const _AboutLayout({
    required this.title,
    required this.content,
    required this.stats,
    required this.images,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Subtle top accent stripe ──────────────────────────────────
          Container(
            height: 4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4A9B6A), Color(0xFF7FD17A), Color(0xFF4A9FD4)],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 56 : 80,
              horizontal: isMobile ? 24 : 80,
            ),
            child: (isMobile || isTablet)
                ? _MobileContent(
                    title: title, content: content,
                    stats: stats, images: images,
                    isMobile: isMobile,
                  )
                : _DesktopContent(
                    title: title, content: content,
                    stats: stats, images: images,
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DESKTOP — text left, image right
// ─────────────────────────────────────────────────────────────────────────────
class _DesktopContent extends StatelessWidget {
  final String title, content;
  final List<dynamic> stats, images;
  const _DesktopContent({
    required this.title, required this.content,
    required this.stats, required this.images,
  });

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 5,
        child: _TextBlock(title: title, content: content, stats: stats, isMobile: false),
      ),
      const SizedBox(width: 64),
      Expanded(
        flex: 4,
        child: _ImageBlock(images: images),
      ),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// MOBILE / TABLET — stacked
// ─────────────────────────────────────────────────────────────────────────────
class _MobileContent extends StatelessWidget {
  final String title, content;
  final List<dynamic> stats, images;
  final bool isMobile;
  const _MobileContent({
    required this.title, required this.content,
    required this.stats, required this.images,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      _TextBlock(title: title, content: content, stats: stats, isMobile: isMobile),
      const SizedBox(height: 40),
      _ImageBlock(images: images),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// TEXT BLOCK
// ─────────────────────────────────────────────────────────────────────────────
class _TextBlock extends StatelessWidget {
  final String title, content;
  final List<dynamic> stats;
  final bool isMobile;
  const _TextBlock({
    required this.title, required this.content,
    required this.stats, required this.isMobile,
  });

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
    children: [
      // ── Label pill ─────────────────────────────────────────────────────
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFF4A9B6A).withValues(alpha:  0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF4A9B6A).withValues(alpha:  0.25)),
        ),
        child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.eco_rounded, size: 13, color: Color(0xFF4A9B6A)),
          SizedBox(width: 6),
          Text(
            'WHO WE ARE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Color(0xFF4A9B6A),
              letterSpacing: 1.2,
            ),
          ),
        ]),
      ),
      const SizedBox(height: 18),

      // ── Title ──────────────────────────────────────────────────────────
      Text(
        title,
        textAlign: isMobile ? TextAlign.center : TextAlign.left,
        style: TextStyle(
          fontSize: isMobile ? 28 : 38,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF1C2A1E),
          height: 1.2,
          letterSpacing: -0.5,
        ),
      ),
      const SizedBox(height: 6),

      // ── Underline accent ───────────────────────────────────────────────
      if (!isMobile)
        Container(
          width: 56,
          height: 4,
          margin: const EdgeInsets.only(top: 10, bottom: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF4A9B6A),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      const SizedBox(height: 20),

      // ── Body text ──────────────────────────────────────────────────────
      if (content.isNotEmpty)
        Text(
          content,
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: isMobile ? 15 : 17,
            height: 1.75,
            color: const Color(0xFF4A5E48),
          ),
        ),

      // ── Stats ──────────────────────────────────────────────────────────
      if (stats.isNotEmpty) ...[
        const SizedBox(height: 36),
        isMobile
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: stats.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _StatCard(value: (s['value'] ?? '').toString(), label: (s['label'] ?? '').toString()),
                )).toList(),
              )
            : Wrap(
                spacing: 16,
                runSpacing: 16,
                children: stats.map((s) => _StatCard(
                  value: (s['value'] ?? '').toString(),
                  label: (s['label'] ?? '').toString(),
                )).toList(),
              ),
      ],
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// IMAGE BLOCK
// ─────────────────────────────────────────────────────────────────────────────
class _ImageBlock extends StatelessWidget {
  final List<dynamic> images;
  const _ImageBlock({required this.images});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final imgUrl   = (images.isNotEmpty && images[0] != null)
        ? images[0].toString()
        : '';

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main image
        Container(
          height: isMobile ? 260 : 420,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4A9B6A).withValues(alpha:  0.15),
                blurRadius: 40,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: imgUrl.isNotEmpty
                ? Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
        ),

        // Floating stat badge — bottom-left
        Positioned(
          bottom: -18,
          left: isMobile ? 16 : 24,
          child: _FloatingBadge(
            icon: Icons.eco_rounded,
            label: 'Since 2022',
            color: const Color(0xFF4A9B6A),
          ),
        ),

        // Floating badge — top-right
        Positioned(
          top: -14,
          right: isMobile ? 16 : 24,
          child: _FloatingBadge(
            icon: Icons.location_on_rounded,
            label: 'Zambia',
            color: const Color(0xFF4A9FD4),
          ),
        ),
      ],
    );
  }

  Widget _placeholder() => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF1A3A2A), Color(0xFF2D5A3D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.groups_rounded, size: 72, color: Colors.white.withValues(alpha:  0.3)),
        const SizedBox(height: 16),
        Text(
          'Community Impact',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha:  0.5),
          ),
        ),
      ],
    ),
  );
}

class _FloatingBadge extends StatelessWidget {
  final IconData icon; final String label; final Color color;
  const _FloatingBadge({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha:  0.2),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
      border: Border.all(color: color.withValues(alpha:  0.2)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(color: color.withValues(alpha:  0.12), shape: BoxShape.circle),
        child: Icon(icon, size: 13, color: color),
      ),
      const SizedBox(width: 7),
      Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
    ]),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// STAT CARD
// ─────────────────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String value, label;
  const _StatCard({required this.value, required this.label});

  static const _palette = [
    Color(0xFF4A9B6A), Color(0xFF4A9FD4),
    Color(0xFFF5A623), Color(0xFFE85D75),
  ];

  // Pick a consistent colour based on label hash
  Color _color() => _palette[label.length % _palette.length];

  @override
  Widget build(BuildContext context) {
    final col = _color();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: col.withValues(alpha:  0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: col.withValues(alpha:  0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: col,
              height: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: col.withValues(alpha:  0.8),
            ),
          ),
        ],
      ),
    );
  }
}