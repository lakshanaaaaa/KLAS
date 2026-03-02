import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../widgets/profile_tile.dart';
import '../../widgets/profile_switcher.dart';
import '../../models/profile_model.dart';
import '../../services/profile_storage_service.dart';
import '../../services/recommendation_engine.dart';
import 'add_profile_screen.dart';

class KlasProfileScreen extends StatefulWidget {
  const KlasProfileScreen({super.key});

  @override
  State<KlasProfileScreen> createState() => _KlasProfileScreenState();
}

class _KlasProfileScreenState extends State<KlasProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  List<ProfileModel> _profiles = [];
  ProfileModel? _activeProfile;
  bool _isLoading = true;
  bool _canAddMore = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadProfiles();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  Future<void> _loadProfiles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profiles = await ProfileStorageService.getProfiles();
      final activeProfile = await ProfileStorageService.getActiveProfile();
      final canAddMore = await ProfileStorageService.canAddMoreProfiles();

      setState(() {
        _profiles = profiles;
        _activeProfile = activeProfile;
        _canAddMore = canAddMore;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading profiles: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onProfileSelected(String profileId) async {
    await ProfileStorageService.setActiveProfile(profileId);
    await _loadProfiles();
  }

  Future<void> _onAddProfile() async {
    final result = await Navigator.push<ProfileModel>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddProfileScreen(),
      ),
    );

    if (result != null) {
      final success = await ProfileStorageService.addProfile(result);
      if (success) {
        await _loadProfiles();
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profile "${result.name}" added successfully!',
              style: GoogleFonts.poppins(
                color: AppColors.warmCreme,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: AppColors.coffeeBrown,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        // Show error message (max profiles reached)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Maximum profiles reached. Please delete an existing profile.',
              style: GoogleFonts.poppins(
                color: AppColors.warmCreme,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _deleteProfile(String profileId) async {
    final profile = _profiles.firstWhere((p) => p.id == profileId);
    
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Profile',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.coffeeBrown,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${profile.name}"? This action cannot be undone.',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: AppColors.coffeeBrown,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: AppColors.coffeeBrown,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: AppColors.warmCreme,
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ProfileStorageService.deleteProfile(profileId);
      if (success) {
        await _loadProfiles();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profile "${profile.name}" deleted successfully!',
              style: GoogleFonts.poppins(
                color: AppColors.warmCreme,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: AppColors.coffeeBrown,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCreme,
      appBar: AppBar(
        backgroundColor: AppColors.warmCreme,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Profile',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.coffeeBrown,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: AppColors.coffeeBrown,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile Switcher Section
              if (!_isLoading)
                ProfileSwitcher(
                  profiles: _profiles,
                  activeProfileId: _activeProfile?.id ?? '',
                  onProfileSelected: _onProfileSelected,
                  onAddProfile: _onAddProfile,
                  canAddMore: _canAddMore,
                ),
              
              if (_isLoading)
                const SizedBox(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.coffeeBrown,
                    ),
                  ),
                ),
              
              const SizedBox(height: 32),
              
              // Active Profile Details
              if (_activeProfile != null && !_isLoading)
                _buildActiveProfileDetails(),
              
              const SizedBox(height: 32),
              
              // Profile Actions
              if (_activeProfile != null && !_isLoading)
                _buildProfileActions(),
              
              const SizedBox(height: 32),
              
              // Profile Statistics
              if (!_isLoading && _profiles.isNotEmpty)
                _buildProfileStatistics(),
              
              const SizedBox(height: 32),
              
              // Menu Items
              _buildMenuItems(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveProfileDetails() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Avatar
          Hero(
            tag: 'profile-avatar-${_activeProfile!.id}',
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.coffeeBrown.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: AppColors.coffeeBrown.withOpacity(0.3),
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: _activeProfile!.avatarUrl != null && 
                       _activeProfile!.avatarUrl!.isNotEmpty
                    ? Image.network(
                        _activeProfile!.avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildDefaultAvatar();
                        },
                      )
                    : _buildDefaultAvatar(),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Profile Name
          Text(
            _activeProfile!.name,
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.coffeeBrown,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Profile Info
          Text(
            '${_activeProfile!.age} years • ${_activeProfile!.gender.displayName}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.coffeeBrown.withOpacity(0.7),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Size Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warmCreme,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Size Details',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.coffeeBrown,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSizeInfo('Top', _activeProfile!.topSize),
                    _buildSizeInfo('Bottom', _activeProfile!.bottomSize),
                    _buildSizeInfo('Shoes', _activeProfile!.footwearSize),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
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
        child: Text(
          _activeProfile!.initials,
          style: GoogleFonts.playfairDisplay(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: AppColors.warmCreme,
          ),
        ),
      ),
    );
  }

  Widget _buildSizeInfo(String label, String size) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.coffeeBrown.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          size,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.coffeeBrown,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileActions() {
    return Row(
      children: [
        // Edit Profile Button
        Expanded(
          child: GestureDetector(
            onTap: () {
              // TODO: Navigate to edit profile screen
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.coffeeBrown,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepMocha.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Text(
                'Edit Profile',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.warmCreme,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Delete Profile Button (if more than 1 profile)
        if (_profiles.length > 1)
          GestureDetector(
            onTap: () => _deleteProfile(_activeProfile!.id),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.red.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 20,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProfileStatistics() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Statistics',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.coffeeBrown,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Profiles',
                  '${_profiles.length}',
                  Icons.people_outline,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Available Slots',
                  '${5 - _profiles.length}',
                  Icons.add_circle_outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warmCreme,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.coffeeBrown,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.coffeeBrown,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.coffeeBrown.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        ProfileTile(
          icon: Icons.shopping_bag_outlined,
          title: 'Order History',
          onTap: () {
            // Navigate to orders
          },
        ),
        const SizedBox(height: 12),
        ProfileTile(
          icon: Icons.favorite_outline,
          title: 'Wishlist',
          onTap: () {
            // Navigate to wishlist
          },
        ),
        const SizedBox(height: 12),
        ProfileTile(
          icon: Icons.location_on_outlined,
          title: 'Shipping Addresses',
          onTap: () {
            // Navigate to addresses
          },
        ),
        const SizedBox(height: 12),
        ProfileTile(
          icon: Icons.payment_outlined,
          title: 'Payment Methods',
          onTap: () {
            // Navigate to payment methods
          },
        ),
        const SizedBox(height: 12),
        ProfileTile(
          icon: Icons.settings_outlined,
          title: 'Settings',
          onTap: () {
            // Navigate to settings
          },
        ),
        const SizedBox(height: 12),
        ProfileTile(
          icon: Icons.help_outline,
          title: 'Help & Support',
          onTap: () {
            // Navigate to help
          },
        ),
        const SizedBox(height: 12),
        ProfileTile(
          icon: Icons.logout_outlined,
          title: 'Sign Out',
          onTap: () {
            // Sign out
          },
          isDestructive: true,
        ),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.coffeeBrown,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.coffeeBrown.withOpacity(0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.coffeeBrown,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout logic
            },
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
