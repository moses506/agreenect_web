import 'package:agreenect/utils/responsivenes.dart';
import 'package:flutter/material.dart';


class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 50 : 60,
        horizontal: isMobile ? 20 : 40,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A4439), Color(0xFF0F5A4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: isMobile
          ? Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatsCard(
                        number: '300+',
                        label: 'Farmers Trained',
                        icon: Icons.people,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _StatsCard(
                        number: '15+',
                        label: 'Communities',
                        icon: Icons.location_city,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: _StatsCard(
                        number: '95%',
                        label: 'Satisfaction Rate',
                        icon: Icons.thumb_up,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _StatsCard(
                        number: '3+',
                        label: 'Years Experience',
                        icon: Icons.timeline,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatsCard(number: '300+', label: 'Farmers Trained', icon: Icons.people),
                _StatsCard(number: '15+', label: 'Communities', icon: Icons.location_city),
                _StatsCard(number: '95%', label: 'Satisfaction Rate', icon: Icons.thumb_up),
                _StatsCard(number: '3+', label: 'Years Experience', icon: Icons.timeline),
              ],
            ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final String number;
  final String label;
  final IconData icon;

  const _StatsCard({
    required this.number,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Column(
      children: [
        Icon(
          icon,
          size: isMobile ? 30 : 40,
          color: Colors.white.withValues(alpha: 0.8),
        ),
        const SizedBox(height: 15),
        Text(
          number,
          style: TextStyle(
            fontSize: isMobile ? 24 : 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMobile ? 12 : 16,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}