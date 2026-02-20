import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../booking/data/datasources/booking_remote_datasource.dart';

class QrController extends GetxController {
  final BookingRemoteDatasource _datasource = BookingRemoteDatasource();
  final isVerifying = false.obs;
  final verificationResult = ''.obs;
  final verificationSuccess = false.obs;

  Future<void> verifyQr(String rawValue) async {
    if (isVerifying.value) return;

    isVerifying.value = true;
    try {
      final data = jsonDecode(rawValue);
      final bookingId = data['bookingId'];
      final qrCodeToken = data['qrCodeToken'];

      if (bookingId == null || qrCodeToken == null) {
        verificationResult.value = 'Invalid QR code format';
        verificationSuccess.value = false;
        return;
      }

      await _datasource.verifyBooking(
        bookingId: bookingId,
        qrCodeToken: qrCodeToken,
      );

      verificationResult.value = 'Booking verified! Status: Checked-In';
      verificationSuccess.value = true;
      Get.snackbar('Success', 'Booking verified!',
          backgroundColor: Colors.green.withAlpha(200), colorText: Colors.white);
    } catch (e) {
      verificationResult.value = 'Verification failed: $e';
      verificationSuccess.value = false;
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red.withAlpha(200), colorText: Colors.white);
    } finally {
      isVerifying.value = false;
    }
  }
}
