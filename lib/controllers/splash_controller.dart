// controllers/auth_controller.dart
import 'package:get/get.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var user = Rxn<UserModel>();

  // Login method
  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));
      
      // Mock successful login
      user.value = UserModel(
        id: '1',
        firstName: 'John',
        lastName: 'Doe',
        username: 'johndoe',
        email: email,
        createdAt: DateTime.now(),
      );
      
      Get.snackbar(
        'Success',
        'Login successful!',
        backgroundColor: Color(0xFF2E7D4A),
        colorText: Colors.white,
      );
      
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Login failed. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Register method
  Future<bool> register(UserModel newUser, String password) async {
    try {
      isLoading.value = true;
      
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));
      
      // Mock successful registration
      user.value = newUser.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
      );
      
      Get.snackbar(
        'Success',
        'Registration successful!',
        backgroundColor: Color(0xFF2E7D4A),
        colorText: Colors.white,
      );
      
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Registration failed. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Forgot password method
  Future<bool> forgotPassword(String email) async {
    try {
      isLoading.value = true;
      
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));
      
      Get.snackbar(
        'Success',
        'Password reset link sent to $email',
        backgroundColor: Color(0xFF2E7D4A),
        colorText: Colors.white,
      );
      
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send reset link. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Logout method
  void logout() {
    user.value = null;
    Get.offAllNamed('/login');
  }
}

// Extension for UserModel
extension UserModelExtension on UserModel {
  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? contactNumber,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      contactNumber: contactNumber ?? this.contactNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}