import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_model.dart';

class ProfileStorageService {
  static const String _profilesKey = 'klas_profiles';
  static const String _activeProfileIdKey = 'klas_active_profile_id';
  static const int _maxProfiles = 5;

  static Future<List<ProfileModel>> getProfiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profilesJson = prefs.getString(_profilesKey);
      
      if (profilesJson == null) {
        return [];
      }
      
      final List<dynamic> profilesList = json.decode(profilesJson);
      return profilesList
          .map((profileJson) => ProfileModel.fromJson(profileJson))
          .toList();
    } catch (e) {
      print('Error loading profiles: $e');
      return [];
    }
  }

  static Future<void> saveProfiles(List<ProfileModel> profiles) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profilesJson = json.encode(
        profiles.map((profile) => profile.toJson()).toList(),
      );
      await prefs.setString(_profilesKey, profilesJson);
    } catch (e) {
      print('Error saving profiles: $e');
    }
  }

  static Future<ProfileModel?> getActiveProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final activeProfileId = prefs.getString(_activeProfileIdKey);
      
      if (activeProfileId == null) {
        return null;
      }
      
      final profiles = await getProfiles();
      return profiles.firstWhere(
        (profile) => profile.id == activeProfileId,
        orElse: () => profiles.isEmpty ? ProfileModel.empty() : profiles.first,
      );
    } catch (e) {
      print('Error loading active profile: $e');
      return null;
    }
  }

  static Future<void> setActiveProfile(String profileId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_activeProfileIdKey, profileId);
    } catch (e) {
      print('Error setting active profile: $e');
    }
  }

  static Future<bool> addProfile(ProfileModel profile) async {
    try {
      final profiles = await getProfiles();
      
      if (profiles.length >= _maxProfiles) {
        return false; // Maximum profiles reached
      }
      
      profiles.add(profile);
      await saveProfiles(profiles);
      
      // Set as active profile if it's the first one
      if (profiles.length == 1) {
        await setActiveProfile(profile.id);
      }
      
      return true;
    } catch (e) {
      print('Error adding profile: $e');
      return false;
    }
  }

  static Future<bool> updateProfile(ProfileModel updatedProfile) async {
    try {
      final profiles = await getProfiles();
      final index = profiles.indexWhere((p) => p.id == updatedProfile.id);
      
      if (index == -1) {
        return false; // Profile not found
      }
      
      profiles[index] = updatedProfile;
      await saveProfiles(profiles);
      return true;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  static Future<bool> deleteProfile(String profileId) async {
    try {
      final profiles = await getProfiles();
      final profilesToRemove = profiles.where((p) => p.id != profileId).toList();
      
      if (profilesToRemove.length == profiles.length) {
        return false; // Profile not found
      }
      
      await saveProfiles(profilesToRemove);
      
      // If the deleted profile was active, set a new active profile
      final activeProfileId = await getActiveProfileId();
      if (activeProfileId == profileId && profilesToRemove.isNotEmpty) {
        await setActiveProfile(profilesToRemove.first.id);
      }
      
      return true;
    } catch (e) {
      print('Error deleting profile: $e');
      return false;
    }
  }

  static Future<String?> getActiveProfileId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_activeProfileIdKey);
    } catch (e) {
      print('Error getting active profile ID: $e');
      return null;
    }
  }

  static Future<bool> canAddMoreProfiles() async {
    try {
      final profiles = await getProfiles();
      return profiles.length < _maxProfiles;
    } catch (e) {
      print('Error checking if can add more profiles: $e');
      return false;
    }
  }

  static Future<int> getProfileCount() async {
    try {
      final profiles = await getProfiles();
      return profiles.length;
    } catch (e) {
      print('Error getting profile count: $e');
      return 0;
    }
  }

  static Future<void> clearAllProfiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profilesKey);
      await prefs.remove(_activeProfileIdKey);
    } catch (e) {
      print('Error clearing all profiles: $e');
    }
  }

  static Future<bool> hasProfiles() async {
    try {
      final profiles = await getProfiles();
      return profiles.isNotEmpty;
    } catch (e) {
      print('Error checking if has profiles: $e');
      return false;
    }
  }

  static Future<ProfileModel?> getProfileById(String profileId) async {
    try {
      final profiles = await getProfiles();
      return profiles.firstWhere(
        (profile) => profile.id == profileId,
        orElse: () => ProfileModel.empty(),
      );
    } catch (e) {
      print('Error getting profile by ID: $e');
      return null;
    }
  }

  // Utility method to validate profile data
  static bool isValidProfile(ProfileModel profile) {
    return profile.name.trim().isNotEmpty &&
           profile.age > 0 &&
           profile.age <= 120 &&
           profile.topSize.trim().isNotEmpty &&
           profile.bottomSize.trim().isNotEmpty &&
           profile.footwearSize.trim().isNotEmpty;
  }

  // Method to get profile statistics
  static Future<Map<String, dynamic>> getProfileStats() async {
    try {
      final profiles = await getProfiles();
      final activeProfileId = await getActiveProfileId();
      
      return {
        'totalProfiles': profiles.length,
        'maxProfiles': _maxProfiles,
        'canAddMore': profiles.length < _maxProfiles,
        'activeProfileId': activeProfileId,
        'hasActiveProfile': activeProfileId != null,
        'profilesByGender': _getProfilesByGender(profiles),
        'profilesBySkinType': _getProfilesBySkinType(profiles),
        'profilesByHairType': _getProfilesByHairType(profiles),
      };
    } catch (e) {
      print('Error getting profile stats: $e');
      return {};
    }
  }

  static Map<String, int> _getProfilesByGender(List<ProfileModel> profiles) {
    final genderCount = <String, int>{};
    for (final profile in profiles) {
      final gender = profile.gender.displayName;
      genderCount[gender] = (genderCount[gender] ?? 0) + 1;
    }
    return genderCount;
  }

  static Map<String, int> _getProfilesBySkinType(List<ProfileModel> profiles) {
    final skinTypeCount = <String, int>{};
    for (final profile in profiles) {
      final skinType = profile.skinType.displayName;
      skinTypeCount[skinType] = (skinTypeCount[skinType] ?? 0) + 1;
    }
    return skinTypeCount;
  }

  static Map<String, int> _getProfilesByHairType(List<ProfileModel> profiles) {
    final hairTypeCount = <String, int>{};
    for (final profile in profiles) {
      final hairType = profile.hairType.displayName;
      hairTypeCount[hairType] = (hairTypeCount[hairType] ?? 0) + 1;
    }
    return hairTypeCount;
  }
}
