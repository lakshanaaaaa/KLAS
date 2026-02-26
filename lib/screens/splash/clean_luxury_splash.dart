import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CleanLuxurySplash extends StatefulWidget {
  const CleanLuxurySplash({super.key});

  @override
  State<CleanLuxurySplash> createState() => _CleanLuxurySplashState();
}

class _CleanLuxurySplashState extends State<CleanLuxurySplash>
    with TickerProviderStateMixin {
  late AnimationController _zoomController;
  late AnimationController _fadeController;
  late AnimationController _taglineController;

  late Animation<double> _zoomAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _taglineAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _navigateToHome();
  }

  void _initializeAnimations() {
    _zoomController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _zoomAnimation = Tween<double>(
      begin: 1.2,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _zoomController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _taglineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _taglineController,
      curve: Curves.easeIn,
    ));
  }

  void _startAnimations() {
    // Start logo animations immediately
    _fadeController.forward();
    _zoomController.forward();
    
    // Start "Elegant Finds" after 1.5 seconds for slow appearance
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _taglineController.forward();
      }
    });
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _zoomController.dispose();
    _fadeController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFF9F2E8),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF9F2E8),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF9F2E8),
              Color(0xFFF0E4D0),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_zoomAnimation, _fadeAnimation, _taglineAnimation]),
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _zoomAnimation,
                  child: _buildMainContent(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLogo(),
        const SizedBox(height: 20),
        _buildTagline(),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 400,
      height: 150,
      child: Image.asset(
        'assets/images/3-removebg-preview.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          print('Image error: $error');
          return const Icon(
            Icons.diamond_outlined,
            size: 100,
            color: Color(0xFF4B2E2B),
          );
        },
      ),
    );
  }

  Widget _buildTagline() {
    return AnimatedBuilder(
      animation: _taglineAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _taglineAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _taglineController,
              curve: Curves.easeOutCubic,
            )),
            child: Text(
              'Elegant Finds',
              style: GoogleFonts.playfairDisplay(
                fontSize: 28,
                fontWeight: FontWeight.w300,
                color: const Color(0xFF4B2E2B),
                letterSpacing: 3,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
