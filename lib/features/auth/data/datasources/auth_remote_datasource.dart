import 'package:get/get.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';

class AuthRemoteDatasource {
  final DioClient _client = Get.find<DioClient>();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _client.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    return response.data['data'];
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? phone,
    String? position,
  }) async {
    final response = await _client.post(
      ApiConstants.register,
      data: {
        'fullName': fullName,
        'email': email,
        'password': password,
        'role': role,
        'phone': phone,
        'position': position,
      },
    );
    return response.data['data'];
  }
}
