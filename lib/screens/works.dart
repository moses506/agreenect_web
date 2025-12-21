import 'package:flutter/material.dart';
import 'package:agreenect/utils/responsivenes.dart';

class OurWorksSection extends StatelessWidget {
  const OurWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 80,
        horizontal: isMobile ? 20 : 40,
      ),
      color: Colors.grey[50],
      child: Column(
        children: [
          Text(
            'Our Works in Action',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'See how we are making a difference in communities across Zambia through our digital agriculture initiatives with a help of our partners',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              height: 1.6,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 60),
          LayoutBuilder(
            builder: (context, constraints) {
              if (isMobile) {
                return _buildMobileLayout();
              } else if (isTablet) {
                return _buildTabletLayout();
              }
              return _buildDesktopLayout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _WorkPhotoCard(
                imagePath:
                    'assets/works/WhatsApp Image 2025-09-20 at 13.34.07 (1).jpeg',
                title: 'Farmer Training Session',
                subtitle: 'Empowering local farmers with digital tools',
                isLarge: false,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _WorkPhotoCard(
                imagePath:
                    'assets/works/WhatsApp Image 2025-11-15 at 15.52.18.jpeg',
                title: 'Mobile App Demo',
                subtitle: 'Teaching smartphone-based farming solutions',
                isLarge: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // _WorkPhotoCard(
        //   imagePath:
        //       'assets/works/WhatsApp Image 2025-09-19 at 21.50.41 (1).jpeg',
        //   title: 'Community Workshop',
        //   subtitle: 'Building climate resilience through collective learning',
        //   isLarge: true,
        // ),
        // const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _WorkPhotoCard(
                imagePath:
                    'assets/works/WhatsApp Image 2025-09-19 at 21.50.41 (1).jpeg',
                title: 'Youth Engagement',
                subtitle: 'Involving young people in smart farming practices',
                isLarge: false,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _WorkPhotoCard(
                imagePath:
                    'assets/works/WhatsApp Image 2025-09-20 at 13.34.08.jpeg',
                title: 'Sustainable Farming',
                subtitle: 'Promoting eco-friendly agricultural methods',
                isLarge: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _WorkPhotoCard(
                imagePath:
                    'assets/works/WhatsApp Image 2025-09-20 at 13.34.07 (1).jpeg',
                title: 'Farmer Training Session',
                subtitle: 'Empowering local farmers with digital tools',
                isLarge: false,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _WorkPhotoCard(
                imagePath:
                    'assets/works/WhatsApp Image 2025-11-15 at 15.52.18.jpeg',
                title: 'Mobile App Demo',
                subtitle: 'Teaching smartphone-based farming solutions',
                isLarge: false,
              ),
            ),
          ],
        ),
        // const SizedBox(height: 20),
        // _WorkPhotoCard(
        //   imagePath:
        //       'assets/works/WhatsApp Image 2025-09-19 at 21.50.41 (1).jpeg',
        //   title: 'Community Workshop',
        //   subtitle: 'Building climate resilience through collective learning',
        //   isLarge: true,
        // ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _WorkPhotoCard(
                imagePath:
                    'assets/works/WhatsApp Image 2025-09-19 at 21.50.41 (1).jpeg',
                title: 'Youth Engagement',
                subtitle: 'Involving young people in smart farming practices',
                isLarge: false,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _WorkPhotoCard(
                imagePath:
                    'assets/works/WhatsApp Image 2025-09-20 at 13.34.08.jpeg',
                title: 'Sustainable Farming',
                subtitle: 'Promoting eco-friendly agricultural methods',
                isLarge: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _WorkPhotoCard(
                imagePath:
                    'assets/works/WhatsApp Image 2025-09-20 at 13.34.07 (1).jpeg',
                title: 'Farmer Training Session',
                subtitle: 'Empowering local farmers with digital tools',
                isLarge: false,
              ),
              const SizedBox(height: 15),
              _WorkPhotoCard(
                imagePath:
                    'assets/works/WhatsApp Image 2025-11-15 at 15.52.18.jpeg',
                title: 'Mobile App Demo',
                subtitle: 'Teaching smartphone-based farming solutions',
                isLarge: false,
              ),
              const SizedBox(height: 15),
              _WorkPhotoCard(
                imagePath:
                    'assets/works/WhatsApp Image 2025-09-19 at 21.50.41 (1).jpeg',
                title: 'Youth Engagement',
                subtitle: 'Involving young people in smart farming practices',
                isLarge: false,
              ),
            ],
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            children: [
              // _WorkPhotoCard(
              //   imagePath:
              //       'assets/works/WhatsApp Image 2025-09-19 at 21.50.41 (1).jpeg',
              //   title: 'Community Workshop',
              //   subtitle:
              //       'Building climate resilience through collective learning',
              //   isLarge: true,
              // ),
              const SizedBox(height: 15),
              _WorkPhotoCard(
                imagePath:
                    'assets/works/WhatsApp Image 2025-09-20 at 13.34.08.jpeg',
                title: 'Sustainable Farming',
                subtitle: 'Promoting eco-friendly agricultural methods',
                isLarge: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WorkPhotoCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final bool isLarge;

  const _WorkPhotoCard({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: isLarge ? 16 / 7 : 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          color: Colors.white,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(imagePath, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
