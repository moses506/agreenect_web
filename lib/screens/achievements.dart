// lib/screens/achievements_dynamic.dart
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

        final String title = data['title'] ?? 'Awards & Recognition';
        final String? subtitle = data['subtitle'];
        final List<dynamic> achievements = data['achievements'] ?? [];

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

              // Achievements list
              if (achievements.isNotEmpty)
                Column(
                  children: achievements.map((achievement) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: _DynamicAchievementCard(
                        year: achievement['year'] ?? '',
                        title: achievement['title'] ?? '',
                        description: achievement['description'] ?? '',
                        image: achievement['image'],
                        color: achievement['color'],
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _DynamicAchievementCard extends StatelessWidget {
  final String year;
  final String title;
  final String description;
  final String? image;
  final String? color;

  const _DynamicAchievementCard({
    required this.year,
    required this.title,
    required this.description,
    this.image,
    this.color,
  });

  Color _getColor() {
    if (color != null && color!.isNotEmpty) {
      try {
        return Color(int.parse(color!.replaceFirst('#', '0xFF')));
      } catch (e) {
        return Colors.amber;
      }
    }
    return Colors.amber;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final cardColor = _getColor();

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: isMobile ? double.infinity : 700,
      ),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              children: [
                _buildImage(isMobile, cardColor),
                const SizedBox(height: 20),
                _buildContent(isMobile),
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildImage(isMobile, cardColor),
                ),
                const SizedBox(width: 30),
                Expanded(
                  flex: 3,
                  child: _buildContent(isMobile),
                ),
              ],
            ),
    );
  }

  Widget _buildImage(bool isMobile, Color cardColor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: image != null && image!.isNotEmpty
          ? Image.network(
              image!,
              height: isMobile ? 150 : 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _defaultImage(isMobile, cardColor);
              },
            )
          : _defaultImage(isMobile, cardColor),
    );
  }

  Widget _defaultImage(bool isMobile, Color cardColor) {
    return Container(
      height: isMobile ? 150 : 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.emoji_events,
        size: isMobile ? 60 : 80,
        color: cardColor,
      ),
    );
  }

  Widget _buildContent(bool isMobile) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Year badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            year,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Title
        Text(
          title,
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: isMobile ? 18 : 22,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        
        // Description
        Text(
          description,
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
      ],
    );
  }
}