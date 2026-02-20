import 'package:get/get.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';

class ChatRemoteDatasource {
  final DioClient _client = Get.find<DioClient>();

  Future<List<dynamic>> getMessages(String teamId) async {
    final response = await _client.get(ApiConstants.teamMessages(teamId));
    return response.data['data'];
  }

  Future<Map<String, dynamic>> sendMessage(String teamId, String message) async {
    final response = await _client.post(
      ApiConstants.sendMessage,
      data: {'teamId': teamId, 'message': message},
    );
    return response.data['data'];
  }
}
