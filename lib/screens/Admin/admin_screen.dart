// ============================================================================
// lib/screens/Admin/admin_dashboard.dart
// ============================================================================

import 'package:agreenect/screens/Admin/team_editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
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
  static const amber  = Color(0xFFF5A623);
  static const rose   = Color(0xFFE85D75);
  static const sky    = Color(0xFF4A9FD4);
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION MODEL
// ─────────────────────────────────────────────────────────────────────────────
class _Section {
  final String id, name;
  final IconData icon;
  final Color color;
  const _Section(this.id, this.name, this.icon, this.color);
}

const _kSections = [
  _Section('dashboard',            'Dashboard',    Icons.dashboard_rounded,     _C.leaf),
  _Section('hero_section',         'Hero',         Icons.panorama_rounded,      _C.sky),
  _Section('features_section',     'Features',     Icons.auto_awesome_rounded,  _C.amber),
  _Section('about_section',        'About Us',     Icons.info_outline_rounded,  _C.leaf),
  _Section('works_section',        'Our Works',    Icons.work_outline_rounded,  _C.canopy),
  _Section('mission_section',      'Mission',      Icons.flag_outlined,         _C.amber),
  _Section('impact_section',       'Impact',       Icons.trending_up_rounded,   _C.lime),
  _Section('stats_section',        'Statistics',   Icons.bar_chart_rounded,     _C.sky),
  _Section('achievements_section', 'Achievements', Icons.emoji_events_outlined, _C.amber),
  _Section('team_section',         'Team',         Icons.people_alt_outlined,   _C.leaf),
  _Section('partners_section',     'Partners',     Icons.handshake_outlined,    _C.sky),
  _Section('contact_section',      'Contact',      Icons.mail_outline_rounded,  _C.rose),
];

// ─────────────────────────────────────────────────────────────────────────────
// ROOT WIDGET
// ─────────────────────────────────────────────────────────────────────────────
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  int _idx = 0;
  late final AnimationController _ac =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 260));
  late final Animation<double> _fade =
      CurvedAnimation(parent: _ac, curve: Curves.easeOut);

  void _go(int i) {
    if (_idx == i) return;
    _ac.reset();
    setState(() => _idx = i);
    _ac.forward();
  }

  @override
  void initState() { super.initState(); _ac.forward(); }
  @override
  void dispose()   { _ac.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.paper,
      body: Row(children: [
        _Sidebar(idx: _idx, onSelect: _go),
        Expanded(child: Column(children: [
          _TopBar(section: _kSections[_idx]),
          Expanded(
            child: FadeTransition(
              opacity: _fade,
              child: _page(_kSections[_idx].id),
            ),
          ),
        ])),
      ]),
    );
  }

  Widget _page(String id) {
    switch (id) {
      case 'dashboard':            return const _DashboardPage();
      case 'hero_section':         return const HeroEditor();
      case 'features_section':     return const FeaturesEditor();
      case 'about_section':        return const AboutEditor();
      case 'works_section':        return const WorksEditor();
      case 'mission_section':      return const MissionEditor();
      case 'impact_section':       return const ImpactEditor();
      case 'stats_section':        return const StatsEditor();
      case 'achievements_section': return const AchievementsEditor();
      case 'team_section':         return const TeamSectionEditor();
      case 'partners_section':     return const PartnersEditor();
      case 'contact_section':      return const ContactEditor();
      default:                     return const SizedBox();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SIDEBAR — shows the REAL logged-in Firebase user
// ─────────────────────────────────────────────────────────────────────────────
class _Sidebar extends StatelessWidget {
  final int idx;
  final ValueChanged<int> onSelect;
  const _Sidebar({required this.idx, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final user     = FirebaseAuth.instance.currentUser;
    final email    = user?.email ?? '';
    final rawName  = user?.displayName?.trim() ?? '';
    // Use displayName if set, else derive from email prefix
    final name     = rawName.isNotEmpty
        ? rawName
        : (email.contains('@') ? email.split('@').first : 'Admin');
    final initial  = name.isNotEmpty ? name[0].toUpperCase() : 'A';
    final photoUrl = user?.photoURL;

    return Container(
      width: 218,
      decoration: const BoxDecoration(
        color: _C.deep,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(3, 0))],
      ),
      child: Column(children: [
        // Brand header
        Container(
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white10))),
          child: Row(children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [_C.leaf, _C.lime], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(child: Text('🌿', style: TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Agreenect', style: TextStyle(color: _C.white, fontWeight: FontWeight.w800, fontSize: 15)),
              Text('ADMIN PANEL', style: TextStyle(color: _C.ash, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.8)),
            ]),
          ]),
        ),

        // Nav items
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            children: [
              _SLabel('OVERVIEW'),
              _NItem(s: _kSections[0], selected: idx == 0, onTap: () => onSelect(0)),
              const SizedBox(height: 6),
              _SLabel('PAGE SECTIONS'),
              ...List.generate(_kSections.length - 1, (i) => _NItem(
                s: _kSections[i + 1],
                selected: idx == i + 1,
                onTap: () => onSelect(i + 1),
              )),
            ],
          ),
        ),

        // Live user footer
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.white10))),
          child: Material(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) Navigator.of(context).pushReplacementNamed('/login');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(children: [
                  // Avatar: photo if available, else gradient initial
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [_C.canopy, _C.leaf]),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: photoUrl != null
                          ? Image.network(photoUrl, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _Initials(initial))
                          : _Initials(initial),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(name, style: const TextStyle(color: _C.white, fontWeight: FontWeight.w600, fontSize: 12.5), overflow: TextOverflow.ellipsis),
                    Text(email, style: TextStyle(color: _C.ash, fontSize: 9.5), overflow: TextOverflow.ellipsis),
                  ])),
                  const Icon(Icons.logout_rounded, color: _C.ash, size: 15),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class _Initials extends StatelessWidget {
  final String letter;
  const _Initials(this.letter);
  @override
  Widget build(BuildContext context) => Center(
    child: Text(letter, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
  );
}

class _SLabel extends StatelessWidget {
  final String t;
  const _SLabel(this.t);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 12, 12, 5),
    child: Text(t, style: TextStyle(color: _C.ash, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 2)),
  );
}

class _NItem extends StatelessWidget {
  final _Section s; final bool selected; final VoidCallback onTap;
  const _NItem({required this.s, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 180),
    margin: const EdgeInsets.only(bottom: 2),
    decoration: BoxDecoration(
      color: selected ? Colors.white.withValues(alpha: 0.12) : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: selected ? Colors.white.withValues(alpha: 0.12) : Colors.transparent),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        hoverColor: Colors.white.withValues(alpha: 0.06),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(children: [
            Icon(s.icon, size: 17, color: selected ? _C.glow : _C.ash),
            const SizedBox(width: 11),
            Expanded(child: Text(s.name, style: TextStyle(
              color: selected ? _C.glow : Colors.white60,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 13.5,
            ))),
            if (selected) Container(width: 6, height: 6, decoration: const BoxDecoration(color: _C.lime, shape: BoxShape.circle)),
          ]),
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// TOPBAR
// ─────────────────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final _Section section;
  const _TopBar({required this.section});
  @override
  Widget build(BuildContext context) => Container(
    height: 62,
    padding: const EdgeInsets.symmetric(horizontal: 28),
    decoration: const BoxDecoration(color: _C.white, border: Border(bottom: BorderSide(color: _C.mist))),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(section.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _C.ink, letterSpacing: -0.3)),
        Text('Agreenect / ${section.name}', style: TextStyle(fontSize: 11, color: _C.ash)),
      ])),
      _LiveBadge(),
      const SizedBox(width: 10),
      _Btn(label: 'Preview', icon: Icons.open_in_new_rounded, ghost: true, onTap: () {}),
    ]),
  );
}

