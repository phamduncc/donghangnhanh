import 'list_parcel_items_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'file_video_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FileVideoResponseModel{
  final String url;
  final Metadata file;
  FileVideoResponseModel({required this.file,required this.url});
  factory FileVideoResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FileVideoResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$FileVideoResponseModelToJson(this);
}