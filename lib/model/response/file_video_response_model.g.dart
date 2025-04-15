// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_video_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileVideoResponseModel _$FileVideoResponseModelFromJson(
        Map<String, dynamic> json) =>
    FileVideoResponseModel(
      file: Metadata.fromJson(json['file'] as Map<String, dynamic>),
      url: json['url'] as String,
    );

Map<String, dynamic> _$FileVideoResponseModelToJson(
        FileVideoResponseModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'file': instance.file.toJson(),
    };
