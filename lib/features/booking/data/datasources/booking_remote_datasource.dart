import 'package:get/get.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';

class BookingRemoteDatasource {
  final DioClient _client = Get.find<DioClient>();

  Future<Map<String, dynamic>> createBooking({
    required String pitchId,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    final response = await _client.post(
      ApiConstants.bookings,
      data: {
        'pitchId': pitchId,
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
      },
    );
    return response.data['data'];
  }

  Future<List<dynamic>> getMyBookings() async {
    final response = await _client.get(ApiConstants.myBookings);
    return response.data['data'];
  }

  Future<void> cancelBooking(String id) async {
    await _client.patch(ApiConstants.cancelBooking(id));
  }

  Future<Map<String, dynamic>> verifyBooking({
    required String bookingId,
    required String qrCodeToken,
  }) async {
    final response = await _client.post(
      ApiConstants.verifyBooking,
      data: {'bookingId': bookingId, 'qrCodeToken': qrCodeToken},
    );
    return response.data['data'];
  }
}
