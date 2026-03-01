// lib/screens/contact_dynamic.dart
// Live DynamicContactSection — reads from Firestore contact_section

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agreenect/utils/responsivenes.dart';

class DynamicContactSection extends StatelessWidget {
  const DynamicContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('sections')
          .doc('contact_section')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: isMobile ? 60 : 80),
            color: const Color(0xFFF5F7F2),
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFF4A9B6A)),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        if (data['visible'] == false) return const SizedBox.shrink();

        final String title    = data['title']    ?? 'Get In Touch';
        final String subtitle = data['subtitle'] ?? '';
        final String email    = data['email']    ?? '';
        final String phone    = data['phone']    ?? '';
        final String address  = data['address']  ?? '';

        return _ContactLayout(
          title: title,
          subtitle: subtitle,
          email: email,
          phone: phone,
          address: address,
          isMobile: isMobile,
        );
      },
    );
  }
}

// =============================================================================
// LAYOUT SHELL
// =============================================================================
class _ContactLayout extends StatelessWidget {
  final String title, subtitle, email, phone, address;
  final bool isMobile;

  const _ContactLayout({
    required this.title,
    required this.subtitle,
    required this.email,
    required this.phone,
    required this.address,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final contactItems = [
      if (email.isNotEmpty)
        _ContactInfo(
          icon: Icons.email_rounded,
          label: 'Email Us',
          detail: email,
          color: const Color(0xFF4A9B6A),
        ),
      if (phone.isNotEmpty)
        _ContactInfo(
          icon: Icons.phone_rounded,
          label: 'Call Us',
          detail: phone,
          color: const Color(0xFF4A9FD4),
        ),
      if (address.isNotEmpty)
        _ContactInfo(
          icon: Icons.location_on_rounded,
          label: 'Visit Us',
          detail: address,
          color: const Color(0xFFF5A623),
        ),
    ];

    return Container(
      color: const Color(0xFFF5F7F2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Dark header banner ────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 48 : 64,
              horizontal: isMobile ? 24 : 80,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F2419), Color(0xFF1A3A2A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon badge
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A9B6A).withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF7FD17A).withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.mail_outline_rounded,
                    size: 34,
                    color: Color(0xFF7FD17A),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 28 : 38,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                    height: 1.2,
                  ),
                ),

                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        color: Colors.white.withOpacity(0.65),
                        height: 1.6,
                      ),
                    ),
                  ),
                ],

                // Contact info chips row
                if (contactItems.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: contactItems.map((c) => _HeaderChip(info: c)).toList(),
                  ),
                ],
              ],
            ),
          ),

          // ── Body ──────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: isMobile ? 40 : 64,
              horizontal: isMobile ? 20 : 80,
            ),
            child: isMobile
                ? _MobileBody(contactItems: contactItems, email: email)
                : _DesktopBody(contactItems: contactItems, email: email),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// HEADER CHIP (small contact pill in the banner)
// =============================================================================
class _ContactInfo {
  final IconData icon;
  final String label, detail;
  final Color color;
  const _ContactInfo({
    required this.icon,
    required this.label,
    required this.detail,
    required this.color,
  });
}

class _HeaderChip extends StatelessWidget {
  final _ContactInfo info;
  const _HeaderChip({required this.info});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: info.color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: info.color.withOpacity(0.35)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(info.icon, size: 14, color: info.color),
      const SizedBox(width: 7),
      Text(
        info.detail,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: info.color,
        ),
      ),
    ]),
  );
}

// =============================================================================
// DESKTOP — 2 col: contact cards left, form right
// =============================================================================
class _DesktopBody extends StatelessWidget {
  final List<_ContactInfo> contactItems;
  final String email;
  const _DesktopBody({required this.contactItems, required this.email});

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Left: contact cards
      SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < contactItems.length; i++) ...[
              if (i > 0) const SizedBox(height: 16),
              _ContactCard(info: contactItems[i]),
            ],
          ],
        ),
      ),
      const SizedBox(width: 48),

      // Right: form
      Expanded(child: _FormCard(email: email)),
    ],
  );
}

