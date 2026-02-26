class Validators {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Username cannot contain special characters';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    final phoneRegex = RegExp(r'^[0-9]+$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Phone number can only contain digits';
    }
    
    if (value.length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    
    if (value.length > 15) {
      return 'Phone number cannot exceed 15 digits';
    }
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    
    return null;
  }

  static int calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0;
    
    int strength = 0;
    
    // Length check
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;
    
    // Character variety checks
    if (password.contains(RegExp(r'[a-z]'))) strength++; // lowercase
    if (password.contains(RegExp(r'[A-Z]'))) strength++; // uppercase
    if (password.contains(RegExp(r'[0-9]'))) strength++; // numbers
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++; // special chars
    
    // Return strength level (1-4)
    if (strength <= 2) return 1; // Weak
    if (strength <= 3) return 2; // Fair
    if (strength <= 4) return 3; // Good
    return 4; // Strong
  }
}
