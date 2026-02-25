import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../widgets/profile_tile.dart';

class KlasProfileScreen extends StatefulWidget {
  const KlasProfileScreen({super.key});

  @override
  State<KlasProfileScreen> createState() => _KlasProfileScreenState();
}

class _KlasProfileScreenState extends State<KlasProfileScreen>
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
          'Profile',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Avatar
                    Hero(
                      tag: 'profile-avatar',
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.coffeeBrown.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: AppColors.coffeeBrown.withOpacity(0.3),
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          color: AppColors.coffeeBrown,
                          size: 50,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // User Info
                    Text(
                      'Sarah Johnson',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.coffeeBrown,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'sarah.johnson@email.com',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.coffeeBrown.withOpacity(0.7),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Edit Profile Button
                    GestureDetector(
                      onTap: () {
                        // Edit profile
                      },
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
                          'Edit Profile',
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
              
              const SizedBox(height: 32),
              
              // Profile Options
              ProfileTile(
                icon: Icons.shopping_bag_outlined,
                title: 'My Orders',
                subtitle: 'View your order history',
                onTap: () => Navigator.pushNamed(context, '/orders'),
              ),
              
              ProfileTile(
                icon: Icons.favorite_border_outlined,
                title: 'Wishlist',
                subtitle: 'Your saved items',
                onTap: () => Navigator.pushNamed(context, '/wishlist'),
              ),
              
              ProfileTile(
                icon: Icons.location_on_outlined,
                title: 'Saved Addresses',
                subtitle: 'Manage delivery addresses',
                onTap: () {
                  // Navigate to addresses
                },
              ),
              
              ProfileTile(
                icon: Icons.payment_outlined,
                title: 'Payment Methods',
                subtitle: 'Add or remove payment methods',
                onTap: () {
                  // Navigate to payment methods
                },
              ),
              
              ProfileTile(
                icon: Icons.settings_outlined,
                title: 'Settings',
                subtitle: 'App preferences and privacy',
                onTap: () {
                  // Navigate to settings
                },
              ),
              
              ProfileTile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get help with your orders',
                onTap: () {
                  // Navigate to help
                },
              ),
              
              ProfileTile(
                icon: Icons.logout_outlined,
                title: 'Logout',
                subtitle: 'Sign out of your account',
                onTap: () {
                  _showLogoutDialog();
                },
                iconColor: Colors.red,
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.coffeeBrown,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.coffeeBrown.withOpacity(0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.coffeeBrown,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/auth');
            },
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
