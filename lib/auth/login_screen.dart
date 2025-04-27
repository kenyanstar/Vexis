import 'package:flutter/material.dart';
import 'package:vexis_browser/auth/auth_service.dart';
import 'package:vexis_browser/core/constants.dart';
import 'package:vexis_browser/browser/browser_screen.dart';
import 'package:vexis_browser/ui/components/shield_v_logo.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  late TabController _tabController;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String _username = '';
  String _password = '';
  String _phoneNumber = '';
  String _verificationId = '';
  String _otp = '';
  String _errorMessage = '';
  bool _isOtpSent = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _checkBiometrics();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _checkBiometrics() async {
    final bool isAvailable = await _authService.isBiometricAvailable();
    if (!isAvailable && _tabController.index == 2) {
      // If biometrics not available, switch to username tab
      _tabController.animateTo(0);
    }
  }
  
  Future<void> _authenticateWithBiometrics() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      bool success = await _authService.authenticateWithBiometrics();
      if (success) {
        _navigateToBrowser();
      } else {
        setState(() {
          _errorMessage = 'Biometric authentication failed. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _signInWithEmailAndPassword() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final user = await _authService.signInWithEmailAndPassword(_username, _password);
      if (user != null) {
        _navigateToBrowser();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Login failed: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _registerWithEmailAndPassword() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final user = await _authService.registerWithEmailAndPassword(_username, _password);
      if (user != null) {
        _navigateToBrowser();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Registration failed: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _verifyPhoneNumber() async {
    if (_phoneNumber.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a valid phone number';
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      await _authService.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        verificationCompleted: (credential) async {
          // Auto-verification completed
          final user = await _authService.currentUser;
          if (user != null) {
            _navigateToBrowser();
          }
        },
        verificationFailed: (e) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Verification failed: ${e.message}';
          });
        },
        codeSent: (verificationId, resendToken) {
          setState(() {
            _isLoading = false;
            _verificationId = verificationId;
            _isOtpSent = true;
          });
        },
        codeAutoRetrievalTimeout: (verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred: $e';
      });
    }
  }
  
  Future<void> _verifyOtp() async {
    if (_otp.isEmpty || _otp.length < 6) {
      setState(() {
        _errorMessage = 'Please enter a valid OTP';
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final user = await _authService.verifyOTP(_verificationId, _otp);
      if (user != null) {
        _navigateToBrowser();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'OTP verification failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  void _navigateToBrowser() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const BrowserScreen()),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Logo
                  Center(
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: ShieldVLogo(
                        glowColor: VexisColors.primaryBlue,
                        animate: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // App name
                  Text(
                    VexisConstants.appName,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your Ultimate Browser Experience',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: VexisColors.textColor.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  // Auth method tabs
                  TabBar(
                    controller: _tabController,
                    indicatorColor: VexisColors.primaryBlue,
                    labelColor: VexisColors.primaryBlue,
                    unselectedLabelColor: VexisColors.textColor.withOpacity(0.7),
                    tabs: const [
                      Tab(text: 'Username'),
                      Tab(text: 'Phone'),
                      Tab(text: 'Biometric'),
                    ],
                    onTap: (index) {
                      if (index == 2) {
                        _checkBiometrics();
                      }
                    },
                  ),
                  const SizedBox(height: 32),
                  // Tab content
                  SizedBox(
                    height: 300,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Username/Password tab
                        _buildUsernamePasswordTab(),
                        // Phone tab
                        _buildPhoneTab(),
                        // Biometric tab
                        _buildBiometricTab(),
                      ],
                    ),
                  ),
                  // Error message
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        _errorMessage,
                        style: TextStyle(
                          color: VexisColors.errorColor,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Skip button for demo purposes
                  TextButton(
                    onPressed: _navigateToBrowser,
                    child: const Text('Skip Login (Demo Mode)'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildUsernamePasswordTab() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Username',
            hintText: 'Enter your username',
            prefixIcon: Icon(FeatherIcons.user),
            suffixText: '@globals.com',
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your username';
            }
            return null;
          },
          onSaved: (value) {
            _username = value ?? '';
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: const Icon(FeatherIcons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? FeatherIcons.eyeOff : FeatherIcons.eye,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          obscureText: _obscurePassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          onSaved: (value) {
            _password = value ?? '';
          },
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _signInWithEmailAndPassword,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Sign In'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                onPressed: _isLoading ? null : _registerWithEmailAndPassword,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Register'),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildPhoneTab() {
    return _isOtpSent ? _buildOtpVerification() : _buildPhoneInput();
  }
  
  Widget _buildPhoneInput() {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            hintText: 'Enter your phone number with country code',
            prefixIcon: Icon(FeatherIcons.phone),
          ),
          keyboardType: TextInputType.phone,
          onChanged: (value) {
            setState(() {
              _phoneNumber = value;
            });
          },
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _verifyPhoneNumber,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Send OTP'),
          ),
        ),
      ],
    );
  }
  
  Widget _buildOtpVerification() {
    return Column(
      children: [
        Text(
          'OTP sent to $_phoneNumber',
          style: TextStyle(
            color: VexisColors.textColor.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'OTP Code',
            hintText: 'Enter 6-digit code',
            prefixIcon: Icon(FeatherIcons.key),
          ),
          keyboardType: TextInputType.number,
          maxLength: 6,
          onChanged: (value) {
            setState(() {
              _otp = value;
            });
          },
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Verify OTP'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        setState(() {
                          _isOtpSent = false;
                        });
                      },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Change Number'),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildBiometricTab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.fingerprint,
          size: 80,
          color: VexisColors.primaryBlue,
        ),
        const SizedBox(height: 24),
        Text(
          'Use Fingerprint or Face ID',
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 8),
        Text(
          'Quick and secure access to VEXIS Browser',
          style: TextStyle(
            color: VexisColors.textColor.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _authenticateWithBiometrics,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Authenticate'),
          ),
        ),
      ],
    );
  }
}
