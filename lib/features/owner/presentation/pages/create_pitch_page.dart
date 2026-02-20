import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../controllers/owner_controller.dart';

class CreatePitchPage extends GetView<OwnerController> {
  const CreatePitchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.editingPitchId != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Pitch' : 'Add New Pitch')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: controller.nameController,
              hintText: 'Pitch Name',
              labelText: 'Name *',
              prefixIcon: Icons.stadium,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: controller.locationController,
              hintText: 'e.g. Alexandria, Egypt',
              labelText: 'Location *',
              prefixIcon: Icons.location_on,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: controller.latController,
                    hintText: 'Latitude',
                    labelText: 'Latitude',
                    prefixIcon: Icons.map,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: controller.lngController,
                    hintText: 'Longitude',
                    labelText: 'Longitude',
                    prefixIcon: Icons.map,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: controller.mapsUrlController,
              hintText: 'https://maps.google.com/...',
              labelText: 'Google Maps URL',
              prefixIcon: Icons.link,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: controller.priceController,
              hintText: 'Price per hour (EGP)',
              labelText: 'Price *',
              prefixIcon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: controller.startHourController,
                    hintText: '8',
                    labelText: 'Opens at (hour)',
                    prefixIcon: Icons.access_time,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: controller.endHourController,
                    hintText: '24',
                    labelText: 'Closes at (hour)',
                    prefixIcon: Icons.access_time,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Obx(
              () => CustomButton(
                text: isEditing ? 'Update Pitch' : 'Create Pitch',
                isLoading: controller.isSubmitting.value,
                onPressed: controller.submitPitch,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
