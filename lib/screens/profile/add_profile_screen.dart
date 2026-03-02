import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../models/profile_model.dart';

class AddProfileScreen extends StatefulWidget {
  const AddProfileScreen({super.key});

  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _stepperController;
  late Animation<double> _stepperAnimation;
  
  int _currentStep = 0;
  final int _totalSteps = 3;
  
  // Form Controllers
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _topSizeController = TextEditingController();
  final _bottomSizeController = TextEditingController();
  final _footwearSizeController = TextEditingController();
  
  // Form Values
  Gender _selectedGender = Gender.female;
  FitPreference _selectedFitPreference = FitPreference.regular;
  SkinType _selectedSkinType = SkinType.combination;
  HairType _selectedHairType = HairType.straight;
  PrimaryConcern _selectedConcern = PrimaryConcern.dullSkin;
  
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _stepperController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _stepperAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _stepperController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _stepperController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _topSizeController.dispose();
    _bottomSizeController.dispose();
    _footwearSizeController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      bool isValid = false;
      
      switch (_currentStep) {
        case 0:
          isValid = _formKey1.currentState?.validate() ?? false;
          break;
        case 1:
          isValid = _formKey2.currentState?.validate() ?? false;
          break;
        case 2:
          isValid = _formKey3.currentState?.validate() ?? false;
          break;
      }
      
