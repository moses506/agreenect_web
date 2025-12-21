// ============================================
// FILE: widgets/hero_section.dart
// ============================================
import 'package:flutter/material.dart';
import 'package:agreenect/utils/responsivenes.dart';
import 'package:url_launcher/url_launcher.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  // Launch YouTube video
  Future<void> _launchYouTube() async {
    final Uri url = Uri.parse('https://youtu.be/csG7x8U0WxI?feature=shared');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  // Launch Play Store
  Future<void> _launchPlayStore() async {
    // Replace with your actual Play Store app ID
    final Uri url = Uri.parse('https://play.google.com/store/apps/details?id=YOUR_APP_PACKAGE_NAME');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    return Container(
      height: isMobile ? null : MediaQuery.of(context).size.height * 0.9,
      constraints: isMobile ? const BoxConstraints(minHeight: 600) : null,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A4439), Color(0xFF0F5A4A), Colors.green.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          if (!isMobile) ..._buildBackgroundPattern(),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 40,
              vertical: isMobile ? 40 : 60,
            ),
            child: isMobile || isTablet
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _HeroContent(
                        onGetStarted: _launchPlayStore,
                        onWatchDemo: _launchYouTube,
                      ),
                      const SizedBox(height: 40),
                      _HeroImage(),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: _HeroContent(
                          onGetStarted: _launchPlayStore,
                          onWatchDemo: _launchYouTube,
                        ),
                      ),
                      Expanded(flex: 4, child: _HeroImage()),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBackgroundPattern() {
    return [
      Positioned(
        right: -100,
        top: 100,
        child: Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.05),
          ),
        ),
      ),
      Positioned(
        left: -200,
        bottom: -100,
        child: Container(
          width: 500,
          height: 500,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.03),
          ),
        ),
      ),
    ];
  }
}

class _HeroContent extends StatelessWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onWatchDemo;

  const _HeroContent({
    required this.onGetStarted,
    required this.onWatchDemo,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            '🌱 Youth-Led Innovation',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.green[800],
            ),
          ),
        ),
        const SizedBox(height: 30),
        Text(
          'Transforming Agriculture\nThrough Digital Innovation',
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: isMobile ? 28 : (MediaQuery.of(context).size.width > 800 ? 48 : 36),
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 25),
        Text(
          'AgreeNect empowers Zambian smallholder farmers with cutting-edge digital solutions to increase productivity, restore degraded land, and build climate resilience for sustainable agriculture.',
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            color: Colors.white.withValues(alpha: 0.9),
            height: 1.7,
          ),
        ),
        const SizedBox(height: 40),
        isMobile
            ? Column(
                children: [
                  _HeroButton(
                    isPrimary: true,
                    onPressed: onGetStarted,
                  ),
                  const SizedBox(height: 15),
                  _HeroButton(
                    isPrimary: false,
                    onPressed: onWatchDemo,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  _HeroButton(
                    isPrimary: true,
                    onPressed: onGetStarted,
                  ),
                  const SizedBox(width: 20),
                  _HeroButton(
                    isPrimary: false,
                    onPressed: onWatchDemo,
                  ),
                ],
              ),
      ],
    );
  }
}

class _HeroButton extends StatelessWidget {
  final bool isPrimary;
  final VoidCallback onPressed;

  const _HeroButton({
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return isPrimary
        ? ElevatedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.rocket_launch, color: Colors.white),
            label: const Text(
              "Get Started",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              minimumSize: Size(isMobile ? double.infinity : 180, 50),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
            ),
          )
        : OutlinedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.play_circle_outline, color: Colors.white),
            label: const Text(
              "Watch Demo",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: Size(isMobile ? double.infinity : 180, 50),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              side: const BorderSide(color: Colors.white, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          );
  }
}

class _HeroImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Container(
      height: isMobile ? 250 : 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.green[100],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/agreenetct_logo-removebg-preview.png',
                  height: isMobile ? 80 : 130,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.agriculture,
                    size: isMobile ? 80 : 120,
                    color: Colors.green[600],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Smart Farming\nSolutions',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}