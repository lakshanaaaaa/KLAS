import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';

class WomenHomeScreenNew extends StatefulWidget {
  const WomenHomeScreenNew({super.key});

  @override
  State<WomenHomeScreenNew> createState() => _WomenHomeScreenNewState();
}

class _WomenHomeScreenNewState extends State<WomenHomeScreenNew>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _heroController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _heroAnimation;
  late ScrollController _scrollController;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _heroAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _slideController.forward();
    _heroController.forward();
  }

  void _onScroll() {
    final isScrolled = _scrollController.offset > 10;
    if (isScrolled != _isScrolled) {
      setState(() => _isScrolled = isScrolled);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _heroController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCreme,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFloatingNav(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(),
          _buildHeroSection(),
          _buildCategorySection(),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
          _buildProductGrid(),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
          _buildTrendingSection(),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
          _buildCuratedSection(),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  // ---------------- APP BAR ----------------

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      backgroundColor: _isScrolled
          ? AppColors.warmCreme.withOpacity(0.95)
          : AppColors.warmCreme,
      elevation: _isScrolled ? 8 : 0,
      shadowColor: AppColors.shadowColor,
      surfaceTintColor: Colors.transparent,
      floating: true,
      snap: true,
      pinned: true,
      expandedHeight: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Mumbai',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.coffeeBrown,
            ),
          ),
          Text(
            'KLAS',
            style: GoogleFonts.playfairDisplay(
              fontSize: _isScrolled ? 20 : 24,
              fontWeight: FontWeight.w700,
              color: AppColors.coffeeBrown,
              letterSpacing: 2,
            ),
          ),
          const Icon(Icons.shopping_bag_outlined),
        ],
      ),
    );
  }

  // ---------------- HERO ----------------

  SliverToBoxAdapter _buildHeroSection() {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _heroAnimation,
        child: Container(
          margin: const EdgeInsets.all(20),
          height: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: AppColors.softBeige,
            ),
            child: Center(
              child: Text(
                "New Collection",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffeeBrown,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- CATEGORY ----------------

  SliverToBoxAdapter _buildCategorySection() {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Shop by Category",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffeeBrown,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryChip('Dresses', true),
                    _buildCategoryChip('Ethnic Wear', false),
                    _buildCategoryChip('Jewellery', false),
                    _buildCategoryChip('Handbags', false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- GRID ----------------

  SliverPadding _buildProductGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildProductCard(index),
              ),
            );
          },
          childCount: 8,
        ),
      ),
    );
  }

  // ---------------- TRENDING ----------------

  SliverToBoxAdapter _buildTrendingSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          "Trending Now",
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.coffeeBrown,
          ),
        ),
      ),
    );
  }

  // ---------------- CURATED ----------------

  SliverToBoxAdapter _buildCuratedSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          "Curated For You",
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.coffeeBrown,
          ),
        ),
      ),
    );
  }

  // ---------------- NAV ----------------

  Widget _buildFloatingNav() {
    return Container(
      height: 70,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.coffeeBrown,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(Icons.home_outlined, color: Colors.white),
          Icon(Icons.favorite_border, color: Colors.white70),
          Icon(Icons.person_outline, color: Colors.white70),
        ],
      ),
    );
  }

  // ---------------- PRODUCT CARD ----------------

  Widget _buildProductCard(int index) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          "Product ${index + 1}",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.coffeeBrown,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.coffeeBrown
            : AppColors.softBeige.withOpacity(0.5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color:
              isSelected ? AppColors.warmCreme : AppColors.coffeeBrown,
        ),
      ),
    );
  }
}