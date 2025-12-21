import 'package:agreenect/utils/responsivenes.dart';
import 'package:flutter/material.dart';


class CustomNavigationBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(String) onNavigate;

  const CustomNavigationBar({
    super.key,
    required this.scaffoldKey,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final isMobile = ResponsiveUtils.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: isMobile ? 15 : 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLogo(isMobile),
          if (isDesktop)
            _buildDesktopMenu()
          else
            _buildMobileMenuButton(),
        ],
      ),
    );
  }

  Widget _buildLogo(bool isMobile) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(
            'assets/agreenetct_logo-removebg-preview.png',
            height: isMobile ? 25 : 30,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.eco,
              color: Colors.green[700],
              size: isMobile ? 22 : 28,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'AgreeNect',
          style: TextStyle(
            fontSize: isMobile ? 20 : 26,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopMenu() {
    return Row(
      children: [
        _navButton('Home', () => onNavigate('Home')),
        _navButton('About Us', () => onNavigate('About Us')),
        _navButton('Our Works', () => onNavigate('Our Works')),
        _navButton('Impact', () => onNavigate('Impact')),
        _navButton('Achievements', () => onNavigate('Achievements')),
        _navButton('Team', () => onNavigate('Team')),
        _navButton('Contact', () => onNavigate('Contact')),
      ],
    );
  }

  Widget _buildMobileMenuButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(Icons.menu, color: Colors.green[700]),
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
      ),
    );
  }

  Widget _navButton(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0A4439),
          ),
        ),
      ),
    );
  }
}