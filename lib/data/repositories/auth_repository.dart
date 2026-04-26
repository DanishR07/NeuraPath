import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:fyp/model/user_model.dart';
import 'package:fyp/services/email_service.dart';

class AuthRepository {
  static final Map<String, dynamic> _otpStorage = {};
  static String? _resetEmail;
  static String? _currentUserId;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserModel> login(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      
      final User? firebaseUser = userCredential.user;
      
      if (firebaseUser == null) {
        throw Exception("Authentication failed");
      }

      // Check if email is verified
      if (!firebaseUser.emailVerified) {
        throw Exception("NOT_VERIFIED:${firebaseUser.uid}");
      }

      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (result.docs.isEmpty) {
        throw Exception('User data not found in database');
      }

      final userDoc = result.docs.first;
      final userData = userDoc.data() as Map<String, dynamic>;

      if (userData['password'] != password) {
         // Keep existing password field up to date / consistent if needed
      }

      _currentUserId = firebaseUser.uid; // Use firebase UID
      return UserModel.fromJson(userData, userDoc.id);
    } catch (e) {
      if (e is FirebaseAuthException) {
         throw Exception(e.message ?? "Authentication failed");
      }
      rethrow;
    }
  }

  Future<UserModel> signup(String email, String password) async {
    try {
      // Create user in Firebase Auth
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
          
      final User? firebaseUser = userCredential.user;
      
      if (firebaseUser == null) {
        throw Exception("Failed to create user in Firebase Auth");
      }
      
      // Attempt to send verification email immediately
      await firebaseUser.sendEmailVerification();

      // Create new user document in Firestore using Firebase UID
      final userRef = _firestore.collection('users').doc(firebaseUser.uid);
      final userModel = UserModel(
        id: firebaseUser.uid,
        email: email,
        password: password,
      );

      await userRef.set(userModel.toJson());
      _currentUserId = firebaseUser.uid;
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

      print('  [AuthRepository] generateAndSendOTP: Email received: $email');
      print('  [AuthRepository] generateAndSendOTP: OTP generated: $otp');
      print('  [AuthRepository] generateAndSendOTP: Reset email set to: $_resetEmail');
      print('  [AuthRepository] generateAndSendOTP: OTP expiry time: $expiryTime');

      print('  [AuthRepository] generateAndSendOTP: Attempting to send OTP via email...');
      final emailSent = await EmailService.sendOTPEmail(
        recipientEmail: email,
        otp: otp,
      );

      if (emailSent) {
        print('  [AuthRepository] generateAndSendOTP: OTP email sent successfully');
      } else {
        print('  [AuthRepository] generateAndSendOTP: WARNING - Email send returned false');
      }

      return otp;
    } catch (e) {
      print('  [AuthRepository] generateAndSendOTP: ERROR - ${e.toString()}');
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
      print('  [AuthRepository] verifyOTP: Verifying OTP for email: $email');
      print('  [AuthRepository] verifyOTP: Entered OTP: $enteredOTP');
      print('  [AuthRepository] verifyOTP: Storage keys: ${_otpStorage.keys.toList()}');

      if (_otpStorage.containsKey(email)) {
        final otpData = _otpStorage[email];
        final storedOTP = otpData['otp'];
        final expiryTime = otpData['expiryTime'] as DateTime;
        final attempts = otpData['attempts'] as int;

        print('  [AuthRepository] verifyOTP: Stored OTP: $storedOTP, Attempts: $attempts');

        // Check if OTP has expired
        if (DateTime.now().isAfter(expiryTime)) {
          print('  [AuthRepository] verifyOTP: OTP has expired');
          _otpStorage.remove(email);
          throw Exception('OTP has expired. Please request a new OTP.');
        }

        // Check if too many attempts
        if (attempts >= 3) {
          print('  [AuthRepository] verifyOTP: Too many attempts');
          _otpStorage.remove(email);
          throw Exception('Too many attempts. Please request a new OTP.');
        }

        // Verify OTP
        if (storedOTP == enteredOTP) {
          print('  [AuthRepository] verifyOTP: OTP matched successfully');
          _otpStorage[email]['verified'] = true;
          return true;
        } else {
          print('  [AuthRepository] verifyOTP: OTP mismatch');
          _otpStorage[email]['attempts'] = attempts + 1;
          return false;
        }
      } else {
        print('  [AuthRepository] verifyOTP: ERROR - Email not found in OTP storage');
      }
      return false;
    } catch (e) {
      print('  [AuthRepository] verifyOTP: EXCEPTION - ${e.toString()}');
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
      print('  [AuthRepository] updatePassword: Starting password update');
      print('  [AuthRepository] updatePassword: Reset email: $_resetEmail');
      print('  [AuthRepository] updatePassword: Current user ID: $_currentUserId');

      if (_resetEmail != null && _resetEmail!.isNotEmpty) {
        print('  [AuthRepository] updatePassword: Searching for user with email: $_resetEmail');

        final result = await _firestore
            .collection('users')
            .where('email', isEqualTo: _resetEmail)
            .limit(1)
            .get();

        if (result.docs.isEmpty) {
          print('  [AuthRepository] updatePassword: ERROR - User not found with email: $_resetEmail');
          throw Exception('User not found');
        }

        final userDoc = result.docs.first;
        final userId = userDoc.id;

        print('  [AuthRepository] updatePassword: Found user ID: $userId');
        print('  [AuthRepository] updatePassword: Updating password in Firestore');

        await _firestore.collection('users').doc(userId).update({
          'password': newPassword,
        });

        print('  [AuthRepository] updatePassword: Password updated successfully');
      } else {
        print('  [AuthRepository] updatePassword: ERROR - Reset email is null or empty');
        throw Exception('No user logged in or reset email not found');
      }
    } catch (e) {
      print('  [AuthRepository] updatePassword: EXCEPTION - ${e.toString()}');
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
      print('  [AuthRepository] checkUserExists: Checking if user exists for email: $email');

      final result = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      final exists = result.docs.isNotEmpty;
      print('  [AuthRepository] checkUserExists: Result - $exists (${result.docs.length} docs found)');

      return exists;
    } catch (e) {
      print('  [AuthRepository] checkUserExists: ERROR - ${e.toString()}');
      return false;
    }
  }

  String? getResetEmail() {
    print('  [AuthRepository] getResetEmail: Retrieved email: $_resetEmail');
    return _resetEmail;
  }

  void clearResetData() {
    print('  [AuthRepository] clearResetData: Clearing reset data for email: $_resetEmail');
    if (_resetEmail != null) {
      _otpStorage.remove(_resetEmail);
    }
    _resetEmail = null;
  }

  Future<void> updateUserProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String role,
    String? profileImageUrl,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'role': role,
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      });
    } catch (e) {
      print('  [AuthRepository] updateUserProfile: ERROR - ${e.toString()}');
      rethrow;
    }
  }

  Future<void> updateBasicUserInfo({
    required String userId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
      };
      if (profileImageUrl != null) {
        data['profileImageUrl'] = profileImageUrl;
      }
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      print('  [AuthRepository] updateBasicUserInfo: ERROR - ${e.toString()}');
      rethrow;
    }
  }

  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('  [AuthRepository] getUserProfile: ERROR - ${e.toString()}');
      rethrow;
    }
  }

  Future<bool> isProfileComplete(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        // Profile is complete if firstName, lastName, phoneNumber, and role are all provided
        return data['firstName'] != null &&
            data['lastName'] != null &&
            data['phoneNumber'] != null &&
            data['role'] != null &&
            data['firstName'].toString().isNotEmpty &&
            data['lastName'].toString().isNotEmpty &&
            data['phoneNumber'].toString().isNotEmpty &&
            data['role'].toString().isNotEmpty;
      }
      return false;
    } catch (e) {
      print('  [AuthRepository] isProfileComplete: ERROR - ${e.toString()}');
      return false;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      if (_currentUserId != null) {
        final doc = await _firestore.collection('users').doc(_currentUserId).get();
        if (doc.exists) {
          return UserModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
        }
      }
      return null;
    } catch (e) {
      print('  [AuthRepository] getCurrentUser: ERROR - ${e.toString()}');
      rethrow;
    }
  }

  Stream<UserModel?> getUserStream() {
    if (_currentUserId == null) {
      return Stream.value(null);
    }
    return _firestore
        .collection('users')
        .doc(_currentUserId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    });
  }
}
