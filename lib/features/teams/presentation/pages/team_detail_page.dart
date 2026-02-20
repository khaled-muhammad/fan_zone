import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../controllers/team_controller.dart';

class TeamDetailPage extends GetView<TeamController> {
  const TeamDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.selectedTeam.value?.name ?? 'Team')),
      ),
      body: Obx(() {
        final team = controller.selectedTeam.value;
        if (controller.isLoading.value && team == null) {
          return const LoadingWidget();
        }
        if (team == null) return const Center(child: Text('Team not found'));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: AppColors.primaryLight.withAlpha(40),
                        child: const Icon(Icons.group, size: 36, color: AppColors.primaryLight),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        team.name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${team.players.length}/${team.maxPlayers} players',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      if (team.isComplete)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.available.withAlpha(30),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Team Complete',
                            style: TextStyle(
                                color: AppColors.available, fontWeight: FontWeight.w600),
                          ),
                        ),
                      if (team.captainName != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Captain: ${team.captainName}',
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Team Chat',
                icon: Icons.chat,
                onPressed: () => Get.toNamed(AppRoutes.chat, arguments: team.id),
              ),
              const SizedBox(height: 24),
              const Text('Players',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...team.players.map(
                (player) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _levelColor(player.level ?? 'Bronze').withAlpha(40),
                      child: Text(
                        player.fullName != null && player.fullName!.isNotEmpty
                            ? player.fullName![0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: _levelColor(player.level ?? 'Bronze'),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(player.fullName ?? 'Unknown'),
                    subtitle: Text(player.position ?? 'No position'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _levelColor(player.level ?? 'Bronze').withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        player.level ?? 'Bronze',
                        style: TextStyle(
                          color: _levelColor(player.level ?? 'Bronze'),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Color _levelColor(String level) {
    switch (level) {
      case 'Gold':
        return AppColors.gold;
      case 'Silver':
        return AppColors.silver;
      default:
        return AppColors.bronze;
    }
  }
}