class _LiveBadge extends StatefulWidget {
  @override State<_LiveBadge> createState() => _LiveBadgeState();
}
class _LiveBadgeState extends State<_LiveBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  late final Animation<double> _a = Tween(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: _C.lime.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _C.lime.withValues(alpha: 0.3)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      FadeTransition(opacity: _a, child: Container(width: 7, height: 7, decoration: const BoxDecoration(color: _C.lime, shape: BoxShape.circle))),
      const SizedBox(width: 6),
      const Text('Live', style: TextStyle(color: _C.leaf, fontSize: 11.5, fontWeight: FontWeight.w700)),
    ]),
  );
}

class _Btn extends StatelessWidget {
  final String label; final IconData icon; final VoidCallback onTap; final bool ghost;
  const _Btn({required this.label, required this.icon, required this.onTap, this.ghost = false});
  @override
  Widget build(BuildContext context) => Material(
    color: ghost ? _C.mist : _C.canopy,
    borderRadius: BorderRadius.circular(9),
    child: InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 15, color: ghost ? _C.ink : _C.white),
          const SizedBox(width: 7),
          Text(label, style: TextStyle(color: ghost ? _C.ink : _C.white, fontSize: 13, fontWeight: FontWeight.w600)),
        ]),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────────────────────────────────────
class _Card extends StatelessWidget {
  final String? title; final IconData? icon; final Widget child; final Widget? trailing;
  const _Card({this.title, this.icon, required this.child, this.trailing});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: _C.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _C.mist)),
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

class _Field extends StatelessWidget {
  final String label; final String? hint; final IconData? icon;
  final TextEditingController? ctrl; final String? init;
  final void Function(String)? onChange; final String? Function(String?)? validator;
  final int lines; final bool req;
  const _Field({required this.label, this.hint, this.icon, this.ctrl, this.init,
    this.onChange, this.validator, this.lines = 1, this.req = false});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    if (label.isNotEmpty) ...[
      RichText(text: TextSpan(
        text: label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _C.ash, letterSpacing: 0.5),
        children: req ? const [TextSpan(text: ' *', style: TextStyle(color: _C.rose))] : [],
      )),
      const SizedBox(height: 6),
    ],
    TextFormField(
      controller: ctrl,
      initialValue: ctrl == null ? init : null,
      maxLines: lines,
      onChanged: onChange,
      validator: validator,
      style: const TextStyle(fontSize: 13.5, color: _C.ink),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: _C.ash.withValues(alpha: 0.6), fontSize: 13),
        prefixIcon: icon != null ? Icon(icon, color: _C.leaf, size: 18) : null,
        filled: true, fillColor: _C.paper,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border:        OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: _C.mist)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: _C.mist, width: 1.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: _C.leaf, width: 1.8)),
        errorBorder:   OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: _C.rose)),
      ),
    ),
  ]);
}

class _VisToggle extends StatelessWidget {
  final bool val; final ValueChanged<bool> onChange;
  const _VisToggle({required this.val, required this.onChange});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: val ? _C.lime.withValues(alpha: 0.15) : _C.smoke.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: val ? _C.lime.withValues(alpha: 0.4) : _C.smoke),
      ),
      child: Text(val ? 'Visible' : 'Hidden', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: val ? _C.leaf : _C.ash)),
    ),
    Switch(value: val, onChanged: onChange, activeColor: _C.leaf, activeTrackColor: _C.lime.withValues(alpha: 0.3), inactiveThumbColor: _C.ash, inactiveTrackColor: _C.smoke),
  ]);
}

class _PageHeader extends StatelessWidget {
  final String title, sub; final bool vis; final ValueChanged<bool> onVis; final List<Widget> actions;
  const _PageHeader({required this.title, required this.sub, required this.vis, required this.onVis, this.actions = const []});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(28, 24, 28, 20),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _C.ink, letterSpacing: -0.5)),
        const SizedBox(height: 3),
        Text(sub, style: TextStyle(fontSize: 13, color: _C.ash)),
      ])),
      ...actions,
      const SizedBox(width: 12),
      _VisToggle(val: vis, onChange: onVis),
    ]),
  );
}

class _Empty extends StatelessWidget {
  final IconData icon; final String title, sub, btn; final VoidCallback onTap;
  const _Empty({required this.icon, required this.title, required this.sub, required this.btn, required this.onTap});
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    Container(padding: const EdgeInsets.all(22), decoration: const BoxDecoration(color: _C.mist, shape: BoxShape.circle),
      child: Icon(icon, size: 42, color: _C.ash)),
    const SizedBox(height: 16),
    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _C.ink)),
    const SizedBox(height: 5),
    Text(sub, style: TextStyle(fontSize: 13, color: _C.ash)),
    const SizedBox(height: 20),
    _Btn(label: btn, icon: Icons.add_rounded, onTap: onTap),
  ]));
}

void _snack(BuildContext ctx, String msg, {bool err = false}) {
  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
    content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
    backgroundColor: err ? _C.rose : _C.canopy,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    margin: const EdgeInsets.all(16),
  ));
}

