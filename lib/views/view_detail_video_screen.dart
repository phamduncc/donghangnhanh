import 'package:donghangnhanh/widget/video_type_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:video_player/video_player.dart';
import '../controllers/video_detail_controller.dart';

class ViewDetailVideoScreen extends GetView<VideoDetailController> {
  ViewDetailVideoScreen({Key? key}) : super(key: key);
  Map<String, String> mapType = {
    "package": "Đóng hàng",
    "inbound": "Nhập hàng",
    "outbound": "Xuất hàng",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết video',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offNamed("/"),
        ),
        actions: [
          Obx(() {
            return IconButton(
              icon: controller.isDownloading.value
                  ? const SizedBox(
                      width: 20.0, // Chiều rộng
                      height: 20.0, // Chiều cao
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      LucideIcons.downloadCloud,
                      size: 18,
                    ),
              onPressed: () {
                if (controller.videoPlayerController.value != null) {
                  final videoUrl =
                      controller.videoPlayerController.value!.dataSource;
                  controller.downloadVideo(videoUrl);
                }
              },
            );
          }),
        ],
      ),
      body: Stack(
        children: [
          Obx(
            () => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      if (controller.videoPlayerController.value != null)
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: controller
                                .videoPlayerController.value!.value.aspectRatio,
                            child: VideoPlayer(
                                controller.videoPlayerController.value!),
                          ),
                        ),
                    ],
                  ),
          ),
          // Play button in center
          Obx(() {
            return Center(
              child: GestureDetector(
                onTap: () {
                  if (controller.isPlaying.value) {
                    controller.pauseVideo();
                  } else {
                    controller.playVideo();
                  }
                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: controller.isPlaying.value
                      ? const Icon(
                          Icons.pause,
                          size: 40,
                          color: Colors.black,
                        )
                      : const Icon(
                          Icons.play_arrow,
                          size: 40,
                          color: Colors.black,
                        ),
                ),
              ),
            );
          }),
          // Shipping badge in top right corner
          Positioned(
            top: 20,
            right: 20,
            child: VideoTypeBadge(type: controller.orderType.value),
          ),
        ],
      ),
    );
  }
}
