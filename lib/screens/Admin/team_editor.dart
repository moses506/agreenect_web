// Replace the TeamSectionEditor placeholder in your admin panel with this

import 'package:agreenect/screens/Admin/admin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeamSectionEditor extends StatefulWidget {
  const TeamSectionEditor({super.key});

  @override
  State<TeamSectionEditor> createState() => _TeamSectionEditorState();
}

class _TeamSectionEditorState extends State<TeamSectionEditor> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  List<Map<String, dynamic>> _members = [];
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
        .doc('team_section')
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _titleController.text = data['title'] ?? 'Meet Our Team';
        _subtitleController.text = data['subtitle'] ?? '';
        _visible = data['visible'] ?? true;
        _members = List<Map<String, dynamic>>.from(data['members'] ?? []);
      });
    }
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('sections')
          .doc('team_section')
          .set({
        'order': 9,
        'visible': _visible,
        'title': _titleController.text,
        'subtitle': _subtitleController.text,
        'members': _members,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Team section saved!'),
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

  void _addMember() {
    setState(() {
      _members.add({
        'name': '',
        'role': '',
        'bio': '',
        'image': '',
        'social': {'linkedin': '', 'email': ''},
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
              'Team Members',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _addMember,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add Member'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Switch(
                  value: _visible,
                  onChanged: (value) => setState(() => _visible = value),
                  activeColor: Colors.green,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Title and Subtitle
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Section Title',
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
        ),
        const SizedBox(height: 32),

        Expanded(
          child: ListView.builder(
            itemCount: _members.length,
            itemBuilder: (context, index) {
              return _buildMemberCard(index);
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMemberCard(int index) {
    final member = _members[index];

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
                  'Team Member ${index + 1}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() => _members.removeAt(index));
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Member Image
            const Text('Profile Photo', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ImageUploadWidget(
              initialImageUrl: member['image'],
              storagePath: 'team',
              height: 200,
              onImageUploaded: (url) {
                setState(() => _members[index]['image'] = url);
              },
            ),
            const SizedBox(height: 16),

            // Name
            TextFormField(
              initialValue: member['name'],
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _members[index]['name'] = value;
              },
            ),
            const SizedBox(height: 12),

            // Role
            TextFormField(
              initialValue: member['role'],
              decoration: const InputDecoration(
                labelText: 'Role/Position',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _members[index]['role'] = value;
              },
            ),
            const SizedBox(height: 12),

            // Bio
            TextFormField(
              initialValue: member['bio'],
              decoration: const InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              onChanged: (value) {
                _members[index]['bio'] = value;
              },
            ),
            const SizedBox(height: 12),

            // LinkedIn
            TextFormField(
              initialValue: member['social']?['linkedin'] ?? '',
              decoration: const InputDecoration(
                labelText: 'LinkedIn URL',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
              onChanged: (value) {
                if (_members[index]['social'] == null) {
                  _members[index]['social'] = {};
                }
                _members[index]['social']['linkedin'] = value;
              },
            ),
            const SizedBox(height: 12),

            // Email
            TextFormField(
              initialValue: member['social']?['email'] ?? '',
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              onChanged: (value) {
                if (_members[index]['social'] == null) {
                  _members[index]['social'] = {};
                }
                _members[index]['social']['email'] = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }
}