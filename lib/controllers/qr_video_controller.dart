import 'dart:math';

import 'package:donghangnhanh/comon/data_center.dart';
import 'package:donghangnhanh/model/create_order_video_request.dart';
import 'package:donghangnhanh/model/response/file_video_response_model.dart';
import 'package:donghangnhanh/model/response/order_video_reponse.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import '../model/response/list_parcel_items_response.dart';
import '../services/api_service.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart'; // Cho MIME
import 'package:path/path.dart' as p;
import 'dart:developer' as developer;

class QrVideoController extends GetxController {
  final ApiService apiService;

  var videoPath;

  QrVideoController({required this.apiService});

  Rx<Metadata?> fileVideo = Rx<Metadata?>(null);
  RxString orderCode = ''.obs;
  RxString selectedOption = "package".obs;
  RxBool isLoading = false.obs;
  int CHUNK_SIZE = 10 * 1024 * 1024; // 10MB

  String createRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();

    return List.generate(length, (index) => chars[rand.nextInt(chars.length)])
        .join();
  }

  Future<void> createOrder(
      Map<String, dynamic> jsonData, String orderCode) async {
    var data = Metadata.fromJson(jsonData);
    fileVideo.value = data;
    var response = await apiService.createOrderVideo(
      CreateOrderVideoRequest(
        fileMetadataId: data.id,
        orderCode: orderCode,
        type: selectedOption.value,
        prepareCode: '',
        updateStorage: true,
        startTime: data.createdAt,
        duration: 0,
      ),
    );
    if (response != null) {
      Get.snackbar(
        'Thông báo',
        'Tạo thành công',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // Get.offNamed('/video_detail', arguments: {
      //   "videoId": data.filename,
      //   "orderType": selectedOption.value
      // });
    } else {
      Get.snackbar('Error', 'Invalid credentials');
    }
  }

  Future<Map<String, dynamic>?> uploadFile(File file, String mimeType) async {
    if (file == null) return {};

    final start = DateTime.now().millisecondsSinceEpoch;
    final fileSize = await file.length();
    final ext = mimeType.contains('webm') ? 'webm' : 'mp4';
    final name = '${createRandomString(6)}.$ext';

    final blobInfo = {
      'fieldname': null,
      'originalname': name,
      'encoding': 'utf-8',
      'mimetype': "video/mp4",
      'size': fileSize,
      'destination': 'N/A',
      'filename': name,
      'path': 'N/A',
    };

    if (fileSize < 8 * CHUNK_SIZE) {
      final res = await apiService.presignedUrlFile({
        'fileName': name,
        'fileSize': fileSize,
        'fileType': 'video/mp4',
        'destination': blobInfo['destination'],
        'fieldname': blobInfo['fieldname'],
        'originalname': blobInfo['originalname'],
        'encoding': blobInfo['encoding'],
        'mimetype': blobInfo['mimetype'],
        'path': blobInfo['path'],
      });

      final url = res['url'];
      final dio = Dio();
      final bytes = file.readAsBytes();
      developer.log(
        "POST URL $url",
      );
      developer.log(
        "DATA $bytes",
      );

      dio.options.headers["Authorization"] =
          "Bearer ${Get.find<StorageService>().getToken()}";
      try {
        // dio.interceptors.add(LogInterceptor(
        //   requestHeader: true,
        //   requestBody: false,
        //   responseHeader: false,
        //   responseBody: false,
        // ));
        var result = await dio.put(
          url,
          data: file.openRead(),
          options: Options(
            headers: {
              'Authorization': null,
              'Content-Type': 'video/mp4',
              Headers.contentLengthHeader: fileSize,
            },
          ),
          onSendProgress: (sent, total) {
            print('Progress: ${(sent / total * 100).toStringAsFixed(0)}%');
          },
        );
        if (result.statusCode == 200) {
          return res['file'];
        }
      } catch (e, stack) {
        print('Error occurred: $e');
        print('Stack trace: $stack');
      }
    } else {
      try {
        // Step 1: Initiate upload
        final initRes = await apiService.initUpload({
          'fileName': name,
          'fileSize': fileSize,
        });

        final uploadId = initRes['uploadId'];
        final key = initRes['key'];
        final presignedUrls = List<String>.from(initRes['presignedUrls']);
        final finalFileName = initRes['finalFileName'];

        // Step 2: Upload parts
        final numParts = (fileSize / CHUNK_SIZE).ceil();
        // Đọc file thành bytes
        final fileBytes = await file.readAsBytes();
        final uploadFutures = <Future<dynamic>>[];
        final dio = Dio();

        for (var i = 0; i < numParts - 1; i++) {
          // final startByte = i * CHUNK_SIZE;
          // final endByte = (startByte + CHUNK_SIZE > fileSize)
          //     ? fileSize
          //     : startByte + CHUNK_SIZE;
          // final chunk =
          // await file.openRead(startByte, endByte).reduce((a, b) => a + b);

          final startByte = i * CHUNK_SIZE;
          final endByte = (startByte + CHUNK_SIZE > fileSize)
              ? fileSize
              : startByte + CHUNK_SIZE;

          // Cắt phần của file
          final chunk = fileBytes.sublist(startByte, endByte);

          final future = dio.put(
            presignedUrls[i],
            data: Stream.fromIterable([chunk]),
            options: Options(
              headers: {
                'Content-Type': 'video/mp4',
                'x-amz-decoded-content-length': chunk.length.toString(),
              },
            ),
            onSendProgress: (sent, total) {
              final progress = (sent / (total == 0 ? 1 : total)) * 100;
              // print('Part ${i + 1}: $progress%');
            },
          ).catchError((error) {
            debugPrint('Error uploading part ${i + 1}: $error');
            return Future.error('Upload failed for part ${i + 1}');
          });

          uploadFutures.add(future);
        }

        final results = await Future.wait(uploadFutures);

        // Step 3: Complete upload
        return await apiService.completeUpload({
          'key': key,
          'fileName': name,
          'finalFileName': finalFileName,
          'uploadId': uploadId,
          'parts': List.generate(results.length, (index) {
            final etag =
                results[index].headers.value('etag')?.replaceAll('"', '');
            return {'ETag': etag, 'PartNumber': index + 1};
          }),
          'fileSize': fileSize,
          'destination': blobInfo['destination'],
          'fieldname': blobInfo['fieldname'],
          'originalname': blobInfo['originalname'],
          'encoding': blobInfo['encoding'],
          'mimetype': blobInfo['mimetype'],
          'path': blobInfo['path'],
          'start': start,
        });
      } catch (e, stack) {
        debugPrint('Error occurred: $e');
        debugPrint('Stack trace: $stack');
        Fluttertoast.showToast(
            msg: "❌ Lỗi khi lưu video lên hệ thống.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
