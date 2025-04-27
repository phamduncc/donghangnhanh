import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import '../services/api_service.dart';

class VideoDetailController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final videoPlayerController = Rx<VideoPlayerController?>(null);
  final isLoading = true.obs;
  final isPlaying = false.obs;
  final isDownloading = false.obs;
  final orderType = ''.obs;
  final orderCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final String? videoId = Get.arguments['videoId'];
    final String? orderType = Get.arguments['orderType'];
    final String? orderCode = Get.arguments['orderCode'];
    if (videoId != null) {
      loadVideo(videoId);
    }
    if (orderType != null) {
      this.orderType.value = orderType;
    }

    if (orderCode != null) {
      this.orderCode.value = orderCode;
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

  Future<void> downloadVideo(String videoUrl) async {
    try {
      // 1. Xin quyền storage nếu Android
      // if (Platform.isAndroid) {
      //   var status = await Permission.storage.request();
      //   if (!status.isGranted) {
      //     // Nếu quyền bị từ chối
      //     if (status.isDenied) {
      //       print("Quyền lưu trữ chưa được cấp, yêu cầu cấp quyền.");
      //
      //       // Yêu cầu quyền
      //       // Điều hướng người dùng đến cài đặt để cấp quyền thủ công
      //       openAppSettings();
      //       print(
      //           "Quyền lưu trữ bị từ chối vĩnh viễn. Vui lòng cấp quyền trong cài đặt.");
      //     }
      //   }
      // }
      isDownloading.value = true; // Bắt đầu tải video

      // 1. Lấy thư mục tạm thời
      Directory tempDir = await getTemporaryDirectory();
      final String filePath =
          '${tempDir.path}/$orderCode.mp4'; // Đặt tên cho file tải về

      // Sử dụng Dio để tải video
      Dio dio = Dio();
      await dio.download(videoUrl, filePath);

      print('Video downloaded to $filePath');

      // 3. Lưu video vào Gallery
      bool? success = await GallerySaver.saveVideo(filePath);
      if (success == true) {
        Fluttertoast.showToast(
            msg: "✅ Video đã lưu vào Gallery. Bạn kiểm tra trong thư mục Videos",
            toastLength: Toast.LENGTH_LONG,
            // Thời gian hiển thị
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            fontSize: 16.0 // Kích thước font chữ
            );
      } else {
        Fluttertoast.showToast(
            msg: "❌ Lỗi khi lưu video vào Gallery.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      // 4. Xoá video khỏi thư mục tạm thời sau khi lưu vào Gallery
      File(filePath).delete();
    } catch (e) {
      Fluttertoast.showToast(
          msg: "❌ Lỗi khi tải video.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      isDownloading.value = false; // Kết thúc tải video
    }
  }

  @override
  void onClose() {
    videoPlayerController.value?.dispose();
    super.onClose();
  }
}
