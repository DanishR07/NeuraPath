import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/student_profile_model.dart';
import '../../model/job_seeker_profile_model.dart';
import '../../model/professional_profile_model.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Student Methods
  Future<void> saveStudentProfile(StudentProfileModel profile) async {
    try {
      await _firestore.collection('student_profiles').doc(profile.userId).set(
        profile.toJson(),
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Failed to save student profile: $e');
    }
  }

  Future<StudentProfileModel?> getStudentProfile(String userId) async {
    try {
      final doc = await _firestore.collection('student_profiles').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return StudentProfileModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch student profile: $e');
    }
  }

  // Job Seeker Methods
  Future<void> saveJobSeekerProfile(JobSeekerProfileModel profile) async {
    try {
      await _firestore.collection('job_seeker_profiles').doc(profile.userId).set(
        profile.toJson(),
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Failed to save job seeker profile: $e');
    }
  }

  Future<JobSeekerProfileModel?> getJobSeekerProfile(String userId) async {
    try {
      final doc = await _firestore.collection('job_seeker_profiles').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return JobSeekerProfileModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch job seeker profile: $e');
    }
  }

  // Professional Methods
  Future<void> saveProfessionalProfile(ProfessionalProfileModel profile) async {
    try {
      await _firestore.collection('professional_profiles').doc(profile.userId).set(
        profile.toJson(),
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Failed to save professional profile: $e');
    }
  }

  Future<ProfessionalProfileModel?> getProfessionalProfile(String userId) async {
    try {
      final doc = await _firestore.collection('professional_profiles').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return ProfessionalProfileModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch professional profile: $e');
    }
  }
}
