import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../controllers/video_detail_controller.dart';

class ViewDetailVideoScreen extends GetView<VideoDetailController> {
  ViewDetailVideoScreen({Key? key}) : super(key: key);
  Map<String, String> mapType = {
    "package":"Đóng hàng",
    "inbound":"Nhập hàng",
    "outbound":"Xuất hàng",
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết video'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offNamed("/"),
        ),
      ),
      body: Obx(
            () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            if (controller.videoPlayerController.value != null)
              Expanded(
                child: AspectRatio(
                  aspectRatio: controller
                      .videoPlayerController.value!.value.aspectRatio,
                  child: VideoPlayer(controller.videoPlayerController.value!),
                ),
              ),
            const SizedBox(height: 16),
            if (controller.orderType.value.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Loại đơn hàng: ${mapType[controller.orderType.value]}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    controller.isPlaying.value
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                  onPressed: () {
                    if (controller.isPlaying.value) {
                      controller.pauseVideo();
                    } else {
                      controller.playVideo();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}