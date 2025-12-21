import 'package:flutter/material.dart';

class MobileSidebar extends StatelessWidget {
  final Function(String) onNavigate;

  const MobileSidebar({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const Divider(),
              Expanded(child: _buildMenuItems()),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              'assets/agreenetct_logo-removebg-preview.png',
              height: 30,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.eco, color: Colors.green[700], size: 28),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'AgreeNect',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      children: [
        _buildSidebarItem('Home', Icons.home, () => onNavigate('Home')),
        _buildSidebarItem('About Us', Icons.info_outline, () => onNavigate('About Us')),
        _buildSidebarItem('Our Works', Icons.work_outline, () => onNavigate('Our Works')),
        _buildSidebarItem('Impact', Icons.trending_up, () => onNavigate('Impact')),
        _buildSidebarItem('Achievements', Icons.star_outline, () => onNavigate('Achievements')),
        _buildSidebarItem('Team', Icons.people_outline, () => onNavigate('Team')),
        _buildSidebarItem('Contact', Icons.contact_mail, () => onNavigate('Contact')),
      ],
    );
  }

  Widget _buildSidebarItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green[600], size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.green[800],
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.rocket_launch, size: 18),
            label: const Text('Get Started'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.play_circle_outline, size: 18),
            label: const Text('Watch Demo'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.green[600],
              side: BorderSide(color: Colors.green[600]!),
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}