import 'package:get/get.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';

class LeagueRemoteDatasource {
  final DioClient _client = Get.find<DioClient>();

  Future<List<dynamic>> getAllLeagues() async {
    final response = await _client.get(ApiConstants.leagues);
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getLeagueById(String id) async {
    final response = await _client.get(ApiConstants.leagueDetail(id));
    return response.data['data'];
  }

  Future<void> registerTeam(String leagueId, String teamId) async {
    await _client.post(
      ApiConstants.registerTeamToLeague(leagueId),
      data: {'teamId': teamId},
    );
  }
}
