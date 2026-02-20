import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/datasources/profile_remote_datasource.dart';

class ProfileController extends GetxController {
  final ProfileRemoteDatasource _datasource = ProfileRemoteDatasource();

  final profile = Rxn<UserModel>();
  final isLoading = false.obs;
  final isEditing = false.obs;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final positionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final data = await _datasource.getProfile();
      profile.value = UserModel.fromJson(data);
      nameController.text = profile.value?.fullName ?? '';
      phoneController.text = profile.value?.phone ?? '';
      positionController.text = profile.value?.position ?? '';
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    isLoading.value = true;
    try {
      final data = await _datasource.updateProfile({
        'fullName': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'position': positionController.text.trim(),
      });
      profile.value = UserModel.fromJson(data);
      isEditing.value = false;
      Get.snackbar('Success', 'Profile updated',
          backgroundColor: Colors.green.withAlpha(200), colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    positionController.dispose();
    super.onClose();
  }
}
