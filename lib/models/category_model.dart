enum CategoryType {
  clothing,
  innerwear,
  accessories,
  footwear,
  beauty;

  String get displayName {
    switch (this) {
      case CategoryType.clothing:
        return 'Clothing';
      case CategoryType.innerwear:
        return 'Innerwear & Sleepwear';
      case CategoryType.accessories:
        return 'Accessories';
      case CategoryType.footwear:
        return 'Footwear';
      case CategoryType.beauty:
        return 'Beauty & Care';
    }
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String imageUrl;
  final CategoryType type;
  final int productCount;
  final String? description;
  final List<String> subcategories;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.type,
    this.productCount = 0,
    this.description,
    this.subcategories = const [],
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      type: CategoryType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => CategoryType.clothing,
      ),
      productCount: json['productCount'] ?? 0,
      description: json['description'],
      subcategories: List<String>.from(json['subcategories'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'type': type.name,
      'productCount': productCount,
      'description': description,
      'subcategories': subcategories,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, type: $type)';
  }
}

class CategorySection {
  final CategoryType type;
  final String title;
  final String? description;
  final List<CategoryModel> categories;
  final String? heroImage;

  CategorySection({
    required this.type,
    required this.title,
    this.description,
    required this.categories,
    this.heroImage,
  });
}

