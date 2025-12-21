// lib/screens/about_dynamic.dart
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
            child: const Center(
              child: CircularProgressIndicator(color: Colors.green),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

        if (data['visible'] == false) {
          return const SizedBox.shrink();
        }

        final String title = data['title'] ?? 'About AgreeNect';
        final String content = data['content'] ?? '';
        final List<dynamic> stats = data['stats'] ?? [];
        final List<dynamic> images = data['images'] ?? [];

        return Container(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 60 : 80,
            horizontal: isMobile ? 20 : 40,
          ),
          child: (isMobile || isTablet)
              ? Column(
                  children: [
                    _AboutContent(
                      title: title,
                      content: content,
                      stats: stats,
                    ),
                    const SizedBox(height: 40),
                    _AboutImage(images: images),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _AboutContent(
                        title: title,
                        content: content,
                        stats: stats,
                      ),
                    ),
                    const SizedBox(width: 60),
                    Expanded(child: _AboutImage(images: images)),
                  ],
                ),
        );
      },
    );
  }
}

class _AboutContent extends StatelessWidget {
  final String title;
  final String content;
  final List<dynamic> stats;

  const _AboutContent({
    required this.title,
    required this.content,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: isMobile ? 28 : 36,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        const SizedBox(height: 30),
        Text(
          content,
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: 18,
            height: 1.6,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 30),
        
        // Stats
        if (stats.isNotEmpty)
          isMobile
              ? Column(
                  children: stats.map((stat) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _StatCard(
                        number: stat['value'] ?? '',
                        label: stat['label'] ?? '',
                      ),
                    );
                  }).toList(),
                )
              : Wrap(
                  spacing: 30,
                  runSpacing: 20,
                  children: stats.map((stat) {
                    return _StatCard(
                      number: stat['value'] ?? '',
                      label: stat['label'] ?? '',
                    );
                  }).toList(),
                ),
      ],
    );
  }
}

class _AboutImage extends StatelessWidget {
  final List<dynamic> images;

  const _AboutImage({required this.images});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.green[100],
      ),
      child: images.isNotEmpty && images[0] != null && images[0].isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                images[0],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _defaultImage();
                },
              ),
            )
          : _defaultImage(),
    );
  }

  Widget _defaultImage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.groups, size: 80, color: Colors.green[600]),
          const SizedBox(height: 20),
          Text(
            'Community Impact',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String number;
  final String label;

  const _StatCard({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Container(
      width: isMobile ? 200 : null,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.green[600],
            ),
          ),
        ],
      ),
    );
  }
}