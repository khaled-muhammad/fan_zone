import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/datasources/owner_remote_datasource.dart';
import '../../data/models/owner_stats_model.dart';
import '../../../pitches/data/models/pitch_model.dart';
import '../../../booking/data/models/booking_model.dart';
import '../../../../core/routes/app_routes.dart';

class OwnerController extends GetxController {
  final OwnerRemoteDatasource _datasource = OwnerRemoteDatasource();

  final stats = Rxn<OwnerStatsModel>();
  final myPitches = <PitchModel>[].obs;
  final todayBookings = <BookingModel>[].obs;
  final pitchBookings = <BookingModel>[].obs;
  final selectedPitchForBookings = Rxn<PitchModel>();

  final isLoading = false.obs;
  final isStatsLoading = false.obs;

  // Create/Edit pitch form
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();
  final priceController = TextEditingController();
  final mapsUrlController = TextEditingController();
  final startHourController = TextEditingController(text: '8');
  final endHourController = TextEditingController(text: '24');
  final isSubmitting = false.obs;
  String? editingPitchId;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    await Future.wait([
      fetchStats(),
      fetchMyPitches(),
      fetchTodayBookings(),
    ]);
  }

  Future<void> fetchStats() async {
    isStatsLoading.value = true;
    try {
      final data = await _datasource.getOwnerStats();
      stats.value = OwnerStatsModel.fromJson(data);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isStatsLoading.value = false;
    }
  }

  Future<void> fetchMyPitches() async {
    isLoading.value = true;
    try {
      final data = await _datasource.getMyPitches();
      myPitches.value = data.map((json) => PitchModel.fromJson(json)).toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTodayBookings() async {
    try {
      final data = await _datasource.getTodayBookings();
      todayBookings.value = data.map((json) => BookingModel.fromJson(json)).toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> fetchPitchBookings(String pitchId) async {
    isLoading.value = true;
    try {
      final data = await _datasource.getPitchBookings(pitchId);
      pitchBookings.value = data.map((json) => BookingModel.fromJson(json)).toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completeBooking(String bookingId) async {
    try {
      await _datasource.completeBooking(bookingId);
      Get.snackbar('Success', 'Booking marked as completed',
          backgroundColor: Colors.green.withAlpha(200), colorText: Colors.white);
      fetchTodayBookings();
      if (selectedPitchForBookings.value != null) {
        fetchPitchBookings(selectedPitchForBookings.value!.id);
      }
      fetchStats();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void prepareCreatePitch() {
    editingPitchId = null;
    nameController.clear();
    locationController.clear();
    latController.clear();
    lngController.clear();
    priceController.clear();
    mapsUrlController.clear();
    startHourController.text = '8';
    endHourController.text = '24';
    Get.toNamed(AppRoutes.createPitch);
  }

  void prepareEditPitch(PitchModel pitch) {
    editingPitchId = pitch.id;
    nameController.text = pitch.name;
    locationController.text = pitch.locationName;
    latController.text = pitch.latitude.toString();
    lngController.text = pitch.longitude.toString();
    priceController.text = pitch.pricePerHour.toStringAsFixed(0);
    mapsUrlController.text = pitch.mapsUrl ?? '';
    startHourController.text = pitch.workingHoursStart.toString();
    endHourController.text = pitch.workingHoursEnd.toString();
    Get.toNamed(AppRoutes.createPitch);
  }

  Future<void> submitPitch() async {
    if (nameController.text.isEmpty || locationController.text.isEmpty ||
        priceController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all required fields',
          backgroundColor: Colors.red.withAlpha(200), colorText: Colors.white);
      return;
    }

    isSubmitting.value = true;
    try {
      final data = {
        'name': nameController.text.trim(),
        'locationName': locationController.text.trim(),
        'latitude': double.tryParse(latController.text) ?? 0,
        'longitude': double.tryParse(lngController.text) ?? 0,
        'pricePerHour': double.tryParse(priceController.text) ?? 0,
        'mapsUrl': mapsUrlController.text.trim(),
        'workingHoursStart': int.tryParse(startHourController.text) ?? 8,
        'workingHoursEnd': int.tryParse(endHourController.text) ?? 24,
      };

      if (editingPitchId != null) {
        await _datasource.updatePitch(editingPitchId!, data);
        Get.snackbar('Success', 'Pitch updated',
            backgroundColor: Colors.green.withAlpha(200), colorText: Colors.white);
      } else {
        await _datasource.createPitch(data);
        Get.snackbar('Success', 'Pitch created',
            backgroundColor: Colors.green.withAlpha(200), colorText: Colors.white);
      }
      Get.back();
      fetchMyPitches();
      fetchStats();
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red.withAlpha(200), colorText: Colors.white);
    } finally {
      isSubmitting.value = false;
    }
  }

  void openPitchBookings(PitchModel pitch) {
    selectedPitchForBookings.value = pitch;
    fetchPitchBookings(pitch.id);
    Get.toNamed(AppRoutes.pitchBookings);
  }
}
