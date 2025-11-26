import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:fyp/model/user_model.dart';
import 'package:fyp/services/email_service.dart';

class AuthRepository {
  static final Map<String, dynamic> _otpStorage = {};
  static String? _resetEmail;
  static String? _currentUserId;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> login(String email, String password) async {
    try {
      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (result.docs.isEmpty) {
        throw Exception('User not found');
      }

      final userDoc = result.docs.first;
      final userData = userDoc.data() as Map<String, dynamic>;

      if (userData['password'] != password) {
        throw Exception('Incorrect password');
      }

      _currentUserId = userDoc.id;
      return UserModel.fromJson(userData, userDoc.id);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> signup(String email, String password) async {
    try {
      // Check if user already exists
      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (result.docs.isNotEmpty) {
        throw Exception('User already exists');
      }

      // Create new user document
      final userRef = _firestore.collection('users').doc();
      final userModel = UserModel(
        id: userRef.id,
        email: email,
        password: password,
      );

      await userRef.set(userModel.toJson());
      _currentUserId = userRef.id;
      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> generateAndSendOTP(String email) async {
    try {
      final otp = (Random().nextInt(9000) + 1000).toString(); // 4-digit OTP
      final expiryTime = DateTime.now().add(Duration(minutes: 5));

      _otpStorage[email] = {
        'otp': otp,
        'expiryTime': expiryTime,
        'attempts': 0,
      };

      _resetEmail = email;

      print('[v0] [AuthRepository] generateAndSendOTP: Email received: $email');
      print('[v0] [AuthRepository] generateAndSendOTP: OTP generated: $otp');
      print('[v0] [AuthRepository] generateAndSendOTP: Reset email set to: $_resetEmail');
      print('[v0] [AuthRepository] generateAndSendOTP: OTP expiry time: $expiryTime');

      print('[v0] [AuthRepository] generateAndSendOTP: Attempting to send OTP via email...');
      final emailSent = await EmailService.sendOTPEmail(
        recipientEmail: email,
        otp: otp,
      );

      if (emailSent) {
        print('[v0] [AuthRepository] generateAndSendOTP: OTP email sent successfully');
      } else {
        print('[v0] [AuthRepository] generateAndSendOTP: WARNING - Email send returned false');
      }

      return otp;
    } catch (e) {
      print('[v0] [AuthRepository] generateAndSendOTP: ERROR - ${e.toString()}');
      rethrow;
    }
  }

  Future<void> resetPassword(String email) {
    // Placeholder for reset password functionality
    // Since Firebase Auth dependency is removed, this method is not needed
    throw Exception('Reset password functionality is not available');
  }

  Future<bool> verifyOTP(String email, String enteredOTP) async {
    try {
      print('[v0] [AuthRepository] verifyOTP: Verifying OTP for email: $email');
      print('[v0] [AuthRepository] verifyOTP: Entered OTP: $enteredOTP');
      print('[v0] [AuthRepository] verifyOTP: Storage keys: ${_otpStorage.keys.toList()}');

      if (_otpStorage.containsKey(email)) {
        final otpData = _otpStorage[email];
        final storedOTP = otpData['otp'];
        final expiryTime = otpData['expiryTime'] as DateTime;
        final attempts = otpData['attempts'] as int;

        print('[v0] [AuthRepository] verifyOTP: Stored OTP: $storedOTP, Attempts: $attempts');

        // Check if OTP has expired
        if (DateTime.now().isAfter(expiryTime)) {
          print('[v0] [AuthRepository] verifyOTP: OTP has expired');
          _otpStorage.remove(email);
          throw Exception('OTP has expired. Please request a new OTP.');
        }

        // Check if too many attempts
        if (attempts >= 3) {
          print('[v0] [AuthRepository] verifyOTP: Too many attempts');
          _otpStorage.remove(email);
          throw Exception('Too many attempts. Please request a new OTP.');
        }

        // Verify OTP
        if (storedOTP == enteredOTP) {
          print('[v0] [AuthRepository] verifyOTP: OTP matched successfully');
          _otpStorage[email]['verified'] = true;
          return true;
        } else {
          print('[v0] [AuthRepository] verifyOTP: OTP mismatch');
          _otpStorage[email]['attempts'] = attempts + 1;
          return false;
        }
      } else {
        print('[v0] [AuthRepository] verifyOTP: ERROR - Email not found in OTP storage');
      }
      return false;
    } catch (e) {
      print('[v0] [AuthRepository] verifyOTP: EXCEPTION - ${e.toString()}');
      rethrow;
    }
  }

  bool isOTPValid(String email) {
    if (_otpStorage.containsKey(email)) {
      final otpData = _otpStorage[email];
      final expiryTime = otpData['expiryTime'] as DateTime;
      return DateTime.now().isBefore(expiryTime);
    }
    return false;
  }

  int getOTPExpirySeconds(String email) {
    if (_otpStorage.containsKey(email)) {
      final otpData = _otpStorage[email];
      final expiryTime = otpData['expiryTime'] as DateTime;
      final remaining = expiryTime.difference(DateTime.now()).inSeconds;
      return remaining > 0 ? remaining : 0;
    }
    return 0;
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      print('[v0] [AuthRepository] updatePassword: Starting password update');
      print('[v0] [AuthRepository] updatePassword: Reset email: $_resetEmail');
      print('[v0] [AuthRepository] updatePassword: Current user ID: $_currentUserId');

      if (_resetEmail != null && _resetEmail!.isNotEmpty) {
        print('[v0] [AuthRepository] updatePassword: Searching for user with email: $_resetEmail');

        final result = await _firestore
            .collection('users')
            .where('email', isEqualTo: _resetEmail)
            .limit(1)
            .get();

        if (result.docs.isEmpty) {
          print('[v0] [AuthRepository] updatePassword: ERROR - User not found with email: $_resetEmail');
          throw Exception('User not found');
        }

        final userDoc = result.docs.first;
        final userId = userDoc.id;

        print('[v0] [AuthRepository] updatePassword: Found user ID: $userId');
        print('[v0] [AuthRepository] updatePassword: Updating password in Firestore');

        await _firestore.collection('users').doc(userId).update({
          'password': newPassword,
        });

        print('[v0] [AuthRepository] updatePassword: Password updated successfully');
      } else {
        print('[v0] [AuthRepository] updatePassword: ERROR - Reset email is null or empty');
        throw Exception('No user logged in or reset email not found');
      }
    } catch (e) {
      print('[v0] [AuthRepository] updatePassword: EXCEPTION - ${e.toString()}');
      rethrow;
    }
  }

  UserModel? getLoggedInUser() {
    // Returns a basic user object if user ID exists
    if (_currentUserId != null) {
      return UserModel(id: _currentUserId, email: '', password: '');
    }
    return null;
  }

  Future<String?> getLoggedInUserEmail() async {
    try {
      if (_currentUserId != null) {
        final doc = await _firestore.collection('users').doc(_currentUserId).get();
        if (doc.exists) {
          return doc['email'];
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    _currentUserId = null;
  }

  Future<bool> checkUserExists(String email) async {
    try {
      print('[v0] [AuthRepository] checkUserExists: Checking if user exists for email: $email');

      final result = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      final exists = result.docs.isNotEmpty;
      print('[v0] [AuthRepository] checkUserExists: Result - $exists (${result.docs.length} docs found)');

      return exists;
    } catch (e) {
      print('[v0] [AuthRepository] checkUserExists: ERROR - ${e.toString()}');
      return false;
    }
  }

  String? getResetEmail() {
    print('[v0] [AuthRepository] getResetEmail: Retrieved email: $_resetEmail');
    return _resetEmail;
  }

  void clearResetData() {
    print('[v0] [AuthRepository] clearResetData: Clearing reset data for email: $_resetEmail');
    if (_resetEmail != null) {
      _otpStorage.remove(_resetEmail);
    }
    _resetEmail = null;
  }
}
