// Admin Login with Firebase Authentication
// Save as: lib/admin/admin_login_page.dart

import 'package:agreenect/screens/Admin/admin_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  late AnimationController _leafController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _leafController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _leafController.dispose();
    _fadeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Sign in with Firebase Authentication
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Check if user is an admin
      final adminDoc = await FirebaseFirestore.instance
          .collection('admin_users')
          .doc(userCredential.user!.uid)
          .get();

      if (!adminDoc.exists) {
        // Not an admin user
        await FirebaseAuth.instance.signOut();
        setState(() => _errorMessage = 'Access denied. Admin privileges required.');
        return;
      }

      // Check if account is active
      final isActive = adminDoc.data()?['isActive'] as bool? ?? false;
      if (!isActive) {
        await FirebaseAuth.instance.signOut();
        setState(() => _errorMessage = 'Account is disabled. Contact administrator.');
        return;
      }

      // Success - navigate to admin panel
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many failed attempts. Please try again later.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid email or password.';
          break;
        default:
          errorMessage = 'Login failed: ${e.message}';
      }
      setState(() => _errorMessage = errorMessage);
    } catch (e) {
      setState(() => _errorMessage = 'Connection error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F0F),
      body: Stack(
        children: [
          // Animated background elements
          _AnimatedBackground(controller: _leafController),

          // Main content
          FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo / Brand
                    _buildLogo(),
                    const SizedBox(height: 48),

                    // Login Card
                    _buildLoginCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF1A3A1C),
            border: Border.all(color: const Color(0xFF4CAF50), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'A',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w900,
                color: Color(0xFF4CAF50),
                fontFamily: 'serif',
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'AGREENECT',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Color(0xFFE8F5E9),
            letterSpacing: 8,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Admin Portal',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF81C784),
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      decoration: BoxDecoration(
        color: const Color(0xFF122114),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF2E5C30),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      padding: const EdgeInsets.all(40),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFFE8F5E9),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Sign in to manage your platform',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF81C784),
              ),
            ),
            const SizedBox(height: 36),

            // Email field
            _buildLabel('Email Address'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _emailController,
              hint: 'admin@agreenect.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email is required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Password field
            _buildLabel('Password'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _passwordController,
              hint: '••••••••',
              icon: Icons.lock_outline,
              obscure: _obscurePassword,
              suffix: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0xFF4CAF50),
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required';
                if (v.length < 6) return 'Password too short';
                return null;
              },
            ),

            // Error message
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.redAccent, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Login button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 24),

            // Footer note
            Center(
              child: Text(
                'Restricted access · Agreenect © ${DateTime.now().year}',
                style: TextStyle(
                  fontSize: 11,
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.5),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFFB2DFDB),
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Color(0xFFE8F5E9), fontSize: 15),
      cursorColor: const Color(0xFF4CAF50),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            TextStyle(color: const Color(0xFF4CAF50).withValues(alpha: 0.3)),
        prefixIcon: Icon(icon, color: const Color(0xFF4CAF50), size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFF0D1F0F),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E5C30)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E5C30)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
        ),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
    );
  }
}

// ── Animated floating leaf particles in background ──────────────────────────
class _AnimatedBackground extends StatelessWidget {
  final AnimationController controller;
  const _AnimatedBackground({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _LeafPainter(controller.value),
        );
      },
    );
  }
}

class _LeafPainter extends CustomPainter {
  final double t;
  _LeafPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final List<_Particle> particles = [
      _Particle(0.1, 0.2, 18, 0.0),
      _Particle(0.3, 0.7, 12, 0.3),
      _Particle(0.6, 0.15, 22, 0.6),
      _Particle(0.8, 0.5, 15, 0.1),
      _Particle(0.5, 0.85, 10, 0.8),
      _Particle(0.9, 0.9, 20, 0.4),
      _Particle(0.15, 0.55, 14, 0.7),
      _Particle(0.7, 0.35, 16, 0.2),
    ];

    for (final p in particles) {
      final phase = (t + p.phase) % 1.0;
      final y = (p.baseY + phase * 0.3) % 1.0;
      final x = p.baseX + math.sin(phase * math.pi * 2) * 0.05;

      final paint = Paint()
        ..color =
            const Color(0xFF4CAF50).withValues(alpha: 0.08 + p.phase * 0.06)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x * size.width, y * size.height);
      canvas.rotate(phase * math.pi * 2);
      _drawLeaf(canvas, paint, p.size);
      canvas.restore();
    }

    // Radial glow at center
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF1B5E20).withValues(alpha: 0.3),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width * 0.6,
        ),
      );
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.6,
      glowPaint,
    );
  }

  void _drawLeaf(Canvas canvas, Paint paint, double size) {
    final path = Path();
    path.moveTo(0, -size);
    path.quadraticBezierTo(size * 0.8, -size * 0.4, size * 0.3, size * 0.4);
    path.quadraticBezierTo(0, size * 0.6, -size * 0.3, size * 0.4);
    path.quadraticBezierTo(-size * 0.8, -size * 0.4, 0, -size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_LeafPainter old) => old.t != t;
}

class _Particle {
  final double baseX, baseY, size, phase;
  const _Particle(this.baseX, this.baseY, this.size, this.phase);
}