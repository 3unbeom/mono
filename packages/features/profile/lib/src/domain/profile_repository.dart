import 'profile_entity.dart';

abstract class ProfileRepository {
  Future<Profile> getCurrentProfile();
  Future<bool> updateNickname(String nickname);
  Future<bool> updateProfileImage(String imagePath);
}
