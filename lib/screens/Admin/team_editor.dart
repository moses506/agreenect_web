// lib/screens/Admin/sections/team_section_editor.dart
// Redesigned to match the Agreenect Admin Dashboard design system

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS (matches admin_dashboard.dart)
// ─────────────────────────────────────────────────────────────────────────────
class _C {
  static const forest = Color(0xFF1A3A2A);
  static const deep   = Color(0xFF0F2419);
  static const canopy = Color(0xFF2D5A3D);
  static const leaf   = Color(0xFF4A9B6A);
  static const lime   = Color(0xFF7FD17A);
  static const glow   = Color(0xFFA8F5A0);
  static const paper  = Color(0xFFF5F7F2);
  static const mist   = Color(0xFFE8EDE5);
  static const smoke  = Color(0xFFC8D4C0);
  static const ash    = Color(0xFF8A9E88);
  static const ink    = Color(0xFF1C2A1E);
  static const white  = Color(0xFFFFFFFF);
  static const rose   = Color(0xFFE85D75);
  static const amber  = Color(0xFFF5A623);
}

// ─────────────────────────────────────────────────────────────────────────────
// TEAM SECTION EDITOR
// ─────────────────────────────────────────────────────────────────────────────
class TeamSectionEditor extends StatefulWidget {
  const TeamSectionEditor({super.key});
  @override
  State<TeamSectionEditor> createState() => _TeamSectionEditorState();
}

class _TeamSectionEditorState extends State<TeamSectionEditor> {
  final _titleCtrl    = TextEditingController();
  final _subtitleCtrl = TextEditingController();
  final _formKey      = GlobalKey<FormState>();

  List<Map<String, dynamic>> _members = [];
  bool _isLoading = false;
  bool _isSaving  = false;
  bool _visible   = true;

  // Which member card is expanded for editing (-1 = none)
  int _expandedIndex = -1;

  @override
  void initState() { super.initState(); _loadData(); }

  @override
  void dispose() { _titleCtrl.dispose(); _subtitleCtrl.dispose(); super.dispose(); }

