// Save this as: lib/admin/seed_data.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// This is the WIDGET you use in routes
class SeedDataPage extends StatefulWidget {
  const SeedDataPage({super.key});

  @override
  State<SeedDataPage> createState() => _SeedDataPageState();
}

class _SeedDataPageState extends State<SeedDataPage> {
  bool _isSeeding = false;
  String _status = 'Ready to seed database';
  final List<String> _logs = [];

  // ── Admin credentials (change before going live!) ──────────────────────────
  static const String _adminEmail = 'admin@agreenect.com';
  static const String _adminPassword = 'Admin@123'; // Change this to a strong password before going live!
  // ──────────────────────────────────────────────────────────────────────────

  void _addLog(String message) {
    setState(() {
      _logs.add(message);
      _status = message;
    });
  }

  Future<void> _seedDatabase() async {
    setState(() {
      _isSeeding = true;
      _logs.clear();
    });

    final firestore = FirebaseFirestore.instance;

    try {
      _addLog('🌱 Starting database seed...');

      // ── Admin Credentials ─────────────────────────────────────────────────
      _addLog('Creating admin credentials...');
      await firestore.collection('admin').doc('credentials').set({
        'email': _adminEmail,
        'password': _adminPassword,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _addLog('✅ Admin credentials created (email: $_adminEmail)');
      // ─────────────────────────────────────────────────────────────────────

      // Hero Section
      _addLog('Creating hero_section...');
      await firestore.collection('sections').doc('hero_section').set({
        'order': 1,
        'visible': true,
        'title': 'Transforming Agriculture in Zambia',
        'subtitle': 'Connecting farmers with modern technology and sustainable practices',
        'backgroundImage': 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=1920',
        'overlayOpacity': 0.5,
        'ctaButtons': [
          {'text': 'Learn More', 'link': '#about', 'style': 'primary'},
          {'text': 'Contact Us', 'link': '#contact', 'style': 'secondary'},
        ],
      });
      _addLog('✅ Hero section created');

      // Features Section
      _addLog('Creating features_section...');
      await firestore.collection('sections').doc('features_section').set({
        'order': 2,
        'visible': true,
        'title': 'Our Features',
        'subtitle': 'What makes Agreenect different',
        'items': [
          {
            'title': 'Smart Farming Solutions',
            'description': 'IoT-enabled devices to monitor and optimize farm conditions',
            'icon': 'https://cdn-icons-png.flaticon.com/512/3050/3050411.png',
          },
          {
            'title': 'Market Access',
            'description': 'Direct connection between farmers and buyers',
            'icon': 'https://cdn-icons-png.flaticon.com/512/2936/2936886.png',
          },
          {
            'title': 'Training & Support',
            'description': 'Continuous education on modern farming techniques',
            'icon': 'https://cdn-icons-png.flaticon.com/512/3079/3079652.png',
          },
          {
            'title': 'Data Analytics',
            'description': 'Make informed decisions with real-time data insights',
            'icon': 'https://cdn-icons-png.flaticon.com/512/2920/2920277.png',
          },
        ],
      });
      _addLog('✅ Features section created');

      // About Section
      _addLog('Creating about_section...');
      await firestore.collection('sections').doc('about_section').set({
        'order': 3,
        'visible': true,
        'title': 'About Agreenect',
        'content': '''Agreenect is a pioneering agricultural technology company based in Lusaka, Zambia. We are dedicated to revolutionizing farming practices through innovation and technology.

Our mission is to empower smallholder farmers with the tools and knowledge they need to increase productivity, improve sustainability, and enhance their livelihoods.

Since our inception, we have worked tirelessly to bridge the gap between traditional farming methods and modern agricultural technology.''',
        'images': [
          'https://images.unsplash.com/photo-1464226184884-fa280b87c399?w=800',
          'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=800',
        ],
        'stats': [
          {'label': 'Years of Experience', 'value': '5+'},
          {'label': 'Farmers Reached', 'value': '10,000+'},
          {'label': 'Hectares Impacted', 'value': '50,000+'},
          {'label': 'Technology Solutions', 'value': '15+'},
        ],
      });
      _addLog('✅ About section created');

      // Works Section
      _addLog('Creating works_section...');
      await firestore.collection('sections').doc('works_section').set({
        'order': 4,
        'visible': true,
        'title': 'Our Projects',
        'subtitle': 'Innovative solutions making a difference',
        'projects': [
          {
            'title': 'Smart Irrigation System',
            'description': 'Automated irrigation systems that save water and increase crop yields',
            'image': 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=600',
            'category': 'Technology',
          },
          {
            'title': 'Mobile Market Platform',
            'description': 'Connecting farmers directly with buyers through mobile technology',
            'image': 'https://images.unsplash.com/photo-1556740738-b6a63e27c4df?w=600',
            'category': 'Digital',
          },
        ],
      });
      _addLog('✅ Works section created');

      // Mission Section
      _addLog('Creating mission_section...');
      await firestore.collection('sections').doc('mission_section').set({
        'order': 5,
        'visible': true,
        'mission': 'To empower smallholder farmers through innovative technology and sustainable agricultural practices.',
        'vision': 'A thriving agricultural sector where every farmer has access to modern tools and markets.',
        'values': [
          {
            'title': 'Innovation',
            'description': 'Constantly seeking new solutions',
            'icon': '💡',
          },
          {
            'title': 'Sustainability',
            'description': 'Protecting our environment',
            'icon': '🌱',
          },
          {
            'title': 'Empowerment',
            'description': 'Giving farmers the tools to succeed',
            'icon': '💪',
          },
        ],
      });
      _addLog('✅ Mission section created');

      // Impact Section
      _addLog('Creating impact_section...');
      await firestore.collection('sections').doc('impact_section').set({
        'order': 6,
        'visible': true,
        'title': 'Our Impact',
        'subtitle': 'Making a real difference',
        'stories': [
          {
            'farmer': 'John Mwale',
            'location': 'Chongwe District',
            'story': 'My maize yield increased by 40% using smart irrigation',
            'image': 'https://i.pravatar.cc/300?img=12',
          },
        ],
      });
      _addLog('✅ Impact section created');

      // Stats Section
      _addLog('Creating stats_section...');
      await firestore.collection('sections').doc('stats_section').set({
        'order': 7,
        'visible': true,
        'stats': [
          {'label': 'Farmers Impacted', 'value': '10,000+', 'icon': '👨‍🌾'},
          {'label': 'Hectares Covered', 'value': '50,000+', 'icon': '🌾'},
          {'label': 'Technology Solutions', 'value': '15+', 'icon': '💡'},
          {'label': 'Partner Organizations', 'value': '25+', 'icon': '🤝'},
        ],
        'backgroundColor': '#f8f9fa',
      });
      _addLog('✅ Stats section created');

      // Achievements Section
      _addLog('Creating achievements_section...');
      await firestore.collection('sections').doc('achievements_section').set({
        'order': 8,
        'visible': true,
        'title': 'Our Achievements',
        'achievements': [
          {
            'year': '2024',
            'title': 'National Agriculture Innovation Award',
            'description': 'Recognized for outstanding contribution',
          },
          {
            'year': '2023',
            'title': '10,000 Farmers Milestone',
            'description': 'Reached 10,000 farmers across 5 provinces',
          },
        ],
      });
      _addLog('✅ Achievements section created');

      // Team Section
      _addLog('Creating team_section...');
      await firestore.collection('sections').doc('team_section').set({
        'order': 9,
        'visible': true,
        'title': 'Meet Our Team',
        'subtitle': 'The people behind Agreenect\'s success',
        'members': [
          {
            'name': 'David Chapoloko',
            'role': 'CEO & Founder',
            'bio': 'Visionary leader driving agricultural innovation in Zambia',
            'image': 'https://firebasestorage.googleapis.com/v0/b/agreenect-d4c47.appspot.com/o/team%2Fdavid.jpg?alt=media',
            'social': {
              'linkedin': 'https://linkedin.com',
              'email': 'david@agreenect.com',
            },
          },
          {
            'name': 'Contance Mubanga',
            'role': 'Financial & Admin Lead',
            'bio': 'Expert in financial management and administrative operations',
            'image': 'https://firebasestorage.googleapis.com/v0/b/agreenect-d4c47.appspot.com/o/team%2Fcontance.jpg?alt=media',
            'social': {
              'linkedin': 'https://linkedin.com',
              'email': 'contance@agreenect.com',
            },
          },
          {
            'name': 'Moses Mpande',
            'role': 'Technical/ Developer',
            'bio': 'Tech innovator building digital solutions for agriculture',
            'image': 'https://firebasestorage.googleapis.com/v0/b/agreenect-d4c47.appspot.com/o/team%2Fmoses.jpg?alt=media',
            'social': {
              'linkedin': 'https://linkedin.com',
              'email': 'moses@agreenect.com',
            },
          },
          {
            'name': 'Kunda Nyirongo',
            'role': 'Business Development',
            'bio': 'Strategic partnerships and business growth specialist',
            'image': 'https://firebasestorage.googleapis.com/v0/b/agreenect-d4c47.appspot.com/o/team%2Fkunda.jpg?alt=media',
            'social': {
              'linkedin': 'https://linkedin.com',
              'email': 'kunda@agreenect.com',
            },
          },
          {
            'name': 'Kena Chibuye',
            'role': 'Partnership & Outreach',
            'bio': 'Building connections with farmers and stakeholders',
            'image': 'https://firebasestorage.googleapis.com/v0/b/agreenect-d4c47.appspot.com/o/team%2Fkena.jpg?alt=media',
            'social': {
              'linkedin': 'https://linkedin.com',
              'email': 'kena@agreenect.com',
            },
          },
          {
            'name': 'Celcilia Kuasa',
            'role': 'Procurement Officer',
            'bio': 'Managing resources and procurement operations',
            'image': 'https://firebasestorage.googleapis.com/v0/b/agreenect-d4c47.appspot.com/o/team%2Fcelcilia.jpg?alt=media',
            'social': {
              'linkedin': 'https://linkedin.com',
              'email': 'celcilia@agreenect.com',
            },
          },
        ],
      });
      _addLog('✅ Team section created');

      // Partners Section
      _addLog('Creating partners_section...');
      await firestore.collection('sections').doc('partners_section').set({
        'order': 10,
        'visible': true,
        'title': 'Our Partners',
        'subtitle': 'Working together for transformation',
        'logos': [
          {
            'name': 'Ministry of Agriculture',
            'image': 'https://via.placeholder.com/200x100?text=Ministry',
            'link': '#',
          },
        ],
      });
      _addLog('✅ Partners section created');

      // Contact Section
      _addLog('Creating contact_section...');
      await firestore.collection('sections').doc('contact_section').set({
        'order': 11,
        'visible': true,
        'title': 'Get In Touch',
        'subtitle': 'We\'d love to hear from you',
        'email': 'info@agreenect.com',
        'phone': '+260 XXX XXX XXX',
        'address': 'Lusaka, Zambia',
        'socialLinks': {
          'facebook': 'https://facebook.com/agreenect',
          'twitter': 'https://twitter.com/agreenect',
          'linkedin': 'https://linkedin.com/company/agreenect',
          'instagram': 'https://instagram.com/agreenect',
        },
        'mapCoordinates': {'lat': -15.4167, 'lng': 28.2833},
      });
      _addLog('✅ Contact section created');

      // Footer
      _addLog('Creating footer...');
      await firestore.collection('sections').doc('footer').set({
        'order': 12,
        'visible': true,
        'copyrightText': '© 2024 Agreenect. All rights reserved.',
        'quickLinks': [
          {'title': 'About Us', 'link': '#about'},
          {'title': 'Our Works', 'link': '#works'},
          {'title': 'Contact', 'link': '#contact'},
        ],
        'socialLinks': [
          {'platform': 'facebook', 'url': 'https://facebook.com/agreenect'},
          {'platform': 'twitter', 'url': 'https://twitter.com/agreenect'},
        ],
      });
      _addLog('✅ Footer created');

      // Navigation Config
      _addLog('Creating navigation config...');
      await firestore.collection('website_config').doc('navigation').set({
        'menuItems': [
          'Home',
          'About Us',
          'Our Works',
          'Impact',
          'Team',
          'Contact',
        ],
        'logo': 'https://via.placeholder.com/150x50?text=Agreenect',
        'ctaButton': {'text': 'Get Started', 'link': '#contact'},
      });
      _addLog('✅ Navigation config created');

      _addLog('🎉 Database seeded successfully!');

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('✅ Success!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your database has been seeded successfully!'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha:  0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withValues(alpha:  0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🔐 Admin Login Credentials',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text('Email: $_adminEmail'),
                      Text('Password: $_adminPassword'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '⚠️ Please change your password after first login.',
                  style: TextStyle(color: Colors.orange, fontSize: 12),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      _addLog('❌ Error: $e');
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('❌ Error'),
            content: Text('Failed: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } finally {
      setState(() => _isSeeding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seed Database'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_upload, size: 80, color: Colors.green),
              const SizedBox(height: 24),
              const Text(
                'Initialize Agreenect Database',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'This will create all sections + admin credentials. Only run once!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha:  0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withValues(alpha:  0.2)),
                ),
                child: Text(
                  '🔐 Admin: $_adminEmail',
                  style: const TextStyle(fontSize: 13, color: Colors.green),
                ),
              ),
              const SizedBox(height: 32),

              if (_isSeeding)
                Column(
                  children: [
                    const CircularProgressIndicator(color: Colors.green),
                    const SizedBox(height: 16),
                    Text(_status, textAlign: TextAlign.center),
                  ],
                )
              else
                ElevatedButton.icon(
                  onPressed: _seedDatabase,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Seed Database'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                  ),
                ),

              const SizedBox(height: 32),

              if (_logs.isNotEmpty)
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      itemCount: _logs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            _logs[index],
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}