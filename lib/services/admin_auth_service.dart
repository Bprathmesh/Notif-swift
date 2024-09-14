// lib/services/admin_auth_service.dart

class AdminAuthService {
  // This should be a secure, hashed password in a real application
  static const String _adminPassword = 'admin123';

  static bool verifyAdminPassword(String password) {
    return password == _adminPassword;
  }
}