// ─────────────────────────────────────────────────────────────────────────────
// DASHBOARD — fully live from Firestore
// ─────────────────────────────────────────────────────────────────────────────
class _DashboardPage extends StatefulWidget {
  const _DashboardPage();
  @override State<_DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<_DashboardPage> {
  bool _loading = true;
  List<Map<String, dynamic>> _stats        = [];
  List<Map<String, dynamic>> _members      = [];
  List<Map<String, dynamic>> _partners     = [];
  List<Map<String, dynamic>> _achievements = [];
  // [{name, visible}] sorted by order field
  List<Map<String, dynamic>> _sections     = [];

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        FirebaseFirestore.instance.collection('sections').doc('stats_section').get(),
        FirebaseFirestore.instance.collection('sections').doc('team_section').get(),
        FirebaseFirestore.instance.collection('sections').doc('partners_section').get(),
        FirebaseFirestore.instance.collection('sections').doc('achievements_section').get(),
        FirebaseFirestore.instance.collection('sections').orderBy('order').get(),
      ]);

      final statsDoc        = results[0] as DocumentSnapshot;
      final teamDoc         = results[1] as DocumentSnapshot;
      final partnersDoc     = results[2] as DocumentSnapshot;
      final achievementsDoc = results[3] as DocumentSnapshot;
      final allSnap         = results[4] as QuerySnapshot;

      // Build readable section names from Firestore doc IDs
      final sections = allSnap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final pretty = doc.id
            .replaceAll('_section', '')
            .replaceAll('_', ' ')
            .split(' ')
            .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
            .join(' ')
            .trim();
        return {'name': pretty, 'visible': data['visible'] ?? true};
      }).toList();

      setState(() {
        _stats        = statsDoc.exists        ? List<Map<String,dynamic>>.from((statsDoc.data()        as Map)['stats']        ?? []) : [];
        _members      = teamDoc.exists         ? List<Map<String,dynamic>>.from((teamDoc.data()         as Map)['members']      ?? []) : [];
        _partners     = partnersDoc.exists     ? List<Map<String,dynamic>>.from((partnersDoc.data()     as Map)['logos']        ?? []) : [];
        _achievements = achievementsDoc.exists ? List<Map<String,dynamic>>.from((achievementsDoc.data() as Map)['achievements'] ?? []) : [];
        _sections     = sections;
        _loading      = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) _snack(context, 'Error loading dashboard: $e', err: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      CircularProgressIndicator(color: _C.leaf),
      SizedBox(height: 16),
      Text('Loading dashboard…', style: TextStyle(color: _C.ash, fontSize: 13)),
    ]));
    }

    return RefreshIndicator(
      onRefresh: _load,
      color: _C.leaf,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(28),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildStatCards(),
          const SizedBox(height: 24),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _buildVisibilityCard()),
            const SizedBox(width: 20),
            Expanded(child: _buildTeamCard()),
          ]),
          const SizedBox(height: 20),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _buildAchievementsCard()),
            const SizedBox(width: 20),
            Expanded(child: _buildPartnersCard()),
          ]),
          const SizedBox(height: 20),
          _buildBanner(),
        ]),
      ),
    );
  }

  // ── Stat cards ──────────────────────────────────────────────────────────────
  Widget _buildStatCards() {
    if (_stats.isEmpty) {
      return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: _C.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _C.mist)),
      child: Row(children: [
        const Icon(Icons.info_outline_rounded, color: _C.ash, size: 18),
        const SizedBox(width: 10),
        Text('No statistics yet. Go to Statistics to add some.', style: TextStyle(color: _C.ash, fontSize: 13)),
      ]),
    );
    }

    final colors = [_C.leaf, _C.amber, _C.sky, _C.rose, _C.lime, _C.canopy];
    final count  = _stats.length;
    final w = ((MediaQuery.of(context).size.width - 218 - 56) / count - 16).clamp(150.0, 300.0);

    return Wrap(spacing: 16, runSpacing: 16, children: _stats.asMap().entries.map((e) {
      final stat = e.value;
      final col  = colors[e.key % colors.length];
      return SizedBox(width: w, child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: _C.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _C.mist)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(color: col.withValues(alpha:  0.12), borderRadius: BorderRadius.circular(9)),
              child: Text(stat['icon'] ?? '📊', style: const TextStyle(fontSize: 18))),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: _C.lime.withValues(alpha:  0.15), borderRadius: BorderRadius.circular(20)),
              child: const Text('Live', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: _C.leaf))),
          ]),
          const SizedBox(height: 14),
          Text(stat['value'] ?? '—', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: _C.ink, height: 1)),
          const SizedBox(height: 4),
          Text(stat['label'] ?? '', style: TextStyle(fontSize: 12, color: _C.ash, fontWeight: FontWeight.w500)),
        ]),
      ));
    }).toList());
  }

  // ── Visibility card ─────────────────────────────────────────────────────────
  Widget _buildVisibilityCard() => _Card(
    title: 'Section Visibility (${_sections.length})',
    icon: Icons.visibility_outlined,
    child: _sections.isEmpty
      ? _et('No sections found')
      : Column(children: _sections.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(color: _C.paper, borderRadius: BorderRadius.circular(9), border: Border.all(color: _C.mist)),
            child: Row(children: [
              Expanded(child: Text(s['name'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _C.ink))),
              _VisBadge(visible: s['visible'] as bool),
            ]),
          ),
        )).toList(),
      ),
  );

  // ── Team card ───────────────────────────────────────────────────────────────
  Widget _buildTeamCard() => _Card(
    title: 'Team — ${_members.length} member${_members.length != 1 ? 's' : ''}',
    icon: Icons.people_alt_outlined,
    child: _members.isEmpty ? _et('No team members yet')
      : Column(children: _members.map((m) {
          final name    = (m['name']  ?? '').toString();
          final role    = (m['role']  ?? '').toString();
          final imgUrl  = (m['image'] ?? '').toString();
          final initial = name.isNotEmpty ? name.trim()[0].toUpperCase() : '?';
          return Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [
            Container(width: 34, height: 34,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: _C.mist)),
              child: ClipRRect(borderRadius: BorderRadius.circular(7),
                child: imgUrl.isNotEmpty
                  ? Image.network(imgUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _gi(initial))
                  : _gi(initial))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _C.ink)),
              Text(role, style: TextStyle(fontSize: 11, color: _C.ash)),
            ])),
            Container(width: 8, height: 8, decoration: const BoxDecoration(color: _C.lime, shape: BoxShape.circle)),
          ]));
        }).toList()),
  );

  // ── Achievements card ────────────────────────────────────────────────────────
  Widget _buildAchievementsCard() => _Card(
    title: 'Achievements — ${_achievements.length}',
    icon: Icons.emoji_events_outlined,
    child: _achievements.isEmpty ? _et('No achievements yet')
      : Column(children: _achievements.map((a) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: _C.amber.withValues(alpha:  0.12), borderRadius: BorderRadius.circular(6)),
              child: Text((a['year'] ?? '').toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: _C.amber))),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text((a['title'] ?? '').toString(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _C.ink)),
              if ((a['description'] ?? '').toString().isNotEmpty)
                Text((a['description']).toString(), style: TextStyle(fontSize: 11, color: _C.ash)),
            ])),
          ]),
        )).toList()),
  );

  // ── Partners card ────────────────────────────────────────────────────────────
  Widget _buildPartnersCard() => _Card(
    title: 'Partners — ${_partners.length}',
    icon: Icons.handshake_outlined,
    child: _partners.isEmpty ? _et('No partners added yet')
      : Wrap(spacing: 10, runSpacing: 10,
          children: _partners.map((p) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(color: _C.paper, borderRadius: BorderRadius.circular(8), border: Border.all(color: _C.mist)),
            child: Text((p['name'] ?? '').toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _C.ink)),
          )).toList()),
  );

  // ── Banner ───────────────────────────────────────────────────────────────────
  Widget _buildBanner() => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [_C.forest, _C.canopy], begin: Alignment.centerLeft, end: Alignment.centerRight),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(children: [
      const Text('🌾', style: TextStyle(fontSize: 26)),
      const SizedBox(width: 16),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Agreenect — Transforming Agriculture in Zambia',
          style: TextStyle(color: _C.white, fontWeight: FontWeight.w800, fontSize: 14)),
        const SizedBox(height: 3),
        Text('${_members.length} team members · ${_partners.length} partners · ${_achievements.length} achievements',
          style: const TextStyle(color: Colors.white60, fontSize: 12)),
      ])),
      Material(color: Colors.white.withValues(alpha:  0.1), borderRadius: BorderRadius.circular(8),
        child: InkWell(borderRadius: BorderRadius.circular(8), onTap: _load,
          child: const Padding(padding: EdgeInsets.all(10),
            child: Icon(Icons.refresh_rounded, color: Colors.white70, size: 18)))),
    ]),
  );

  Widget _et(String t) => Padding(padding: const EdgeInsets.symmetric(vertical: 16),
    child: Center(child: Text(t, style: TextStyle(color: _C.ash, fontSize: 13))));

  Widget _gi(String letter) => Container(
    decoration: const BoxDecoration(gradient: LinearGradient(colors: [_C.canopy, _C.leaf])),
    child: Center(child: Text(letter, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14))));
}

class _VisBadge extends StatelessWidget {
  final bool visible;
  const _VisBadge({required this.visible});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: visible ? _C.lime.withValues(alpha:  0.15) : _C.smoke.withValues(alpha:  0.4),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(visible ? 'Visible' : 'Hidden',
      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: visible ? _C.leaf : _C.ash)),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// HERO EDITOR
