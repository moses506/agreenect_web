// lib/admin/admin_panel_complete.dart
// Replace your entire admin panel file with this

import 'package:agreenect/screens/Admin/team_editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:typed_data';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int _selectedIndex = 0;

  final List<AdminSection> _sections = [
    AdminSection(
      id: 'hero_section',
      name: 'Hero Section',
      icon: Icons.photo_size_select_actual,
    ),
    AdminSection(id: 'features_section', name: 'Features', icon: Icons.star),
    AdminSection(id: 'about_section', name: 'About Us', icon: Icons.info),
    AdminSection(id: 'works_section', name: 'Our Works', icon: Icons.work),
    AdminSection(
      id: 'mission_section',
      name: 'Mission & Vision',
      icon: Icons.flag,
    ),
    AdminSection(id: 'impact_section', name: 'Impact', icon: Icons.trending_up),
    AdminSection(
      id: 'stats_section',
      name: 'Statistics',
      icon: Icons.bar_chart,
    ),
    AdminSection(
      id: 'achievements_section',
      name: 'Achievements',
      icon: Icons.emoji_events,
    ),
    AdminSection(id: 'team_section', name: 'Team', icon: Icons.people),
    AdminSection(
      id: 'partners_section',
      name: 'Partners',
      icon: Icons.handshake,
    ),
    AdminSection(
      id: 'contact_section',
      name: 'Contact',
      icon: Icons.contact_mail,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.eco, color: Colors.white, size: 32),
            const SizedBox(width: 16),
            const Text('Agreenect Admin Panel'),
          ],
        ),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.preview),
            tooltip: 'Preview Website',
            onPressed: () => Navigator.pushNamed(context, '/home'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) =>
                setState(() => _selectedIndex = index),
            labelType: NavigationRailLabelType.all,
            backgroundColor: Colors.grey[100],
            selectedIconTheme: const IconThemeData(color: Colors.green),
            selectedLabelTextStyle: const TextStyle(color: Colors.green),
            destinations: _sections
                .map(
                  (s) => NavigationRailDestination(
                    icon: Icon(s.icon),
                    label: Text(s.name),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: _buildEditor(_sections[_selectedIndex].id),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditor(String id) {
    switch (id) {
      case 'hero_section':
        return const HeroSectionEditor();
      case 'features_section':
        return const FeaturesSectionEditor();
      case 'about_section':
        return const AboutSectionEditor();
      case 'works_section':
        return const WorksSectionEditor();
      case 'mission_section':
        return const MissionSectionEditor();
      case 'impact_section':
        return const ImpactSectionEditor();
      case 'stats_section':
        return const StatsSectionEditor();
      case 'achievements_section':
        return const AchievementsSectionEditor();
      case 'team_section':
        return const TeamSectionEditor();
      case 'partners_section':
        return const PartnersSectionEditor();
      case 'contact_section':
        return const ContactSectionEditor();
      default:
        return Center(child: Text('Editor for $id'));
    }
  }
}

class AdminSection {
  final String id, name;
  final IconData icon;
  AdminSection({required this.id, required this.name, required this.icon});
}

// ============================================================================
// REUSABLE WIDGETS
// ============================================================================

class ImageUploadWidget extends StatefulWidget {
  final String? initialImageUrl;
  final String storagePath;
  final Function(String url) onImageUploaded;
  final double height;

  const ImageUploadWidget({
    super.key,
    this.initialImageUrl,
    required this.storagePath,
    required this.onImageUploaded,
    this.height = 200,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  String? _imageUrl;
  bool _isUploading = false;
  double _uploadProgress = 0;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.initialImageUrl;
  }

  Future<void> _uploadImage() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files == null || files.isEmpty) return;

      final file = files[0];
      final reader = html.FileReader();

      reader.readAsArrayBuffer(file);
      reader.onLoadEnd.listen((e) async {
        setState(() => _isUploading = true);

        try {
          final bytes = reader.result as Uint8List;
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final storageRef = FirebaseStorage.instance.ref().child(
            '${widget.storagePath}/${timestamp}_${file.name}',
          );

          final uploadTask = storageRef.putData(
            bytes,
            SettableMetadata(contentType: file.type),
          );

          uploadTask.snapshotEvents.listen((snapshot) {
            setState(
              () => _uploadProgress =
                  snapshot.bytesTransferred / snapshot.totalBytes,
            );
          });

          await uploadTask;
          final url = await storageRef.getDownloadURL();

          setState(() {
            _imageUrl = url;
            _isUploading = false;
            _uploadProgress = 0;
          });

          widget.onImageUploaded(url);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Image uploaded!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          setState(() {
            _isUploading = false;
            _uploadProgress = 0;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Upload failed: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_imageUrl != null)
          Container(
            height: widget.height,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Center(child: Icon(Icons.broken_image, size: 48)),
              ),
            ),
          ),
        const SizedBox(height: 12),
        if (_isUploading)
          Column(
            children: [
              LinearProgressIndicator(
                value: _uploadProgress,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              const SizedBox(height: 8),
              Text('Uploading: ${(_uploadProgress * 100).toStringAsFixed(0)}%'),
            ],
          )
        else
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _uploadImage,
                icon: const Icon(Icons.upload_file),
                label: Text(
                  _imageUrl == null ? 'Upload Image' : 'Change Image',
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              if (_imageUrl != null) ...[
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() => _imageUrl = null);
                    widget.onImageUploaded('');
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Remove'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ],
          ),
      ],
    );
  }
}

// ============================================================================
// SECTION EDITORS
// ============================================================================

class HeroSectionEditor extends StatefulWidget {
  const HeroSectionEditor({super.key});

  @override
  State<HeroSectionEditor> createState() => _HeroSectionEditorState();
}

class _HeroSectionEditorState extends State<HeroSectionEditor> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  String? _backgroundImageUrl;
  bool _isLoading = false;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final doc = await FirebaseFirestore.instance
        .collection('sections')
        .doc('hero_section')
        .get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _titleController.text = data['title'] ?? '';
        _subtitleController.text = data['subtitle'] ?? '';
        _backgroundImageUrl = data['backgroundImage'];
        _visible = data['visible'] ?? true;
      });
    }
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('sections')
          .doc('hero_section')
          .set({
            'order': 1,
            'visible': _visible,
            'title': _titleController.text,
            'subtitle': _subtitleController.text,
            'backgroundImage': _backgroundImageUrl ?? '',
            'overlayOpacity': 0.5,
            'ctaButtons': [],
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saved!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Edit Hero Section',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Switch(
              value: _visible,
              onChanged: (v) => setState(() => _visible = v),
              activeColor: Colors.green,
            ),
          ],
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _subtitleController,
          decoration: const InputDecoration(
            labelText: 'Subtitle',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 24),
        const Text(
          'Background Image',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ImageUploadWidget(
          initialImageUrl: _backgroundImageUrl,
          storagePath: 'hero',
          height: 300,
          onImageUploaded: (url) => setState(() => _backgroundImageUrl = url),
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _saveChanges,
            icon: const Icon(Icons.save),
            label: const Text('Save Changes'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }
}

// Features Section Editor
class FeaturesSectionEditor extends StatefulWidget {
  const FeaturesSectionEditor({super.key});

  @override
  State<FeaturesSectionEditor> createState() => _FeaturesSectionEditorState();
}

class _FeaturesSectionEditorState extends State<FeaturesSectionEditor> {
  List<Map<String, dynamic>> _features = [];
  bool _isLoading = false;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final doc = await FirebaseFirestore.instance
        .collection('sections')
        .doc('features_section')
        .get();
    if (doc.exists && doc.data()!['items'] != null) {
      setState(() {
        _features = List<Map<String, dynamic>>.from(doc.data()!['items']);
        _visible = doc.data()!['visible'] ?? true;
      });
    }
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('sections')
          .doc('features_section')
          .set({
            'order': 2,
            'visible': _visible,
            'title': 'Our Features',
            'items': _features,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Features saved!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _addFeature() {
    setState(() {
      _features.add({
        'title': '',
        'description': '',
        'icon': '',
        'color': '#4CAF50',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Edit Features',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _addFeature,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Feature'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Switch(
                  value: _visible,
                  onChanged: (v) => setState(() => _visible = v),
                  activeColor: Colors.green,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            itemCount: _features.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Feature ${index + 1}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                setState(() => _features.removeAt(index)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _features[index]['title'],
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => _features[index]['title'] = value,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        initialValue: _features[index]['description'],
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        onChanged: (value) =>
                            _features[index]['description'] = value,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        initialValue: _features[index]['icon'],
                        decoration: const InputDecoration(
                          labelText: 'Icon URL',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => _features[index]['icon'] = value,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _saveChanges,
            icon: const Icon(Icons.save),
            label: const Text('Save All Changes'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
          ),
        ),
      ],
    );
  }
}

// Placeholder editors (you can expand these similarly)
class AboutSectionEditor extends StatelessWidget {
  const AboutSectionEditor({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('About Section Editor - Coming Soon'));
}

class WorksSectionEditor extends StatelessWidget {
  const WorksSectionEditor({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Works Section Editor - Coming Soon'));
}

class MissionSectionEditor extends StatelessWidget {
  const MissionSectionEditor({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Mission Section Editor - Coming Soon'));
}

class ImpactSectionEditor extends StatelessWidget {
  const ImpactSectionEditor({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Impact Section Editor - Coming Soon'));
}

class StatsSectionEditor extends StatelessWidget {
  const StatsSectionEditor({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Stats Section Editor - Coming Soon'));
}

class AchievementsSectionEditor extends StatelessWidget {
  const AchievementsSectionEditor({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Achievements Section Editor - Coming Soon'));
}


class PartnersSectionEditor extends StatelessWidget {
  const PartnersSectionEditor({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Partners Section Editor - Coming Soon'));
}

class ContactSectionEditor extends StatelessWidget {
  const ContactSectionEditor({super.key});
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Contact Section Editor - Coming Soon'));
}
