import 'package:get/get.dart';
import '../controllers/pitch_controller.dart';

class PitchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PitchController>(() => PitchController());
  }
}