// ─────────────────────────────────────────────────────────────────────────────
class HeroEditor extends StatefulWidget {
  const HeroEditor({super.key});
  @override State<HeroEditor> createState() => _HeroEditorState();
}
class _HeroEditorState extends State<HeroEditor> {
  final _title = TextEditingController(); final _sub = TextEditingController();
  final _bgImg = TextEditingController(); final _cta1lbl = TextEditingController();
  final _cta1link = TextEditingController(); final _cta2lbl = TextEditingController();
  final _cta2link = TextEditingController();
  double _opacity = 0.5;
  bool _vis = true, _loading = true, _saving = false;
  @override void initState() { super.initState(); _load(); }
  @override void dispose() { for (var c in [_title,_sub,_bgImg,_cta1lbl,_cta1link,_cta2lbl,_cta2link]) {
    c.dispose();
  } super.dispose(); }
  Future<void> _load() async {
    final doc = await FirebaseFirestore.instance.collection('sections').doc('hero_section').get();
    if (doc.exists) { final d = doc.data()!; final btns = List<Map>.from(d['ctaButtons'] ?? []);
      setState(() { _title.text = d['title'] ?? ''; _sub.text = d['subtitle'] ?? ''; _bgImg.text = d['backgroundImage'] ?? '';
        _opacity = (d['overlayOpacity'] ?? 0.5).toDouble(); _vis = d['visible'] ?? true;
        if (btns.isNotEmpty) { _cta1lbl.text = btns[0]['text'] ?? ''; _cta1link.text = btns[0]['link'] ?? ''; }
        if (btns.length > 1) { _cta2lbl.text = btns[1]['text'] ?? ''; _cta2link.text = btns[1]['link'] ?? ''; }
      });
    }
    setState(() => _loading = false);
  }
  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await FirebaseFirestore.instance.collection('sections').doc('hero_section').set({
        'order': 1, 'visible': _vis, 'title': _title.text.trim(), 'subtitle': _sub.text.trim(),
        'backgroundImage': _bgImg.text.trim(), 'overlayOpacity': _opacity,
        'ctaButtons': [
          {'text': _cta1lbl.text.trim(), 'link': _cta1link.text.trim(), 'style': 'primary'},
          {'text': _cta2lbl.text.trim(), 'link': _cta2link.text.trim(), 'style': 'secondary'},
        ], 'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      if (mounted) _snack(context, '✓ Hero section saved!');
    } catch (e) { if (mounted) _snack(context, 'Error: $e', err: true); }
    finally { setState(() => _saving = false); }
  }
  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: _C.leaf));
    return SingleChildScrollView(child: Column(children: [
      _PageHeader(title: 'Hero Section', sub: 'Main banner at the top of your website', vis: _vis, onVis: (v) => setState(() => _vis = v),
        actions: [_Btn(label: _saving ? 'Saving…' : 'Save Changes', icon: Icons.save_outlined, onTap: _saving ? () {} : _save)]),
      Padding(padding: const EdgeInsets.fromLTRB(28, 0, 28, 28), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex: 3, child: Column(children: [
          _Card(title: 'Content', icon: Icons.edit_rounded, child: Column(children: [
            _Field(label: 'HEADLINE', hint: 'Transforming Agriculture in Zambia', icon: Icons.title_rounded, ctrl: _title, req: true),
            const SizedBox(height: 14),
            _Field(label: 'SUBTITLE', hint: 'Brief description…', icon: Icons.short_text_rounded, ctrl: _sub, lines: 3),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: _Field(label: 'CTA 1 LABEL', hint: 'Learn More', ctrl: _cta1lbl)),
              const SizedBox(width: 14),
              Expanded(child: _Field(label: 'CTA 1 LINK', hint: '#about', ctrl: _cta1link)),
            ]),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: _Field(label: 'CTA 2 LABEL', hint: 'Contact Us', ctrl: _cta2lbl)),
              const SizedBox(width: 14),
              Expanded(child: _Field(label: 'CTA 2 LINK', hint: '#contact', ctrl: _cta2link)),
            ]),
          ])),
          const SizedBox(height: 18),
          _Card(title: 'Background Image', icon: Icons.image_outlined, child: Column(children: [
            _Field(label: 'IMAGE URL', hint: 'https://…', icon: Icons.link_rounded, ctrl: _bgImg),
            const SizedBox(height: 16),
            Row(children: [
              Text('Overlay Opacity', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _C.ash)),
              const Spacer(),
              Text('${(_opacity * 100).round()}%', style: TextStyle(fontSize: 12, color: _C.ash)),
            ]),
            Slider(value: _opacity, onChanged: (v) => setState(() => _opacity = v), activeColor: _C.leaf, inactiveColor: _C.mist),
          ])),
        ])),
        const SizedBox(width: 20),
        SizedBox(width: 270, child: _HeroPreview(title: _title.text, imageUrl: _bgImg.text, opacity: _opacity)),
      ])),
    ]));
  }
}

class _HeroPreview extends StatelessWidget {
  final String title, imageUrl; final double opacity;
  const _HeroPreview({required this.title, required this.imageUrl, required this.opacity});
  @override
  Widget build(BuildContext context) => _Card(title: 'Live Preview', icon: Icons.preview_rounded,
    child: ClipRRect(borderRadius: BorderRadius.circular(10),
      child: AspectRatio(aspectRatio: 16/10, child: Stack(fit: StackFit.expand, children: [
        imageUrl.isNotEmpty ? Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: _C.forest))
          : Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [_C.forest, _C.deep]))),
        Container(color: Colors.black.withValues(alpha: opacity)),
        Center(child: Padding(padding: const EdgeInsets.all(12),
          child: Text(title.isNotEmpty ? title : 'Your headline here', textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)))),
      ]))));
}

// ─────────────────────────────────────────────────────────────────────────────
// FEATURES EDITOR
// ─────────────────────────────────────────────────────────────────────────────
class FeaturesEditor extends StatefulWidget {
  const FeaturesEditor({super.key});
  @override State<FeaturesEditor> createState() => _FeaturesEditorState();
}
class _FeaturesEditorState extends State<FeaturesEditor> {
  List<Map<String,dynamic>> _items = []; bool _vis = true, _loading = true, _saving = false;
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final doc = await FirebaseFirestore.instance.collection('sections').doc('features_section').get();
    if (doc.exists) { final d = doc.data()!; setState(() { _items = List<Map<String,dynamic>>.from(d['items'] ?? []); _vis = d['visible'] ?? true; }); }
    setState(() => _loading = false);
  }
  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await FirebaseFirestore.instance.collection('sections').doc('features_section').set({
        'order': 2, 'visible': _vis, 'title': 'Our Features', 'subtitle': 'What makes Agreenect different', 'items': _items, 'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      if (mounted) _snack(context, '✓ Features saved!');
    } catch (e) { if (mounted) _snack(context, 'Error: $e', err: true); }
    finally { setState(() => _saving = false); }
  }
  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: _C.leaf));
    return SingleChildScrollView(child: Column(children: [
      _PageHeader(title: 'Features Section', sub: 'Showcase your key features', vis: _vis, onVis: (v) => setState(() => _vis = v),
        actions: [
          _Btn(label: '+ Add', icon: Icons.add_rounded, ghost: true, onTap: () => setState(() => _items.add({'title':'','description':'','icon':''}))),
          const SizedBox(width: 10),
          _Btn(label: _saving ? 'Saving…' : 'Save', icon: Icons.save_outlined, onTap: _saving ? () {} : _save),
        ]),
      Padding(padding: const EdgeInsets.fromLTRB(28, 0, 28, 28), child: _items.isEmpty
        ? _Empty(icon: Icons.auto_awesome_outlined, title: 'No features yet', sub: 'Add your first feature', btn: 'Add Feature',
            onTap: () => setState(() => _items.add({'title':'','description':'','icon':''})))
        : Column(children: _items.asMap().entries.map((e) { final i = e.key; return Padding(padding: const EdgeInsets.only(bottom: 14), child: _Card(child: Column(children: [
            Row(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: _C.leaf.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: Text('#${i+1}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: _C.leaf))),
              const SizedBox(width: 10),
              Expanded(child: Text(_items[i]['title']?.isNotEmpty == true ? _items[i]['title'] : 'New Feature', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _C.ink))),
              IconButton(icon: const Icon(Icons.delete_outline_rounded, color: _C.rose, size: 20), onPressed: () => setState(() => _items.removeAt(i))),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _Field(label: 'TITLE', hint: 'Smart Farming Solutions', init: _items[i]['title'], onChange: (v) => _items[i]['title'] = v, req: true)),
              const SizedBox(width: 14),
              Expanded(child: _Field(label: 'ICON URL', hint: 'https://… or 🌱', init: _items[i]['icon'], onChange: (v) => _items[i]['icon'] = v)),
            ]),
            const SizedBox(height: 12),
            _Field(label: 'DESCRIPTION', hint: 'Brief description…', init: _items[i]['description'], onChange: (v) => _items[i]['description'] = v, lines: 3),
          ]))); }).toList()),
      ),
    ]));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ABOUT EDITOR
