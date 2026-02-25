import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';

class KlasCartScreen extends StatefulWidget {
  const KlasCartScreen({super.key});

  @override
  State<KlasCartScreen> createState() => _KlasCartScreenState();
}

class _KlasCartScreenState extends State<KlasCartScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

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

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCreme,
      appBar: AppBar(
        backgroundColor: AppColors.warmCreme,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Shopping Cart',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.coffeeBrown,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: AppColors.coffeeBrown,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.coffeeBrown.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColors.coffeeBrown,
                  size: 60,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Your cart is empty',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffeeBrown,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Add items to get started!',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.coffeeBrown.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/home'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.coffeeBrown,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    'Continue Shopping',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.warmCreme,
                    ),
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
