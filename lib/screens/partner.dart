import 'package:flutter/material.dart';
import 'package:agreenect/utils/responsivenes.dart';

class PartnersSection extends StatelessWidget {
  const PartnersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 80,
        horizontal: isMobile ? 20 : 40,
      ),
      color: Colors.grey[50],
      child: Column(
        children: [
          Text(
            'Our Partners',
            style: TextStyle(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'We collaborate with farmer cooperatives, NGOs, educational institutions, and government partners to amplify impact and deliver practical, scalable solutions.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              height: 1.6,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 50),
          isMobile
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _PartnerCard(
                          name: 'Agri Train Initiative\nZambia',
                          icon: Icons.agriculture,
                          image: 'assets/partners .jpeg',
                        ),
                        const SizedBox(width: 20),
                        _PartnerCard(
                          name: 'Art For climate',
                          icon: Icons.agriculture,
                          image: 'assets/partners/WhatsApp Image 2025-09-20 at 11.08.45.jpeg',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _PartnerCard(
                          name: 'Ecoservannah\n Initiative',
                          icon: Icons.agriculture,
                          image: 'assets/partners/WhatsApp Image 2025-09-20 at 11.09.29.jpeg',
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
                    _PartnerCard(
                      name: 'Agri Train Initiative\nZambia',
                      icon: Icons.agriculture,
                      image: 'assets/partners .jpeg',
                    ),
                    _PartnerCard(
                      name: 'Art For climate',
                      icon: Icons.agriculture,
                      image: 'assets/partners/WhatsApp Image 2025-09-20 at 11.08.45.jpeg',
                    ),
                    _PartnerCard(
                      name: 'Ecoservannah\n Initiative',
                      icon: Icons.agriculture,
                      image: 'assets/partners/WhatsApp Image 2025-09-20 at 11.09.29.jpeg',
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _PartnerCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final String image;

  const _PartnerCard({
    required this.name,
    required this.icon,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Container(
      width: isMobile ? 200 : 180,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 40,
            errorBuilder: (context, error, stackTrace) =>
                Icon(icon, size: 40, color: Colors.green[600]),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }
}