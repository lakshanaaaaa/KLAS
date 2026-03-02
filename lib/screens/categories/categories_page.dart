import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../models/category_model.dart';
import '../../widgets/category_card.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late ScrollController _scrollController;
  
  CategoryType _selectedCategory = CategoryType.clothing;
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
      body: Row(
        children: [
          // Vertical Navbar
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Categories',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.coffeeBrown,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Browse our collection',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.coffeeBrown.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Divider(color: AppColors.softBeige),
                
                // Category List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: _sections.length,
                    itemBuilder: (context, index) {
                      final section = _sections[index];
                      final isSelected = section.type == _selectedCategory;
                      
                      return _buildCategoryNavItem(
                        section,
                        isSelected,
                        () => _selectCategory(section.type),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Main Content Area
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildMainContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryNavItem(CategorySection section, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.coffeeBrown.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.coffeeBrown : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Category Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.coffeeBrown : AppColors.coffeeBrown.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getCategoryIcon(section.type),
                color: isSelected ? AppColors.warmCreme : AppColors.coffeeBrown,
                size: 20,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Category Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.coffeeBrown : AppColors.coffeeBrown,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${section.categories.length} items',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.coffeeBrown.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            
            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isSelected ? AppColors.coffeeBrown : AppColors.coffeeBrown.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    final selectedSection = _sections.firstWhere(
      (section) => section.type == _selectedCategory,
    );

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // AppBar
        SliverAppBar(
          backgroundColor: AppColors.warmCreme,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          pinned: true,
          floating: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColors.coffeeBrown,
              size: 20,
            ),
          ),
          centerTitle: true,
          title: Text(
            selectedSection.title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.coffeeBrown,
              letterSpacing: 1,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                // TODO: Implement search
              },
              icon: Icon(
                Icons.search,
                color: AppColors.coffeeBrown,
                size: 22,
              ),
            ),
          ],
        ),

        // Hero Banner
        SliverToBoxAdapter(
          child: _buildHeroBanner(selectedSection),
        ),

        // Recommended Collections
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top Recommended',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.coffeeBrown,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Handpicked pieces just for you',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.coffeeBrown.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Recommended Items Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: selectedSection.categories.take(6).length,
                  itemBuilder: (context, index) {
                    final category = selectedSection.categories[index];
                    return CategoryCard(
                      category: category,
                      onTap: () => _navigateToCategory(category),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // All Categories Grid
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final category = selectedSection.categories[index];
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
                          0.3 + (index * 0.05),
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
              childCount: selectedSection.categories.length,
            ),
          ),
        ),

        // Bottom Padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 40),
        ),
      ],
    );
  }

  Widget _buildHeroBanner(CategorySection section) {
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
                section.heroImage ?? 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800',
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
                      section.title,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.warmCreme,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      section.description ?? 'Discover our curated collection',
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

  void _selectCategory(CategoryType category) {
    setState(() {
      _selectedCategory = category;
    });
    
    // Reset animations for new content
    _fadeController.reset();
    _slideController.reset();
    _fadeController.forward();
    _slideController.forward();
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

  IconData _getCategoryIcon(CategoryType type) {
    switch (type) {
      case CategoryType.clothing:
        return Icons.checkroom;
      case CategoryType.innerwear:
        return Icons.woman;
      case CategoryType.accessories:
        return Icons.diamond;
      case CategoryType.footwear:
        return Icons.healing;
      case CategoryType.beauty:
        return Icons.face;
    }
  }
}
