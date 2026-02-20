import 'package:get/get.dart';
import '../../data/datasources/league_remote_datasource.dart';
import '../../data/models/league_model.dart';

class LeagueController extends GetxController {
  final LeagueRemoteDatasource _datasource = LeagueRemoteDatasource();

  final leagues = <LeagueModel>[].obs;
  final selectedLeague = Rxn<LeagueModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeagues();
  }

  Future<void> fetchLeagues() async {
    isLoading.value = true;
    try {
      final data = await _datasource.getAllLeagues();
      leagues.value = data.map((json) => LeagueModel.fromJson(json)).toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLeagueDetail(String id) async {
    isLoading.value = true;
    try {
      final data = await _datasource.getLeagueById(id);
      selectedLeague.value = LeagueModel.fromJson(data);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerTeam(String leagueId, String teamId) async {
    try {
      await _datasource.registerTeam(leagueId, teamId);
      Get.snackbar('Success', 'Team registered to league!');
      fetchLeagueDetail(leagueId);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
