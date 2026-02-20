import 'package:get/get.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';

class PitchRemoteDatasource {
  final DioClient _client = Get.find<DioClient>();

  Future<List<dynamic>> getAllPitches() async {
    final response = await _client.get(ApiConstants.pitches);
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getPitchById(String id) async {
    final response = await _client.get(ApiConstants.pitchDetail(id));
    return response.data['data'];
  }

  Future<List<dynamic>> getSchedule(String pitchId, String date) async {
    final response = await _client.get(
      ApiConstants.pitchSchedule(pitchId),
      queryParameters: {'date': date},
    );
    return response.data['data'];
  }
}