class SampleCategories {
  static List<CategorySection> getAllSections() {
    return [
      CategorySection(
        type: CategoryType.clothing,
        title: 'Clothing',
        description: 'Elegant apparel for every occasion',
        heroImage: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800',
        categories: [
          CategoryModel(
            id: 'dresses',
            name: 'Dresses',
            imageUrl: 'https://images.unsplash.com/photo-1539008835657-9e8e9680c956?w=400',
            type: CategoryType.clothing,
            productCount: 245,
            description: 'Elegant dresses for every occasion',
            subcategories: ['Maxi Dresses', 'Midi Dresses', 'Mini Dresses', 'Party Dresses'],
          ),
          CategoryModel(
            id: 'kurti-ethnic',
            name: 'Kurti & Ethnic Wear',
            imageUrl: 'https://images.unsplash.com/photo-1594736797933-d0401ba2fe65?w=400',
            type: CategoryType.clothing,
            productCount: 189,
            description: 'Traditional and contemporary ethnic wear',
            subcategories: ['Kurtis', 'Salwar Kameez', 'Sarees', 'Lehengas'],
          ),
          CategoryModel(
            id: 'coord-sets',
            name: 'Co-ord Sets',
            imageUrl: 'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=400',
            type: CategoryType.clothing,
            productCount: 156,
            description: 'Perfectly coordinated outfits',
            subcategories: ['Casual Co-ords', 'Formal Co-ords', 'Party Co-ords'],
          ),
          CategoryModel(
            id: 'tops',
            name: 'Tops',
            imageUrl: 'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=400',
            type: CategoryType.clothing,
            productCount: 312,
            description: 'Stylish tops for every mood',
            subcategories: ['Casual Tops', 'Formal Tops', 'Crop Tops', 'Tunics'],
          ),
          CategoryModel(
            id: 'tshirts',
            name: 'T-Shirts',
            imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
            type: CategoryType.clothing,
            productCount: 278,
            description: 'Comfortable and trendy t-shirts',
            subcategories: ['Graphic Tees', 'Plain Tees', 'Oversized Tees'],
          ),
          CategoryModel(
            id: 'shirts',
            name: 'Shirts',
            imageUrl: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2f?w=400',
            type: CategoryType.clothing,
            productCount: 195,
            description: 'Classic and modern shirts',
            subcategories: ['Formal Shirts', 'Casual Shirts', 'Denim Shirts'],
          ),
          CategoryModel(
            id: 'jeans',
            name: 'Jeans',
            imageUrl: 'https://images.unsplash.com/photo-1542272606-44b355b12c8d?w=400',
            type: CategoryType.clothing,
            productCount: 234,
            description: 'Perfect fitting jeans for every body',
            subcategories: ['Skinny Jeans', 'Straight Jeans', 'Bootcut Jeans', 'Flared Jeans'],
          ),
          CategoryModel(
            id: 'trousers',
            name: 'Trousers',
            imageUrl: 'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=400',
            type: CategoryType.clothing,
            productCount: 167,
            description: 'Elegant trousers for work and leisure',
            subcategories: ['Formal Trousers', 'Casual Trousers', 'Palazzo Pants'],
          ),
          CategoryModel(
            id: 'skirts',
            name: 'Skirts',
            imageUrl: 'https://images.unsplash.com/photo-1583496266422-7dfb0f5d77c9?w=400',
            type: CategoryType.clothing,
            productCount: 143,
            description: 'Feminine skirts in various styles',
            subcategories: ['Mini Skirts', 'Midi Skirts', 'Maxi Skirts', 'Pencil Skirts'],
          ),
          CategoryModel(
            id: 'jumpsuits',
            name: 'Jumpsuits',
            imageUrl: 'https://images.unsplash.com/photo-1578632292335-df3abbb0d586?w=400',
            type: CategoryType.clothing,
            productCount: 98,
            description: 'One-piece elegance',
            subcategories: ['Casual Jumpsuits', 'Formal Jumpsuits', 'Party Jumpsuits'],
          ),
          CategoryModel(
            id: 'winter-wear',
            name: 'Winter Wear',
            imageUrl: 'https://images.unsplash.com/photo-1544966503-26e7586fba92?w=400',
            type: CategoryType.clothing,
            productCount: 176,
            description: 'Stay warm in style',
            subcategories: ['Coats', 'Jackets', 'Sweaters', 'Cardigans'],
          ),
          CategoryModel(
            id: 'blazers',
            name: 'Blazers',
            imageUrl: 'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=400',
            type: CategoryType.clothing,
            productCount: 124,
            description: 'Professional and stylish blazers',
            subcategories: ['Formal Blazers', 'Casual Blazers', 'Oversized Blazers'],
          ),
          CategoryModel(
            id: 'loungewear',
            name: 'Loungewear',
            imageUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400',
            type: CategoryType.clothing,
            productCount: 189,
            description: 'Comfortable home wear',
            subcategories: ['Lounge Sets', 'Pajamas', 'Robes', 'Sleep Shirts'],
          ),
          CategoryModel(
            id: 'nightwear',
            name: 'Nightwear',
            imageUrl: 'https://images.unsplash.com/photo-1595429226966-9a9a944e8ba0?w=400',
            type: CategoryType.clothing,
            productCount: 145,
            description: 'Comfortable night essentials',
            subcategories: ['Night Dresses', 'Pajama Sets', 'Night Suits'],
          ),
        ],
      ),
      
      CategorySection(
        type: CategoryType.innerwear,
        title: 'Innerwear & Sleepwear',
        description: 'Comfort and confidence from within',
        heroImage: 'https://images.unsplash.com/photo-1549060279-7e168fcee0c2?w=800',
        categories: [
          CategoryModel(
            id: 'bras',
            name: 'Bras',
            imageUrl: 'https://images.unsplash.com/photo-1594633312686-7359ce56d9ae?w=400',
            type: CategoryType.innerwear,
            productCount: 267,
            description: 'Comfortable and supportive bras',
            subcategories: ['T-shirt Bras', 'Sports Bras', 'Lace Bras', 'Push-up Bras'],
          ),
          CategoryModel(
            id: 'panties',
            name: 'Panties',
            imageUrl: 'https://images.unsplash.com/photo-1490481651871-ab68de25d425?w=400',
            type: CategoryType.innerwear,
            productCount: 312,
            description: 'Comfortable everyday essentials',
            subcategories: ['Briefs', 'Thongs', 'Boyshorts', 'Hipsters'],
          ),
          CategoryModel(
            id: 'shapewear',
            name: 'Shapewear',
            imageUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400',
            type: CategoryType.innerwear,
            productCount: 134,
            description: 'Enhance your natural silhouette',
            subcategories: ['Bodysuits', 'Waist Cinchers', 'Thigh Shapers'],
          ),
          CategoryModel(
            id: 'lingerie-sets',
            name: 'Lingerie Sets',
            imageUrl: 'https://images.unsplash.com/photo-1490481651871-ab68de25d425?w=400',
            type: CategoryType.innerwear,
            productCount: 189,
            description: 'Coordinated lingerie sets',
            subcategories: ['Lace Sets', 'Silk Sets', 'Cotton Sets'],
          ),
          CategoryModel(
            id: 'night-suits',
            name: 'Night Suits',
            imageUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400',
            type: CategoryType.innerwear,
            productCount: 156,
            description: 'Comfortable nightwear sets',
            subcategories: ['Cotton Night Suits', 'Silk Night Suits', 'Printed Sets'],
          ),
          CategoryModel(
            id: 'robes',
            name: 'Robes',
            imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
            type: CategoryType.innerwear,
            productCount: 98,
            description: 'Luxurious bath and lounge robes',
            subcategories: ['Bath Robes', 'Lounge Robes', 'Silk Robes'],
          ),
          CategoryModel(
            id: 'maternity-wear',
            name: 'Maternity Wear',
            imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
            type: CategoryType.innerwear,
            productCount: 145,
            description: 'Comfortable maternity essentials',
            subcategories: ['Maternity Bras', 'Maternity Panties', 'Nursing Wear'],
          ),
        ],
      ),
      
      CategorySection(
        type: CategoryType.accessories,
        title: 'Accessories',
        description: 'Complete your look with perfect accessories',
        heroImage: 'https://images.unsplash.com/photo-1524863479829-916d8e5f7ea1?w=800',
        categories: [
          CategoryModel(
            id: 'handbags',
            name: 'Handbags',
            imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400',
            type: CategoryType.accessories,
            productCount: 289,
            description: 'Stylish handbags for every occasion',
            subcategories: ['Tote Bags', 'Clutches', 'Crossbody Bags', 'Shoulder Bags'],
          ),
          CategoryModel(
            id: 'clutches',
            name: 'Clutches',
            imageUrl: 'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=400',
            type: CategoryType.accessories,
            productCount: 167,
            description: 'Elegant clutches for special occasions',
            subcategories: ['Evening Clutches', 'Wedding Clutches', 'Party Clutches'],
          ),
          CategoryModel(
            id: 'jewellery',
            name: 'Jewellery',
            imageUrl: 'https://images.unsplash.com/photo-1596944924646-6b9c81ba0792?w=400',
            type: CategoryType.accessories,
            productCount: 423,
            description: 'Beautiful jewellery pieces',
            subcategories: ['Necklaces', 'Earrings', 'Bracelets', 'Rings'],
          ),
          CategoryModel(
            id: 'watches',
            name: 'Watches',
            imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
            type: CategoryType.accessories,
            productCount: 198,
            description: 'Elegant timepieces',
            subcategories: ['Analog Watches', 'Smart Watches', 'Luxury Watches'],
          ),
          CategoryModel(
            id: 'sunglasses',
            name: 'Sunglasses',
            imageUrl: 'https://images.unsplash.com/photo-1473496169904-658ba799cd28?w=400',
            type: CategoryType.accessories,
            productCount: 145,
            description: 'Stylish eye protection',
            subcategories: ['Aviator', 'Wayfarer', 'Cat Eye', 'Round'],
          ),
          CategoryModel(
            id: 'belts',
            name: 'Belts',
            imageUrl: 'https://images.unsplash.com/photo-1544966503-26e7586fba92?w=400',
            type: CategoryType.accessories,
            productCount: 123,
            description: 'Fashionable belts',
            subcategories: ['Leather Belts', 'Fabric Belts', 'Chain Belts'],
          ),
          CategoryModel(
            id: 'hair-accessories',
            name: 'Hair Accessories',
            imageUrl: 'https://images.unsplash.com/photo-1562322140439-69e35b8b4c44?w=400',
            type: CategoryType.accessories,
            productCount: 234,
            description: 'Beautiful hair accessories',
            subcategories: ['Hair Clips', 'Headbands', 'Hair Ties', 'Scrunchies'],
          ),
        ],
      ),
      
      CategorySection(
        type: CategoryType.footwear,
        title: 'Footwear',
        description: 'Step out in style',
        heroImage: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=800',
        categories: [
          CategoryModel(
            id: 'heels',
            name: 'Heels',
            imageUrl: 'https://images.unsplash.com/photo-1543169868-851b9c3b3b2d?w=400',
            type: CategoryType.footwear,
            productCount: 267,
            description: 'Elegant heels for every occasion',
            subcategories: ['Stilettos', 'Block Heels', 'Wedges', 'Kitten Heels'],
          ),
          CategoryModel(
            id: 'flats',
            name: 'Flats',
            imageUrl: 'https://images.unsplash.com/photo-1460353571641-1d1239a76c34?w=400',
            type: CategoryType.footwear,
            productCount: 198,
            description: 'Comfortable flats for daily wear',
            subcategories: ['Ballet Flats', 'Loafers', 'Moccasins'],
          ),
          CategoryModel(
            id: 'sandals',
            name: 'Sandals',
            imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400',
            type: CategoryType.footwear,
            productCount: 234,
            description: 'Stylish sandals for warm weather',
            subcategories: ['Flat Sandals', 'Heeled Sandals', 'Gladiator Sandals'],
          ),
          CategoryModel(
            id: 'sneakers',
            name: 'Sneakers',
            imageUrl: 'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=400',
            type: CategoryType.footwear,
            productCount: 312,
            description: 'Trendy sneakers for active lifestyle',
            subcategories: ['Athletic Sneakers', 'Fashion Sneakers', 'High-tops'],
          ),
          CategoryModel(
            id: 'boots',
            name: 'Boots',
            imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400',
            type: CategoryType.footwear,
            productCount: 189,
            description: 'Stylish boots for all seasons',
            subcategories: ['Ankle Boots', 'Knee-high Boots', 'Combat Boots'],
          ),
          CategoryModel(
            id: 'ethnic-footwear',
            name: 'Ethnic Footwear',
            imageUrl: 'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=400',
            type: CategoryType.footwear,
            productCount: 145,
            description: 'Traditional ethnic footwear',
            subcategories: ['Juttis', 'Mojaris', 'Kolhapuris', 'Ethnic Sandals'],
          ),
        ],
      ),
      
      CategorySection(
        type: CategoryType.beauty,
        title: 'Beauty & Care',
        description: 'Enhance your natural beauty',
        heroImage: 'https://images.unsplash.com/photo-1596462502278-27d44129a983?w=800',
        categories: [
          CategoryModel(
            id: 'skincare',
            name: 'Skincare',
            imageUrl: 'https://images.unsplash.com/photo-1556228723-3f071e45ac4c?w=400',
            type: CategoryType.beauty,
            productCount: 456,
            description: 'Complete skincare solutions',
            subcategories: ['Face Care', 'Body Care', 'Sun Care', 'Lip Care'],
          ),
          CategoryModel(
            id: 'makeup',
            name: 'Makeup',
            imageUrl: 'https://images.unsplash.com/photo-1596462502278-27d44129a983?w=400',
            type: CategoryType.beauty,
            productCount: 523,
            description: 'Professional makeup products',
            subcategories: ['Foundation', 'Lipstick', 'Eye Makeup', 'Face Makeup'],
          ),
          CategoryModel(
            id: 'haircare',
            name: 'Haircare',
            imageUrl: 'https://images.unsplash.com/photo-1562322140439-69e35b8b4c44?w=400',
            type: CategoryType.beauty,
            productCount: 389,
            description: 'Complete hair care solutions',
            subcategories: ['Shampoos', 'Conditioners', 'Hair Oils', 'Styling Products'],
          ),
          CategoryModel(
            id: 'bath-body',
            name: 'Bath & Body',
            imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
            type: CategoryType.beauty,
            productCount: 278,
            description: 'Luxurious bath and body products',
            subcategories: ['Body Wash', 'Body Lotion', 'Bath Salts', 'Soaps'],
          ),
          CategoryModel(
            id: 'fragrance',
            name: 'Fragrance',
            imageUrl: 'https://images.unsplash.com/photo-1541643600964-783ee5a45617?w=400',
            type: CategoryType.beauty,
            productCount: 234,
            description: 'Captivating fragrances',
            subcategories: ['Perfumes', 'Body Mists', 'Deodorants', 'Roll-ons'],
          ),
        ],
      ),
    ];
  }
}
