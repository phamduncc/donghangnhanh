import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// Enum for user plans
// Helper function to get user plan name
String getNamedUserPlan(int plan) {
  switch (plan) {
    case 0:
      return 'Gói miễn phí';
    case 1:
      return 'Gói cơ bản';
    case 2:
      return 'Gói tiết kiệm';
    case 3:
      return 'Gói cao cấp';
    default:
      return 'Gói miễn phí';
  }
}

class PricePackageCard extends StatelessWidget {
  final int userPlan;
  final bool expired;
  final DateTime? expireLicenseDate;
  final double storageAmount; // in bytes
  final double storageLimitAmount; // in MB

  const PricePackageCard({
    Key? key,
    required this.userPlan,
    required this.expired,
    required this.expireLicenseDate,
    required this.storageAmount,
    required this.storageLimitAmount,
  }) : super(key: key);

  String formatCreatedDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final double storageGb = storageAmount / (1024 * 1024 * 1024);
    final double limitGb = storageLimitAmount / 1024;
    final double progressValue = (storageAmount * 100) / (storageLimitAmount * 1024 * 1024);

    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Card Header
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Gói giá',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    getNamedUserPlan(userPlan),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Card Content
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Expiration Warning
                if (expired)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Gói giá của bạn đã hết hạn!',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Expiration Date
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ngày hết hạn',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      expireLicenseDate != null ? Text(
                        formatCreatedDate(expireLicenseDate!),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ) : Container(),
                    ],
                  ),
                ),

                // Storage Usage
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Dung lượng',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '${storageGb.toStringAsFixed(2)}/${limitGb.toStringAsFixed(2)}GB',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progressValue / 100,
                    minHeight: 4,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),

                // Renewal Link
                if (expired)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: GestureDetector(
                      onTap: () async {
                        Uri url = Uri.parse(
                            'https://www.facebook.com/donghangnhanh'); // Liên kết bạn muốn mở
                        await launchUrl(url);
                      },
                      child: Text(
                        'Liên hệ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}