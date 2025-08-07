import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PurchaseDetailPage extends StatelessWidget {
  final String paymentId;
  final Map<String, dynamic> paymentData;

  const PurchaseDetailPage({
    super.key,
    required this.paymentId,
    required this.paymentData,
  });

  Widget _row(String label, String value, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: SelectableText(
              value,
              style: const TextStyle(fontSize: 11),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  channelName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _row('Price', 'GHS $price'),
                _row('Gmail', gmail, copyable: true),
                _row('Password', password, copyable: true),
                _row('WhatsApp', whatsapp, copyable: true),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Instructions:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
                const Text(
                  'Use the credentials above to access the channel. Change password after login for security.',
                  style: TextStyle(fontSize: 11),
                ),
                const Text(
                  'Please contact our 2 step verification handler to help you with your 2steps verification.',
                  style: TextStyle(fontSize: 11),
                ),

                SizedBox(
                  height: 20,
                ),


                ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return Container();
                      }));
                    },
                    child: Text('Whatsapp Support Line')
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
