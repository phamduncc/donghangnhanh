class VideoModel {
  final String id;
  final String title;
  final Duration duration;
  final String thumbnailUrl;
  final String videoUrl;
  final DateTime createdAt;

  VideoModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.createdAt,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      duration: Duration(seconds: json['duration_seconds'] as int),
      thumbnailUrl: json['thumbnail_url'] as String,
      videoUrl: json['video_url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duration_seconds': duration.inSeconds,
      'thumbnail_url': thumbnailUrl,
      'video_url': videoUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}