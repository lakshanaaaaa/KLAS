import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import 'components/signup_form.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _showEmailForm = false;
  bool _isHoveringGoogle = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _showGoogleSignup() {
    Navigator.pushNamed(context, '/signup-form');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCreme,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // KLAS Logo with Hero Animation and Hover
              Hero(
                tag: 'klas-logo',
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.identity()..scale(1.0),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.coffeeBrown.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowColor.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/3-removebg-preview.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                'KLAS',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.coffeeBrown,
                                  letterSpacing: 2,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Welcome Text
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Text(
                      'Welcome to KLAS',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.coffeeBrown,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Elevate Your Style Journey',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.coffeeBrown.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Main Options
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    // Continue with Google
                    _buildGoogleButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHoveringGoogle = true),
      onExit: (_) => setState(() => _isHoveringGoogle = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _showGoogleSignup,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isHoveringGoogle ? 1.05 : 1.0),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: _isHoveringGoogle 
                  ? AppColors.coffeeBrown.withOpacity(0.8)
                  : AppColors.softBeige.withOpacity(0.5),
              width: _isHoveringGoogle ? 2.5 : 2,
            ),
            boxShadow: _isHoveringGoogle
                ? [
                    BoxShadow(
                      color: AppColors.shadowColor.withOpacity(0.4),
                      blurRadius: 25,
                      offset: const Offset(0, 12),
                    ),
                    BoxShadow(
                      color: AppColors.coffeeBrown.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Google Icon
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.transparent,
                  ),
                  child: Icon(
                    Icons.g_mobiledata,
                    color: _isHoveringGoogle 
                        ? AppColors.coffeeBrown.withOpacity(0.9)
                        : AppColors.coffeeBrown,
                    size: 24,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Button Text
                Text(
                  'Continue with Google',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _isHoveringGoogle 
                        ? AppColors.coffeeBrown.withOpacity(0.9)
                        : AppColors.coffeeBrown,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
