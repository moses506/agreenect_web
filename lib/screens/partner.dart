// lib/screens/partner.dart
// Live PartnersSection — reads from Firestore partners_section

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agreenect/utils/responsivenes.dart';

class PartnersSection extends StatelessWidget {
  const PartnersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('sections')
          .doc('partners_section')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: isMobile ? 60 : 80),
            color: Colors.grey[50],
            child: const Center(child: CircularProgressIndicator(color: Colors.green)),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) return const SizedBox.shrink();
        final data = snapshot.data!.data() as Map<String, dynamic>;
        if (data['visible'] == false) return const SizedBox.shrink();

        final String title    = data['title']    ?? 'Our Partners';
        final String subtitle = data['subtitle'] ?? 'We collaborate with farmer cooperatives, NGOs, educational institutions, and government partners to amplify impact and deliver practical, scalable solutions.';
        final List<dynamic> logos = data['logos'] ?? [];

        return Container(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 60 : 80,
            horizontal: isMobile ? 20 : 40,
          ),
          color: Colors.grey[50],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 28 : 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, height: 1.6, color: Colors.grey[700]),
                ),
              ],
              const SizedBox(height: 50),

              logos.isEmpty
                  ? _FallbackPartners(isMobile: isMobile)
                  : Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      alignment: WrapAlignment.center,
                      children: logos.map((p) => _PartnerCard(partner: p, isMobile: isMobile)).toList(),
                    ),
            ],
          ),
        );
      },
    );
  }
}

// ── Partner card ──────────────────────────────────────────────────────────────
class _PartnerCard extends StatelessWidget {
  final dynamic partner; final bool isMobile;
  const _PartnerCard({required this.partner, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final name   = (partner['name']  ?? '').toString();
    final imgUrl = (partner['image'] ?? '').toString();

    return Container(
      width: isMobile ? 160 : 180,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green[200]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo image or initials fallback
          imgUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imgUrl,
                    height: 48, width: 100,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => _initial(name),
                  ),
                )
              : _initial(name),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.green[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _initial(String name) {
    final letter = name.isNotEmpty ? name[0].toUpperCase() : 'P';
    return Container(
      width: 48, height: 48,
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: Text(letter, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.green[700]))),
    );
  }
}

// ── Fallback when no partners in Firestore yet ────────────────────────────────
class _FallbackPartners extends StatelessWidget {
  final bool isMobile;
  const _FallbackPartners({required this.isMobile});

  static const _partners = [
    ('Agri Train Initiative\nZambia', 'assets/partners .jpeg'),
    ('Art For Climate',               'assets/partners/WhatsApp Image 2025-09-20 at 11.08.45.jpeg'),
    ('Ecoservannah\nInitiative',      'assets/partners/WhatsApp Image 2025-09-20 at 11.09.29.jpeg'),
  ];

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 24, runSpacing: 24, alignment: WrapAlignment.center,
    children: _partners.map((p) => _AssetPartnerCard(name: p.$1, asset: p.$2, isMobile: isMobile)).toList(),
  );
}

class _AssetPartnerCard extends StatelessWidget {
  final String name, asset; final bool isMobile;
  const _AssetPartnerCard({required this.name, required this.asset, required this.isMobile});
  @override
  Widget build(BuildContext context) => Container(
    width: isMobile ? 160 : 180, height: 140,
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.green[200]!)),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.asset(asset, height: 40,
        errorBuilder: (_, __, ___) => Icon(Icons.agriculture, size: 40, color: Colors.green[600])),
      const SizedBox(height: 10),
      Text(name, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.green[700])),
    ]),
  );
}