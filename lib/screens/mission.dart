// lib/screens/mission.dart
// Live MissionVisionValues — reads from Firestore mission_section

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agreenect/utils/responsivenes.dart';

class MissionVisionValues extends StatelessWidget {
  const MissionVisionValues({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('sections')
          .doc('mission_section')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: isMobile ? 60 : 80),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.green[50]!, Colors.blue[50]!]),
            ),
            child: const Center(child: CircularProgressIndicator(color: Colors.green)),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) return const SizedBox.shrink();
        final data = snapshot.data!.data() as Map<String, dynamic>;
        if (data['visible'] == false) return const SizedBox.shrink();

        final String mission = data['mission'] ?? '';
        final String vision  = data['vision']  ?? '';
        final List<dynamic> values = data['values'] ?? [];

        return Container(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 60 : 80,
            horizontal: isMobile ? 20 : 40,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[50]!, Colors.blue[50]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Our Foundation',
                style: TextStyle(
                  fontSize: isMobile ? 28 : 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              const SizedBox(height: 60),

              // Mission + Vision cards
              isMobile
                  ? Column(mainAxisSize: MainAxisSize.min, children: [
                      if (mission.isNotEmpty) _MVCard(icon: Icons.rocket_launch, title: 'Mission', content: mission, color: Colors.blue),
                      if (mission.isNotEmpty && vision.isNotEmpty) const SizedBox(height: 30),
                      if (vision.isNotEmpty)  _MVCard(icon: Icons.visibility,    title: 'Vision',  content: vision,  color: Colors.green),
                    ])
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (mission.isNotEmpty) Expanded(child: _MVCard(icon: Icons.rocket_launch, title: 'Mission', content: mission, color: Colors.blue)),
                        if (mission.isNotEmpty && vision.isNotEmpty) const SizedBox(width: 30),
                        if (vision.isNotEmpty)  Expanded(child: _MVCard(icon: Icons.visibility,    title: 'Vision',  content: vision,  color: Colors.green)),
                      ],
                    ),

              // Core values
              if (values.isNotEmpty) ...[
                const SizedBox(height: 40),
                _ValuesCard(values: values, isMobile: isMobile),
              ],
            ],
          ),
        );
      },
    );
  }
}

// ── Mission / Vision card ─────────────────────────────────────────────────────
class _MVCard extends StatelessWidget {
  final IconData icon; final String title, content; final Color color;
  const _MVCard({required this.icon, required this.title, required this.content, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(30),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10))],
    ),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(50)),
        child: Icon(icon, size: 35, color: color),
      ),
      const SizedBox(height: 20),
      Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[800])),
      const SizedBox(height: 15),
      Text(content, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, height: 1.6, color: Colors.grey[600])),
    ]),
  );
}

// ── Core values grid ──────────────────────────────────────────────────────────
class _ValuesCard extends StatelessWidget {
  final List<dynamic> values; final bool isMobile;
  const _ValuesCard({required this.values, required this.isMobile});

  static const _colors = [Colors.orange, Colors.purple, Colors.teal, Colors.pink, Colors.indigo];

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(30),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10))],
    ),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(50)),
        child: const Icon(Icons.favorite, size: 35, color: Colors.orange),
      ),
      const SizedBox(height: 20),
      Text('Values', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[800])),
      const SizedBox(height: 20),
      Wrap(
        spacing: 12, runSpacing: 12, alignment: WrapAlignment.center,
        children: values.asMap().entries.map((e) {
          final v     = e.value;
          final color = _colors[e.key % _colors.length];
          final emoji = (v['icon'] ?? '').toString();
          final title = (v['title'] ?? '').toString();
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: color.withOpacity(0.25)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              if (emoji.isNotEmpty) ...[Text(emoji, style: const TextStyle(fontSize: 16)), const SizedBox(width: 6)],
              Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color)),
            ]),
          );
        }).toList(),
      ),
    ]),
  );
}