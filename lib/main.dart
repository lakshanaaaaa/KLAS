import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/app_colors.dart';
import 'screens/splash/clean_luxury_splash.dart';
import 'screens/home/klas_home_screen.dart';
import 'screens/profile/klas_profile_screen.dart';
import 'screens/wishlist/klas_wishlist_screen.dart';
import 'screens/orders/klas_orders_screen.dart';
import 'screens/cart/klas_cart_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/signup_form_screen.dart';
import 'screens/profile/add_profile_screen.dart';
import 'screens/categories/women_categories_screen.dart';

void main() {
  runApp(const KlasApp());
}

class KlasApp extends StatelessWidget {
  const KlasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KLAS - Elegant Finds',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.coffeeBrown),
        scaffoldBackgroundColor: AppColors.warmCreme,
        useMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.warmCreme,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: AppColors.coffeeBrown,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.coffeeBrown,
            foregroundColor: AppColors.warmCreme,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
          ),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const CleanLuxurySplash(),
        '/home': (context) => const KlasHomeScreen(),
        '/profile': (context) => const KlasProfileScreen(),
        '/wishlist': (context) => const KlasWishlistScreen(),
        '/orders': (context) => const KlasOrdersScreen(),
        '/cart': (context) => const KlasCartScreen(),
        '/login': (context)=> const LoginScreen(),
        '/signup':(context)=>const SignupScreen(),
        '/signup-form':(context)=>const SignupFormScreen(),
        '/add-profile':(context)=>const AddProfileScreen(),
        '/women-categories':(context)=>const WomenCategoriesScreen(),
      }, 
    );
  }
}