// =============================================================================
// MOBILE — stacked
// =============================================================================
class _MobileBody extends StatelessWidget {
  final List<_ContactInfo> contactItems;
  final String email;
  const _MobileBody({required this.contactItems, required this.email});

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (contactItems.isNotEmpty) ...[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < contactItems.length; i++) ...[
              if (i > 0) const SizedBox(height: 14),
              _ContactCard(info: contactItems[i]),
            ],
          ],
        ),
        const SizedBox(height: 32),
      ],
      _FormCard(email: email),
    ],
  );
}

// =============================================================================
// CONTACT CARD
// =============================================================================
class _ContactCard extends StatelessWidget {
  final _ContactInfo info;
  const _ContactCard({required this.info});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: info.color.withOpacity(0.15)),
      boxShadow: [
        BoxShadow(
          color: info.color.withOpacity(0.08),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: info.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(info.icon, color: info.color, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                info.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: info.color,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                info.detail,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1C2A1E),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// =============================================================================
// FORM CARD
// =============================================================================
class _FormCard extends StatelessWidget {
  final String email;
  const _FormCard({required this.email});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form header
          Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF4A9B6A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.edit_note_rounded,
                color: Color(0xFF4A9B6A),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Send a Message',
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 22,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1C2A1E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'We reply within 24 hours',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ]),
          const SizedBox(height: 28),
          const Divider(height: 1, color: Color(0xFFEEF2ED)),
          const SizedBox(height: 28),

          _ContactForm(isMobile: isMobile, recipientEmail: email),
        ],
      ),
    );
  }
}

// =============================================================================
// CONTACT FORM
// =============================================================================
class _ContactForm extends StatefulWidget {
  final bool isMobile;
  final String recipientEmail;

  const _ContactForm({required this.isMobile, required this.recipientEmail});

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey          = GlobalKey<FormState>();
  final _nameController   = TextEditingController();
  final _emailController  = TextEditingController();
  final _messageController= TextEditingController();
  bool _isSubmitting = false;
  bool _sent         = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      await FirebaseFirestore.instance.collection('contact_messages').add({
        'name':      _nameController.text.trim(),
        'email':     _emailController.text.trim(),
        'message':   _messageController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'status':    'unread',
      });
      if (mounted) {
        setState(() { _sent = true; _isSubmitting = false; });
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ── Success state ─────────────────────────────────────────────────────
    if (_sent) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF4A9B6A).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                color: Color(0xFF4A9B6A),
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Message Sent!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1C2A1E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We'll get back to you within 24 hours.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => setState(() => _sent = false),
              child: const Text(
                'Send another message',
                style: TextStyle(color: Color(0xFF4A9B6A), fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }

    // ── Form ──────────────────────────────────────────────────────────────
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name + Email side-by-side on desktop
          widget.isMobile
              ? Column(mainAxisSize: MainAxisSize.min, children: [
                  _field(
                    controller: _nameController,
                    label: 'Your Name',
                    hint: 'Moses Mwamba',
                    icon: Icons.person_outline_rounded,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  _field(
                    controller: _emailController,
                    label: 'Email Address',
                    hint: 'moses@example.com',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                  ),
                ])
              : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: _field(
                    controller: _nameController,
                    label: 'Your Name',
                    hint: 'Moses Mwamba',
                    icon: Icons.person_outline_rounded,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  )),
                  const SizedBox(width: 16),
                  Expanded(child: _field(
                    controller: _emailController,
                    label: 'Email Address',
                    hint: 'moses@example.com',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                  )),
                ]),
          const SizedBox(height: 16),

          // Message
          _field(
            controller: _messageController,
            label: 'Message',
            hint: 'Tell us how we can help...',
            icon: Icons.chat_bubble_outline_rounded,
            maxLines: 5,
            alignLabelWithHint: true,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              if (v.trim().length < 10) return 'At least 10 characters';
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Submit button
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D5A3D),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Send Message',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.send_rounded, size: 17),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool alignLabelWithHint = false,
  }) {
    const accent  = Color(0xFF4A9B6A);
    const border  = Color(0xFFDDE4D8);

    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1C2A1E)),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
        labelStyle: const TextStyle(color: Color(0xFF8A9E88), fontSize: 13),
        alignLabelWithHint: alignLabelWithHint,
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: maxLines > 1 ? (maxLines * 12.0) : 0),
          child: Icon(icon, size: 18, color: const Color(0xFF8A9E88)),
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAF7),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE85D75), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE85D75), width: 2),
        ),
      ),
    );
  }
}