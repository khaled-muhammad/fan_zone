import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/pitch_model.dart';

class PitchCard extends StatelessWidget {
  final PitchModel pitch;
  final VoidCallback onTap;

  const PitchCard({super.key, required this.pitch, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 180,
              width: double.infinity,
              child: pitch.images.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: pitch.images.first,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.darkCard,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => _placeholderImage(),
                    )
                  : _placeholderImage(),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          pitch.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.gold, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            pitch.rating.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        pitch.locationName,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${pitch.pricePerHour.toStringAsFixed(0)} EGP/hr',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryLight,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withAlpha(30),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      color: AppColors.darkCard,
      child: const Center(
        child: Icon(Icons.sports_soccer, size: 48, color: AppColors.textSecondary),
      ),
    );
  }
}
