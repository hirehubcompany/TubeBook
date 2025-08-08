import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class PurchaseDetailPage extends StatelessWidget {
  final String paymentId;
  final Map<String, dynamic> paymentData;

  const PurchaseDetailPage({
    super.key,
    required this.paymentId,
    required this.paymentData,
  });

  Widget _row(String label, String value, {bool copyable = false, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: Colors.grey[700]),
            const SizedBox(width: 8),
          ],
          Expanded(
            flex: 3,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: SelectableText(
              value,
              style: const TextStyle(fontSize: 11, color: Colors.black87),
            ),
          ),
          if (copyable)
            IconButton(
              icon: const Icon(Icons.copy, size: 18),
              tooltip: 'Copy',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final channelName = paymentData['channelName'] ?? 'N/A';
    final price = paymentData['price']?.toString() ?? 'N/A';
    final gmail = paymentData['channelGmail'] ??
        paymentData['gmail'] ??
        paymentData['email'] ??
        'Not provided';
    final password = paymentData['channelPassword'] ??
        paymentData['password'] ??
        'Not provided';
    final whatsapp = paymentData['whatsappNumber'] ??
        paymentData['whatsapp'] ??
        'Not provided';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Details'),
        backgroundColor: Colors.black,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      child: const Icon(Icons.shopping_bag, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        channelName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Info rows
                _row('Price', 'GHS $price', icon: Icons.attach_money),
                _row('Gmail', gmail, copyable: true, icon: Icons.email),
                _row('Password', password, copyable: true, icon: Icons.lock),
                _row('WhatsApp', whatsapp, copyable: true, icon: Icons.phone),

                const SizedBox(height: 20),
                const Divider(thickness: 1),
                const SizedBox(height: 12),

                // Instructions section
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 18, color: Colors.grey[700]),
                    const SizedBox(width: 6),
                    const Text(
                      'Instructions',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Use the credentials above to access the channel. '
                      'Change the password immediately after login for security.\n\n'
                      'Please contact our 2-step verification handler if needed.',
                  style: TextStyle(fontSize: 12, height: 1.4),
                ),

                const SizedBox(height: 24),

                // WhatsApp button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.whatshot, color: Colors.white),
                    label: const Text(
                      'WhatsApp Support Line',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      const supportNumber = '233551597865';
                      final url = Uri.parse('https://wa.me/$supportNumber');

                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not open WhatsApp')),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
