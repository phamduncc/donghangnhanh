import 'dart:math';

import 'package:donghangnhanh/model/response/order_video_reponse.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class HomeController extends GetxController {
  final ApiService apiService;

  HomeController({required this.apiService});

   RxList<OrderVideoResponse> orderVideoList = <OrderVideoResponse>[].obs;

  void getOrder({String? keySearch}) async {
    try{
      var result = await apiService.getOrderVideo(
        page:0,
        limit:10,
        orderCode: keySearch,
      );
      if(result != null) {
        orderVideoList.assignAll(result);
      }
    } catch(e) {
      Get.snackbar('Error', 'Invalid credentials');
    }
  }

int CHUNK_SIZE = 10 * 1024 * 1024; // 5MB

String createRandomString(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final rand = Random.secure();

  return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
}

Future<Map<String, dynamic>> uploadFile(File file, String mimeType) async {
  if (file == null) return {};

  final start = DateTime.now().millisecondsSinceEpoch;
  final fileSize = await file.length();
  final ext = mimeType.contains('webm') ? 'webm' : 'mp4';
  final name = '${createRandomString(6)}.$ext';

  final blobInfo = {
    'fieldname': null,
    'originalname': name,
    'encoding': 'utf-8',
    'mimetype': mimeType,
    'size': fileSize,
    'destination': 'N/A',
    'filename': name,
    'path': 'N/A',
  };

  if (fileSize < 8 * CHUNK_SIZE) {
        final res = await apiService.presignedUrlFile({
      'fileName': name,
      'fileSize': fileSize,
      'destination': blobInfo['destination'],
      'fieldname': blobInfo['fieldname'],
      'originalname': blobInfo['originalname'],
      'encoding': blobInfo['encoding'],
      'mimetype': blobInfo['mimetype'],
      'path': blobInfo['path'],
    });

    final url = res['data']['url'];
    final dio = Dio();

    var result =await dio.put(
      url,
      data: file.openRead(),
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: mimeType,
      }),
    );

    if(result.statusCode == 200) {
      return res['data']['file'];
    }
  }

  // Step 1: Initiate upload
  final initRes = await apiService.initUpload({
    'fileName': name,
    'fileSize': fileSize,
  });

  final uploadId = initRes['data']['uploadId'];
  final key = initRes['data']['key'];
  final presignedUrls = List<String>.from(initRes['data']['presignedUrls']);
  final finalFileName = initRes['data']['finalFileName'];

  // Step 2: Upload parts
  final numParts = (fileSize / CHUNK_SIZE).ceil();
  final uploadFutures = <Future<dynamic>>[];
  final dio = Dio();

  for (var i = 0; i < numParts; i++) {
    final startByte = i * CHUNK_SIZE;
    final endByte = (startByte + CHUNK_SIZE > fileSize)
        ? fileSize
        : startByte + CHUNK_SIZE;
    final chunk = await file.openRead(startByte, endByte).reduce((a, b) => a + b);

    final future = dio.put(
      presignedUrls[i],
      data: Stream.fromIterable([chunk]),
      options: Options(
        headers: {'Content-Type': 'application/octet-stream'},
      ),
      onSendProgress: (sent, total) {
        final progress = (sent / (total == 0 ? 1 : total)) * 100;
        // print('Part ${i + 1}: $progress%');
      },
    );

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
      final etag = results[index].headers.value('etag')?.replaceAll('"', '');
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
}

}