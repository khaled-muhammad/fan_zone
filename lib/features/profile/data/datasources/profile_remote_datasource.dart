import 'package:get/get.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';

class ProfileRemoteDatasource {
  final DioClient _client = Get.find<DioClient>();

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _client.get(ApiConstants.me);
    return response.data['data'];
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await _client.patch(ApiConstants.me, data: data);
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getUserStats(String userId) async {
    final response = await _client.get(ApiConstants.userStats(userId));
    return response.data['data'];
  }
}
