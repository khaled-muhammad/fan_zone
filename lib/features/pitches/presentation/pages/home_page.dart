import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/services/theme_service.dart';
import '../controllers/pitch_controller.dart';
import '../widgets/pitch_card.dart';

class HomePage extends GetView<PitchController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset('assets/app_icon.png', width: 32, height: 32),
            ),
            const SizedBox(width: 8),
            const Text('FAN ZONE'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => Get.find<ThemeService>().toggleTheme(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'Loading pitches...');
        }
        if (controller.errorMessage.isNotEmpty) {
          return AppErrorWidget(
            message: controller.errorMessage.value,
            onRetry: controller.fetchPitches,
          );
        }
        if (controller.pitches.isEmpty) {
          return const Center(child: Text('No pitches available'));
        }
        return RefreshIndicator(
          onRefresh: controller.fetchPitches,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.pitches.length,
            itemBuilder: (context, index) {
              final pitch = controller.pitches[index];
              return PitchCard(
                pitch: pitch,
                onTap: () {
                  controller.selectPitch(pitch);
                  Get.toNamed(AppRoutes.pitchDetail);
                },
              );
            },
          ),
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Teams'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Leagues'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              Get.toNamed(AppRoutes.myBookings);
              break;
            case 2:
              Get.toNamed(AppRoutes.teams);
              break;
            case 3:
              Get.toNamed(AppRoutes.leagues);
              break;
            case 4:
              Get.toNamed(AppRoutes.profile);
              break;
          }
        },
      ),
    );
  }
}
