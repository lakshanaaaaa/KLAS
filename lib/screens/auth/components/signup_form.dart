import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/app_colors.dart';
import 'validators.dart';

class SignupForm extends StatefulWidget {
  final VoidCallback onBack;

  const SignupForm({
    super.key,
    required this.onBack,
  });

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _agreeToTerms = false;
  String _selectedCountryCode = '+91';
  bool _isLoadingLocation = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            Row(
              children: [
                GestureDetector(
                  onTap: widget.onBack,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.softBeige.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.coffeeBrown,
                      size: 20,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Create Account',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.coffeeBrown,
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 36), // Balance the back button
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Username Field
            _buildNameField(),
            
            const SizedBox(height: 20),
            
            // Email Field
            _buildEmailField(),
            
            const SizedBox(height: 20),
            
            // Phone Number Field
            _buildPhoneField(),
            
            const SizedBox(height: 20),
            
            // Address Field
            _buildAddressField(),
            
            const SizedBox(height: 20),
            
            // Password Field
            _buildPasswordField(),
            
            const SizedBox(height: 30),
            
            // Signup Button
            _buildSignupButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Username',
        hintText: 'Enter your username',
        prefixIcon: Icon(
          Icons.person_outline,
          color: AppColors.coffeeBrown.withOpacity(0.6),
        ),
        filled: true,
        fillColor: AppColors.warmCreme,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: AppColors.softBeige.withOpacity(0.5),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: AppColors.coffeeBrown.withOpacity(0.5),
            width: 2,
          ),
        ),
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: AppColors.coffeeBrown.withOpacity(0.7),
        ),
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: AppColors.coffeeBrown.withOpacity(0.4),
        ),
      ),
      style: GoogleFonts.poppins(
        fontSize: 16,
        color: AppColors.coffeeBrown,
      ),
      validator: Validators.validateName,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email address',
        prefixIcon: Icon(
          Icons.email_outlined,
          color: AppColors.coffeeBrown.withOpacity(0.6),
        ),
        filled: true,
        fillColor: AppColors.warmCreme,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: AppColors.softBeige.withOpacity(0.5),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: AppColors.coffeeBrown.withOpacity(0.5),
            width: 2,
          ),
        ),
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: AppColors.coffeeBrown.withOpacity(0.7),
        ),
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: AppColors.coffeeBrown.withOpacity(0.4),
        ),
      ),
      style: GoogleFonts.poppins(
        fontSize: 16,
        color: AppColors.coffeeBrown,
      ),
      validator: Validators.validateEmail,
    );
  }

  Widget _buildPhoneField() {
    return Row(
      children: [
        // Country Code Selector
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.warmCreme,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              bottomLeft: Radius.circular(24),
            ),
            border: Border(
              right: BorderSide(
                color: AppColors.softBeige.withOpacity(0.5),
                width: 1,
              ),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCountryCode,
              items: [
                '+91',
                '+1',
                '+44',
                '+61',
                '+86',
              ].map((code) {
                return DropdownMenuItem<String>(
                  value: code,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.flag,
                          color: AppColors.coffeeBrown,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          code,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.coffeeBrown,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCountryCode = value!;
                });
              },
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.coffeeBrown.withOpacity(0.6),
                size: 20,
              ),
              isDense: true,
            ),
          ),
        ),
        
        // Phone Number Field
        Expanded(
          child: TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: 'Enter your phone number',
              prefixIcon: Icon(
                Icons.phone_outlined,
                color: AppColors.coffeeBrown.withOpacity(0.6),
              ),
              filled: true,
              fillColor: AppColors.warmCreme,
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                borderSide: BorderSide(
                  color: AppColors.softBeige.withOpacity(0.5),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                borderSide: BorderSide(
                  color: AppColors.coffeeBrown.withOpacity(0.5),
                  width: 2,
                ),
              ),
              labelStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.coffeeBrown.withOpacity(0.7),
              ),
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.coffeeBrown.withOpacity(0.4),
              ),
            ),
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.coffeeBrown,
            ),
            validator: Validators.validatePhone,
          ),
        ),
      ],
    );
  }

  Widget _buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _addressController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Address',
            hintText: 'Enter your full address',
            prefixIcon: Icon(
              Icons.location_on_outlined,
              color: AppColors.coffeeBrown.withOpacity(0.6),
            ),
            filled: true,
            fillColor: AppColors.warmCreme,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: AppColors.softBeige.withOpacity(0.5),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: AppColors.coffeeBrown.withOpacity(0.5),
                width: 2,
              ),
            ),
            labelStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.coffeeBrown.withOpacity(0.7),
            ),
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.coffeeBrown.withOpacity(0.4),
            ),
          ),
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: AppColors.coffeeBrown,
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Use Current Location Button
        GestureDetector(
          onTap: _getCurrentLocation,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.coffeeBrown.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.coffeeBrown.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.my_location_outlined,
                  color: AppColors.coffeeBrown,
                  size: 18,
                ),
                const SizedBox(width: 8),
                _isLoadingLocation
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.coffeeBrown,
                          ),
                        ),
                      )
                    : Text(
                        'Use Current Location',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.coffeeBrown,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Create a strong password',
            prefixIcon: Icon(
              Icons.lock_outline,
              color: AppColors.coffeeBrown.withOpacity(0.6),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              child: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.coffeeBrown.withOpacity(0.6),
              ),
            ),
            filled: true,
            fillColor: AppColors.warmCreme,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: AppColors.softBeige.withOpacity(0.5),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: AppColors.coffeeBrown.withOpacity(0.5),
                width: 2,
              ),
            ),
            labelStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.coffeeBrown.withOpacity(0.7),
            ),
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.coffeeBrown.withOpacity(0.4),
            ),
          ),
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: AppColors.coffeeBrown,
          ),
          validator: Validators.validatePassword,
          onChanged: (value) {
            setState(() {}); // Trigger password strength update
          },
        ),
        
        const SizedBox(height: 8),
        
        // Password Strength Indicator
        _buildPasswordStrengthIndicator(),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    final password = _passwordController.text;
    final strength = Validators.calculatePasswordStrength(password);
    
    return Container(
      height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: AppColors.softBeige.withOpacity(0.3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: strength / 4,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: _getPasswordStrengthColor(strength),
          ),
        ),
      ),
    );
  }

  Color _getPasswordStrengthColor(int strength) {
    switch (strength) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.green;
      default:
        return AppColors.softBeige.withOpacity(0.3);
    }
  }

  Widget _buildSignupButton() {
    return GestureDetector(
      onTap: _handleSignup,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: _formKey.currentState?.validate() == true
              ? AppColors.coffeeBrown
              : AppColors.coffeeBrown.withOpacity(0.3),
          borderRadius: BorderRadius.circular(30),
          boxShadow: _formKey.currentState?.validate() == true
              ? [
                  BoxShadow(
                    color: AppColors.deepMocha.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            'Create Account',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.warmCreme,
            ),
          ),
        ),
      ),
    );
  }

  void _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Simulate location fetch
      await Future.delayed(const Duration(seconds: 2));
      _addressController.text = '123 Fashion Street, Style City, SC 12345';
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  void _handleSignup() {
    if (_formKey.currentState?.validate() == true) {
      // Handle signup logic
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}