// ─────────────────────────────────────────────────────────────────────────────
class AboutEditor extends StatefulWidget {
  const AboutEditor({super.key});
  @override State<AboutEditor> createState() => _AboutEditorState();
}
class _AboutEditorState extends State<AboutEditor> {
  final _title = TextEditingController(); final _content = TextEditingController();
  List<Map<String,dynamic>> _stats = []; bool _vis = true, _loading = true, _saving = false;
  @override void initState() { super.initState(); _load(); }
  @override void dispose() { _title.dispose(); _content.dispose(); super.dispose(); }
  Future<void> _load() async {
    final doc = await FirebaseFirestore.instance.collection('sections').doc('about_section').get();
    if (doc.exists) { final d = doc.data()!; setState(() { _title.text = d['title'] ?? ''; _content.text = d['content'] ?? ''; _stats = List<Map<String,dynamic>>.from(d['stats'] ?? []); _vis = d['visible'] ?? true; }); }
    setState(() => _loading = false);
  }
  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await FirebaseFirestore.instance.collection('sections').doc('about_section').set({
        'order': 3, 'visible': _vis, 'title': _title.text.trim(), 'content': _content.text.trim(), 'stats': _stats, 'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      if (mounted) _snack(context, '✓ About section saved!');
    } catch (e) { if (mounted) _snack(context, 'Error: $e', err: true); }
    finally { setState(() => _saving = false); }
  }
  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: _C.leaf));
    return SingleChildScrollView(child: Column(children: [
      _PageHeader(title: 'About Us', sub: 'Tell your company story', vis: _vis, onVis: (v) => setState(() => _vis = v),
        actions: [_Btn(label: _saving ? 'Saving…' : 'Save', icon: Icons.save_outlined, onTap: _saving ? () {} : _save)]),
      Padding(padding: const EdgeInsets.fromLTRB(28, 0, 28, 28), child: Column(children: [
        _Card(title: 'Content', icon: Icons.edit_rounded, child: Column(children: [
          _Field(label: 'TITLE', hint: 'About Agreenect', ctrl: _title, req: true),
          const SizedBox(height: 14),
          _Field(label: 'CONTENT', hint: 'Tell your story…', ctrl: _content, lines: 8),
        ])),
        const SizedBox(height: 18),
        _Card(title: 'Key Statistics', icon: Icons.bar_chart_rounded,
          trailing: _Btn(label: '+ Add Stat', icon: Icons.add_rounded, ghost: true, onTap: () => setState(() => _stats.add({'label':'','value':''}))),
          child: _stats.isEmpty
            ? Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Text('No stats yet.', style: TextStyle(color: _C.ash))))
            : Column(children: _stats.asMap().entries.map((e) { final i = e.key; return Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [
                Expanded(child: _Field(label: 'VALUE', hint: '10,000+', init: _stats[i]['value'], onChange: (v) => _stats[i]['value'] = v)),
                const SizedBox(width: 14),
                Expanded(child: _Field(label: 'LABEL', hint: 'Farmers Reached', init: _stats[i]['label'], onChange: (v) => _stats[i]['label'] = v)),
                const SizedBox(width: 8),
                IconButton(icon: const Icon(Icons.delete_outline_rounded, color: _C.rose, size: 18), onPressed: () => setState(() => _stats.removeAt(i))),
              ])); }).toList()),
        ),
      ])),
    ]));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WORKS EDITOR
// ─────────────────────────────────────────────────────────────────────────────
class WorksEditor extends StatefulWidget {
  const WorksEditor({super.key});
  @override State<WorksEditor> createState() => _WorksEditorState();
}
class _WorksEditorState extends State<WorksEditor> {
  List<Map<String,dynamic>> _projects = []; bool _vis = true, _loading = true, _saving = false;
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final doc = await FirebaseFirestore.instance.collection('sections').doc('works_section').get();
    if (doc.exists) { final d = doc.data()!; setState(() { _projects = List<Map<String,dynamic>>.from(d['projects'] ?? []); _vis = d['visible'] ?? true; }); }
    setState(() => _loading = false);
  }
  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await FirebaseFirestore.instance.collection('sections').doc('works_section').set({
        'order': 4, 'visible': _vis, 'title': 'Our Projects', 'subtitle': 'Innovative solutions making a difference', 'projects': _projects, 'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      if (mounted) _snack(context, '✓ Works saved!');
    } catch (e) { if (mounted) _snack(context, 'Error: $e', err: true); }
    finally { setState(() => _saving = false); }
  }
  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: _C.leaf));
    return SingleChildScrollView(child: Column(children: [
      _PageHeader(title: 'Our Works', sub: 'Showcase your projects and case studies', vis: _vis, onVis: (v) => setState(() => _vis = v),
        actions: [
          _Btn(label: '+ Add Project', icon: Icons.add_rounded, ghost: true, onTap: () => setState(() => _projects.add({'title':'','description':'','image':'','category':''}))),
          const SizedBox(width: 10),
          _Btn(label: _saving ? 'Saving…' : 'Save', icon: Icons.save_outlined, onTap: _saving ? () {} : _save),
        ]),
      Padding(padding: const EdgeInsets.fromLTRB(28, 0, 28, 28), child: _projects.isEmpty
        ? _Empty(icon: Icons.work_outline_rounded, title: 'No projects yet', sub: 'Showcase your work', btn: 'Add Project',
            onTap: () => setState(() => _projects.add({'title':'','description':'','image':'','category':''})))
        : Column(children: _projects.asMap().entries.map((e) { final i = e.key; return Padding(padding: const EdgeInsets.only(bottom: 14), child: _Card(child: Column(children: [
            Row(children: [Text('Project ${i+1}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _C.ink)), const Spacer(),
              IconButton(icon: const Icon(Icons.delete_outline_rounded, color: _C.rose, size: 18), onPressed: () => setState(() => _projects.removeAt(i)))]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _Field(label: 'TITLE', hint: 'Smart Irrigation System', init: _projects[i]['title'], onChange: (v) => _projects[i]['title'] = v, req: true)),
              const SizedBox(width: 14),
              Expanded(child: _Field(label: 'CATEGORY', hint: 'Technology', init: _projects[i]['category'], onChange: (v) => _projects[i]['category'] = v)),
            ]),
            const SizedBox(height: 12),
            _Field(label: 'IMAGE URL', hint: 'https://…', init: _projects[i]['image'], onChange: (v) => _projects[i]['image'] = v),
            const SizedBox(height: 12),
            _Field(label: 'DESCRIPTION', hint: 'Project description…', init: _projects[i]['description'], onChange: (v) => _projects[i]['description'] = v, lines: 3),
          ]))); }).toList()),
      ),
    ]));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MISSION EDITOR
