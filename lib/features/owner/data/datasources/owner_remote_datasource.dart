import 'package:get/get.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';

class OwnerRemoteDatasource {
  final DioClient _client = Get.find<DioClient>();

  Future<List<dynamic>> getMyPitches() async {
    final response = await _client.get(ApiConstants.myPitches);
    return response.data['data'];
  }

  Future<Map<String, dynamic>> createPitch(Map<String, dynamic> data) async {
    final response = await _client.post(ApiConstants.pitches, data: data);
    return response.data['data'];
  }

  Future<Map<String, dynamic>> updatePitch(String id, Map<String, dynamic> data) async {
    final response = await _client.patch(ApiConstants.updatePitch(id), data: data);
    return response.data['data'];
  }

  Future<Map<String, dynamic>> getOwnerStats() async {
    final response = await _client.get(ApiConstants.ownerStats);
    return response.data['data'];
  }

  Future<List<dynamic>> getTodayBookings() async {
    final response = await _client.get(ApiConstants.ownerToday);
    return response.data['data'];
  }

  Future<List<dynamic>> getPitchBookings(String pitchId, {String? date, String? status}) async {
    final params = <String, dynamic>{};
    if (date != null) params['date'] = date;
    if (status != null) params['status'] = status;
    final response = await _client.get(
      ApiConstants.pitchBookings(pitchId),
      queryParameters: params,
    );
    return response.data['data'];
  }

  Future<void> completeBooking(String bookingId) async {
    await _client.patch(ApiConstants.completeBooking(bookingId));
  }
}
