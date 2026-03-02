import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../models/category_model.dart';
import '../../widgets/category_card.dart';

class ClothingCategoryScreen extends StatefulWidget {
  final CategorySection clothingSection;

  const ClothingCategoryScreen({
    super.key,
    required this.clothingSection,
  });

  @override
  State<ClothingCategoryScreen> createState() => _ClothingCategoryScreenState();
}

class _ClothingCategoryScreenState extends State<ClothingCategoryScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _scrollController = ScrollController();
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

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCreme,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // AppBar
          SliverAppBar(
            backgroundColor: AppColors.warmCreme,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            pinned: true,
            floating: true,
            snap: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.coffeeBrown,
                size: 20,
              ),
            ),
            centerTitle: true,
            title: FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'Clothing',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffeeBrown,
                  letterSpacing: 1,
                ),
              ),
            ),
            actions: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: IconButton(
                  onPressed: () {
                    // TODO: Implement filter
                  },
                  icon: Icon(
                    Icons.filter_list,
                    color: AppColors.coffeeBrown,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),

          // Hero Banner
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildHeroBanner(),
              ),
            ),
          ),

          // Category Grid
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = widget.clothingSection.categories[index];
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _slideController,
                          curve: Interval(
                            0.3 + (index * 0.1),
                            1.0,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                      ),
                      child: CategoryCard(
                        category: category,
                        onTap: () => _navigateToCategory(category),
                      ),
                    ),
                  );
                },
                childCount: widget.clothingSection.categories.length,
              ),
            ),
          ),

          // Bottom Padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      margin: const EdgeInsets.all(24),
      height: 180,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.network(
                'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.coffeeBrown.withOpacity(0.8),
                          AppColors.deepMocha.withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.5),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            
            // Content
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Elegant Clothing',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.warmCreme,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover our curated collection of premium apparel',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.warmCreme.withOpacity(0.9),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCategory(CategoryModel category) {
    // Navigate to specific category products
    Navigator.pushNamed(
      context,
      '/category-products',
      arguments: {
        'categoryName': category.name,
        'categoryId': category.id,
        'category': category,
      },
    );
  }
}
