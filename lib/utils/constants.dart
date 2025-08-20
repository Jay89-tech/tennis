// views/auth/forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    if (_formKey.currentState!.validate()) {
      final success = await _authController.forgotPassword(
        _emailController.text.trim(),
      );
      
      if (success) {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF2E7D4A)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
              SizedBox(height: 40),
              
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0xFF2E7D4A).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_reset,
                  size: 40,
                  color: Color(0xFF2E7D4A),
                ),
              ),
              SizedBox(height: 32),
              
              // Title
              Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D4A),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Enter your email address and we\'ll send you a link to reset your password.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              SizedBox(height: 48),
              
              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xFF2E7D4A)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32),
                    
                    // Reset Button
                    Obx(() => SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _authController.isLoading.value 
                          ? null 
                          : _handleForgotPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2E7D4A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _authController.isLoading.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Send Reset Link',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                      ),
                    )),
                  ],
                ),
              ),
              
              SizedBox(height: 32),
              
              // Back to Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Remember your password? ',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: Color(0xFF2E7D4A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}