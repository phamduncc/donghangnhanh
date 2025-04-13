import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../services/api_service.dart';

class VideoDetailController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final videoPlayerController = Rx<VideoPlayerController?>(null);
  final isLoading = true.obs;
  final isPlaying = false.obs;
  final orderType = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final String? videoId = Get.arguments['videoId'];
    final String? orderType = Get.arguments['orderType'];
    if (videoId != null) {
      loadVideo(videoId);
    }
    if (orderType != null) {
      this.orderType.value = orderType;
    }
  }

  Future<void> loadVideo(String videoId) async {
    try {
      isLoading.value = true;
      final String? videoUrl = await _apiService.getUrlImage(fileName: videoId);
      if (videoUrl != null) {
        videoPlayerController.value = VideoPlayerController.network(videoUrl);
        await videoPlayerController.value!.initialize();
        update();
      }
    } catch (e) {
      print('Error loading video: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void playVideo() {
    if (videoPlayerController.value != null) {
      videoPlayerController.value!.play();
      isPlaying.value = true;
    }
  }

  void pauseVideo() {
    if (videoPlayerController.value != null) {
      videoPlayerController.value!.pause();
      isPlaying.value = false;
    }
  }

  @override
  void onClose() {
    videoPlayerController.value?.dispose();
    super.onClose();
  }
}