  // ── Data ────────────────────────────────────────────────────────────────────
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final doc = await FirebaseFirestore.instance
          .collection('sections').doc('team_section').get();
      if (doc.exists) {
        final d = doc.data()!;
        setState(() {
          _titleCtrl.text    = d['title']    ?? 'Meet Our Team';
          _subtitleCtrl.text = d['subtitle'] ?? '';
          _visible           = d['visible']  ?? true;
          _members           = List<Map<String, dynamic>>.from(d['members'] ?? []);
        });
      }
    } catch (e) {
      _snack('Error loading: $e', err: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      _snack('Please fill in all required fields', err: true);
      return;
    }
    setState(() => _isSaving = true);
    try {
      await FirebaseFirestore.instance
          .collection('sections').doc('team_section')
          .set({
        'order':     9,
        'visible':   _visible,
        'title':     _titleCtrl.text.trim(),
        'subtitle':  _subtitleCtrl.text.trim(),
        'members':   _members,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      _snack('✓ Team section saved!');
    } catch (e) {
      _snack('Save failed: $e', err: true);
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _addMember() {
    setState(() {
      _members.add({'name': '', 'role': '', 'bio': '', 'image': '', 'social': {'linkedin': '', 'email': ''}});
      _expandedIndex = _members.length - 1;
    });
  }

  void _removeMember(int i) => showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: _C.white,
      title: const Text('Remove member?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _C.ink)),
      content: Text(
        'Remove ${_members[i]['name']?.isNotEmpty == true ? _members[i]['name'] : 'this member'}?',
        style: TextStyle(color: _C.ash, fontSize: 13),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: _C.ash))),
        _AgBtn(label: 'Remove', icon: Icons.delete_outline_rounded, danger: true, onTap: () {
          setState(() {
            _members.removeAt(i);
            if (_expandedIndex == i) {
              _expandedIndex = -1;
            } else if (_expandedIndex > i) _expandedIndex--;
          });
          Navigator.pop(context);
          _snack('Member removed');
        }),
      ],
    ),
  );

  void _snack(String msg, {bool err = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        Icon(err ? Icons.error_outline : Icons.check_circle_rounded, color: err ? _C.rose : _C.lime, size: 17),
        const SizedBox(width: 9),
        Expanded(child: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600))),
      ]),
      backgroundColor: err ? _C.rose : _C.forest,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    ));
  }

  // ── Build ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator(color: _C.leaf));

    return Form(
      key: _formKey,
      child: Column(children: [
        // ── Page header ──────────────────────────────────────────────────────
        _buildPageHeader(),

        // ── Body ─────────────────────────────────────────────────────────────
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
            children: [
              // Settings card
              _buildSettingsCard(),
              const SizedBox(height: 18),

              // Members area
              if (_members.isEmpty)
                _buildEmptyState()
              else ...[
                _buildMembersHeader(),
                const SizedBox(height: 12),
                ..._members.asMap().entries.map((e) => _buildMemberCard(e.key)),
              ],
            ],
          ),
        ),
      ]),
    );
  }

  // ── Page header ──────────────────────────────────────────────────────────────
  Widget _buildPageHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 20),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Team Section', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _C.ink, letterSpacing: -0.5)),
          const SizedBox(height: 3),
          Text('${_members.length} member${_members.length != 1 ? 's' : ''} · Manage your team profiles',
            style: TextStyle(fontSize: 13, color: _C.ash)),
        ])),
        _AgBtn(label: '+ Add Member', icon: Icons.person_add_rounded, ghost: true, onTap: _addMember),
        const SizedBox(width: 10),
        _AgBtn(
          label: _isSaving ? 'Saving…' : 'Save Changes',
          icon: _isSaving ? Icons.hourglass_empty_rounded : Icons.save_outlined,
          onTap: _isSaving ? () {} : _save,
        ),
        const SizedBox(width: 12),
        // Visibility toggle
        _VisToggle(val: _visible, onChange: (v) => setState(() => _visible = v)),
      ]),
    );
  }

  // ── Settings card ────────────────────────────────────────────────────────────
  Widget _buildSettingsCard() {
    return _ACard(
      title: 'Section Settings',
      icon: Icons.tune_rounded,
      child: Row(children: [
        Expanded(child: _AField(
          label: 'SECTION TITLE',
          hint: 'Meet Our Team',
          icon: Icons.title_rounded,
          ctrl: _titleCtrl,
          req: true,
          validator: (v) => v!.trim().isEmpty ? 'Required' : null,
        )),
        const SizedBox(width: 16),
        Expanded(child: _AField(
          label: 'SUBTITLE',
          hint: "The people behind Agreenect's success",
          icon: Icons.short_text_rounded,
          ctrl: _subtitleCtrl,
        )),
      ]),
    );
  }

  // ── Members header ───────────────────────────────────────────────────────────
  Widget _buildMembersHeader() {
    return Row(children: [
      Container(width: 3, height: 18, decoration: BoxDecoration(color: _C.leaf, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 10),
      Text('TEAM MEMBERS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: _C.ash, letterSpacing: 1.5)),
      const SizedBox(width: 10),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: _C.leaf.withValues(alpha:  0.1), borderRadius: BorderRadius.circular(10)),
        child: Text('${_members.length}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: _C.leaf)),
      ),
    ]);
  }

  // ── Empty state ──────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: const BoxDecoration(color: _C.mist, shape: BoxShape.circle),
          child: const Icon(Icons.people_outline_rounded, size: 42, color: _C.ash),
        ),
        const SizedBox(height: 16),
        const Text('No team members yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _C.ink)),
        const SizedBox(height: 6),
        Text('Add your first team member to get started', style: TextStyle(fontSize: 13, color: _C.ash)),
        const SizedBox(height: 22),
        _AgBtn(label: 'Add First Member', icon: Icons.person_add_rounded, onTap: _addMember),
      ]),
    );
  }

  // ── Member card ──────────────────────────────────────────────────────────────
  Widget _buildMemberCard(int i) {
    final m          = _members[i];
    final isExpanded = _expandedIndex == i;
    final name       = m['name']?.isNotEmpty == true ? m['name'] as String : 'New Member';
    final role       = m['role']?.isNotEmpty == true ? m['role'] as String : '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          color: _C.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isExpanded ? _C.leaf.withValues(alpha:  0.5) : _C.mist, width: isExpanded ? 1.8 : 1),
          boxShadow: isExpanded
              ? [BoxShadow(color: _C.leaf.withValues(alpha:  0.08), blurRadius: 16, offset: const Offset(0, 6))]
              : [],
        ),
        child: Column(children: [
          // ── Card header (always visible) ──────────────────────────────────
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => setState(() => _expandedIndex = isExpanded ? -1 : i),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(children: [
                // Avatar preview
                _MiniAvatar(
                  imageUrl: m['image'] ?? '',
                  name: name,
                  size: 42,
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _C.ink)),
                  if (role.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: _C.leaf.withValues(alpha:  0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text(role, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _C.leaf)),
                      ),
                    ),
                ])),
                // Index badge
                Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(color: _C.paper, borderRadius: BorderRadius.circular(6), border: Border.all(color: _C.mist)),
                  child: Center(child: Text('${i+1}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: _C.ash))),
                ),
                const SizedBox(width: 8),
                // Delete
                InkWell(
                  onTap: () => _removeMember(i),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: _C.mist)),
                    child: const Icon(Icons.delete_outline_rounded, size: 16, color: _C.rose),
                  ),
                ),
                const SizedBox(width: 8),
                // Expand chevron
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 220),
                  child: const Icon(Icons.keyboard_arrow_down_rounded, size: 22, color: _C.ash),
                ),
              ]),
            ),
          ),

          // ── Expanded editor ───────────────────────────────────────────────
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _buildMemberEditor(i),
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 220),
          ),
        ]),
      ),
    );
  }

  // ── Member editor (expanded) ─────────────────────────────────────────────────
  Widget _buildMemberEditor(int i) {
    final m = _members[i];
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _C.mist)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Avatar + name/role row
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Avatar upload
          _AvatarUpload(
            imageUrl:   m['image']  ?? '',
            memberName: m['name']   ?? '',
            onUploaded: (url) => setState(() => _members[i]['image'] = url),
          ),
          const SizedBox(width: 24),
          Expanded(child: Column(children: [
            Row(children: [
              Expanded(child: _AField(
                label: 'FULL NAME',
                hint: 'David Chapoloko',
                icon: Icons.person_outline_rounded,
                init: m['name'],
                req: true,
                onChange: (v) => setState(() => _members[i]['name'] = v),
                validator: (v) => v!.trim().isEmpty ? 'Name required' : null,
              )),
              const SizedBox(width: 14),
              Expanded(child: _AField(
                label: 'ROLE / POSITION',
                hint: 'CEO & Founder',
                icon: Icons.work_outline_rounded,
                init: m['role'],
                req: true,
                onChange: (v) => setState(() => _members[i]['role'] = v),
                validator: (v) => v!.trim().isEmpty ? 'Role required' : null,
              )),
            ]),
            const SizedBox(height: 14),
            _AField(
              label: 'BIO',
              hint: 'Brief description of this team member…',
              icon: Icons.notes_rounded,
              init: m['bio'],
              lines: 3,
              req: true,
              onChange: (v) => setState(() => _members[i]['bio'] = v),
              validator: (v) => v!.trim().isEmpty ? 'Bio required' : null,
            ),
          ])),
        ]),

        const SizedBox(height: 18),

        // Divider with label
        Row(children: [
          Container(width: 3, height: 14, decoration: BoxDecoration(color: _C.smoke, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Text('CONTACT & SOCIAL', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: _C.ash, letterSpacing: 1.5)),
        ]),
        const SizedBox(height: 12),

        Row(children: [
          Expanded(child: _AField(
            label: 'EMAIL',
            hint: 'name@agreenect.com',
            icon: Icons.email_outlined,
            init: m['social']?['email'] ?? '',
            onChange: (v) {
              _members[i]['social'] ??= <String, dynamic>{};
              (_members[i]['social'] as Map<String, dynamic>)['email'] = v;
            },
          )),
          const SizedBox(width: 14),
          Expanded(child: _AField(
            label: 'LINKEDIN',
            hint: 'linkedin.com/in/username',
            icon: Icons.link_rounded,
            init: m['social']?['linkedin'] ?? '',
            onChange: (v) {
              _members[i]['social'] ??= <String, dynamic>{};
              (_members[i]['social'] as Map<String, dynamic>)['linkedin'] = v;
            },
          )),
        ]),

        const SizedBox(height: 16),

        // Apply button
        Align(
          alignment: Alignment.centerRight,
          child: _AgBtn(
            label: 'Apply Changes',
            icon: Icons.check_rounded,
            onTap: () => setState(() => _expandedIndex = -1),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED WIDGET: Card
// ─────────────────────────────────────────────────────────────────────────────
class _ACard extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Widget child;
  final Widget? trailing;

  const _ACard({this.title, this.icon, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.mist),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (title != null)
          Container(
            padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: _C.mist))),
            child: Row(children: [
              if (icon != null) ...[Icon(icon, size: 17, color: _C.leaf), const SizedBox(width: 8)],
              Text(title!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _C.ink)),
              if (trailing != null) ...[const Spacer(), trailing!],
            ]),
          ),
        Padding(padding: const EdgeInsets.all(18), child: child),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED WIDGET: Text Field
