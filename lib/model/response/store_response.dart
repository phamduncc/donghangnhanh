import 'package:json_annotation/json_annotation.dart';
import 'store_model.dart';

part 'store_response.g.dart';

@JsonSerializable(explicitToJson: true)
class StoreResponse {
  final List<Store> stores;
  final String? activeStore;
  final int? recordingTime;
  final DateTime? expireLicenseDate;

  StoreResponse({
    required this.stores,
    required this.activeStore,
    required this.recordingTime,
    required this.expireLicenseDate,
  });

  factory StoreResponse.fromJson(Map<String, dynamic> json) =>
      _$StoreResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoreResponseToJson(this);
}
