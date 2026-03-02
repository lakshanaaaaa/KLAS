import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _useEmail = true; // Toggle between email/username and phone
  bool _isLoading = false;
  bool _isHoveringLogin = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
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

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleLoginMethod() {
    setState(() {
      _useEmail = !_useEmail;
    });
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate login process
    await Future.delayed(const Duration(seconds: 2));
    
    // Set login state
    await AuthService.setLogin(true);

    setState(() {
      _isLoading = false;
    });

    // Navigate to home screen
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmCreme,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // KLAS Logo with Hero Animation and Hover
              Hero(
                tag: 'klas-logo',
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.identity()..scale(1.0),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.coffeeBrown.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowColor.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/3-removebg-preview.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                'KLAS',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.coffeeBrown,
                                  letterSpacing: 2,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Welcome Text
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Text(
                      'Welcome Back',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.coffeeBrown,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue your style journey',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.coffeeBrown.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Login Form Container
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(32),
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
                  child: Column(
                    children: [
                      // Login Method Toggle
                      _buildLoginToggle(),
                      
                      const SizedBox(height: 30),
                      
                      // Email/Username or Phone Field
                      _useEmail ? _buildEmailField() : _buildPhoneField(),
                      
                      const SizedBox(height: 20),
                      
                      // Password Field
                      _buildPasswordField(),
                      
                      const SizedBox(height: 30),
                      
                      // Forgot Password
                      _buildForgotPassword(),
                      
                      const SizedBox(height: 30),
                      
                      // Login Button
                      _buildLoginButton(),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Sign Up Link
              _buildSignUpLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginToggle() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.softBeige.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          // Email/Username Option
          Expanded(
            child: GestureDetector(
              onTap: () => _toggleLoginMethod(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: _useEmail ? AppColors.coffeeBrown : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.email_outlined,
                        color: _useEmail ? AppColors.warmCreme : AppColors.coffeeBrown,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Email / Username',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _useEmail ? AppColors.warmCreme : AppColors.coffeeBrown,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Phone Option
          Expanded(
            child: GestureDetector(
              onTap: () => _toggleLoginMethod(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: !_useEmail ? AppColors.coffeeBrown : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        color: !_useEmail ? AppColors.warmCreme : AppColors.coffeeBrown,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Mobile Number',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: !_useEmail ? AppColors.warmCreme : AppColors.coffeeBrown,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email or Username',
        hintText: 'Enter your email or username',
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
              value: '+91',
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
              onChanged: (value) {},
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
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
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
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          // Handle forgot password
        },
        child: Text(
          'Forgot Password?',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.coffeeBrown,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.coffeeBrown.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHoveringLogin = true),
      onExit: (_) => setState(() => _isHoveringLogin = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _handleLogin,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          transform: Matrix4.identity()..scale(_isHoveringLogin && !_isLoading ? 1.02 : 1.0),
          decoration: BoxDecoration(
            color: _isLoading 
                ? AppColors.coffeeBrown.withOpacity(0.6)
                : _isHoveringLogin 
                    ? AppColors.coffeeBrown.withOpacity(0.9)
                    : AppColors.coffeeBrown,
            borderRadius: BorderRadius.circular(30),
            boxShadow: !_isLoading
                ? _isHoveringLogin
                    ? [
                        BoxShadow(
                          color: AppColors.deepMocha.withOpacity(0.4),
                          blurRadius: 25,
                          offset: const Offset(0, 12),
                        ),
                        BoxShadow(
                          color: AppColors.coffeeBrown.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: AppColors.deepMocha.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ]
                : null,
          ),
          child: Center(
            child: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.warmCreme,
                      ),
                    ),
                  )
                : Text(
                    'Sign In',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.warmCreme,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.coffeeBrown.withOpacity(0.7),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/signup');
            },
            child: Text(
              'Sign Up',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.coffeeBrown,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.coffeeBrown.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