// ─────────────────────────────────────────────────────────────────────────────
class MissionEditor extends StatefulWidget {
  const MissionEditor({super.key});
  @override State<MissionEditor> createState() => _MissionEditorState();
}
class _MissionEditorState extends State<MissionEditor> {
  final _mission = TextEditingController(); final _vision = TextEditingController();
  List<Map<String,dynamic>> _values = []; bool _vis = true, _loading = true, _saving = false;
  @override void initState() { super.initState(); _load(); }
  @override void dispose() { _mission.dispose(); _vision.dispose(); super.dispose(); }
  Future<void> _load() async {
    final doc = await FirebaseFirestore.instance.collection('sections').doc('mission_section').get();
    if (doc.exists) { final d = doc.data()!; setState(() { _mission.text = d['mission'] ?? ''; _vision.text = d['vision'] ?? ''; _values = List<Map<String,dynamic>>.from(d['values'] ?? []); _vis = d['visible'] ?? true; }); }
    setState(() => _loading = false);
  }
  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await FirebaseFirestore.instance.collection('sections').doc('mission_section').set({
        'order': 5, 'visible': _vis, 'mission': _mission.text.trim(), 'vision': _vision.text.trim(), 'values': _values, 'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      if (mounted) _snack(context, '✓ Mission saved!');
    } catch (e) { if (mounted) _snack(context, 'Error: $e', err: true); }
    finally { setState(() => _saving = false); }
  }
  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: _C.leaf));
    return SingleChildScrollView(child: Column(children: [
      _PageHeader(title: 'Mission', sub: 'Define your purpose and values', vis: _vis, onVis: (v) => setState(() => _vis = v),
        actions: [_Btn(label: _saving ? 'Saving…' : 'Save', icon: Icons.save_outlined, onTap: _saving ? () {} : _save)]),
      Padding(padding: const EdgeInsets.fromLTRB(28, 0, 28, 28), child: Column(children: [
        _Card(title: 'Mission & Vision', icon: Icons.flag_outlined, child: Column(children: [
          _Field(label: 'MISSION STATEMENT', hint: 'To empower smallholder farmers…', ctrl: _mission, lines: 3, req: true),
          const SizedBox(height: 14),
          _Field(label: 'VISION STATEMENT', hint: 'A thriving agricultural sector…', ctrl: _vision, lines: 3),
        ])),
        const SizedBox(height: 18),
        _Card(title: 'Core Values', icon: Icons.star_outline_rounded,
          trailing: _Btn(label: '+ Add Value', icon: Icons.add_rounded, ghost: true, onTap: () => setState(() => _values.add({'title':'','description':'','icon':''}))),
          child: _values.isEmpty
            ? Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Text('No values added yet.', style: TextStyle(color: _C.ash))))
            : Column(children: _values.asMap().entries.map((e) { final i = e.key; return Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(children: [
                Expanded(child: _Field(label: 'EMOJI', hint: '💡', init: _values[i]['icon'], onChange: (v) => _values[i]['icon'] = v)),
                const SizedBox(width: 10),
                Expanded(flex: 2, child: _Field(label: 'TITLE', hint: 'Innovation', init: _values[i]['title'], onChange: (v) => _values[i]['title'] = v)),
                const SizedBox(width: 10),
                Expanded(flex: 3, child: _Field(label: 'DESCRIPTION', hint: 'Constantly seeking…', init: _values[i]['description'], onChange: (v) => _values[i]['description'] = v)),
                const SizedBox(width: 6),
                IconButton(icon: const Icon(Icons.delete_outline_rounded, color: _C.rose, size: 18), onPressed: () => setState(() => _values.removeAt(i))),
              ])); }).toList()),
        ),
      ])),
    ]));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// IMPACT EDITOR
// ─────────────────────────────────────────────────────────────────────────────
class ImpactEditor extends StatefulWidget {
  const ImpactEditor({super.key});
  @override State<ImpactEditor> createState() => _ImpactEditorState();
}
class _ImpactEditorState extends State<ImpactEditor> {
  List<Map<String,dynamic>> _stories = []; bool _vis = true, _loading = true, _saving = false;
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final doc = await FirebaseFirestore.instance.collection('sections').doc('impact_section').get();
    if (doc.exists) { final d = doc.data()!; setState(() { _stories = List<Map<String,dynamic>>.from(d['stories'] ?? []); _vis = d['visible'] ?? true; }); }
    setState(() => _loading = false);
  }
  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await FirebaseFirestore.instance.collection('sections').doc('impact_section').set({
        'order': 6, 'visible': _vis, 'title': 'Our Impact', 'subtitle': 'Making a real difference', 'stories': _stories, 'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      if (mounted) _snack(context, '✓ Impact saved!');
    } catch (e) { if (mounted) _snack(context, 'Error: $e', err: true); }
    finally { setState(() => _saving = false); }
  }
  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: _C.leaf));
    return SingleChildScrollView(child: Column(children: [
      _PageHeader(title: 'Impact', sub: 'Share farmer success stories', vis: _vis, onVis: (v) => setState(() => _vis = v),
        actions: [
          _Btn(label: '+ Add Story', icon: Icons.add_rounded, ghost: true, onTap: () => setState(() => _stories.add({'farmer':'','location':'','story':'','image':''}))),
          const SizedBox(width: 10),
          _Btn(label: _saving ? 'Saving…' : 'Save', icon: Icons.save_outlined, onTap: _saving ? () {} : _save),
        ]),
      Padding(padding: const EdgeInsets.fromLTRB(28, 0, 28, 28), child: _stories.isEmpty
        ? _Empty(icon: Icons.trending_up_rounded, title: 'No stories yet', sub: 'Add farmer impact stories', btn: 'Add Story',
            onTap: () => setState(() => _stories.add({'farmer':'','location':'','story':'','image':''})))
        : Column(children: _stories.asMap().entries.map((e) { final i = e.key; return Padding(padding: const EdgeInsets.only(bottom: 14), child: _Card(child: Column(children: [
            Row(children: [Text('Story ${i+1}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _C.ink)), const Spacer(),
              IconButton(icon: const Icon(Icons.delete_outline_rounded, color: _C.rose, size: 18), onPressed: () => setState(() => _stories.removeAt(i)))]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _Field(label: 'FARMER NAME', hint: 'John Mwale', init: _stories[i]['farmer'], onChange: (v) => _stories[i]['farmer'] = v, req: true)),
              const SizedBox(width: 14),
              Expanded(child: _Field(label: 'LOCATION', hint: 'Chongwe District', init: _stories[i]['location'], onChange: (v) => _stories[i]['location'] = v)),
            ]),
            const SizedBox(height: 12),
            _Field(label: 'STORY', hint: 'My yield increased by 40%…', init: _stories[i]['story'], onChange: (v) => _stories[i]['story'] = v, lines: 3),
            const SizedBox(height: 12),
            _Field(label: 'PHOTO URL', hint: 'https://…', init: _stories[i]['image'], onChange: (v) => _stories[i]['image'] = v),
          ]))); }).toList()),
      ),
    ]));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATS EDITOR
