// lib/home_page.dart

import 'package:agreenect/features.dart';
import 'package:agreenect/screens/about.dart';
import 'package:agreenect/screens/achievements.dart';
import 'package:agreenect/screens/contact.dart';
import 'package:agreenect/screens/team.dart';
import 'package:flutter/material.dart';

// OLD IMPORTS - REMOVE THESE
// import 'package:agreenect/features.dart';
// import 'package:agreenect/screens/about.dart';
// import 'package:agreenect/screens/achievements.dart';
// import 'package:agreenect/screens/contact.dart';
// import 'package:agreenect/screens/team.dart';

// NEW DYNAMIC IMPORTS - ADD THESE

// Keep these existing imports
import 'package:agreenect/hero_section/footer.dart';
import 'package:agreenect/hero_section/hero_section.dart';
import 'package:agreenect/nav_bar.dart';
import 'package:agreenect/screens/impact.dart';
import 'package:agreenect/screens/mission.dart';
import 'package:agreenect/screens/partner.dart';
import 'package:agreenect/screens/stats.dart';
import 'package:agreenect/screens/works.dart';
import 'package:agreenect/seidebar.dart';
import 'package:agreenect/utils/responsivenes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(String section) {
    if (_scaffoldKey.currentState?.isDrawerOpen == true) {
      Navigator.of(context).pop();
    }

    double offset = 0;
    switch (section) {
      case 'Home':
        offset = 0;
        break;
      case 'About Us':
        offset = 800;
        break;
      case 'Our Works':
        offset = 1200;
        break;
      case 'Impact':
        offset = 1800;
        break;
      case 'Achievements':
        offset = 2600;
        break;
      case 'Team':
        offset = 3400;
        break;
      case 'Contact':
        offset = 4200;
        break;
    }

    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: ResponsiveUtils.isMobile(context)
          ? MobileSidebar(onNavigate: _scrollToSection)
          : null,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/seed');
        },
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.cloud_upload),
        label: const Text('Seed Database'),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomNavigationBar(
              scaffoldKey: _scaffoldKey,
              onNavigate: _scrollToSection,
            ),
            const HeroSection(),

            // ✅ UPDATED DYNAMIC SECTIONS
            const DynamicFeaturesSection(), // Was: FeaturesSection()
            const DynamicAboutSection(), // Was: AboutSection()
            // These remain the same for now (can be made dynamic later)
            const OurWorksSection(),
            const MissionVisionValues(),
            const ImpactSection(),
            const StatsSection(),

            // ✅ UPDATED DYNAMIC SECTIONS
            const DynamicAchievementsSection(), // Was: AchievementsSection()
            const DynamicTeamSection(), // Was: TeamSection()
            // These remain the same for now
            const PartnersSection(),

            // ✅ UPDATED DYNAMIC SECTION
            const DynamicContactSection(), // Was: ContactSection()

            const Footer(),
          ],
        ),
      ),
    );
  }
}
