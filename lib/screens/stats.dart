// lib/screens/stats.dart
// Live StatsSection — reads from Firestore stats_section

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agreenect/utils/responsivenes.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('sections')
          .doc('stats_section')
          .snapshots(),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: isMobile ? 50 : 60),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A4439), Color(0xFF0F5A4A)],
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white54),
            ),
          );
        }

        // Hidden or missing
        if (!snapshot.hasData || !snapshot.data!.exists) return const SizedBox.shrink();
        final data = snapshot.data!.data() as Map<String, dynamic>;
        if (data['visible'] == false) return const SizedBox.shrink();

        final List<dynamic> stats = data['stats'] ?? [];
        if (stats.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 50 : 60,
            horizontal: isMobile ? 20 : 40,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0A4439), Color(0xFF0F5A4A)],
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: isMobile
              ? _MobileGrid(stats: stats)
              : _DesktopRow(stats: stats),
        );
      },
    );
  }
}

// ── Mobile: 2-column grid ─────────────────────────────────────────────────────
class _MobileGrid extends StatelessWidget {
  final List<dynamic> stats;
  const _MobileGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    // Pair items into rows of 2
    final rows = <List<dynamic>>[];
    for (var i = 0; i < stats.length; i += 2) {
      rows.add(stats.sublist(i, i + 2 > stats.length ? stats.length : i + 2));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows.asMap().entries.map((e) {
        final row = e.value;
        return Padding(
          padding: EdgeInsets.only(top: e.key == 0 ? 0 : 30),
          child: Row(
            children: row.map((s) => Expanded(child: _StatCard(stat: s))).toList()
              ..addAll(row.length == 1 ? [const Expanded(child: SizedBox())] : []),
          ),
        );
      }).toList(),
    );
  }
}

// ── Desktop: single row ───────────────────────────────────────────────────────
class _DesktopRow extends StatelessWidget {
  final List<dynamic> stats;
  const _DesktopRow({required this.stats});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: stats.map((s) => _StatCard(stat: s)).toList(),
  );
}

// ── Individual stat card ──────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final dynamic stat;
  const _StatCard({required this.stat});

  // Map common icon keywords to MaterialIcons
  static const _iconMap = <String, IconData>{
    'farmer':    Icons.agriculture,
    'farmers':   Icons.agriculture,
    'people':    Icons.people,
    'person':    Icons.person,
    'community': Icons.location_city,
    'communities': Icons.location_city,
    'hectare':   Icons.terrain,
    'land':      Icons.terrain,
    'solution':  Icons.lightbulb_outline,
    'tech':      Icons.devices,
    'year':      Icons.timeline,
    'impact':    Icons.trending_up,
    'partner':   Icons.handshake,
    'satisfy':   Icons.thumb_up,
    'satisfaction': Icons.thumb_up,
  };

  IconData _icon() {
    final raw = (stat['icon'] ?? '').toString().toLowerCase();
    // If it looks like an emoji, just return a fallback
    if (raw.runes.any((r) => r > 0x2000)) return Icons.bar_chart;
    for (final k in _iconMap.keys) {
      if (raw.contains(k)) return _iconMap[k]!;
    }
    // Also try matching against label
    final label = (stat['label'] ?? '').toString().toLowerCase();
    for (final k in _iconMap.keys) {
      if (label.contains(k)) return _iconMap[k]!;
    }
    return Icons.bar_chart;
  }

  String _emoji() {
    final raw = (stat['icon'] ?? '').toString();
    // If it contains an emoji character, return it
    if (raw.runes.any((r) => r > 0x2000)) return raw;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final emoji = _emoji();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon: use emoji if stored, otherwise fallback to material icon
        emoji.isNotEmpty
            ? Text(emoji, style: TextStyle(fontSize: isMobile ? 28 : 36))
            : Icon(_icon(),
                size: isMobile ? 30 : 40,
                color: Colors.white.withOpacity(0.8)),
        const SizedBox(height: 15),
        Text(
          (stat['value'] ?? '—').toString(),
          style: TextStyle(
            fontSize: isMobile ? 24 : 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          (stat['label'] ?? '').toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMobile ? 12 : 16,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}