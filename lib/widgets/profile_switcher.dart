import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../models/profile_model.dart';

class ProfileSwitcher extends StatefulWidget {
  final List<ProfileModel> profiles;
  final String activeProfileId;
  final Function(String) onProfileSelected;
  final VoidCallback onAddProfile;
  final bool canAddMore;

  const ProfileSwitcher({
    super.key,
    required this.profiles,
    required this.activeProfileId,
    required this.onProfileSelected,
    required this.onAddProfile,
    required this.canAddMore,
  });

  @override
  State<ProfileSwitcher> createState() => _ProfileSwitcherState();
}

class _ProfileSwitcherState extends State<ProfileSwitcher>
    with TickerProviderStateMixin {
  late AnimationController _selectionController;
  late Animation<double> _selectionAnimation;

  @override
  void initState() {
    super.initState();
    _selectionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _selectionAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _selectionController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _selectionController.dispose();
    super.dispose();
  }

  void _animateSelection() {
    _selectionController.forward().then((_) {
      _selectionController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Shopping For',
            style: GoogleFonts.playfairDisplay(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.coffeeBrown,
              letterSpacing: 1,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Horizontal Scrollable Profiles
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: widget.profiles.length + (widget.canAddMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == widget.profiles.length) {
                // Add Profile Button
                return _buildAddProfileButton();
              }
              
              final profile = widget.profiles[index];
              final isActive = profile.id == widget.activeProfileId;
              
              return _buildProfileAvatar(profile, isActive);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileAvatar(ProfileModel profile, bool isActive) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () {
          if (!isActive) {
            widget.onProfileSelected(profile.id);
            _animateSelection();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(isActive ? 1.05 : 1.0),
          child: Column(
            children: [
              // Avatar Container
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive 
                        ? AppColors.coffeeBrown 
                        : AppColors.softBeige.withOpacity(0.5),
                    width: isActive ? 3 : 2,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.coffeeBrown.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                          BoxShadow(
                            color: AppColors.coffeeBrown.withOpacity(0.1),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: AppColors.shadowColor.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive 
                        ? AppColors.coffeeBrown.withOpacity(0.1)
                        : AppColors.softBeige.withOpacity(0.3),
                  ),
                  child: ClipOval(
                    child: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                        ? Image.network(
                            profile.avatarUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildInitialsAvatar(profile);
                            },
                          )
                        : _buildInitialsAvatar(profile),
                  ),
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Name
              SizedBox(
                width: 80,
                child: Text(
                  profile.name,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive 
                        ? AppColors.coffeeBrown 
                        : AppColors.coffeeBrown.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialsAvatar(ProfileModel profile) {
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
          profile.initials,
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.warmCreme,
          ),
        ),
      ),
    );
  }

  Widget _buildAddProfileButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: widget.canAddMore ? widget.onAddProfile : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Column(
            children: [
              // Add Button Container
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.canAddMore
                        ? AppColors.coffeeBrown.withOpacity(0.5)
                        : AppColors.softBeige.withOpacity(0.3),
                    width: 2,
                  ),
                  color: widget.canAddMore
                      ? AppColors.coffeeBrown.withOpacity(0.05)
                      : AppColors.softBeige.withOpacity(0.2),
                  boxShadow: widget.canAddMore
                      ? [
                          BoxShadow(
                            color: AppColors.shadowColor.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    size: 24,
                    color: widget.canAddMore
                        ? AppColors.coffeeBrown.withOpacity(0.7)
                        : AppColors.coffeeBrown.withOpacity(0.3),
                  ),
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Add Text
              SizedBox(
                width: 80,
                child: Text(
                  'Add Profile',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: widget.canAddMore
                        ? AppColors.coffeeBrown.withOpacity(0.7)
                        : AppColors.coffeeBrown.withOpacity(0.3),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
