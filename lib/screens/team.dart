// lib/screens/team_dynamic.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agreenect/utils/responsivenes.dart';

class DynamicTeamSection extends StatelessWidget {
  const DynamicTeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('sections')
          .doc('team_section')
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

        final String title = data['title'] ?? 'Meet Our Team';
        final String? subtitle = data['subtitle'];
        final List<dynamic> members = data['members'] ?? [];

        return Container(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 60 : 80,
            horizontal: isMobile ? 20 : 40,
          ),
          child: Column(
            children: [
              Text(
                title,
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
              
              // Team members
              LayoutBuilder(
                builder: (context, constraints) {
                  if (isMobile) {
                    return _buildMobileLayout(members);
                  } else {
                    return _buildDesktopLayout(members);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(List<dynamic> members) {
    // Group members in pairs for mobile
    List<Widget> rows = [];
    for (int i = 0; i < members.length; i += 2) {
      rows.add(
        Row(
          children: [
            Expanded(
              child: _DynamicTeamCard(
                name: members[i]['name'] ?? '',
                role: members[i]['role'] ?? '',
                bio: members[i]['bio'],
                imageUrl: members[i]['image'],
                social: members[i]['social'],
              ),
            ),
            if (i + 1 < members.length) ...[
              const SizedBox(width: 15),
              Expanded(
                child: _DynamicTeamCard(
                  name: members[i + 1]['name'] ?? '',
                  role: members[i + 1]['role'] ?? '',
                  bio: members[i + 1]['bio'],
                  imageUrl: members[i + 1]['image'],
                  social: members[i + 1]['social'],
                ),
              ),
            ] else
              const Expanded(child: SizedBox()), // Empty space if odd number
          ],
        ),
      );
      
      if (i + 2 < members.length) {
        rows.add(const SizedBox(height: 20));
      }
    }
    return Column(children: rows);
  }

  Widget _buildDesktopLayout(List<dynamic> members) {
    return Wrap(
      spacing: 30,
      runSpacing: 30,
      alignment: WrapAlignment.center,
      children: members.map((member) {
        return _DynamicTeamCard(
          name: member['name'] ?? '',
          role: member['role'] ?? '',
          bio: member['bio'],
          imageUrl: member['image'],
          social: member['social'],
        );
      }).toList(),
    );
  }
}

class _DynamicTeamCard extends StatelessWidget {
  final String name;
  final String role;
  final String? bio;
  final String? imageUrl;
  final Map<String, dynamic>? social;

  const _DynamicTeamCard({
    required this.name,
    required this.role,
    this.bio,
    this.imageUrl,
    this.social,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Container(
      width: isMobile ? null : 250,
      padding: EdgeInsets.all(isMobile ? 15 : 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Image
          Container(
            width: isMobile ? 60 : 80,
            height: isMobile ? 60 : 80,
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(isMobile ? 30 : 40),
            ),
            child: ClipOval(
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? Image.network(
                      imageUrl!,
                      height: isMobile ? 60 : 80,
                      width: isMobile ? 60 : 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _defaultAvatar(isMobile);
                      },
                    )
                  : _defaultAvatar(isMobile),
            ),
          ),
          const SizedBox(height: 20),
          
          // Name
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 14 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          
          // Role
          Text(
            role,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 10 : 14,
              color: Colors.green[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          
          // Bio (if available)
          if (bio != null && bio!.isNotEmpty && !isMobile) ...[
            const SizedBox(height: 12),
            Text(
              bio!,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
          
          // Social Links (if available)
          if (social != null && !isMobile) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (social!['linkedin'] != null && social!['linkedin'].isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.business, size: 18, color: Colors.blue[700]),
                    onPressed: () {
                      // Open LinkedIn
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                if (social!['email'] != null && social!['email'].isNotEmpty) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.email, size: 18, color: Colors.green[700]),
                    onPressed: () {
                      // Open email
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _defaultAvatar(bool isMobile) {
    return Icon(
      Icons.person,
      size: isMobile ? 30 : 40,
      color: Colors.green[600],
    );
  }
}