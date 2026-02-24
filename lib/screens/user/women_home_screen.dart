// SAME IMPORTS
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WomenHomeScreen extends StatelessWidget {
  const WomenHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EFE7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 20),
              _searchBar(),
              const SizedBox(height: 24),
              _banner(),
              const SizedBox(height: 28),
              _sectionTitle("Categories"),
              const SizedBox(height: 14),
              _categories(),
              const SizedBox(height: 28),
              _sectionTitle("Featured"),
              const SizedBox(height: 14),
              _products(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // HEADER (UNCHANGED)
  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        "Boutique",
        style: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF2E2E2E),
        ),
      ),
    );
  }

  // FIXED SEARCH BAR (ONLY SYNTAX FIX)
  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search_outlined, color: Color(0xFF8B7E74)),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search elegant outfits...",
                hintStyle: GoogleFonts.raleway(
                  color: const Color(0xFF8B7E74).withOpacity(0.6),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const Icon(Icons.tune_outlined, color: Color(0xFF8FA879)),
        ],
      ),
    );
  }

  // ADDED (YOU CALLED BUT MISSING)
  Widget _banner() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF8FA879), Color(0xFFE8B4B8)],
        ),
      ),
      child: Center(
        child: Text(
          "Summer Collection\nUp to 40% OFF",
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  // ADDED (YOU CALLED BUT MISSING)
  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.playfairDisplay(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF2E2E2E),
      ),
    );
  }

  // YOUR ORIGINAL CATEGORIES (UNCHANGED)
  Widget _categories() {
    final categories = [
      {'icon': Icons.dry_cleaning, 'label': 'Dresses'},
      {'icon': Icons.checkroom, 'label': 'Tops'},
      {'icon': Icons.style, 'label': 'Bottoms'},
      {'icon': Icons.shopping_bag, 'label': 'Bags'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((category) {
        return Column(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                category['icon'] as IconData,
                color: const Color(0xFF8FA879),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category['label'] as String,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF8B7E74),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  // YOUR ORIGINAL PRODUCTS (UNCHANGED)
  Widget _products() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (_, i) => _productCard(),
    );
  }

  Widget _productCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Center(
                child: Icon(
                  Icons.dry_cleaning,
                  size: 40,
                  color: Color(0xFF8FA879),
                ),
              ),
            ),
            Text(
              "Elegant Summer Dress",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "\$89.99",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: const Color(0xFF8FA879),
              ),
            ),
          ],
        ),
      ),
    );
  }
}