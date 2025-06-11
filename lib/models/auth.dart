class Auth {
  static bool _isLoggedIn = false;
  static String? _userEmail;
  static String? _userName;

  // Check if user is logged in
  static bool get isLoggedIn => _isLoggedIn;

  // Get user email
  static String? get userEmail => _userEmail;

  // Get user name
  static String? get userName => _userName;

  // Login method (mock implementation)
  static Future<bool> login(String email, String password) async {
    // For demo purposes, accept any valid-looking email with password length >= 6
    if (email.contains('@') && password.length >= 6) {
      _isLoggedIn = true;
      _userEmail = email;
      _userName = _generateNameFromEmail(email);
      return true;
    }
    return false;
  }

  // Logout method
  static void logout() {
    _isLoggedIn = false;
    _userEmail = null;
    _userName = null;
  }

  // Generate a name from email (for demo purposes)
  static String _generateNameFromEmail(String email) {
    if (email.isEmpty) return '';
    final parts = email.split('@');
    if (parts.isEmpty) return '';

    String name = parts[0];
    // Capitalize first letter of each part and replace dots/underscores with spaces
    name = name.replaceAll('.', ' ').replaceAll('_', ' ');

    // Capitalize each word
    final words = name.split(' ');
    final capitalizedWords = words.map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    });

    return capitalizedWords.join(' ');
  }
}
