import '../../models/profile_model.dart';

class ProductModel {
  final String id;
  final String name;
  final String category;
  final List<String> sizes;
  final List<String> concerns;
  final List<String> skinTypes;
  final List<String> hairTypes;
  final String? imageUrl;
  final double price;
  final String description;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.sizes,
    required this.concerns,
    required this.skinTypes,
    required this.hairTypes,
    this.imageUrl,
    required this.price,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      sizes: List<String>.from(json['sizes'] ?? []),
      concerns: List<String>.from(json['concerns'] ?? []),
      skinTypes: List<String>.from(json['skinTypes'] ?? []),
      hairTypes: List<String>.from(json['hairTypes'] ?? []),
      imageUrl: json['imageUrl'],
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'sizes': sizes,
      'concerns': concerns,
      'skinTypes': skinTypes,
      'hairTypes': hairTypes,
      'imageUrl': imageUrl,
      'price': price,
      'description': description,
    };
  }
}

class RecommendationEngine {
  static List<ProductModel> getRecommendations(
    ProfileModel profile,
    List<ProductModel> allProducts,
  ) {
    final recommendations = <ProductModel>[];
    
    for (final product in allProducts) {
      final score = _calculateRecommendationScore(profile, product);
      if (score > 0) {
        recommendations.add(product);
      }
    }
    
    // Sort by recommendation score (highest first)
    recommendations.sort((a, b) => 
      _calculateRecommendationScore(profile, b).compareTo(
        _calculateRecommendationScore(profile, a)
      )
    );
    
    return recommendations.take(10).toList(); // Top 10 recommendations
  }

  static double _calculateRecommendationScore(ProfileModel profile, ProductModel product) {
    double score = 0;
    
    // Size match (30 points)
    if (_matchesSize(profile, product)) {
      score += 30;
    }
    
    // Skin type match (25 points)
    if (_matchesSkinType(profile, product)) {
      score += 25;
    }
    
    // Hair type match (20 points)
    if (_matchesHairType(profile, product)) {
      score += 20;
    }
    
    // Primary concern match (25 points)
    if (_matchesConcern(profile, product)) {
      score += 25;
    }
    
    return score;
  }

  static bool _matchesSize(ProfileModel profile, ProductModel product) {
    // Check if product has matching size for profile
    final profileSizes = [
      profile.topSize.toLowerCase(),
      profile.bottomSize.toLowerCase(),
      profile.footwearSize.toLowerCase(),
    ];
    
    return product.sizes.any((size) => 
      profileSizes.contains(size.toLowerCase())
    );
  }

  static bool _matchesSkinType(ProfileModel profile, ProductModel product) {
    return product.skinTypes.contains(profile.skinType.name);
  }

  static bool _matchesHairType(ProfileModel profile, ProductModel product) {
    return product.hairTypes.contains(profile.hairType.name);
  }

  static bool _matchesConcern(ProfileModel profile, ProductModel product) {
    return product.concerns.contains(profile.primaryConcern.name);
  }

  static String getRecommendationReason(ProfileModel profile, ProductModel product) {
    final reasons = <String>[];
    
    if (_matchesSize(profile, product)) {
      reasons.add('Perfect size match');
    }
    
    if (_matchesSkinType(profile, product)) {
      reasons.add('Ideal for ${profile.skinType.displayName} skin');
    }
    
    if (_matchesHairType(profile, product)) {
      reasons.add('Great for ${profile.hairType.displayName} hair');
    }
    
    if (_matchesConcern(profile, product)) {
      reasons.add('Targets ${profile.primaryConcern.displayName}');
    }
    
    if (reasons.isEmpty) {
      return 'Recommended for you';
    }
    
    return reasons.join(' • ');
  }

  static List<String> getPersonalizedTags(ProfileModel profile, ProductModel product) {
    final tags = <String>[];
    
    if (_matchesSize(profile, product)) {
      tags.add('Size Match');
    }
    
    if (_matchesSkinType(profile, product)) {
      tags.add('Skin Type');
    }
    
    if (_matchesHairType(profile, product)) {
      tags.add('Hair Type');
    }
    
    if (_matchesConcern(profile, product)) {
      tags.add('Concern Match');
    }
    
    return tags;
  }
}

