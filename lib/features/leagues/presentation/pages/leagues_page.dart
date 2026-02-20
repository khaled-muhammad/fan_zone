import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../controllers/league_controller.dart';

class LeaguesPage extends GetView<LeagueController> {
  const LeaguesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leagues')),
      body: Obx(() {
        if (controller.isLoading.value && controller.leagues.isEmpty) {
          return const LoadingWidget(message: 'Loading leagues...');
        }
        if (controller.leagues.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events_outlined,
                    size: 64, color: AppColors.textSecondary),
                SizedBox(height: 16),
                Text('No leagues available', style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchLeagues,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.leagues.length,
            itemBuilder: (context, index) {
              final league = controller.leagues[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    controller.selectedLeague.value = league;
                    controller.fetchLeagueDetail(league.id);
                    Get.toNamed(AppRoutes.leagueDetail);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.gold.withAlpha(30),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.emoji_events,
                              color: AppColors.gold, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                league.name,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Starts: ${DateFormat('MMM d, yyyy').format(league.startDate)}',
                                style: const TextStyle(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${league.teams.length}/${league.maxTeams}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const Text('teams',
                                style: TextStyle(
                                    color: AppColors.textSecondary, fontSize: 12)),
                          ],
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
}
