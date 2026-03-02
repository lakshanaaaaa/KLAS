import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../models/category_model.dart';

class CategoryCard extends StatefulWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _onTap,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: Matrix4.identity()..scale(
                _isHovered ? _scaleAnimation.value : 1.0
              ),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: AppColors.deepMocha.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                          BoxShadow(
                            color: AppColors.coffeeBrown.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      // Background Image
                      Positioned.fill(
                        child: Image.network(
                          widget.category.imageUrl,
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
                              child: Center(
                                child: Icon(
                                  _getCategoryIcon(widget.category.type),
                                  size: 40,
                                  color: AppColors.warmCreme,
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
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.1),
                                Colors.black.withOpacity(0.4),
                              ],
                              stops: const [0.0, 0.6, 1.0],
                            ),
                          ),
                        ),
                      ),
                      
                      // Category Info
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(24),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Category Name
                              Text(
                                widget.category.name,
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.warmCreme,
                                  letterSpacing: 0.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              
                              const SizedBox(height: 4),
                              
                              // Product Count
                              Row(
                                children: [
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 14,
                                    color: AppColors.warmCreme.withOpacity(0.8),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${widget.category.productCount} items',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.warmCreme.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Hover Effect Overlay
                      if (_isHovered)
                        Positioned.fill(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: AppColors.coffeeBrown.withOpacity(0.1),
                              border: Border.all(
                                color: AppColors.coffeeBrown.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
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

class CategoryChip extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const CategoryChip({
    super.key,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  State<CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<CategoryChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _onTap,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: Matrix4.identity()..scale(
                widget.isSelected ? _scaleAnimation.value : 1.0
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? AppColors.coffeeBrown
                    : AppColors.warmCreme,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.isSelected
                      ? AppColors.coffeeBrown
                      : AppColors.softBeige,
                  width: 2,
                ),
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.deepMocha.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                widget.label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: widget.isSelected
                      ? AppColors.warmCreme
                      : AppColors.coffeeBrown,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
