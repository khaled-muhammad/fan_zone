import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/datasources/team_remote_datasource.dart';
import '../../data/models/team_model.dart';

class TeamController extends GetxController {
  final TeamRemoteDatasource _datasource = TeamRemoteDatasource();

  final teams = <TeamModel>[].obs;
  final selectedTeam = Rxn<TeamModel>();
  final isLoading = false.obs;

  final teamNameController = TextEditingController();
  final maxPlayersController = TextEditingController(text: '10');

  @override
  void onInit() {
    super.onInit();
    fetchTeams();
  }

  Future<void> fetchTeams() async {
    isLoading.value = true;
    try {
      final data = await _datasource.getAllTeams();
      teams.value = data.map((json) => TeamModel.fromJson(json)).toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTeamDetail(String id) async {
    isLoading.value = true;
    try {
      final data = await _datasource.getTeamById(id);
      selectedTeam.value = TeamModel.fromJson(data);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createTeam() async {
    if (teamNameController.text.isEmpty) {
      Get.snackbar('Error', 'Team name is required');
      return;
    }

    try {
      await _datasource.createTeam(
        teamNameController.text.trim(),
        int.tryParse(maxPlayersController.text) ?? 10,
      );
      teamNameController.clear();
      Get.back();
      Get.snackbar('Success', 'Team created!',
          backgroundColor: Colors.green.withAlpha(200), colorText: Colors.white);
      fetchTeams();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> joinTeam(String id) async {
    try {
      await _datasource.joinTeam(id);
      Get.snackbar('Success', 'Joined team!',
          backgroundColor: Colors.green.withAlpha(200), colorText: Colors.white);
      fetchTeams();
      if (selectedTeam.value != null) fetchTeamDetail(id);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> leaveTeam(String id) async {
    try {
      await _datasource.leaveTeam(id);
      Get.snackbar('Info', 'Left team',
          backgroundColor: Colors.orange.withAlpha(200), colorText: Colors.white);
      fetchTeams();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  void onClose() {
    teamNameController.dispose();
    maxPlayersController.dispose();
    super.onClose();
  }
}
