import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../controllers/team_controller.dart';

class TeamsPage extends GetView<TeamController> {
  const TeamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teams')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryLight,
        onPressed: () => _showCreateTeamDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.teams.isEmpty) {
          return const LoadingWidget(message: 'Loading teams...');
        }
        if (controller.teams.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.group_off, size: 64, color: AppColors.textSecondary),
                SizedBox(height: 16),
                Text('No teams yet. Create one!', style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchTeams,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.teams.length,
            itemBuilder: (context, index) {
              final team = controller.teams[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    controller.selectedTeam.value = team;
                    controller.fetchTeamDetail(team.id);
                    Get.toNamed(AppRoutes.teamDetail);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.primaryLight.withAlpha(40),
                          child: const Icon(Icons.group, color: AppColors.primaryLight),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                team.name,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${team.players.length}/${team.maxPlayers} players',
                                style: const TextStyle(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        if (team.isComplete)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.available.withAlpha(30),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Full',
                              style: TextStyle(
                                  color: AppColors.available,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        else
                          TextButton(
                            onPressed: () => controller.joinTeam(team.id),
                            child: const Text('Join'),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _showCreateTeamDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Create Team'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: controller.teamNameController,
              hintText: 'Team Name',
              prefixIcon: Icons.group,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: controller.maxPlayersController,
              hintText: 'Max Players',
              prefixIcon: Icons.people,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          CustomButton(
            text: 'Create',
            width: 100,
            onPressed: controller.createTeam,
          ),
        ],
      ),
    );
  }
}