// ─────────────────────────────────────────────────────────────────────────────
class StatsEditor extends StatefulWidget {
  const StatsEditor({super.key});
  @override State<StatsEditor> createState() => _StatsEditorState();
}
class _StatsEditorState extends State<StatsEditor> {
  List<Map<String,dynamic>> _stats = []; bool _vis = true, _loading = true, _saving = false;
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final doc = await FirebaseFirestore.instance.collection('sections').doc('stats_section').get();
    if (doc.exists) { final d = doc.data()!; setState(() { _stats = List<Map<String,dynamic>>.from(d['stats'] ?? []); _vis = d['visible'] ?? true; }); }
    setState(() => _loading = false);
  }
  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await FirebaseFirestore.instance.collection('sections').doc('stats_section').set({
        'order': 7, 'visible': _vis, 'stats': _stats, 'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      if (mounted) _snack(context, '✓ Stats saved!');
    } catch (e) { if (mounted) _snack(context, 'Error: $e', err: true); }
    finally { setState(() => _saving = false); }
  }
  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: _C.leaf));
    return SingleChildScrollView(child: Column(children: [
      _PageHeader(title: 'Statistics', sub: 'Edit your key numbers and metrics', vis: _vis, onVis: (v) => setState(() => _vis = v),
        actions: [
          _Btn(label: '+ Add Stat', icon: Icons.add_rounded, ghost: true, onTap: () => setState(() => _stats.add({'label':'','value':'','icon':''}))),
          const SizedBox(width: 10),
          _Btn(label: _saving ? 'Saving…' : 'Save', icon: Icons.save_outlined, onTap: _saving ? () {} : _save),
        ]),
      Padding(padding: const EdgeInsets.fromLTRB(28, 0, 28, 28), child: _stats.isEmpty
        ? _Empty(icon: Icons.bar_chart_rounded, title: 'No stats yet', sub: 'Add your impact numbers', btn: 'Add Stat',
            onTap: () => setState(() => _stats.add({'label':'','value':'','icon':''})))
        : _Card(child: Column(children: [
            Row(children: [
              Expanded(child: Text('ICON', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _C.ash))),
              const SizedBox(width: 10),
              Expanded(flex: 2, child: Text('VALUE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _C.ash))),
              const SizedBox(width: 10),
              Expanded(flex: 3, child: Text('LABEL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _C.ash))),
              const SizedBox(width: 36),
            ]),
            const SizedBox(height: 10),
            ..._stats.asMap().entries.map((e) { final i = e.key; return Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [
              Expanded(child: _Field(label: '', hint: '👨‍🌾', init: _stats[i]['icon'], onChange: (v) => _stats[i]['icon'] = v)),
              const SizedBox(width: 10),
              Expanded(flex: 2, child: _Field(label: '', hint: '10,000+', init: _stats[i]['value'], onChange: (v) => _stats[i]['value'] = v)),
              const SizedBox(width: 10),
              Expanded(flex: 3, child: _Field(label: '', hint: 'Farmers Impacted', init: _stats[i]['label'], onChange: (v) => _stats[i]['label'] = v)),
              const SizedBox(width: 6),
              IconButton(icon: const Icon(Icons.delete_outline_rounded, color: _C.rose, size: 18), onPressed: () => setState(() => _stats.removeAt(i))),
            ])); }),
          ])),
      ),
    ]));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ACHIEVEMENTS EDITOR
// ─────────────────────────────────────────────────────────────────────────────
class AchievementsEditor extends StatefulWidget {
  const AchievementsEditor({super.key});
  @override State<AchievementsEditor> createState() => _AchievementsEditorState();
}
class _AchievementsEditorState extends State<AchievementsEditor> {
  List<Map<String,dynamic>> _items = []; bool _vis = true, _loading = true, _saving = false;
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final doc = await FirebaseFirestore.instance.collection('sections').doc('achievements_section').get();
    if (doc.exists) { final d = doc.data()!; setState(() { _items = List<Map<String,dynamic>>.from(d['achievements'] ?? []); _vis = d['visible'] ?? true; }); }
    setState(() => _loading = false);
  }
  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await FirebaseFirestore.instance.collection('sections').doc('achievements_section').set({
        'order': 8, 'visible': _vis, 'title': 'Our Achievements', 'achievements': _items, 'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      if (mounted) _snack(context, '✓ Achievements saved!');
    } catch (e) { if (mounted) _snack(context, 'Error: $e', err: true); }
    finally { setState(() => _saving = false); }
  }
  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: _C.leaf));
    return SingleChildScrollView(child: Column(children: [
      _PageHeader(title: 'Achievements', sub: 'Highlight your milestones and awards', vis: _vis, onVis: (v) => setState(() => _vis = v),
        actions: [
          _Btn(label: '+ Add', icon: Icons.add_rounded, ghost: true, onTap: () => setState(() => _items.add({'year':'${DateTime.now().year}','title':'','description':''}))),
          const SizedBox(width: 10),
          _Btn(label: _saving ? 'Saving…' : 'Save', icon: Icons.save_outlined, onTap: _saving ? () {} : _save),
        ]),
      Padding(padding: const EdgeInsets.fromLTRB(28, 0, 28, 28), child: _items.isEmpty
        ? _Empty(icon: Icons.emoji_events_outlined, title: 'No achievements yet', sub: 'Add your milestones', btn: 'Add Achievement',
            onTap: () => setState(() => _items.add({'year':'${DateTime.now().year}','title':'','description':''})))
        : Column(children: _items.asMap().entries.map((e) { final i = e.key; return Padding(padding: const EdgeInsets.only(bottom: 14), child: _Card(child: Column(children: [
            Row(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: _C.amber.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(_items[i]['year'] ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _C.amber))),
              const SizedBox(width: 10),
              Expanded(child: Text(_items[i]['title']?.isNotEmpty == true ? _items[i]['title'] : 'New Achievement', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _C.ink))),
              IconButton(icon: const Icon(Icons.delete_outline_rounded, color: _C.rose, size: 18), onPressed: () => setState(() => _items.removeAt(i))),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              SizedBox(width: 100, child: _Field(label: 'YEAR', hint: '2024', init: _items[i]['year'], onChange: (v) => _items[i]['year'] = v)),
              const SizedBox(width: 14),
              Expanded(child: _Field(label: 'TITLE', hint: 'National Agriculture Award', init: _items[i]['title'], onChange: (v) => _items[i]['title'] = v, req: true)),
            ]),
            const SizedBox(height: 12),
            _Field(label: 'DESCRIPTION', hint: 'Brief description…', init: _items[i]['description'], onChange: (v) => _items[i]['description'] = v, lines: 2),
          ]))); }).toList()),
      ),
    ]));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PARTNERS EDITOR
