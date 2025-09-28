import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../services/biometric_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _phoneEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isFirstTimeLogin = true;
  bool _hasFingerprint = false;

  @override
  void initState() {
    super.initState();
    _checkUserState();
  }

  @override
  void dispose() {
    _phoneEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkUserState() async {
    try {
      // Check if user is already logged in
      final isLoggedIn = await AuthService.isLoggedIn();
      final hasBiometricEnabled = await AuthService.isBiometricEnabled();
      final currentUser = AuthService.getCurrentUser();

      // Check if device has fingerprint capability
      final biometricInfo = await BiometricService.getBiometricInfo();
      final hasFingerprint =
          biometricInfo['availableBiometrics']?.contains(
                'BiometricType.strong',
              ) ==
              true ||
          biometricInfo['availableBiometrics']?.contains(
                'BiometricType.fingerprint',
              ) ==
              true;

      print('User state check:');
      print('- Is logged in: $isLoggedIn');
      print('- Has biometric enabled: $hasBiometricEnabled');
      print('- Has fingerprint: $hasFingerprint');
      print('- Current user: ${currentUser?.name}');

      setState(() {
        _isFirstTimeLogin = !isLoggedIn;
        _hasFingerprint = hasFingerprint;
      });
    } catch (e) {
      print('Error checking user state: $e');
      setState(() {
        _isFirstTimeLogin = true;
        _hasFingerprint = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Remove back arrow
        actions: [
          TextButton(
            onPressed: _skipLogin,
            child: Text(
              'Skip',
              style: GoogleFonts.poppins(
                color: const Color(0xFFE60012),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Column(
                  children: [
                    // Logo
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/totalenergies_logo.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isFirstTimeLogin
                          ? 'Welcome'
                          : 'Welcome Back, ${AuthService.getUserDisplayName()}',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFE60012),
                      ),
                    ),
                    Text(
                      _isFirstTimeLogin
                          ? 'Sign in to your account'
                          : 'Choose your preferred login method',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Login Form
              _isFirstTimeLogin
                  ? _buildFirstTimeLoginForm()
                  : _buildReturningUserForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword ? !_isPasswordVisible : false,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
            prefixIcon: Icon(icon, color: const Color(0xFFE60012)),
            suffixIcon:
                isPassword
                    ? IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey[400],
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE60012), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ],
    );
  }

  Future<void> _handleLogin() async {
    if (!_loginFormKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.loginUser(
        phoneOrEmail: _phoneEmailController.text.trim(),
        password: _passwordController.text,
      );

      // If this is first time login and device has fingerprint, enable biometric
      if (_isFirstTimeLogin && _hasFingerprint) {
        try {
          await AuthService.enableBiometric('fingerprint');
          print('Fingerprint authentication enabled for user');
        } catch (e) {
          print('Failed to enable fingerprint: $e');
          // Don't show error to user, just log it
        }
      }

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleBiometricLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Use actual biometric authentication
      final isAuthenticated = await BiometricService.authenticateWithBiometric(
        reason: 'Authenticate to access your TotalEnergies account',
      );

      if (isAuthenticated) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Biometric authentication successful!'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to main screen
          Navigator.pushReplacementNamed(context, '/main');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Biometric authentication failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Biometric authentication error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  void _skipLogin() {
    // Navigate to main screen without authentication
    Navigator.pushReplacementNamed(context, '/main');
  }

  void _forgotPassword() {
    // Show forgot password dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Forgot Password',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Password reset functionality will be implemented soon. Please contact support for assistance.',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(color: const Color(0xFFE60012)),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildFirstTimeLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          // Phone/Email Field
          _buildInputField(
            controller: _phoneEmailController,
            label: 'Phone Number or Email',
            hint: 'Enter your phone number or email',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number or email';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Password Field
          _buildInputField(
            controller: _passwordController,
            label: 'Password',
            hint: 'Enter your password',
            icon: Icons.lock_outline,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Remember Me & Forgot Password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                    activeColor: const Color(0xFFE60012),
                  ),
                  Text('Remember me', style: GoogleFonts.poppins(fontSize: 14)),
                ],
              ),
              TextButton(
                onPressed: _forgotPassword,
                child: Text(
                  'Forgot Password?',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFE60012),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Login Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE60012),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child:
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                        'Sign In',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
          ),

          const SizedBox(height: 20),

          // Register Link
          Center(
            child: TextButton(
              onPressed: _goToRegister,
              child: RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign Up',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFE60012),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReturningUserForm() {
    return Column(
      children: [
        // Welcome message
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFE60012).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE60012).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.waving_hand, color: const Color(0xFFE60012), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Welcome back! Choose how you\'d like to sign in.',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFE60012),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),

        // Fingerprint Login (if available)
        if (_hasFingerprint) ...[
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _handleBiometricLogin,
              icon: const Icon(Icons.fingerprint, size: 24),
              label: Text(
                'Login with Fingerprint',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE60012),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 2,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'OR',
            style: GoogleFonts.poppins(
              color: Colors.grey[500],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Password Field
        _buildInputField(
          controller: _passwordController,
          label: 'Enter your password',
          hint: 'Enter your password',
          icon: Icons.lock_outline,
          isPassword: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Continue Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE60012),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child:
                _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                      'Continue',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
          ),
        ),

        const SizedBox(height: 20),

        // Forgot Password
        Center(
          child: TextButton(
            onPressed: _forgotPassword,
            child: Text(
              'Forgot Password?',
              style: GoogleFonts.poppins(
                color: const Color(0xFFE60012),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
