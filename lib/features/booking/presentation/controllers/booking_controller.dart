import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/datasources/booking_remote_datasource.dart';
import '../../data/models/booking_model.dart';
import '../../../pitches/data/datasources/pitch_remote_datasource.dart';
import '../../../pitches/data/models/pitch_model.dart';
import '../../../pitches/presentation/controllers/pitch_controller.dart';
import '../../../../core/routes/app_routes.dart';

class BookingController extends GetxController {
  final BookingRemoteDatasource _bookingDs = BookingRemoteDatasource();
  final PitchRemoteDatasource _pitchDs = PitchRemoteDatasource();

  final timeSlots = <TimeSlot>[].obs;
  final myBookings = <BookingModel>[].obs;
  final selectedDate = DateTime.now().obs;
  final selectedSlot = Rxn<TimeSlot>();
  final isLoading = false.obs;
  final isBooking = false.obs;
  final lastCreatedBooking = Rxn<BookingModel>();

  String get formattedDate => DateFormat('yyyy-MM-dd').format(selectedDate.value);

  Future<void> fetchSchedule() async {
    final pitchController = Get.find<PitchController>();
    final pitch = pitchController.selectedPitch.value;
    if (pitch == null) return;

    isLoading.value = true;
    try {
      final data = await _pitchDs.getSchedule(pitch.id, formattedDate);
      timeSlots.value = data.map((json) => TimeSlot.fromJson(json)).toList();
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red.withAlpha(200), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    selectedSlot.value = null;
    fetchSchedule();
  }

  void selectSlot(TimeSlot slot) {
    if (!slot.available) return;
    selectedSlot.value = slot;
  }

  Future<void> createBooking() async {
    final pitchController = Get.find<PitchController>();
    final pitch = pitchController.selectedPitch.value;
    final slot = selectedSlot.value;
    if (pitch == null || slot == null) return;

    final startHour = int.parse(slot.time.split(':')[0]);
    final endTime = '${(startHour + 1).toString().padLeft(2, '0')}:00';

    isBooking.value = true;
    try {
      final data = await _bookingDs.createBooking(
        pitchId: pitch.id,
        date: formattedDate,
        startTime: slot.time,
        endTime: endTime,
      );

      lastCreatedBooking.value = BookingModel.fromJson(data);
      Get.snackbar('Success', 'Booking confirmed!',
          backgroundColor: Colors.green.withAlpha(200), colorText: Colors.white);
      Get.toNamed(AppRoutes.qrCode);
      fetchSchedule();
    } catch (e) {
      Get.snackbar('Booking Failed', e.toString(),
          backgroundColor: Colors.red.withAlpha(200), colorText: Colors.white);
    } finally {
      isBooking.value = false;
    }
  }

  Future<void> fetchMyBookings() async {
    isLoading.value = true;
    try {
      final data = await _bookingDs.getMyBookings();
      myBookings.value = data.map((json) => BookingModel.fromJson(json)).toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelBooking(String id) async {
    try {
      await _bookingDs.cancelBooking(id);
      Get.snackbar('Success', 'Booking cancelled',
          backgroundColor: Colors.orange.withAlpha(200), colorText: Colors.white);
      fetchMyBookings();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchSchedule();
  }
}