      if (isValid) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentStep++;
        });
        _stepperController.forward();
      }
    } else {
      _saveProfile();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep--;
      });
      _stepperController.reverse();
    }
  }

  void _saveProfile() {
    if (_formKey3.currentState?.validate() ?? false) {
      final profile = ProfileModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        topSize: _topSizeController.text.trim(),
        bottomSize: _bottomSizeController.text.trim(),
        footwearSize: _footwearSizeController.text.trim(),
        fitPreference: _selectedFitPreference,
        skinType: _selectedSkinType,
        hairType: _selectedHairType,
        primaryConcern: _selectedConcern,
      );
      
      Navigator.pop(context, profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCreme,
      appBar: AppBar(
        backgroundColor: AppColors.warmCreme,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.coffeeBrown,
          ),
        ),
        title: Text(
          'Add Profile',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.coffeeBrown,
          ),
        ),
      ),
      body: Column(
        children: [
          // Stepper
          _buildStepper(),
          
          const SizedBox(height: 24),
          
          // Form Pages
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildBasicDetailsStep(),
                _buildSizeDetailsStep(),
                _buildSkinHairStep(),
              ],
            ),
          ),
          
          // Navigation Buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: List.generate(_totalSteps, (index) {
              final isCompleted = index < _currentStep;
              final isCurrent = index == _currentStep;
              
              return Expanded(
                child: Row(
                  children: [
                    // Step Circle
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? AppColors.coffeeBrown
                            : isCurrent
                                ? AppColors.coffeeBrown
                                : AppColors.softBeige,
                        border: Border.all(
                          color: isCompleted || isCurrent
                              ? AppColors.coffeeBrown
                              : AppColors.softBeige,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: isCompleted
                            ? Icon(
                                Icons.check,
                                size: 20,
                                color: AppColors.warmCreme,
                              )
                            : Text(
                                '${index + 1}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isCurrent
                                      ? AppColors.warmCreme
                                      : AppColors.coffeeBrown,
                                ),
                              ),
                      ),
                    ),
                    
                    // Step Line
                    if (index < _totalSteps - 1)
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 2,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppColors.coffeeBrown
                                : AppColors.softBeige,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          
          const SizedBox(height: 8),
          
          // Step Labels
          Row(
            children: [
              Expanded(
                child: Text(
                  'Basic',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: _currentStep >= 0 ? FontWeight.w600 : FontWeight.w400,
                    color: _currentStep >= 0
                        ? AppColors.coffeeBrown
                        : AppColors.coffeeBrown.withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Size',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: _currentStep >= 1 ? FontWeight.w600 : FontWeight.w400,
                    color: _currentStep >= 1
                        ? AppColors.coffeeBrown
                        : AppColors.coffeeBrown.withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Skin & Hair',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: _currentStep >= 2 ? FontWeight.w600 : FontWeight.w400,
                    color: _currentStep >= 2
                        ? AppColors.coffeeBrown
                        : AppColors.coffeeBrown.withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBasicDetailsStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Details',
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.coffeeBrown,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Name Field
            _buildTextField(
              controller: _nameController,
              label: 'Name',
              hint: 'Enter profile name',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Age Field
            _buildTextField(
              controller: _ageController,
              label: 'Age',
              hint: 'Enter age',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter age';
                }
                final age = int.tryParse(value);
                if (age == null || age < 1 || age > 120) {
                  return 'Please enter a valid age';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Gender Selection
            Text(
              'Gender',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.coffeeBrown,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: Gender.values.map((gender) {
                final isSelected = _selectedGender == gender;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: gender != Gender.other ? 8 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGender = gender;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.coffeeBrown
                              : AppColors.warmCreme,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.coffeeBrown
                                : AppColors.softBeige,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          gender.displayName,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? AppColors.warmCreme
                                : AppColors.coffeeBrown,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeDetailsStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Size Details',
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.coffeeBrown,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Top Size
            _buildTextField(
              controller: _topSizeController,
              label: 'Top Size',
              hint: 'e.g., S, M, L, XL',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter top size';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Bottom Size
            _buildTextField(
              controller: _bottomSizeController,
              label: 'Bottom Size',
              hint: 'e.g., 28, 30, 32, 34',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter bottom size';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Footwear Size
            _buildTextField(
              controller: _footwearSizeController,
              label: 'Footwear Size',
              hint: 'e.g., 6, 7, 8, 9',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter footwear size';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Fit Preference
            Text(
              'Fit Preference',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.coffeeBrown,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: FitPreference.values.map((fit) {
                final isSelected = _selectedFitPreference == fit;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: fit != FitPreference.slim ? 8 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFitPreference = fit;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.coffeeBrown
                              : AppColors.warmCreme,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.coffeeBrown
                                : AppColors.softBeige,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          fit.displayName,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? AppColors.warmCreme
                                : AppColors.coffeeBrown,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkinHairStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Skin & Hair',
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.coffeeBrown,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Skin Type
            Text(
              'Skin Type',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.coffeeBrown,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: SkinType.values.map((type) {
                final isSelected = _selectedSkinType == type;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: type != SkinType.combination ? 8 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSkinType = type;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.coffeeBrown
                              : AppColors.warmCreme,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.coffeeBrown
                                : AppColors.softBeige,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          type.displayName,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? AppColors.warmCreme
                                : AppColors.coffeeBrown,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // Hair Type
            Text(
              'Hair Type',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.coffeeBrown,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: HairType.values.map((type) {
                final isSelected = _selectedHairType == type;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: type != HairType.wavy ? 8 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedHairType = type;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.coffeeBrown
                              : AppColors.warmCreme,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.coffeeBrown
                                : AppColors.softBeige,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          type.displayName,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? AppColors.warmCreme
                                : AppColors.coffeeBrown,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // Primary Concern
            Text(
              'Primary Concern',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.coffeeBrown,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: PrimaryConcern.values.map((concern) {
                final isSelected = _selectedConcern == concern;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedConcern = concern;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.coffeeBrown
                          : AppColors.warmCreme,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.coffeeBrown
                            : AppColors.softBeige,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      concern.displayName,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? AppColors.warmCreme
                            : AppColors.coffeeBrown,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.coffeeBrown,
          ),
        ),
        
        const SizedBox(height: 8),
        
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.coffeeBrown.withOpacity(0.5),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: AppColors.softBeige,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: AppColors.coffeeBrown,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: AppColors.warmCreme,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.coffeeBrown,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Previous Button
          if (_currentStep > 0)
            Expanded(
              child: GestureDetector(
                onTap: _previousStep,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.warmCreme,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.coffeeBrown,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    'Previous',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.coffeeBrown,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          
          if (_currentStep > 0) const SizedBox(width: 16),
          
          // Next/Save Button
          Expanded(
            child: GestureDetector(
              onTap: _nextStep,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
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
                  _currentStep == _totalSteps - 1 ? 'Save Profile' : 'Next',
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
        ],
      ),
    );
  }
}
