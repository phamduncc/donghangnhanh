import 'package:flutter/material.dart';

class VideoTypeBadge extends StatelessWidget {
  final String type;

  const VideoTypeBadge({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final badgeInfo = getBadgeInfo(type);

    if (badgeInfo.isEmpty) {
      return Container(); // Return empty container if type is not recognized
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: hexToColor(badgeInfo['bg']!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        badgeInfo['label']!,
        style: TextStyle(
          color: hexToColor(badgeInfo['color']!),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Map<String, String> getBadgeInfo(String type) {
    final Map<String, Map<String, String>> badgeTypes = {
      'package': {
        'color': '#855A23',  // Brown text
        'bg': '#FFF0D9',     // Light amber background
        'label': 'Đóng hàng'
      },
      'inbound': {
        'color': '#07A35D',  // Green text
        'bg': '#E7FFF4',     // Light green background
        'label': 'Nhập hàng'
      },
      'outbound': {
        'color': '#2B78E4',  // Blue text
        'bg': '#E8F3FF',     // Light blue background
        'label': 'Xuất hàng'
      },
    };

    return badgeTypes[type.toLowerCase()] ?? {};
  }

  Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

// Example usage:
// VideoTypeBadge(type: 'package')
