import 'package:flutter/material.dart';

class AgreeNectApp extends StatelessWidget {
  const AgreeNectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgreeNect - Youth-Led AgriTech',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(height: 1.6),
        ),
      ),
      home: const HomePage(),
    );
  }
}

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
    // Close drawer on mobile
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
      case 'Impact':
        offset = 1600;
        break;
      case 'Achievements':
        offset = 2400;
        break;
      case 'Team':
        offset = 3200;
        break;
      case 'Contact':
        offset = 4000;
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
      drawer: _isMobile(context) ? _buildMobileSidebar() : null,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildNavigationBar(context),
            _buildHeroSection(context),
            _buildFeaturesSection(),
            _buildAboutUsSection(),
            _buildMissionVisionValues(),
            _buildImpactSection(),
            _buildStatsSection(),
            _buildAchievementsSection(),
            _buildTeamSection(),
            _buildPartnersSection(),
            _buildContactSection(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;
  bool _isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768 &&
      MediaQuery.of(context).size.width < 1024;
  bool _isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  // ---------------- MOBILE SIDEBAR ----------------
  Widget _buildMobileSidebar() {
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
              Container(
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
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  children: [
                    _buildSidebarItem(
                      'Home',
                      Icons.home,
                      () => _scrollToSection('Home'),
                    ),
                    _buildSidebarItem(
                      'About Us',
                      Icons.info_outline,
                      () => _scrollToSection('About Us'),
                    ),
                    _buildSidebarItem(
                      'Impact',
                      Icons.trending_up,
                      () => _scrollToSection('Impact'),
                    ),
                    _buildSidebarItem(
                      'Achievements',
                      Icons.star_outline,
                      () => _scrollToSection('Achievements'),
                    ),
                    _buildSidebarItem(
                      'Team',
                      Icons.people_outline,
                      () => _scrollToSection('Team'),
                    ),
                    _buildSidebarItem(
                      'Contact',
                      Icons.contact_mail,
                      () => _scrollToSection('Contact'),
                    ),
                  ],
                ),
              ),
              Container(
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
              ),
            ],
          ),
        ),
      ),
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

  // ---------------- RESPONSIVE NAVIGATION BAR ----------------
  Widget _buildNavigationBar(BuildContext context) {
    final isDesktop = _isDesktop(context);
    final isMobile = _isMobile(context);

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
          Row(
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
          ),
          if (isDesktop)
            Row(
              children: [
                _navButton('Home', () => _scrollToSection('Home')),
                _navButton('About Us', () => _scrollToSection('About Us')),
                _navButton('Impact', () => _scrollToSection('Impact')),
                _navButton(
                  'Achievements',
                  () => _scrollToSection('Achievements'),
                ),
                _navButton('Team', () => _scrollToSection('Team')),
                _navButton('Contact', () => _scrollToSection('Contact')),
              ],
            )
          else
            Container(
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: Icon(Icons.menu, color: Colors.green[700]),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
            ),
        ],
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

  // ---------------- RESPONSIVE HERO SECTION ----------------
  Widget _buildHeroSection(BuildContext context) {
    final isMobile = _isMobile(context);
    final isTablet = _isTablet(context);

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
          // Background pattern
          if (!isMobile) ...[
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
          ],
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
                      _buildHeroContent(context),
                      const SizedBox(height: 40),
                      _buildHeroImage(context),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(flex: 6, child: _buildHeroContent(context)),
                      Expanded(flex: 4, child: _buildHeroImage(context)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroContent(BuildContext context) {
    final isMobile = _isMobile(context);

    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
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
            fontSize: isMobile
                ? 28
                : (MediaQuery.of(context).size.width > 800 ? 48 : 36),
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
                  _buildHeroButton(true),
                  const SizedBox(height: 15),
                  _buildHeroButton(false),
                ],
              )
            : Row(
                mainAxisAlignment: isMobile
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  _buildHeroButton(true),
                  const SizedBox(width: 20),
                  _buildHeroButton(false),
                ],
              ),
      ],
    );
  }

  Widget _buildHeroButton(bool isPrimary) {
    final isMobile = _isMobile(context);

    return isPrimary
        ? ElevatedButton.icon(
            onPressed: () {},
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
            onPressed: () {},
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

  Widget _buildHeroImage(BuildContext context) {
    final isMobile = _isMobile(context);

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

  // ---------------- RESPONSIVE FEATURES SECTION ----------------
  Widget _buildFeaturesSection() {
    final isMobile = _isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 80,
        horizontal: isMobile ? 20 : 40,
      ),
      color: Colors.grey[50],
      child: Column(
        children: [
          Text(
            'Our Digital Solutions',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 50),
          LayoutBuilder(
            builder: (context, constraints) {
              if (isMobile) {
                return Column(
                  children: [
                    _buildFeatureCard(
                      Icons.phone_android,
                      'Mobile Platform',
                      'Access farming knowledge, weather updates, and market prices on your smartphone',
                      Colors.blue,
                    ),
                    const SizedBox(height: 30),
                    _buildFeatureCard(
                      Icons.eco,
                      'Land Restoration',
                      'Tools and resources for rehabilitating degraded soils',
                      Colors.brown,
                    ),
                    const SizedBox(height: 30),
                    _buildFeatureCard(
                      Icons.cloud,
                      'Weather Intelligence',
                      'Real-time weather data and climate-smart farming recommendations',
                      Colors.orange,
                    ),
                    const SizedBox(height: 30),
                    _buildFeatureCard(
                      Icons.trending_up,
                      'Market Access',
                      'Connect directly with buyers and access fair market prices',
                      Colors.green,
                    ),
                    const SizedBox(height: 30),
                    _buildFeatureCard(
                      Icons.school,
                      'Digital Learning',
                      'Interactive training modules on sustainable farming practices',
                      Colors.purple,
                    ),
                  ],
                );
              } else {
                return Wrap(
                  spacing: 30,
                  runSpacing: 30,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildFeatureCard(
                      Icons.phone_android,
                      'Mobile Platform',
                      'Access farming knowledge, weather updates, and market prices on your smartphone',
                      Colors.blue,
                    ),

                    _buildFeatureCard(
                      Icons.cloud,
                      'Weather Intelligence',
                      'Real-time weather data and climate-smart farming recommendations',
                      Colors.orange,
                    ),
                    _buildFeatureCard(
                      Icons.trending_up,
                      'Market Access',
                      'Connect directly with buyers and access fair market prices',
                      Colors.green,
                    ),
                    _buildFeatureCard(
                      Icons.school,
                      'Digital Learning',
                      'Interactive training modules on sustainable farming practices',
                      Colors.purple,
                    ),
                    _buildFeatureCard(
                      Icons.eco,
                      'Land Restoration',
                      'Tools and resources for rehabilitating degraded soils',
                      Colors.brown,
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    final isMobile = _isMobile(context);

    return Container(
      width: isMobile ? double.infinity : 280,
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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(icon, size: 40, color: color),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- RESPONSIVE ABOUT US ----------------
  Widget _buildAboutUsSection() {
    final isMobile = _isMobile(context);
    final isTablet = _isTablet(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 80,
        horizontal: isMobile ? 20 : 40,
      ),
      child: (isMobile || isTablet)
          ? Column(
              children: [
                _buildAboutContent(),
                const SizedBox(height: 40),
                _buildAboutImage(),
              ],
            )
          : Row(
              children: [
                Expanded(child: _buildAboutContent()),
                const SizedBox(width: 60),
                Expanded(child: _buildAboutImage()),
              ],
            ),
    );
  }

  Widget _buildAboutContent() {
    final isMobile = _isMobile(context);

    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          'About AgreeNect',
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: isMobile ? 28 : 36,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        const SizedBox(height: 30),
        Text(
          'AgreeNect addresses key challenges in Zambian agriculture: sustainable food production, land restoration, and climate resilience. We provide scalable digital solutions that connect technology with practical knowledge, ensuring inclusivity and sustainability.',
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(fontSize: 18, height: 1.6, color: Colors.grey[700]),
        ),
        const SizedBox(height: 30),
        isMobile
            ? Column(
                children: [
                  _buildStatCard('300+', 'Farmers Reached'),
                  const SizedBox(height: 20),
                  _buildStatCard('15+', 'Communities'),
                ],
              )
            : Row(
                mainAxisAlignment: isMobile
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  _buildStatCard('300+', 'Farmers Reached'),
                  const SizedBox(width: 30),
                  _buildStatCard('15+', 'Communities'),
                ],
              ),
      ],
    );
  }

  Widget _buildAboutImage() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.green[100],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.groups, size: 80, color: Colors.green[600]),
            const SizedBox(height: 20),
            Text(
              'Community Impact',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String number, String label) {
    final isMobile = _isMobile(context);

    return Container(
      width: isMobile ? 200 : null,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          Text(label, style: TextStyle(fontSize: 14, color: Colors.green[600])),
        ],
      ),
    );
  }

  // ---------------- RESPONSIVE MISSION, VISION, VALUES ----------------
  Widget _buildMissionVisionValues() {
    final isMobile = _isMobile(context);

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
                    _buildMVVCard(
                      Icons.rocket_launch,
                      'Mission',
                      'Empower smallholder farmers with digital tools, knowledge, and support to enhance productivity and resilience.',
                      Colors.blue,
                    ),
                    const SizedBox(height: 30),
                    _buildMVVCard(
                      Icons.visibility,
                      'Vision',
                      'A digitally-enabled, resilient agricultural sector driven by youth-led innovation and environmental stewardship.',
                      Colors.green,
                    ),
                    const SizedBox(height: 30),
                    _buildMVVCard(
                      Icons.favorite,
                      'Values',
                      'Innovation • Sustainability • Empowerment • Integrity • Collaboration',
                      Colors.orange,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMVVCard(
                      Icons.rocket_launch,
                      'Mission',
                      'Empower smallholder farmers with digital tools, knowledge, and support to enhance productivity and resilience.',
                      Colors.blue,
                    ),
                    _buildMVVCard(
                      Icons.visibility,
                      'Vision',
                      'A digitally-enabled, resilient agricultural sector driven by youth-led innovation and environmental stewardship.',
                      Colors.green,
                    ),
                    _buildMVVCard(
                      Icons.favorite,
                      'Values',
                      'Innovation • Sustainability • Empowerment • Integrity • Collaboration',
                      Colors.orange,
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildMVVCard(
    IconData icon,
    String title,
    String content,
    Color color,
  ) {
    final isMobile = _isMobile(context);

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

  // ---------------- RESPONSIVE IMPACT ----------------
  Widget _buildImpactSection() {
    final isMobile = _isMobile(context);

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
                          child: _buildImpactCard(
                            Icons.eco,
                            'Climate-Smart\nPractices',
                            Colors.green,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildImpactCard(
                            Icons.landscape,
                            'Land\nRestoration',
                            Colors.brown,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildImpactCard(
                            Icons.device_thermostat,
                            'Climate\nResilience',
                            Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildImpactCard(
                            Icons.trending_up,
                            'Market\nAccess',
                            Colors.blue,
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
                    _buildImpactCard(
                      Icons.eco,
                      'Climate-Smart\nPractices',
                      Colors.green,
                    ),
                    _buildImpactCard(
                      Icons.landscape,
                      'Land\nRestoration',
                      Colors.brown,
                    ),
                    _buildImpactCard(
                      Icons.device_thermostat,
                      'Climate\nResilience',
                      Colors.orange,
                    ),
                    _buildImpactCard(
                      Icons.trending_up,
                      'Market\nAccess',
                      Colors.blue,
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildImpactCard(IconData icon, String title, Color color) {
    final isMobile = _isMobile(context);

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

  // ---------------- RESPONSIVE STATS SECTION ----------------
  Widget _buildStatsSection() {
    final isMobile = _isMobile(context);

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
                      child: _buildStatsCard(
                        '300+',
                        'Farmers Trained',
                        Icons.people,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildStatsCard(
                        '15+',
                        'Communities',
                        Icons.location_city,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatsCard(
                        '95%',
                        'Satisfaction Rate',
                        Icons.thumb_up,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildStatsCard(
                        '3+',
                        'Years Experience',
                        Icons.timeline,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatsCard('300+', 'Farmers Trained', Icons.people),
                _buildStatsCard('15+', 'Communities', Icons.location_city),
                _buildStatsCard('95%', 'Satisfaction Rate', Icons.thumb_up),
                _buildStatsCard('3+', 'Years Experience', Icons.timeline),
              ],
            ),
    );
  }

  Widget _buildStatsCard(String number, String label, IconData icon) {
    final isMobile = _isMobile(context);

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

  // ---------------- RESPONSIVE ACHIEVEMENTS ----------------
  Widget _buildAchievementsSection() {
    final isMobile = _isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 80,
        horizontal: isMobile ? 20 : 40,
      ),
      color: Colors.grey[50],
      child: Column(
        children: [
          Text(
            'Awards & Recognition',
            style: TextStyle(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 50),
          _buildAchievementCard(
            'assets/mission.jpeg',
            'National Innovation Award',
            'Climate-Smart Agriculture Category',
            Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(
    String image,
    String title,
    String description,
    Color color,
  ) {
    final isMobile = _isMobile(context);

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 600),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              image,
              height: isMobile ? 150 : 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: isMobile ? 150 : 200,
                color: Colors.grey[300],
                child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // ---------------- RESPONSIVE TEAM ----------------
  Widget _buildTeamSection() {
    final isMobile = _isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 80,
        horizontal: isMobile ? 20 : 40,
      ),
      child: Column(
        children: [
          Text(
            'Meet Our Team',
            style: TextStyle(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 50),
          LayoutBuilder(
            builder: (context, constraints) {
              if (isMobile) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        _buildTeamCard(
                          'CEO & Founder',
                          'David Chapoloko',
                          'assets/people/WhatsApp Image 2025-09-20 at 10.48.25.jpeg',
                        ),

                        const SizedBox(width: 15),
                        _buildTeamCard(
                          'Financial & Admin Lead',
                          'Contance Mubanga',
                          'assets/people/WhatsApp Image 2025-09-19 at 21.16.28.jpeg',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(width: 15),
                        _buildTeamCard(
                          'Technical/ Developer',
                          'Moses Mpande',
                          'assets/people/WhatsApp Image 2025-09-20 at 11.49.25.jpeg',
                        ),
                        _buildTeamCard(
                          'Business Development',
                          'Kunda Nyirongo',
                          'assets/people/WhatsApp Image 2025-09-19 at 20.08.24.jpeg',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(width: 15),
                        _buildTeamCard(
                          'Partnership & Outreach',
                          'Kena Chibuye',
                          'assets/people/WhatsApp Image 2025-09-19 at 20.08.53.jpeg',
                        ),
                        _buildTeamCard(
                          'Procurement Officer',
                          'Celcilia Kuasa',
                          'assets/people/1712988933095.jpeg',
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Wrap(
                  spacing: 30,
                  runSpacing: 30,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildTeamCard(
                      'CEO & Founder',
                      'David Chapoloko',
                      'assets/people/WhatsApp Image 2025-09-20 at 10.48.25.jpeg',
                    ),
                    _buildTeamCard(
                      'Financial & Admin Lead',
                      'Contance Mubanga',
                      'assets/people/WhatsApp Image 2025-09-19 at 21.16.28.jpeg',
                    ),

                    _buildTeamCard(
                      'Technical/ Developer',
                      'Moses Mpande',
                      'assets/people/WhatsApp Image 2025-09-20 at 11.49.25.jpeg',
                    ),
                    _buildTeamCard(
                      'Business Development',
                      'Kunda Nyirongo',
                      'assets/people/WhatsApp Image 2025-09-19 at 20.08.24.jpeg',
                    ),
                    _buildTeamCard(
                      'Partnership & Outreach',
                      'Kena Chibuye',
                      'assets/people/WhatsApp Image 2025-09-19 at 20.08.53.jpeg',
                    ),
                    _buildTeamCard(
                      'Procurement Officer',
                      'Celcilia Kuasa',
                      'assets/people/1712988933095.jpeg',
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCard(String role, String name, String image) {
    final isMobile = _isMobile(context);

    return Container(
      width: isMobile ? null : 250,
      padding: EdgeInsets.all(isMobile ? 15 : 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: isMobile ? 60 : 80,
            height: isMobile ? 60 : 80,
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(isMobile ? 30 : 40),
            ),
            // child: Icon(Icons.person, size: isMobile ? 30 : 40, color: Colors.green[600]),
            child: ClipOval(
              child: Image.asset(
                image,
                height: isMobile ? 60 : 80,
                width: isMobile ? 60 : 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            role,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 12 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 10 : 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- RESPONSIVE PARTNERS ----------------
  Widget _buildPartnersSection() {
    final isMobile = _isMobile(context);

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
                        _buildPartnerCard(
                          'Agri Train Initiative\nZambia',
                          Icons.agriculture,
                          'assets/partners .jpeg',
                        ),
                        const SizedBox(width: 20),
                        _buildPartnerCard(
                          'Art For climate',
                          Icons.agriculture,
                          'assets/partners/WhatsApp Image 2025-09-20 at 11.08.45.jpeg',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildPartnerCard(
                          'Ecoservannah\n Initiative',
                          Icons.agriculture,
                          'assets/partners/WhatsApp Image 2025-09-20 at 11.09.29.jpeg',
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
                    _buildPartnerCard(
                      'Agri Train Initiative\nZambia',
                      Icons.agriculture,
                      'assets/partners .jpeg',
                    ),
                    _buildPartnerCard(
                      'Art For climate',
                      Icons.agriculture,
                      'assets/partners/WhatsApp Image 2025-09-20 at 11.08.45.jpeg',
                    ),
                    _buildPartnerCard(
                      'Ecoservannah\n Initiative',
                      Icons.agriculture,
                      'assets/partners/WhatsApp Image 2025-09-20 at 11.09.29.jpeg',
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildPartnerCard(String name, IconData icon, String image) {
    final isMobile = _isMobile(context);

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

  // ---------------- RESPONSIVE CONTACT ----------------
  Widget _buildContactSection() {
    final isMobile = _isMobile(context);

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
            'Get In Touch',
            style: TextStyle(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Wed love to hear from you! Whether you are a farmer, partner, or supporter, reach out to us.',
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
                    _buildContactCard(
                      Icons.email,
                      'Email',
                      'chapolokodavifpfg@gmail.com',
                    ),
                    const SizedBox(height: 20),
                    _buildContactCard(Icons.phone, 'Phone', '+260 768233023'),
                    const SizedBox(height: 20),
                    _buildContactCard(
                      Icons.location_on,
                      'Address',
                      'Lusaka, Zambia',
                    ),
                  ],
                )
              : Wrap(
                  spacing: 40,
                  runSpacing: 40,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildContactCard(
                      Icons.email,
                      'Email',
                      'chapolokodavifpfg@gmail.com',
                    ),
                    _buildContactCard(Icons.phone, 'Phone', '+260 768233023'),
                    _buildContactCard(
                      Icons.location_on,
                      'Address',
                      'Lusaka, Zambia',
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title, String detail) {
    final isMobile = _isMobile(context);

    return Container(
      width: isMobile ? double.infinity : 250,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.green[600]),
          const SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            detail,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  // ---------------- FOOTER ----------------
  Widget _buildFooter() {
    final isMobile = _isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 30 : 40,
        horizontal: isMobile ? 20 : 40,
      ),
      color: const Color(0xFF0A4439),
      child: Column(
        children: [
          Text(
            '© 2025 AgreeNect. All Rights Reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 15),
          isMobile
              ? Column(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Privacy Policy',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Terms of Service',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Support',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                )
              : Wrap(
                  spacing: 20,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Privacy Policy',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Terms of Service',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Support',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
