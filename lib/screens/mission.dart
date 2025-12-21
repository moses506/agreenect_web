import 'package:flutter/material.dart';
import 'package:agreenect/utils/responsivenes.dart';


class MissionVisionValues extends StatelessWidget {
  const MissionVisionValues({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 80,
        horizontal: isMobile ? 20 : 40,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[50]!, Colors.blue[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Our Foundation',
            style: TextStyle(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 60),
          isMobile
              ? Column(
                  children: [
                    _MVVCard(
                      icon: Icons.rocket_launch,
                      title: 'Mission',
                      content: 'Empower smallholder farmers with digital tools, knowledge, and support to enhance productivity and resilience.',
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 30),
                    _MVVCard(
                      icon: Icons.visibility,
                      title: 'Vision',
                      content: 'A digitally-enabled, resilient agricultural sector driven by youth-led innovation and environmental stewardship.',
                      color: Colors.green,
                    ),
                    const SizedBox(height: 30),
                    _MVVCard(
                      icon: Icons.favorite,
                      title: 'Values',
                      content: 'Innovation • Sustainability • Empowerment • Integrity • Collaboration',
                      color: Colors.orange,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _MVVCard(
                      icon: Icons.rocket_launch,
                      title: 'Mission',
                      content: 'Empower smallholder farmers with digital tools, knowledge, and support to enhance productivity and resilience.',
                      color: Colors.blue,
                    ),
                    _MVVCard(
                      icon: Icons.visibility,
                      title: 'Vision',
                      content: 'A digitally-enabled, resilient agricultural sector driven by youth-led innovation and environmental stewardship.',
                      color: Colors.green,
                    ),
                    _MVVCard(
                      icon: Icons.favorite,
                      title: 'Values',
                      content: 'Innovation • Sustainability • Empowerment • Integrity • Collaboration',
                      color: Colors.orange,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _MVVCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color color;

  const _MVVCard({
    required this.icon,
    required this.title,
    required this.content,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Expanded(
      flex: isMobile ? 0 : 1,
      child: Container(
        width: isMobile ? double.infinity : null,
        margin: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 15),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(icon, size: 35, color: color),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 15),
            Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}