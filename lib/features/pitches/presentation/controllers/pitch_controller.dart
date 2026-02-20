import 'package:get/get.dart';
import '../../data/datasources/pitch_remote_datasource.dart';
import '../../data/models/pitch_model.dart';

class PitchController extends GetxController {
  final PitchRemoteDatasource _datasource = PitchRemoteDatasource();

  final pitches = <PitchModel>[].obs;
  final selectedPitch = Rxn<PitchModel>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPitches();
  }

  Future<void> fetchPitches() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final data = await _datasource.getAllPitches();
      pitches.value = data.map((json) => PitchModel.fromJson(json)).toList();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPitchDetail(String id) async {
    isLoading.value = true;
    try {
      final data = await _datasource.getPitchById(id);
      selectedPitch.value = PitchModel.fromJson(data);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void selectPitch(PitchModel pitch) {
    selectedPitch.value = pitch;
  }
}