// ─────────────────────────────────────────────────────────────────────────────
class _AField extends StatelessWidget {
  final String label;
  final String? hint;
  final IconData? icon;
  final TextEditingController? ctrl;
  final String? init;
  final void Function(String)? onChange;
  final String? Function(String?)? validator;
  final int lines;
  final bool req;

  const _AField({
    required this.label,
    this.hint,
    this.icon,
    this.ctrl,
    this.init,
    this.onChange,
    this.validator,
    this.lines = 1,
    this.req = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(text: TextSpan(
        text: label,
        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: _C.ash, letterSpacing: 0.5),
        children: req ? const [TextSpan(text: ' *', style: TextStyle(color: _C.rose))] : [],
      )),
      const SizedBox(height: 6),
      TextFormField(
        controller: ctrl,
        initialValue: ctrl == null ? init : null,
        maxLines: lines,
        onChanged: onChange,
        validator: validator,
        style: const TextStyle(fontSize: 13.5, color: _C.ink),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: _C.ash.withValues(alpha:  0.6), fontSize: 13),
          prefixIcon: icon != null ? Icon(icon, color: _C.leaf, size: 17) : null,
          filled: true,
          fillColor: _C.paper,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border:        OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: _C.mist)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: _C.mist, width: 1.5)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: _C.leaf, width: 1.8)),
          errorBorder:   OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: _C.rose)),
        ),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED WIDGET: Button
