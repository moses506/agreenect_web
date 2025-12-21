// lib/screens/features_dynamic.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agreenect/utils/responsivenes.dart';

class DynamicFeaturesSection extends StatelessWidget {
  const DynamicFeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('sections')
          .doc('features_section')
          .snapshots(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: isMobile ? 60 : 80),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.green),
            ),
          );
        }

        // Error state
        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox.shrink(); // Hide section if error
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

        // Check if section is visible
        if (data['visible'] == false) {
          return const SizedBox.shrink();
        }

        final String title = data['title'] ?? 'Our Digital Solutions';
        final String? subtitle = data['subtitle'];
        final List<dynamic> items = data['items'] ?? [];

        return Container(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 60 : 80,
            horizontal: isMobile ? 20 : 40,
          ),
          color: Colors.grey[50],
          child: Column(
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
              if (subtitle != null) ...[
                const SizedBox(height: 16),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
              const SizedBox(height: 50),
              
              // Feature items
              LayoutBuilder(
                builder: (context, constraints) {
                  if (isMobile) {
                    return Column(
                      children: items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: _DynamicFeatureCard(
                            title: item['title'] ?? '',
                            description: item['description'] ?? '',
                            iconUrl: item['icon'],
                            colorHex: item['color'],
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Wrap(
                      spacing: 30,
                      runSpacing: 30,
                      alignment: WrapAlignment.center,
                      children: items.map((item) {
                        return _DynamicFeatureCard(
                          title: item['title'] ?? '',
                          description: item['description'] ?? '',
                          iconUrl: item['icon'],
                          colorHex: item['color'],
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DynamicFeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final String? iconUrl;
  final String? colorHex;

  const _DynamicFeatureCard({
    required this.title,
    required this.description,
    this.iconUrl,
    this.colorHex,
  });

  Color _getColor() {
    if (colorHex != null && colorHex!.isNotEmpty) {
      try {
        return Color(int.parse(colorHex!.replaceFirst('#', '0xFF')));
      } catch (e) {
        return Colors.green;
      }
    }
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final color = _getColor();

    return Container(
      width: isMobile ? double.infinity : 280,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: iconUrl != null && iconUrl!.isNotEmpty
                ? Image.network(
                    iconUrl!,
                    width: 40,
                    height: 40,
                    color: color,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.eco, size: 40, color: color);
                    },
                  )
                : Icon(Icons.eco, size: 40, color: color),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}