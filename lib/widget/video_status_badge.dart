import 'package:flutter/material.dart';

class VideoStatusBadge extends StatelessWidget {
  final String status;

  const VideoStatusBadge({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusInfo = getStatusInfo(status);

    if (statusInfo.isEmpty) {
      return Container(); // Return an empty container if statusInfo is null/empty
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: hexToColor(statusInfo['bg']!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusInfo['label']!,
        style: TextStyle(
          color: hexToColor(statusInfo['color']!),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Map<String, String> getStatusInfo(String status) {
    final Map<String, Map<String, String>> listStatus = {
      'CREATED': {
        'color': '#999',
        'bg': '#F2F2F2',
        'label': 'Đang cập nhật'
      },
      'INACTIVE': {
        'color': '#E03C31',
        'bg': '#FFECEB',
        'label': 'Thất bại'
      },
      'UP_FAILED': {
        'color': '#E03C31',
        'bg': '#FFECEB',
        'label': 'Chưa tải lên'
      },
      'ACTIVE': {
        'color': '#07A35D',
        'bg': '#E7FFF4',
        'label': 'Hoàn thành'
      },
      'DELETED': {
        'color': '#845D9C',
        'bg': '#F0EAF4',
        'label': 'Đã xóa'
      },
      'CONVERTED': {
        'color': '#07A35D',
        'bg': '#F0EAF4',
        'label': 'Đã xử lý'
      },
      'CONVERTING': {
        'color': '#07A35D',
        'bg': '#F0EAF4',
        'label': 'Đang xử lý'
      },
      'PREPARE_COMPLETE': {
        'color': 'orange',
        'bg': '#F0EAF4',
        'label': 'Đã đóng hàng',
      },
      'IN_QUEUE': {
        'color': 'blue',
        'bg': '#F0EAF4',
        'label': 'Đang trong hàng đợi',
      },
    };

    return listStatus[status] ?? {
      'color': '#999',
      'bg': '#F2F2F2',
      'label': 'Không xác định'
    };
  }

  Color hexToColor(String hexString) {
    // Handle named colors
    if (hexString == 'orange') return Colors.orange;
    if (hexString == 'blue') return Colors.blue;

    // Handle hex colors
    final buffer = StringBuffer();
    if (hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

// Example usage:
// VideoStatusBadge(status: 'ACTIVE')