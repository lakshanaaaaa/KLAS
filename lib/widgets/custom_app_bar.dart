import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool showMenu;
  final bool showProfile;
  final VoidCallback? onMenuTap;
  final VoidCallback? onProfileTap;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showMenu = true,
    this.showProfile = true,
    this.onMenuTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.warmCreme,
        border: Border(
          bottom: BorderSide(
            color: AppColors.softBeige.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu Icon
          if (showMenu)
            GestureDetector(
              onTap: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.softBeige.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.menu,
                  color: AppColors.coffeeBrown,
                  size: 20,
                ),
              ),
            ),
          
          // Logo
          Expanded(
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffeeBrown,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          
          // Profile Avatar
          if (showProfile)
            GestureDetector(
              onTap: onProfileTap ?? () => Navigator.pushNamed(context, '/profile'),
              child: Hero(
                tag: 'profile-avatar',
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.coffeeBrown.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.coffeeBrown.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    color: AppColors.coffeeBrown,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
