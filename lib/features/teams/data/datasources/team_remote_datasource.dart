import 'package:get/get.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';

class TeamRemoteDatasource {
  final DioClient _client = Get.find<DioClient>();

  Future<List<dynamic>> getAllTeams() async {
    final response = await _client.get(ApiConstants.teams);
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getTeamById(String id) async {
    final response = await _client.get(ApiConstants.teamDetail(id));
    return response.data['data'];
  }

  Future<Map<String, dynamic>> createTeam(String name, int maxPlayers) async {
    final response = await _client.post(
      ApiConstants.teams,
      data: {'name': name, 'maxPlayers': maxPlayers},
    );
    return response.data['data'];
  }

  Future<void> joinTeam(String id) async {
    await _client.post(ApiConstants.joinTeam(id));
  }

  Future<void> leaveTeam(String id) async {
    await _client.post(ApiConstants.leaveTeam(id));
  }
}
