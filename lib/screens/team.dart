// Enhanced Professional Team Section Editor - Web Optimized
// This version uses native HTML file input for reliable web uploads
// Save as: lib/screens/Admin/sections/team_section_editor.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class TeamSectionEditor extends StatefulWidget {
  const TeamSectionEditor({super.key});

  @override
  State<TeamSectionEditor> createState() => _TeamSectionEditorState();
}

class _TeamSectionEditorState extends State<TeamSectionEditor> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _members = [];
  bool _isLoading = false;
  bool _visible = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
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
    } catch (e) {
      _showSnackBar('Error loading data: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Please fill in all required fields', isError: true);
      return;
    }

    setState(() => _isSaving = true);
    try {
      await FirebaseFirestore.instance
          .collection('sections')
          .doc('team_section')
          .set({
        'order': 9,
        'visible': _visible,
        'title': _titleController.text.trim(),
        'subtitle': _subtitleController.text.trim(),
        'members': _members,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      _showSnackBar('✓ Team section saved successfully!');
    } catch (e) {
      _showSnackBar('Failed to save: $e', isError: true);
    } finally {
      setState(() => _isSaving = false);
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

  void _removeMember(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Team Member'),
        content: Text(
          'Are you sure you want to remove ${_members[index]['name'].isEmpty ? 'this member' : _members[index]['name']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _members.removeAt(index));
              Navigator.pop(context);
              _showSnackBar('Member removed');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red[700] : Colors.green[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        return Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(isMobile ? 12 : 24),
                  children: [
                    _buildHeader(isMobile),
                    SizedBox(height: isMobile ? 16 : 24),
                    _buildSectionSettings(isMobile),
                    SizedBox(height: isMobile ? 16 : 24),
                    if (_members.isEmpty)
                      _buildEmptyState(isMobile)
                    else
                      ..._members.asMap().entries.map(
                            (entry) => _buildMemberCard(entry.key, isMobile),
                          ),
                    SizedBox(height: isMobile ? 80 : 100),
                  ],
                ),
              ),
              _buildBottomActionBar(isMobile),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[700]!, Colors.green[500]!],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.people, size: 24, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Team Section',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_members.length} member${_members.length != 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    Row(
                      children: [
                        Switch(
                          value: _visible,
                          onChanged: (value) => setState(() => _visible = value),
                          activeColor: Colors.white,
                          activeTrackColor: Colors.green[300],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _visible ? 'Visible' : 'Hidden',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.people, size: 32, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Team Section',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${_members.length} team member${_members.length != 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _visible,
                  onChanged: (value) => setState(() => _visible = value),
                  activeColor: Colors.white,
                  activeTrackColor: Colors.green[300],
                ),
                const SizedBox(width: 8),
                Text(
                  _visible ? 'Visible' : 'Hidden',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSectionSettings(bool isMobile) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.settings, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Section Settings',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 16 : 20),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Section Title *',
                hintText: 'e.g., Meet Our Team',
                prefixIcon: const Icon(Icons.title, color: Colors.green),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
              ),
              validator: (value) =>
                  value?.trim().isEmpty ?? true ? 'Title is required' : null,
            ),
            SizedBox(height: isMobile ? 12 : 16),
            TextFormField(
              controller: _subtitleController,
              decoration: InputDecoration(
                labelText: 'Subtitle',
                hintText: 'e.g., The people behind Agreenect\'s success',
                prefixIcon: const Icon(Icons.subtitles, color: Colors.green),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isMobile) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 80),
        child: Column(
          children: [
            Icon(Icons.people_outline, size: isMobile ? 60 : 80, color: Colors.grey[400]),
            SizedBox(height: isMobile ? 12 : 16),
            Text(
              'No team members yet',
              style: TextStyle(
                fontSize: isMobile ? 18 : 20,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: isMobile ? 6 : 8),
            Text(
              'Click "Add Team Member" to get started',
              style: TextStyle(fontSize: isMobile ? 13 : 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isMobile ? 20 : 24),
            ElevatedButton.icon(
              onPressed: _addMember,
              icon: const Icon(Icons.person_add),
              label: const Text('Add First Team Member'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 32,
                  vertical: isMobile ? 12 : 16,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard(int index, bool isMobile) {
    final member = _members[index];
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: isMobile ? 12 : 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isMobile ? 6 : 8),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '#${index + 1}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                      fontSize: isMobile ? 12 : 14,
                    ),
                  ),
                ),
                SizedBox(width: isMobile ? 8 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member['name'].isEmpty ? 'New Team Member' : member['name'],
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (member['role'].isNotEmpty)
                        Text(
                          member['role'],
                          style: TextStyle(
                            fontSize: isMobile ? 12 : 14,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _removeMember(index),
                  iconSize: isMobile ? 20 : 24,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            child: Column(
              children: [
                WebCircularProfileImageUpload(
                  initialImageUrl: member['image'],
                  onImageUploaded: (url) {
                    setState(() => _members[index]['image'] = url);
                  },
                  memberName: member['name'],
                  isMobile: isMobile,
                ),
                SizedBox(height: isMobile ? 20 : 24),
                _buildSectionLabel('Personal Information', isMobile),
                SizedBox(height: isMobile ? 10 : 12),
                if (isMobile) ...[
                  _buildTextField(
                    label: 'Full Name *',
                    hint: 'John Doe',
                    icon: Icons.person,
                    initialValue: member['name'],
                    onChanged: (value) => _members[index]['name'] = value,
                    validator: (value) =>
                        value?.trim().isEmpty ?? true ? 'Name required' : null,
                    isMobile: isMobile,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'Position/Role *',
                    hint: 'CEO & Founder',
                    icon: Icons.work,
                    initialValue: member['role'],
                    onChanged: (value) => _members[index]['role'] = value,
                    validator: (value) =>
                        value?.trim().isEmpty ?? true ? 'Role required' : null,
                    isMobile: isMobile,
                  ),
                ] else
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'Full Name *',
                          hint: 'John Doe',
                          icon: Icons.person,
                          initialValue: member['name'],
                          onChanged: (value) => _members[index]['name'] = value,
                          validator: (value) => value?.trim().isEmpty ?? true
                              ? 'Name required'
                              : null,
                          isMobile: isMobile,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          label: 'Position/Role *',
                          hint: 'CEO & Founder',
                          icon: Icons.work,
                          initialValue: member['role'],
                          onChanged: (value) => _members[index]['role'] = value,
                          validator: (value) => value?.trim().isEmpty ?? true
                              ? 'Role required'
                              : null,
                          isMobile: isMobile,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: isMobile ? 12 : 16),
                _buildTextField(
                  label: 'Bio *',
                  hint: 'Brief description...',
                  icon: Icons.description,
                  initialValue: member['bio'],
                  maxLines: 3,
                  onChanged: (value) => _members[index]['bio'] = value,
                  validator: (value) =>
                      value?.trim().isEmpty ?? true ? 'Bio required' : null,
                  isMobile: isMobile,
                ),
                SizedBox(height: isMobile ? 20 : 24),
                _buildSectionLabel('Contact & Social', isMobile),
                SizedBox(height: isMobile ? 10 : 12),
                if (isMobile) ...[
                  _buildTextField(
                    label: 'Email',
                    hint: 'john@agreenect.com',
                    icon: Icons.email,
                    initialValue: member['social']?['email'] ?? '',
                    onChanged: (value) {
                      if (_members[index]['social'] == null) {
                        _members[index]['social'] = {};
                      }
                      _members[index]['social']['email'] = value;
                    },
                    isMobile: isMobile,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'LinkedIn',
                    hint: 'linkedin.com/in/username',
                    icon: Icons.link,
                    initialValue: member['social']?['linkedin'] ?? '',
                    onChanged: (value) {
                      if (_members[index]['social'] == null) {
                        _members[index]['social'] = {};
                      }
                      _members[index]['social']['linkedin'] = value;
                    },
                    isMobile: isMobile,
                  ),
                ] else
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: 'Email',
                          hint: 'john@agreenect.com',
                          icon: Icons.email,
                          initialValue: member['social']?['email'] ?? '',
                          onChanged: (value) {
                            if (_members[index]['social'] == null) {
                              _members[index]['social'] = {};
                            }
                            _members[index]['social']['email'] = value;
                          },
                          isMobile: isMobile,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          label: 'LinkedIn',
                          hint: 'linkedin.com/in/username',
                          icon: Icons.link,
                          initialValue: member['social']?['linkedin'] ?? '',
                          onChanged: (value) {
                            if (_members[index]['social'] == null) {
                              _members[index]['social'] = {};
                            }
                            _members[index]['social']['linkedin'] = value;
                          },
                          isMobile: isMobile,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label, bool isMobile) {
    return Row(
      children: [
        Container(
          width: 4,
          height: isMobile ? 16 : 20,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required String initialValue,
    required Function(String) onChanged,
    String? Function(String?)? validator,
    int maxLines = 1,
    required bool isMobile,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(fontSize: isMobile ? 13 : 14),
        hintStyle: TextStyle(fontSize: isMobile ? 13 : 14),
        prefixIcon: Icon(icon, color: Colors.green, size: isMobile ? 18 : 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: isMobile ? 10 : 12,
        ),
      ),
      style: TextStyle(fontSize: isMobile ? 14 : 15),
      maxLines: maxLines,
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildBottomActionBar(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _addMember,
                    icon: const Icon(Icons.person_add, size: 18),
                    label: const Text('Add Team Member'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveChanges,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.save, size: 18),
                    label: Text(_isSaving ? 'Saving...' : 'Save Changes', style: TextStyle(fontSize: 15,color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _addMember,
                    icon: const Icon(Icons.person_add),
                    label: const Text('Add Team Member'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveChanges,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.save,color: Colors.white,),
                    label: Text(_isSaving ? 'Saving...' : 'Save Changes', style: TextStyle(fontSize: 15,color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
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

// WEB-OPTIMIZED: Using native HTML file input for 100% reliable web uploads
class WebCircularProfileImageUpload extends StatefulWidget {
  final String initialImageUrl;
  final Function(String) onImageUploaded;
  final String memberName;
  final bool isMobile;

  const WebCircularProfileImageUpload({
    super.key,
    required this.initialImageUrl,
    required this.onImageUploaded,
    required this.memberName,
    required this.isMobile,
  });

  @override
  State<WebCircularProfileImageUpload> createState() =>
      _WebCircularProfileImageUploadState();
}

class _WebCircularProfileImageUploadState
    extends State<WebCircularProfileImageUpload> {
  bool _isUploading = false;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.initialImageUrl;
  }

  Future<void> _pickAndUploadImage() async {
    if (!kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This feature is only available on web'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      // Create HTML file input element
      final html.FileUploadInputElement uploadInput =
          html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((event) async {
        final files = uploadInput.files;
        if (files == null || files.isEmpty) return;

        final file = files[0];
        
        // Validate file type
        if (!file.type.startsWith('image/')) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select an image file'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        setState(() => _isUploading = true);

        try {
          // Read file as bytes
          final reader = html.FileReader();
          reader.readAsArrayBuffer(file);

          await reader.onLoad.first;
          final fileBytes = reader.result as Uint8List;

          // Upload to Firebase Storage
          final storageFileName =
              'team_${DateTime.now().millisecondsSinceEpoch}_${file.name.replaceAll(' ', '_')}';
          final ref =
              FirebaseStorage.instance.ref().child('team/$storageFileName');

          await ref.putData(
            fileBytes,
            SettableMetadata(
              contentType: file.type,
              customMetadata: {'uploaded': DateTime.now().toIso8601String()},
            ),
          );

          final url = await ref.getDownloadURL();

          setState(() {
            _imageUrl = url;
            _isUploading = false;
          });

          widget.onImageUploaded(url);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✓ Image uploaded successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }
        } catch (e) {
          setState(() => _isUploading = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Upload failed: ${e.toString()}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      });
    } catch (e) {
      setState(() => _isUploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.isMobile ? 120.0 : 150.0;
    final iconSize = widget.isMobile ? 16.0 : 20.0;
    final placeholderIconSize = widget.isMobile ? 50.0 : 60.0;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
                border: Border.all(
                  color: Colors.green,
                  width: widget.isMobile ? 2 : 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: _imageUrl != null && _imageUrl!.isNotEmpty
                    ? Image.network(
                        _imageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(placeholderIconSize),
                      )
                    : _buildPlaceholder(placeholderIconSize),
              ),
            ),
            if (_isUploading)
              Container(
                width: size,
                height: size,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black54,
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            if (!_isUploading)
              Positioned(
                bottom: 0,
                right: 0,
                child: Material(
                  color: Colors.green,
                  shape: const CircleBorder(),
                  elevation: 4,
                  child: InkWell(
                    onTap: _pickAndUploadImage,
                    customBorder: const CircleBorder(),
                    child: Container(
                      padding: EdgeInsets.all(widget.isMobile ? 10 : 12),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: iconSize,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: widget.isMobile ? 10 : 12),
        Text(
          'Profile Photo',
          style: TextStyle(
            fontSize: widget.isMobile ? 13 : 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        TextButton.icon(
          onPressed: _isUploading ? null : _pickAndUploadImage,
          icon: Icon(Icons.upload, size: widget.isMobile ? 16 : 18),
          label: Text(
            'Upload Photo',
            style: TextStyle(fontSize: widget.isMobile ? 13 : 14),
          ),
          style: TextButton.styleFrom(foregroundColor: Colors.green),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(double iconSize) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: iconSize, color: Colors.grey[400]),
            SizedBox(height: widget.isMobile ? 6 : 8),
            Text(
              widget.memberName.isEmpty
                  ? 'No Photo'
                  : widget.memberName.split(' ').first,
              style: TextStyle(
                fontSize: widget.isMobile ? 11 : 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}