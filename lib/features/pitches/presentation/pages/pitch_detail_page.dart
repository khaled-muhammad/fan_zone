import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../controllers/pitch_controller.dart';

class PitchDetailPage extends GetView<PitchController> {
  const PitchDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final pitch = controller.selectedPitch.value;
        if (pitch == null) {
          return const Center(child: Text('No pitch selected'));
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(pitch.name),
                background: pitch.images.isNotEmpty
                    ? PageView.builder(
                        itemCount: pitch.images.length,
                        itemBuilder: (_, index) => CachedNetworkImage(
                          imageUrl: pitch.images[index],
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        color: AppColors.darkCard,
                        child: const Icon(Icons.sports_soccer,
                            size: 64, color: AppColors.textSecondary),
                      ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: AppColors.primaryLight),
                        const SizedBox(width: 8),
                        Text(pitch.locationName,
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _infoChip(Icons.attach_money,
                              '${pitch.pricePerHour.toStringAsFixed(0)} EGP/hr'),
                          const SizedBox(width: 12),
                          _infoChip(Icons.star, pitch.rating.toStringAsFixed(1)),
                          const SizedBox(width: 12),
                          _infoChip(Icons.access_time,
                              '${pitch.workingHoursStart}:00 - ${pitch.workingHoursEnd}:00'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('Location',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    if (ApiConstants.googleMapsEnabled)
                      SizedBox(
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(pitch.latitude, pitch.longitude),
                              zoom: 15,
                            ),
                            markers: {
                              Marker(
                                markerId: MarkerId(pitch.id),
                                position: LatLng(pitch.latitude, pitch.longitude),
                                infoWindow: InfoWindow(title: pitch.name),
                              ),
                            },
                            zoomControlsEnabled: false,
                            scrollGesturesEnabled: false,
                            liteModeEnabled: true,
                          ),
                        ),
                      )
                    else
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.darkCard,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.map_outlined,
                                  size: 40, color: AppColors.textSecondary),
                              const SizedBox(height: 8),
                              Text(pitch.name,
                                  style: const TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(
                                '${pitch.latitude.toStringAsFixed(3)}, ${pitch.longitude.toStringAsFixed(3)}',
                                style: const TextStyle(
                                    color: AppColors.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _openInMaps(pitch.mapsUrl, pitch.latitude, pitch.longitude),
                        icon: const Icon(Icons.directions, size: 20),
                        label: const Text('Open in Google Maps'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryLight,
                          side: const BorderSide(color: AppColors.primaryLight),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'View Schedule & Book',
                      icon: Icons.calendar_month,
                      onPressed: () => Get.toNamed(AppRoutes.schedule),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _openInMaps(String? mapsUrl, double lat, double lng) async {
    final url = (mapsUrl != null && mapsUrl.isNotEmpty)
        ? mapsUrl
        : 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not open maps');
    }
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryLight),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
