import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../models/category_model.dart';
import '../../widgets/category_card.dart';
import 'clothing_category_screen.dart';

class WomenCategoriesScreen extends StatefulWidget {
  const WomenCategoriesScreen({super.key});

  @override
  State<WomenCategoriesScreen> createState() => _WomenCategoriesScreenState();
}

class _WomenCategoriesScreenState extends State<WomenCategoriesScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late ScrollController _scrollController;

  final List<CategorySection> _sections = SampleCategories.getAllSections();

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
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

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

  void _navigateToCategory(CategoryModel category) {
    // Navigate to specific category page based on category type
    switch (category.type) {
      case CategoryType.clothing:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClothingCategoryScreen(
              clothingSection: SampleCategories.getAllSections()
                  .firstWhere((section) => section.type == CategoryType.clothing),
            ),
          ),
        );
        break;
      case CategoryType.innerwear:
        // TODO: Create InnerwearCategoryScreen
        break;
      case CategoryType.accessories:
        // TODO: Create AccessoriesCategoryScreen
        break;
      case CategoryType.footwear:
        // TODO: Create FootwearCategoryScreen
        break;
      case CategoryType.beauty:
        // TODO: Create BeautyCategoryScreen
        break;
    }
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
                'Women Categories',
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
                    // TODO: Implement search
                  },
                  icon: Icon(
                    Icons.search,
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
          
          // Category Sections
          ..._sections.asMap().entries.map((entry) {
            return _buildCategorySection(entry.value, entry.key);
          }).toList(),
          
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
      height: 200,
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
                'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800',
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
                      'Explore Your Style',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.warmCreme,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover elegant pieces curated for you',
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

  Widget _buildCategorySection(CategorySection section, int index) {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.2),
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
          child: Container(
            margin: const EdgeInsets.fromLTRB(24, 32, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Header
                Row(
                  children: [
                    Text(
                      section.title,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.coffeeBrown,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.coffeeBrown.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${section.categories.length}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.coffeeBrown,
                        ),
                      ),
                    ),
                  ],
                ),
                
                if (section.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    section.description!,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.coffeeBrown.withOpacity(0.7),
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
                
                const SizedBox(height: 16),
                
                // Category Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: section.categories.length,
                  itemBuilder: (context, index) {
                    final category = section.categories[index];
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
                              0.4 + (index * 0.05),
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
                ),
                
                const SizedBox(height: 24),
                
                // View All Button
                GestureDetector(
                  onTap: () {
                    // TODO: Navigate to section view
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.warmCreme,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.softBeige,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'View All ${section.title}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.coffeeBrown,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColors.coffeeBrown,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesList() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
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
        
        // Category Sections
        ..._sections.asMap().entries.map((entry) {
          return _buildCategorySection(entry.value, entry.key);
        }).toList(),
        
        // Bottom Padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 40),
        ),
      ],
    );
  }
}