// Sample product data for testing
class SampleProducts {
  static List<ProductModel> getProducts() {
    return [
      // Skincare Products
      ProductModel(
        id: '1',
        name: 'Oil Control Face Wash',
        category: 'skincare',
        sizes: ['50ml', '100ml'],
        concerns: ['acne', 'dullSkin'],
        skinTypes: ['oily', 'combination'],
        hairTypes: [],
        price: 24.99,
        description: 'Gentle face wash that controls excess oil and prevents breakouts.',
      ),
      
      ProductModel(
        id: '2',
        name: 'Hydrating Moisturizer',
        category: 'skincare',
        sizes: ['50ml', '100ml'],
        concerns: ['dullSkin', 'pigmentation'],
        skinTypes: ['dry', 'combination'],
        hairTypes: [],
        price: 34.99,
        description: 'Deeply hydrating moisturizer for dry and combination skin types.',
      ),
      
      ProductModel(
        id: '3',
        name: 'Anti-Pigmentation Serum',
        category: 'skincare',
        sizes: ['30ml'],
        concerns: ['pigmentation', 'dullSkin'],
        skinTypes: ['dry', 'oily', 'combination'],
        hairTypes: [],
        price: 54.99,
        description: 'Powerful serum that reduces dark spots and evens skin tone.',
      ),
      
      ProductModel(
        id: '4',
        name: 'Anti-Hair Fall Shampoo',
        category: 'haircare',
        sizes: ['200ml', '400ml'],
        concerns: ['hairFall'],
        skinTypes: [],
        hairTypes: ['curly', 'straight', 'wavy'],
        price: 19.99,
        description: 'Strengthening shampoo that reduces hair fall and promotes growth.',
      ),
      
      ProductModel(
        id: '5',
        name: 'Curl Enhancing Cream',
        category: 'haircare',
        sizes: ['150ml', '300ml'],
        concerns: ['frizz'],
        skinTypes: [],
        hairTypes: ['curly', 'wavy'],
        price: 22.99,
        description: 'Defines and enhances natural curls while controlling frizz.',
      ),
      
      ProductModel(
        id: '6',
        name: 'Smoothing Hair Serum',
        category: 'haircare',
        sizes: ['50ml', '100ml'],
        concerns: ['frizz'],
        skinTypes: [],
        hairTypes: ['straight', 'wavy'],
        price: 28.99,
        description: 'Lightweight serum that smooths frizz and adds shine.',
      ),
      
      // Clothing Products
      ProductModel(
        id: '7',
        name: 'Classic White T-Shirt',
        category: 'clothing',
        sizes: ['XS', 'S', 'M', 'L', 'XL'],
        concerns: [],
        skinTypes: [],
        hairTypes: [],
        price: 29.99,
        description: 'Premium cotton t-shirt with perfect fit.',
      ),
      
      ProductModel(
        id: '8',
        name: 'Slim Fit Jeans',
        category: 'clothing',
        sizes: ['28', '30', '32', '34'],
        concerns: [],
        skinTypes: [],
        hairTypes: [],
        price: 79.99,
        description: 'Modern slim fit jeans with stretch comfort.',
      ),
      
      ProductModel(
        id: '9',
        name: 'Comfortable Sneakers',
        category: 'footwear',
        sizes: ['6', '7', '8', '9'],
        concerns: [],
        skinTypes: [],
        hairTypes: [],
        price: 89.99,
        description: 'Stylish and comfortable sneakers for all-day wear.',
      ),
      
      ProductModel(
        id: '10',
        name: 'Elegant Dress',
        category: 'clothing',
        sizes: ['XS', 'S', 'M', 'L'],
        concerns: [],
        skinTypes: [],
        hairTypes: [],
        price: 129.99,
        description: 'Beautiful elegant dress perfect for special occasions.',
      ),
      
      ProductModel(
        id: '11',
        name: 'Acne Treatment Gel',
        category: 'skincare',
        sizes: ['15ml', '30ml'],
        concerns: ['acne'],
        skinTypes: ['oily', 'combination'],
        hairTypes: [],
        price: 39.99,
        description: 'Targeted treatment for acne and blemishes.',
      ),
      
      ProductModel(
        id: '12',
        name: 'Brightening Face Mask',
        category: 'skincare',
        sizes: ['5pcs', '10pcs'],
        concerns: ['dullSkin', 'pigmentation'],
        skinTypes: ['dry', 'oily', 'combination'],
        hairTypes: [],
        price: 44.99,
        description: 'Instant brightening mask for radiant skin.',
      ),
    ];
  }
}
