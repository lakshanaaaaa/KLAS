import 'package:flutter/material.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedSort = 'Name';
  double _priceRange = 500.0;
  bool _showFilters = false;

  final List<String> _categories = [
    'All', 'Dresses', 'Tops', 'Bottoms', 'Outerwear', 'Accessories', 'Shoes'
  ];

  final List<String> _sortOptions = [
    'Name', 'Price: Low to High', 'Price: High to Low', 'Newest', 'Oldest'
  ];

  // Sample wishlist items
  final List<Map<String, dynamic>> _wishlistItems = [
    {
      'id': 1,
      'name': 'Elegant Silk Dress',
      'price': 299.99,
      'image': 'assets/images/dress1.jpg',
      'category': 'Dresses',
      'addedDate': DateTime.now().subtract(Duration(days: 5)),
      'inStock': true,
    },
    {
      'id': 2,
      'name': 'Classic White Blouse',
      'price': 149.99,
      'image': 'assets/images/top1.jpg',
      'category': 'Tops',
      'addedDate': DateTime.now().subtract(Duration(days: 3)),
      'inStock': true,
    },
    {
      'id': 3,
      'name': 'Designer Handbag',
      'price': 599.99,
      'image': 'assets/images/bag1.jpg',
      'category': 'Accessories',
      'addedDate': DateTime.now().subtract(Duration(days: 7)),
      'inStock': false,
    },
    {
      'id': 4,
      'name': 'Wool Coat',
      'price': 449.99,
      'image': 'assets/images/coat1.jpg',
      'category': 'Outerwear',
      'addedDate': DateTime.now().subtract(Duration(days: 2)),
      'inStock': true,
    },
    {
      'id': 5,
      'name': 'Silk Scarf',
      'price': 89.99,
      'image': 'assets/images/scarf1.jpg',
      'category': 'Accessories',
      'addedDate': DateTime.now().subtract(Duration(days: 1)),
      'inStock': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredItems {
    var filtered = List<Map<String, dynamic>>.from(_wishlistItems);

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((item) =>
        item['name'].toString().toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    }

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered.where((item) =>
        item['category'] == _selectedCategory
      ).toList();
    }

    // Apply price filter
    filtered = filtered.where((item) =>
      (item['price'] as double) <= _priceRange
    ).toList();

    // Apply sorting
    switch (_selectedSort) {
      case 'Name':
        filtered.sort((a, b) => a['name'].toString().compareTo(b['name'].toString()));
        break;
      case 'Price: Low to High':
        filtered.sort((a, b) => (a['price'] as double).compareTo(b['price'] as double));
        break;
      case 'Price: High to Low':
        filtered.sort((a, b) => (b['price'] as double).compareTo(a['price'] as double));
        break;
      case 'Newest':
        filtered.sort((a, b) => (b['addedDate'] as DateTime).compareTo(a['addedDate'] as DateTime));
        break;
      case 'Oldest':
        filtered.sort((a, b) => (a['addedDate'] as DateTime).compareTo(b['addedDate'] as DateTime));
        break;
    }

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8D5C4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8D5C4),
        elevation: 0,
        title: const Text(
          'My Wishlist',
          style: TextStyle(
            color: Color(0xFF8FA879),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF8FA879)),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
              color: const Color(0xFF8FA879),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search wishlist items...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF8FA879)),
                suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.clear, color: Color(0xFF8FA879)),
                    )
                  : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF8FA879)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF8FA879)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF8FA879), width: 2),
                ),
              ),
            ),
          ),

          // Filters Section
          if (_showFilters) _buildFiltersSection(),

          // Results Count
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_filteredItems.length} items',
                  style: const TextStyle(
                    color: Color(0xFF8B7355),
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                if (_filteredItems.isEmpty)
                  TextButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _selectedCategory = 'All';
                        _selectedSort = 'Name';
                        _priceRange = 500.0;
                      });
                    },
                    child: const Text(
                      'Clear Filters',
                      style: TextStyle(color: Color(0xFF8FA879)),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Wishlist Items Grid
          Expanded(
            child: _filteredItems.isEmpty
              ? _buildEmptyState()
              : _buildWishlistGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF8FA879).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Filter
          const Text(
            'Category',
            style: TextStyle(
              color: Color(0xFF8FA879),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category;
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                backgroundColor: Colors.white,
                selectedColor: const Color(0xFF8FA879).withOpacity(0.2),
                checkmarkColor: const Color(0xFF8FA879),
                labelStyle: TextStyle(
                  color: isSelected ? const Color(0xFF8FA879) : const Color(0xFF8B7355),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                side: const BorderSide(color: Color(0xFF8FA879)),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Sort Filter
          const Text(
            'Sort By',
            style: TextStyle(
              color: Color(0xFF8FA879),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedSort,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF8FA879)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF8FA879)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF8FA879), width: 2),
              ),
            ),
            items: _sortOptions.map((sort) {
              return DropdownMenuItem(
                value: sort,
                child: Text(sort),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedSort = value!;
              });
            },
          ),
          const SizedBox(height: 16),

          // Price Range Filter
          Text(
            'Max Price: \$${_priceRange.toInt()}',
            style: const TextStyle(
              color: Color(0xFF8FA879),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Slider(
            value: _priceRange,
            min: 0,
            max: 1000,
            divisions: 20,
            activeColor: const Color(0xFF8FA879),
            inactiveColor: const Color(0xFF8FA879).withOpacity(0.3),
            onChanged: (value) {
              setState(() {
                _priceRange = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return _buildWishlistItem(item);
      },
    );
  }

  Widget _buildWishlistItem(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    color: const Color(0xFFFAF7F2),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Icon(
                      Icons.image,
                      size: 60,
                      color: const Color(0xFF8FA879).withOpacity(0.5),
                    ),
                  ),
                ),
                // Remove from Wishlist Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _wishlistItems.removeWhere((i) => i['id'] == item['id']);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                // Stock Status
                if (!(item['inStock'] as bool))
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Out of Stock',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Product Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'].toString(),
                    style: const TextStyle(
                      color: Color(0xFF8B7355),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item['price'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFF8FA879),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: item['inStock'] ? () {
                        // TODO: Add to cart logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item['name']} added to cart'),
                            backgroundColor: const Color(0xFF8FA879),
                          ),
                        );
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8FA879),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: const Color(0xFF8FA879).withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your wishlist is empty',
            style: TextStyle(
              color: Color(0xFF8B7355),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start adding items you love!',
            style: TextStyle(
              color: Color(0xFF8B7355),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8FA879),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }
}
