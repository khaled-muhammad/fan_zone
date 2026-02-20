import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../controllers/league_controller.dart';
import '../../data/models/league_model.dart';

class LeagueDetailPage extends GetView<LeagueController> {
  const LeagueDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.selectedLeague.value?.name ?? 'League')),
      ),
      body: Obx(() {
        final league = controller.selectedLeague.value;
        if (controller.isLoading.value && league == null) {
          return const LoadingWidget();
        }
        if (league == null) return const Center(child: Text('League not found'));

        return DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const TabBar(
                indicatorColor: AppColors.primaryLight,
                labelColor: AppColors.primaryLight,
                unselectedLabelColor: AppColors.textSecondary,
                tabs: [
                  Tab(text: 'Standings'),
                  Tab(text: 'Matches'),
                  Tab(text: 'Teams'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildStandingsTab(league),
                    _buildMatchesTab(league),
                    _buildTeamsTab(league),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStandingsTab(LeagueModel league) {
    final sortedStandings = List<Standing>.from(league.standings)
      ..sort((a, b) {
        final pointDiff = b.points.compareTo(a.points);
        if (pointDiff != 0) return pointDiff;
        return b.goalDifference.compareTo(a.goalDifference);
      });

    if (sortedStandings.isEmpty) {
      return const Center(child: Text('No standings yet'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 16,
          headingRowColor: WidgetStateColor.resolveWith(
            (_) => AppColors.primaryLight.withAlpha(20),
          ),
          columns: const [
            DataColumn(label: Text('#')),
            DataColumn(label: Text('Team')),
            DataColumn(label: Text('P'), numeric: true),
            DataColumn(label: Text('W'), numeric: true),
            DataColumn(label: Text('D'), numeric: true),
            DataColumn(label: Text('L'), numeric: true),
            DataColumn(label: Text('GF'), numeric: true),
            DataColumn(label: Text('GA'), numeric: true),
            DataColumn(label: Text('GD'), numeric: true),
            DataColumn(label: Text('Pts'), numeric: true),
          ],
          rows: sortedStandings.asMap().entries.map((entry) {
            final idx = entry.key;
            final s = entry.value;
            return DataRow(
              cells: [
                DataCell(Text('${idx + 1}')),
                DataCell(Text(s.teamName ?? 'Unknown',
                    style: const TextStyle(fontWeight: FontWeight.w600))),
                DataCell(Text('${s.played}')),
                DataCell(Text('${s.won}')),
                DataCell(Text('${s.drawn}')),
                DataCell(Text('${s.lost}')),
                DataCell(Text('${s.goalsFor}')),
                DataCell(Text('${s.goalsAgainst}')),
                DataCell(Text('${s.goalDifference}',
                    style: TextStyle(
                      color: s.goalDifference >= 0
                          ? AppColors.available
                          : AppColors.booked,
                    ))),
                DataCell(Text(
                  '${s.points}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.primaryLight),
                )),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMatchesTab(LeagueModel league) {
    if (league.matches.isEmpty) {
      return const Center(child: Text('No matches played yet'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: league.matches.length,
      itemBuilder: (context, index) {
        final match = league.matches[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    match.homeTeamName ?? 'Home',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: match.played
                        ? AppColors.primaryLight.withAlpha(30)
                        : AppColors.darkCard,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    match.played
                        ? '${match.homeScore} - ${match.awayScore}'
                        : 'vs',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Text(
                    match.awayTeamName ?? 'Away',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTeamsTab(LeagueModel league) {
    if (league.teams.isEmpty) {
      return const Center(child: Text('No teams registered'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: league.teams.length,
      itemBuilder: (context, index) {
        final team = league.teams[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryLight.withAlpha(40),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                    color: AppColors.primaryLight, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(team.name ?? 'Unknown Team',
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        );
      },
    );
  }
}