// ─────────────────────────────────────────────────────────────────────────────
class _AgBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool ghost;
  final bool danger;

  const _AgBtn({required this.label, required this.icon, required this.onTap, this.ghost = false, this.danger = false});

  @override
  Widget build(BuildContext context) {
    Color bg = ghost ? _C.mist : danger ? _C.rose : _C.canopy;
    Color fg = ghost ? _C.ink  : _C.white;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 15, color: fg),
            const SizedBox(width: 7),
            Text(label, style: TextStyle(color: fg, fontSize: 13, fontWeight: FontWeight.w600)),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED WIDGET: Visibility Toggle
// ─────────────────────────────────────────────────────────────────────────────
class _VisToggle extends StatelessWidget {
  final bool val;
  final ValueChanged<bool> onChange;
  const _VisToggle({required this.val, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: val ? _C.lime.withValues(alpha:  0.15) : _C.smoke.withValues(alpha:  0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: val ? _C.lime.withValues(alpha:  0.4) : _C.smoke),
        ),
        child: Text(val ? 'Visible' : 'Hidden', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: val ? _C.leaf : _C.ash)),
      ),
      Switch(
        value: val,
        onChanged: onChange,
        activeColor: _C.leaf,
        activeTrackColor: _C.lime.withValues(alpha:  0.3),
        inactiveThumbColor: _C.ash,
        inactiveTrackColor: _C.smoke,
      ),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MINI AVATAR (used in collapsed card header)
// ─────────────────────────────────────────────────────────────────────────────
class _MiniAvatar extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double size;
  const _MiniAvatar({required this.imageUrl, required this.name, this.size = 40});

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isNotEmpty
        ? name.trim().split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join()
        : '?';

    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: imageUrl.isEmpty
            ? const LinearGradient(colors: [_C.canopy, _C.leaf], begin: Alignment.topLeft, end: Alignment.bottomRight)
            : null,
        border: Border.all(color: _C.mist, width: 2),
      ),
      child: ClipOval(child: imageUrl.isNotEmpty
        ? Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _initials(initials))
        : _initials(initials),
      ),
    );
  }

  Widget _initials(String t) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(colors: [_C.canopy, _C.leaf], begin: Alignment.topLeft, end: Alignment.bottomRight),
    ),
    child: Center(child: Text(t, style: TextStyle(color: _C.white, fontWeight: FontWeight.w800, fontSize: size * 0.28))),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// AVATAR UPLOAD (full-size, in expanded editor — all original logic preserved)
