import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6e5e7),
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Color(0xFF3D3D3D),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFFf6e5e7),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF7A8F64)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildQuickActions(),
            const SizedBox(height: 24),
            _buildProfileOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF7A8F64).withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.person,
              size: 40,
              color: Color(0xFF7A8F64),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sarah Johnson',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D3D3D),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Premium Member Since 2023',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8B7355),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7A8F64),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'VIP Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            'Orders',
            Icons.shopping_bag_outlined,
            '12 Active',
            () => _navigateToOrders(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionCard(
            'Wishlist',
            Icons.favorite_border,
            '28 Items',
            () => _navigateToWishlist(),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: const Color(0xFF7A8F64),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3D3D3D),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF8B7355),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOptions() {
    return Column(
      children: [
        _buildSectionTitle('Account Settings'),
        const SizedBox(height: 12),
        _buildProfileOption(
          'Personal Information',
          Icons.person_outline,
          () => _navigateToPersonalInfo(),
        ),
        _buildProfileOption(
          'Skin Care Profile',
          Icons.face_retouching_natural,
          () => _navigateToSkinCare(),
        ),
        _buildProfileOption(
          'Size & Fit Preferences',
          Icons.straighten,
          () => _navigateToSizePreferences(),
        ),
        _buildProfileOption(
          'Address Book',
          Icons.location_on_outlined,
          () => _navigateToAddresses(),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('Membership & Benefits'),
        const SizedBox(height: 12),
        _buildProfileOption(
          'Card Plan',
          Icons.credit_card,
          () => _navigateToCardPlan(),
        ),
        _buildProfileOption(
          'Rewards Points',
          Icons.stars,
          () => _navigateToRewards(),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('Support'),
        const SizedBox(height: 12),
        _buildProfileOption(
          'Help Center',
          Icons.help_outline,
          () => _navigateToHelpCenter(),
        ),
        _buildProfileOption(
          'Contact Us',
          Icons.phone_outlined,
          () => _navigateToContact(),
        ),
        _buildProfileOption(
          'Terms & Privacy',
          Icons.description_outlined,
          () => _navigateToTerms(),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('App Settings'),
        const SizedBox(height: 12),
        _buildProfileOption(
          'Notifications',
          Icons.notifications_outlined,
          () => _navigateToNotifications(),
        ),
        _buildProfileOption(
          'Language',
          Icons.language,
          () => _navigateToLanguage(),
        ),
        _buildProfileOption(
          'Sign Out',
          Icons.logout,
          () => _signOut(),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF3D3D3D),
        ),
      ),
    );
  }

  Widget _buildProfileOption(String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF7A8F64).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFF7A8F64),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF3D3D3D),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFF8B7355),
        ),
        onTap: onTap,
      ),
    );
  }

  void _navigateToOrders() {
    // TODO: Navigate to orders screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Orders...')),
    );
  }

  void _navigateToWishlist() {
    // TODO: Navigate to wishlist screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Wishlist...')),
    );
  }

  void _navigateToPersonalInfo() {
    // TODO: Navigate to personal information screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Personal Information...')),
    );
  }

  void _navigateToSkinCare() {
    // TODO: Navigate to skin care profile screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Skin Care Profile...')),
    );
  }

  void _navigateToSizePreferences() {
    // TODO: Navigate to size preferences screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Size Preferences...')),
    );
  }

  void _navigateToAddresses() {
    // TODO: Navigate to address book screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Address Book...')),
    );
  }

  void _navigateToCardPlan() {
    // TODO: Navigate to card plan screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Card Plan...')),
    );
  }

  void _navigateToRewards() {
    // TODO: Navigate to rewards screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Rewards Points...')),
    );
  }

  void _navigateToHelpCenter() {
    // TODO: Navigate to help center screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Help Center...')),
    );
  }

  void _navigateToContact() {
    // TODO: Navigate to contact screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Contact Us...')),
    );
  }

  void _navigateToTerms() {
    // TODO: Navigate to terms and privacy screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Terms & Privacy...')),
    );
  }

  void _navigateToNotifications() {
    // TODO: Navigate to notifications screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Notifications...')),
    );
  }

  void _navigateToLanguage() {
    // TODO: Navigate to language screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Language Settings...')),
    );
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
