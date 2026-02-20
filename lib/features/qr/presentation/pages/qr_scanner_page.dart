import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/qr_controller.dart';

class QrScannerPage extends GetView<QrController> {
  const QrScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: Stack(
        children: [
          MobileScanner(
            controller: scannerController,
            onDetect: (capture) {
              final barcode = capture.barcodes.firstOrNull;
              if (barcode?.rawValue != null) {
                scannerController.stop();
                controller.verifyQr(barcode!.rawValue!);
              }
            },
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryLight, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(() {
              if (controller.verificationResult.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  color: Colors.black54,
                  child: const Text(
                    'Point camera at the booking QR code',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              }
              return Container(
                padding: const EdgeInsets.all(24),
                color: controller.verificationSuccess.value
                    ? AppColors.available.withAlpha(200)
                    : AppColors.booked.withAlpha(200),
                child: Column(
                  children: [
                    Icon(
                      controller.verificationSuccess.value
                          ? Icons.check_circle
                          : Icons.error,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.verificationResult.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        controller.verificationResult.value = '';
                        scannerController.start();
                      },
                      child: const Text('Scan Another',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
