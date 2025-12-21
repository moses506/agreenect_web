import 'package:flutter/material.dart';
import 'package:agreenect/utils/responsivenes.dart';

class ImpactSection extends StatelessWidget {
  const ImpactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 80,
        horizontal: isMobile ? 20 : 40,
      ),
      child: Column(
        children: [
          Text(
            'Creating Real Impact',
            style: TextStyle(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'We help farmers implement climate-smart practices, restore degraded soils, adapt to climate variability, and access digital knowledge and markets.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              height: 1.6,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 60),
          isMobile
              ? Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _ImpactCard(
                            icon: Icons.eco,
                            title: 'Climate-Smart\nPractices',
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _ImpactCard(
                            icon: Icons.landscape,
                            title: 'Land\nRestoration',
                            color: Colors.brown,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _ImpactCard(
                            icon: Icons.device_thermostat,
                            title: 'Climate\nResilience',
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _ImpactCard(
                            icon: Icons.trending_up,
                            title: 'Market\nAccess',
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Wrap(
                  spacing: 40,
                  runSpacing: 40,
                  alignment: WrapAlignment.center,
                  children: [
                    _ImpactCard(
                      icon: Icons.eco,
                      title: 'Climate-Smart\nPractices',
                      color: Colors.green,
                    ),
                    _ImpactCard(
                      icon: Icons.landscape,
                      title: 'Land\nRestoration',
                      color: Colors.brown,
                    ),
                    _ImpactCard(
                      icon: Icons.device_thermostat,
                      title: 'Climate\nResilience',
                      color: Colors.orange,
                    ),
                    _ImpactCard(
                      icon: Icons.trending_up,
                      title: 'Market\nAccess',
                      color: Colors.blue,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _ImpactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _ImpactCard({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Container(
      width: isMobile ? null : 200,
      height: isMobile ? 120 : 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: isMobile ? 35 : 50, color: color),
          const SizedBox(height: 15),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}