// lib/screens/team.dart
// Public-facing read-only Team Section — reads live from Firestore
// Do NOT use TeamSectionEditor here; that is admin-only.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeamSection extends StatefulWidget {
  const TeamSection({super.key});

  @override
  State<TeamSection> createState() => _TeamSectionState();
}

class _TeamSectionState extends State<TeamSection> {
  List<Map<String, dynamic>> _members = [];
  String _title    = 'Meet Our Team';
  String _subtitle = 'The passionate people behind Agreenect';
  bool _loading    = true;
  bool _visible    = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('sections')
          .doc('team_section')
          .get();
      if (doc.exists) {
        final d = doc.data()!;
        setState(() {
          _visible  = d['visible'] ?? true;
          _title    = d['title']    ?? 'Meet Our Team';
          _subtitle = d['subtitle'] ?? 'The passionate people behind Agreenect';
          _members  = List<Map<String, dynamic>>.from(d['members'] ?? []);
        });
      }
    } catch (_) {
      // Silently fail — section just won't show
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // If section is hidden in the admin, don't render it
    if (!_loading && !_visible) return const SizedBox.shrink();

    if (_loading) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator(color: Color(0xFF4A9B6A))),
      );
    }

    if (_members.isEmpty) return const SizedBox.shrink();

    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final isMobile  = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 72,
      ),
      color: const Color(0xFFF5F7F2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ─────────────────────────────────────────────────────
          Text(
            _title,
            style: TextStyle(
              fontSize: isDesktop ? 36 : 28,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1C2A1E),
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            _subtitle,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF8A9E88),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // ── Grid ───────────────────────────────────────────────────────
          _TeamGrid(members: _members, isDesktop: isDesktop, isMobile: isMobile),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Responsive grid
// ─────────────────────────────────────────────────────────────────────────────
class _TeamGrid extends StatelessWidget {
  final List<Map<String, dynamic>> members;
  final bool isDesktop, isMobile;
  const _TeamGrid({required this.members, required this.isDesktop, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final cols = isDesktop ? 3 : (isMobile ? 1 : 2);
    // Use Wrap so it doesn't need a fixed height
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: members.map((m) {
        final cardWidth = isDesktop
            ? (MediaQuery.of(context).size.width - 160 - 48) / cols
            : isMobile
                ? MediaQuery.of(context).size.width - 48
                : (MediaQuery.of(context).size.width - 48 - 24) / 2;
        return SizedBox(
          width: cardWidth.clamp(240.0, 360.0),
          child: _MemberCard(member: m),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual member card
// ─────────────────────────────────────────────────────────────────────────────
class _MemberCard extends StatelessWidget {
  final Map<String, dynamic> member;
  const _MemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    final name    = (member['name']  ?? '').toString();
    final role    = (member['role']  ?? '').toString();
    final bio     = (member['bio']   ?? '').toString();
    final imgUrl  = (member['image'] ?? '').toString();
    final initial = name.isNotEmpty ? name.trim()[0].toUpperCase() : '?';

    final social  = Map<String, dynamic>.from(member['social'] ?? {});
    final linkedin = (social['linkedin'] ?? '').toString();
    final email    = (social['email']    ?? '').toString();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar
            Container(
              width: 88, height: 88,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(44),
                border: Border.all(color: const Color(0xFFE8EDE5), width: 3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(41),
                child: imgUrl.isNotEmpty
                    ? Image.network(
                        imgUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _GradientInitial(initial),
                      )
                    : _GradientInitial(initial),
              ),
            ),
            const SizedBox(height: 16),

            // Name
            Text(
              name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1C2A1E),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),

            // Role badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF4A9B6A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                role,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A9B6A),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Bio
            if (bio.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                bio,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8A9E88),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            // Social links
            if (linkedin.isNotEmpty || email.isNotEmpty) ...[
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (linkedin.isNotEmpty)
                    _SocialBtn(icon: Icons.link_rounded, url: linkedin, tooltip: 'LinkedIn'),
                  if (linkedin.isNotEmpty && email.isNotEmpty)
                    const SizedBox(width: 8),
                  if (email.isNotEmpty)
                    _SocialBtn(icon: Icons.email_outlined, url: 'mailto:$email', tooltip: 'Email'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _GradientInitial extends StatelessWidget {
  final String letter;
  const _GradientInitial(this.letter);

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF2D5A3D), Color(0xFF4A9B6A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Center(
      child: Text(
        letter,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 32,
        ),
      ),
    ),
  );
}

class _SocialBtn extends StatelessWidget {
  final IconData icon; final String url, tooltip;
  const _SocialBtn({required this.icon, required this.url, required this.tooltip});

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        // Use url_launcher if added to pubspec, otherwise ignore
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7F2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE8EDE5)),
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF4A9B6A)),
      ),
    ),
  );
}