// ─────────────────────────────────────────────────────────────────────────────
class _AvatarUpload extends StatefulWidget {
  final String imageUrl;
  final String memberName;
  final Function(String) onUploaded;

  const _AvatarUpload({required this.imageUrl, required this.memberName, required this.onUploaded});

  @override
  State<_AvatarUpload> createState() => _AvatarUploadState();
}

class _AvatarUploadState extends State<_AvatarUpload> {
  bool _uploading = false;
  late String _url;
  Uint8List? _localPreview;

  @override
  void initState() { super.initState(); _url = widget.imageUrl; }

  @override
  void didUpdateWidget(_AvatarUpload old) {
    super.didUpdateWidget(old);
    if (old.imageUrl != widget.imageUrl) _url = widget.imageUrl;
  }

  Future<void> _pick() async {
    final input = html.FileUploadInputElement()
      ..accept = 'image/*'
      ..style.display = 'none';
    html.document.body!.append(input);
    input.click();

    input.onChange.listen((event) async {
      final files = input.files;
      if (files == null || files.isEmpty) { input.remove(); return; }

      final file = files[0];
      if (!file.type.startsWith('image/')) {
        _showErr('Please select an image file');
        input.remove();
        return;
      }

      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);

      reader.onLoadEnd.listen((event) async {
        final bytes = reader.result as Uint8List;
        // Show local preview immediately
        setState(() { _localPreview = bytes; _uploading = true; });

        try {
          final ext      = file.name.contains('.') ? file.name.split('.').last : 'jpg';
          final fileName = 'team_${DateTime.now().millisecondsSinceEpoch}.$ext';
          final ref      = FirebaseStorage.instance.ref().child('team/$fileName');

          await ref.putData(bytes, SettableMetadata(contentType: file.type));
          final url = await ref.getDownloadURL();

          setState(() { _url = url; _uploading = false; });
          widget.onUploaded(url);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('✓ Photo saved!'),
            backgroundColor: _C.forest,
            behavior: SnackBarBehavior.floating,
          ));
          }
        } catch (e) {
          setState(() { _uploading = false; _localPreview = null; });
          _showErr('Upload failed: $e');
        } finally {
          input.remove();
        }
      });
    });
  }

  void _showErr(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: _C.rose,
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final initials = widget.memberName.trim().isNotEmpty
        ? widget.memberName.trim().split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join()
        : '?';

    return Column(children: [
      GestureDetector(
        onTap: _uploading ? null : _pick,
        child: Stack(alignment: Alignment.center, children: [
          // Circle
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _C.leaf, width: 2.5),
              boxShadow: [BoxShadow(color: _C.leaf.withValues(alpha:  0.2), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: ClipOval(child: _localPreview != null
              ? Image.memory(_localPreview!, fit: BoxFit.cover)
              : _url.isNotEmpty
                ? Image.network(_url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholder(initials))
                : _placeholder(initials),
            ),
          ),
          // Upload progress overlay
          if (_uploading)
            Positioned(bottom: 0, left: 0, right: 0,
              child: Container(
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha:  0.55),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(50)),
                ),
                child: const Center(child: SizedBox(width: 14, height: 14,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))),
              ),
            ),
          // Camera icon
          if (!_uploading)
            Positioned(bottom: 2, right: 2,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: _C.leaf, shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14),
              ),
            ),
        ]),
      ),
      const SizedBox(height: 8),
      Text(
        _uploading ? 'Uploading…' : 'Tap to change',
        style: TextStyle(
          fontSize: 11,
          color: _uploading ? _C.leaf : _C.ash,
          fontWeight: _uploading ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    ]);
  }

  Widget _placeholder(String initials) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(colors: [_C.canopy, _C.leaf], begin: Alignment.topLeft, end: Alignment.bottomRight),
    ),
    child: Center(child: Text(initials, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: _C.white))),
  );
}