// ─────────────────────────────────────────────────────────────────────────────
class PartnersEditor extends StatefulWidget {
  const PartnersEditor({super.key});
  @override State<PartnersEditor> createState() => _PartnersEditorState();
}
class _PartnersEditorState extends State<PartnersEditor> {
  List<Map<String,dynamic>> _logos = []; bool _vis = true, _loading = true, _saving = false;
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final doc = await FirebaseFirestore.instance.collection('sections').doc('partners_section').get();
    if (doc.exists) { final d = doc.data()!; setState(() { _logos = List<Map<String,dynamic>>.from(d['logos'] ?? []); _vis = d['visible'] ?? true; }); }
    setState(() => _loading = false);
  }
  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await FirebaseFirestore.instance.collection('sections').doc('partners_section').set({
        'order': 10, 'visible': _vis, 'title': 'Our Partners', 'subtitle': 'Working together for transformation', 'logos': _logos, 'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      if (mounted) _snack(context, '✓ Partners saved!');
    } catch (e) { if (mounted) _snack(context, 'Error: $e', err: true); }
    finally { setState(() => _saving = false); }
  }
  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: _C.leaf));
    return SingleChildScrollView(child: Column(children: [
      _PageHeader(title: 'Partners', sub: 'Manage partner logos and links', vis: _vis, onVis: (v) => setState(() => _vis = v),
        actions: [
          _Btn(label: '+ Add Partner', icon: Icons.add_rounded, ghost: true, onTap: () => setState(() => _logos.add({'name':'','image':'','link':'#'}))),
          const SizedBox(width: 10),
          _Btn(label: _saving ? 'Saving…' : 'Save', icon: Icons.save_outlined, onTap: _saving ? () {} : _save),
        ]),
      Padding(padding: const EdgeInsets.fromLTRB(28, 0, 28, 28), child: _logos.isEmpty
        ? _Empty(icon: Icons.handshake_outlined, title: 'No partners yet', sub: 'Add your partner organisations', btn: 'Add Partner',
            onTap: () => setState(() => _logos.add({'name':'','image':'','link':'#'})))
        : Column(children: _logos.asMap().entries.map((e) { final i = e.key; return Padding(padding: const EdgeInsets.only(bottom: 14), child: _Card(child: Column(children: [
            Row(children: [Text('Partner ${i+1}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _C.ink)), const Spacer(),
              IconButton(icon: const Icon(Icons.delete_outline_rounded, color: _C.rose, size: 18), onPressed: () => setState(() => _logos.removeAt(i)))]),
            const SizedBox(height: 12),
            _Field(label: 'PARTNER NAME', hint: 'Ministry of Agriculture', init: _logos[i]['name'], onChange: (v) => _logos[i]['name'] = v, req: true),
            const SizedBox(height: 12),
            _Field(label: 'LOGO URL', hint: 'https://…', init: _logos[i]['image'], onChange: (v) => _logos[i]['image'] = v),
            const SizedBox(height: 12),
            _Field(label: 'LINK', hint: 'https://…', init: _logos[i]['link'], onChange: (v) => _logos[i]['link'] = v),
          ]))); }).toList()),
      ),
    ]));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CONTACT EDITOR
// ─────────────────────────────────────────────────────────────────────────────
class ContactEditor extends StatefulWidget {
  const ContactEditor({super.key});
  @override State<ContactEditor> createState() => _ContactEditorState();
}
class _ContactEditorState extends State<ContactEditor> {
  final _title = TextEditingController(); final _sub = TextEditingController();
  final _email = TextEditingController(); final _phone = TextEditingController();
  final _address = TextEditingController(); final _fbUrl = TextEditingController();
  final _twUrl = TextEditingController(); final _liUrl = TextEditingController();
  final _igUrl = TextEditingController();
  double _lat = -15.4167, _lng = 28.2833;
  bool _vis = true, _loading = true, _saving = false;
  @override void initState() { super.initState(); _load(); }
  @override void dispose() { for (var c in [_title,_sub,_email,_phone,_address,_fbUrl,_twUrl,_liUrl,_igUrl]) {
    c.dispose();
  } super.dispose(); }
  Future<void> _load() async {
    final doc = await FirebaseFirestore.instance.collection('sections').doc('contact_section').get();
    if (doc.exists) { final d = doc.data()!;
      final soc = Map<String,dynamic>.from(d['socialLinks'] ?? {});
      final map = Map<String,dynamic>.from(d['mapCoordinates'] ?? {});
      setState(() {
        _title.text = d['title'] ?? ''; _sub.text = d['subtitle'] ?? '';
        _email.text = d['email'] ?? ''; _phone.text = d['phone'] ?? ''; _address.text = d['address'] ?? '';
        _fbUrl.text = soc['facebook'] ?? ''; _twUrl.text = soc['twitter'] ?? '';
        _liUrl.text = soc['linkedin'] ?? ''; _igUrl.text = soc['instagram'] ?? '';
        _lat = (map['lat'] ?? -15.4167).toDouble(); _lng = (map['lng'] ?? 28.2833).toDouble();
        _vis = d['visible'] ?? true;
      });
    }
    setState(() => _loading = false);
  }
  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await FirebaseFirestore.instance.collection('sections').doc('contact_section').set({
        'order': 11, 'visible': _vis, 'title': _title.text.trim(), 'subtitle': _sub.text.trim(),
        'email': _email.text.trim(), 'phone': _phone.text.trim(), 'address': _address.text.trim(),
        'socialLinks': {'facebook': _fbUrl.text.trim(), 'twitter': _twUrl.text.trim(), 'linkedin': _liUrl.text.trim(), 'instagram': _igUrl.text.trim()},
        'mapCoordinates': {'lat': _lat, 'lng': _lng},
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      if (mounted) _snack(context, '✓ Contact section saved!');
    } catch (e) { if (mounted) _snack(context, 'Error: $e', err: true); }
    finally { setState(() => _saving = false); }
  }
  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: _C.leaf));
    return SingleChildScrollView(child: Column(children: [
      _PageHeader(title: 'Contact', sub: 'Edit contact details and social links', vis: _vis, onVis: (v) => setState(() => _vis = v),
        actions: [_Btn(label: _saving ? 'Saving…' : 'Save', icon: Icons.save_outlined, onTap: _saving ? () {} : _save)]),
      Padding(padding: const EdgeInsets.fromLTRB(28, 0, 28, 28), child: Column(children: [
        _Card(title: 'Section Header', icon: Icons.edit_rounded, child: Row(children: [
          Expanded(child: _Field(label: 'TITLE', hint: 'Get In Touch', ctrl: _title, req: true)),
          const SizedBox(width: 14),
          Expanded(child: _Field(label: 'SUBTITLE', hint: "We'd love to hear from you", ctrl: _sub)),
        ])),
        const SizedBox(height: 18),
        _Card(title: 'Contact Details', icon: Icons.contact_phone_outlined, child: Column(children: [
          Row(children: [
            Expanded(child: _Field(label: 'EMAIL', hint: 'info@agreenect.com', icon: Icons.email_outlined, ctrl: _email)),
            const SizedBox(width: 14),
            Expanded(child: _Field(label: 'PHONE', hint: '+260 XXX XXX XXX', icon: Icons.phone_outlined, ctrl: _phone)),
          ]),
          const SizedBox(height: 14),
          _Field(label: 'ADDRESS', hint: 'Lusaka, Zambia', icon: Icons.location_on_outlined, ctrl: _address),
        ])),
        const SizedBox(height: 18),
        _Card(title: 'Social Links', icon: Icons.share_outlined, child: Column(children: [
          Row(children: [
            Expanded(child: _Field(label: 'FACEBOOK', hint: 'https://facebook.com/agreenect', ctrl: _fbUrl)),
            const SizedBox(width: 14),
            Expanded(child: _Field(label: 'TWITTER', hint: 'https://twitter.com/agreenect', ctrl: _twUrl)),
          ]),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: _Field(label: 'LINKEDIN', hint: 'https://linkedin.com/company/agreenect', ctrl: _liUrl)),
            const SizedBox(width: 14),
            Expanded(child: _Field(label: 'INSTAGRAM', hint: 'https://instagram.com/agreenect', ctrl: _igUrl)),
          ]),
        ])),
        const SizedBox(height: 18),
        _Card(title: 'Map Coordinates', icon: Icons.map_outlined, child: Row(children: [
          Expanded(child: _Field(label: 'LATITUDE', hint: '-15.4167', init: _lat.toString(), onChange: (v) => _lat = double.tryParse(v) ?? _lat)),
          const SizedBox(width: 14),
          Expanded(child: _Field(label: 'LONGITUDE', hint: '28.2833', init: _lng.toString(), onChange: (v) => _lng = double.tryParse(v) ?? _lng)),
        ])),
      ])),
    ]));
  }
}